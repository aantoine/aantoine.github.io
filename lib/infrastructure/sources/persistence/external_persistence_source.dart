import 'dart:collection';

import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/entities/user.dart';
import 'package:card/infrastructure/models/session_state_date.dart';
import 'package:card/infrastructure/models/votes_data.dart';
import 'package:card/infrastructure/sources/persistence/converters/session_converter.dart';
import 'package:card/infrastructure/sources/persistence/converters/table_converter.dart';
import 'package:card/infrastructure/sources/persistence/converters/ticket_converter.dart';
import 'package:card/infrastructure/sources/persistence/converters/user_converter.dart';
import 'package:card/infrastructure/sources/persistence/converters/votes_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

abstract class ExternalPersistenceSource {
  Stream<List<Table>> tables();
  Future<void> createTable(Table table);
  Stream<Table> tableStateFor(Table table);

  Stream<PlanningSession> sessionStateFor(Table table);
  Future<void> updateVotesFor(Table table, User user, String? vote);
  Future<void> clearVotesFor(Table table);
  Future<void> updateTicketsFor(Table table, List<Ticket> tickets);
  Future<void> updateStateFor(Table table, SessionStateData sessionData);

  Future<void> addUserTo(Table table, User user);
  Future<void> removeUserFrom(Table table, User user);
}

class FirestorePersistenceSource extends ExternalPersistenceSource {
  final FirebaseFirestore instance;

  FirestorePersistenceSource() : instance = FirebaseFirestore.instance;

  late final _tablesRef = instance.collection('tables').withConverter<Table>(
        fromFirestore: TableConverter.fromFirestore,
        toFirestore: TableConverter.toFirestore,
      );

  CollectionReference<User> _tableUsers(String tableId) => instance
      .collection('tables')
      .doc(tableId)
      .collection("users")
      .withConverter<User>(
        fromFirestore: UserConverter.fromFirestore,
        toFirestore: UserConverter.toFirestore,
      );

  DocumentReference<List<Ticket>> _tableTickets(String tableId) => instance
      .collection('tables')
      .doc(tableId)
      .collection("tickets")
      .doc("tickets")
      .withConverter<List<Ticket>>(
        fromFirestore: TicketConverter.fromFirestore,
        toFirestore: TicketConverter.toFirestore,
      );

  DocumentReference<SessionStateData> _tableState(String tableId) => instance
      .collection('tables')
      .doc(tableId)
      .collection("state")
      .doc("state")
      .withConverter<SessionStateData>(
        fromFirestore: SessionConverter.fromFirestore,
        toFirestore: SessionConverter.toFirestore,
      );

  CollectionReference<VotesData> _tableVotes(String tableId) => instance
      .collection('tables')
      .doc(tableId)
      .collection("votes")
      .withConverter<VotesData>(
        fromFirestore: VotesConverter.fromFirestore,
        toFirestore: VotesConverter.toFirestore,
      );

  @override
  Stream<List<Table>> tables() {
    return _tablesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((tableDoc) => tableDoc.data()).toList());
  }

  @override
  Future<void> createTable(Table table) async {
    await _tablesRef.doc(table.id).set(table);
  }

  @override
  Stream<Table> tableStateFor(Table table) {
    return _tablesRef
        .doc(table.id)
        .snapshots()
        .mapNotNull((snapshot) => snapshot.data());
  }

  @override
  Future<void> removeUserFrom(Table table, User user) async {
    final myConnectionsRef = FirebaseDatabase.instance.ref("status/${user.id}");
    await myConnectionsRef.onDisconnect().cancel();
    await myConnectionsRef.remove();

    var batch = instance.batch();
    batch.delete(_tableUsers(table.id).doc(user.id));
    batch.delete(_tableVotes(table.id).doc(user.id));

    batch.commit();
  }

  @override
  Future<void> addUserTo(Table table, User user) async {
    final myConnectionsRef = FirebaseDatabase.instance.ref("status/${user.id}");
    myConnectionsRef.set("online");
    myConnectionsRef.onDisconnect().remove();

    final connectedRef = FirebaseDatabase.instance.ref(".info/connected");
    connectedRef.onValue.listen((event) {
      final connected = event.snapshot.value as bool? ?? false;
      if (connected) {
        myConnectionsRef.set("online");
        myConnectionsRef.onDisconnect().remove();
      }
    });

    _tableUsers(table.id).doc(user.id).set(user);
  }

  @override
  Stream<PlanningSession> sessionStateFor(Table table) {
    var usersStream = _tableUsers(table.id).snapshots().mapNotNull(
        (snapshot) => snapshot.docs.map((userDoc) => userDoc.data()).toList());

    var stateStream =
        _tableState(table.id).snapshots().map((snapshot) => snapshot.data());

    var votesStream = _tableVotes(table.id).snapshots().mapNotNull((snapshot) {
      var votes = HashMap<String, String>();
      var rawVotes = snapshot.docs.map((userDoc) => userDoc.data()).toList();
      for (var vote in rawVotes) {
        if (vote.value.isNotEmpty) {
          votes[vote.userId] = vote.value;
        }
      }
      return votes;
    });

    var ticketsStream = _tableTickets(table.id)
        .snapshots()
        .map((snapshot) => snapshot.data());

    return Rx.combineLatest4(
        usersStream, stateStream, votesStream, ticketsStream,
        (users, state, votes, tickets) {
      return PlanningSession(
        tickets ?? [],
        state?.currentTicketId,
        state?.showResults ?? false,
        votes,
        users,
      );
    });
  }

  @override
  Future<void> updateVotesFor(Table table, User user, String? vote) async {
    if (vote != null) {
      _tableVotes(table.id).doc(user.id).set(VotesData(user.id, vote));
    } else {
      _tableVotes(table.id).doc(user.id).delete();
    }
  }

  @override
  Future<void> clearVotesFor(Table table) async {
    var batch = instance.batch();
    var query =
        await _tableVotes(table.id).get(GetOptions(source: Source.cache));
    var oldVotes = query.docs.map((doc) => doc.data());
    for (var vote in oldVotes) {
      batch.delete(_tableVotes(table.id).doc(vote.userId));
    }
    batch.commit();
  }

  @override
  Future<void> updateStateFor(Table table, SessionStateData sessionData) async {
    await _tableState(table.id).set(sessionData);
  }

  @override
  Future<void> updateTicketsFor(Table table, List<Ticket> tickets) async {
    await _tableTickets(table.id).set(tickets);
  }
}

class DummyPersistenceSource extends ExternalPersistenceSource {
  static final dummyTestTable = Table(
    "table_02",
    "id_A",
    "Sala de pruebas 2",
  );
  static final dummySession = PlanningSession(
    [
      Ticket(
        "1",
        "Prueba 1",
        resolved: true,
        result: "8",
        votes: ["8", "5", "8"],
      ),
      Ticket(
        "2",
        "Prueba 2",
      ),
      Ticket(
        "3",
        "Implementación inicial, que puede contener un texto demasiado largo que podría no caber dentro de la pantalla de algunas personas",
      ),
      Ticket(
        "4",
        "Prueba 4",
      ),
    ],
    "3",
    true,
    {"id_B": '5', "id_C": '8'},
    [
      User("b@test.cl", "Bartolomeo Benitez", "id_B"),
      User("c@test.cl", "Camila Cabello", "id_C"),
      User("a@test.cl", "Agustin Antoine", "id_A"),
    ],
  );

  final BehaviorSubject<List<Table>> _subject = BehaviorSubject.seeded([
    dummyTestTable,
  ]);
  final BehaviorSubject<Table> _tableSubject = BehaviorSubject();
  final BehaviorSubject<PlanningSession> _sessionSubject = BehaviorSubject();

  @override
  Future<void> createTable(Table table) async {
    var tables = _subject.valueOrNull ?? [];
    if (tables.where((t) => t.id == table.id).isNotEmpty) {
    } else {
      var update = [table, ...tables];
      _subject.add(update);
    }
  }

  @override
  Future<void> removeUserFrom(Table table, User user) async {}

  @override
  Future<void> addUserTo(Table table, User user) async {}

  @override
  Stream<Table> tableStateFor(Table table) {
    _tableSubject.add(table);
    return _tableSubject;
  }

  @override
  Stream<List<Table>> tables() {
    return _subject;
  }

  @override
  Stream<PlanningSession> sessionStateFor(Table table) {
    if (!_sessionSubject.hasValue) {
      _sessionSubject.add(dummySession);
    }
    return _sessionSubject;
  }

  @override
  Future<void> updateVotesFor(Table table, User user, String? vote) async {
    var currentState = _sessionSubject.value;
    if (vote != null) {
      currentState.votes.update(
        user.id,
        (value) => vote,
        ifAbsent: () => vote,
      );
    } else {
      currentState.votes.remove(user.id);
    }
    _sessionSubject.add(currentState);
  }

  @override
  Future<void> clearVotesFor(Table table) async {
    var currentState = _sessionSubject.value;
    _sessionSubject.add(PlanningSession(
      currentState.tickets,
      currentState.currentTicketId,
      currentState.showResults,
      {},
      currentState.users,
    ));
  }

  @override
  Future<void> updateStateFor(Table table, SessionStateData sessionData) async {
    var currentState = _sessionSubject.value;
    _sessionSubject.add(PlanningSession(
      currentState.tickets,
      sessionData.currentTicketId,
      sessionData.showResults,
      currentState.votes,
      currentState.users,
    ));
  }

  @override
  Future<void> updateTicketsFor(Table table, List<Ticket> tickets) async {
    var currentState = _sessionSubject.value;
    _sessionSubject.add(PlanningSession(
      tickets,
      currentState.currentTicketId,
      currentState.showResults,
      currentState.votes,
      currentState.users,
    ));
  }
}

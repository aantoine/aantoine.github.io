import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/entities/user.dart';
import 'package:card/infrastructure/sources/persistence/converters/table_converter.dart';
import 'package:card/infrastructure/sources/persistence/converters/ticket_converter.dart';
import 'package:card/infrastructure/sources/persistence/converters/user_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

abstract class ExternalPersistenceSource {
  Stream<List<Table>> tables();
  Future<void> createTable(Table table);
  Stream<Table> tableStateFor(Table table);

  Future<void> setSession(Table table, PlanningSession sessionState);
  Stream<PlanningSession> sessionStateFor(Table table);
  /*Future<void> addUserTo(Table table, User user);
  Future<void> updateTicketsFor(Table table, List<Ticket> tickets);
  Future<void> updateVotesFor(Table table, User user, String? vote);
  Future<void> clearVotesFor(Table table);
  Future<void> updateStateFor(Table table);*/

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
  /*.snapshots()
      .mapNotNull((snapshot) =>
          snapshot.docs.map((userDoc) => userDoc.data()).toList());*/

  DocumentReference<Ticket> _tableTickets(String tableId) => instance
      .collection('tables')
      .doc(tableId)
      .collection("tickets")
      .doc("tickets")
      .withConverter<Ticket>(
        fromFirestore: TicketConverter.fromFirestore,
        toFirestore: TicketConverter.toFirestore,
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
    print("FirestorePersistenceSource: disablePresence");
    final myConnectionsRef = FirebaseDatabase.instance.ref("status/${user.id}");
    await myConnectionsRef.onDisconnect().cancel();
    await myConnectionsRef.remove();

    await _tableUsers(table.id).doc(user.id).delete();
  }

  @override
  Future<void> addUserTo(Table table, User user) async {
    print("FirestorePersistenceSource: enablePresence");
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

    await _tableUsers(table.id).doc(user.id).set(user);
  }

  @override
  Stream<PlanningSession> sessionStateFor(Table table) {
    var usersStream = _tableUsers(table.id).snapshots().mapNotNull(
        (snapshot) => snapshot.docs.map((userDoc) => userDoc.data()).toList());

    return usersStream.map((users) {
      return PlanningSession([], null, false, {}, users);
    });
  }

  @override
  Future<void> setSession(Table table, PlanningSession sessionState) async {
    // check users
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
    false,
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
  Future<void> setSession(Table table, PlanningSession sessionState) async {
    _sessionSubject.add(sessionState);
  }
}

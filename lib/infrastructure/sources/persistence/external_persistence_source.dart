import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/planning_session/entities/ticket.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/entities/user.dart';
import 'package:card/infrastructure/sources/persistence/session_converter.dart';
import 'package:card/infrastructure/sources/persistence/table_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

abstract class ExternalPersistenceSource {
  Stream<List<Table>> tables();
  Future<void> setTable(Table table);
  Stream<Table> tableStateFor(Table table);

  Future<void> setSession(Table table, PlanningSession sessionState);
  Stream<PlanningSession> sessionStateFor(Table table);

  Future<void> enablePresence(String id);
  Future<void> disablePresence(String id);
}

class FirestorePersistenceSource extends ExternalPersistenceSource {
  final FirebaseFirestore instance;

  FirestorePersistenceSource() : instance = FirebaseFirestore.instance;
  late List<Table> snapshot;

  late final _tablesRef = instance.collection('tables').withConverter<Table>(
        fromFirestore: TableConverter.fromFirestore,
        toFirestore: TableConverter.toFirestore,
      );

  late final _sessionRef = instance.collection('tables');

  @override
  Stream<List<Table>> tables() {
    return _tablesRef.snapshots().map((snapshot) =>
        snapshot.docs.map((tableDoc) => tableDoc.data()).toList());
  }

  @override
  Future<void> setTable(Table table) async {
    _tablesRef.doc(table.id).set(table);
  }

  @override
  Stream<Table> tableStateFor(Table table) {
    return _tablesRef
        .doc(table.id)
        .snapshots()
        .mapNotNull((snapshot) => snapshot.data());
  }

  @override
  Future<void> disablePresence(String id) async {
    print("FirestorePersistenceSource: disablePresence");
    final myConnectionsRef = FirebaseDatabase.instance.ref("status/$id");
    await myConnectionsRef.onDisconnect().cancel();
    await myConnectionsRef.remove();
  }

  @override
  Future<void> enablePresence(String id) async {
    print("FirestorePersistenceSource: enablePresence");
    final myConnectionsRef = FirebaseDatabase.instance.ref("status/$id");
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
  }

  @override
  Stream<PlanningSession> sessionStateFor(Table table) {
    return _sessionRef
        .doc(table.id)
        .collection("planning")
        .withConverter<PlanningSession>(
          fromFirestore: SessionConverter.fromFirestore,
          toFirestore: SessionConverter.toFirestore,
        )
        .doc("session")
        .snapshots()
        .mapNotNull((snapshot) => snapshot.data());
  }

  @override
  Future<void> setSession(Table table, PlanningSession sessionState) {
    return _sessionRef
        .doc(table.id)
        .collection("planning")
        .withConverter<PlanningSession>(
          fromFirestore: SessionConverter.fromFirestore,
          toFirestore: SessionConverter.toFirestore,
        )
        .doc("session")
        .set(sessionState);
  }
}

class DummyPersistenceSource extends ExternalPersistenceSource {
  static final dummyTestTable = Table(
    "table_02",
    [
      User("b", "Camila Alvarez", "id_B"),
      User("c", "Felipe Hernandez", "id_C"),
      User("antoineagustin@gmail.com", "Agustin Antoine", "id_A"),
    ],
    "id_A",
    "Sala de pruebas 2",
  );
  static final dummySession = PlanningSession(
    [
      Ticket(
        "2",
        "Prueba 1",
        true,
        "8",
        3,
      ),
      Ticket(
        "3",
        "Prueba 2",
        false,
        null,
        0,
      ),
      Ticket(
        "12345",
        "Implementación inicial, que puede contener un texto demasiado largo que podría no caber dentro de la pantalla de algunas personas",
        false,
        null,
        0,
      ),
      Ticket(
        "4",
        "Prueba 3",
        false,
        null,
        0,
      ),
    ],
    "12345",
    false,
    {"id_B": '5', "id_C": '8'},
  );

  final BehaviorSubject<List<Table>> _subject = BehaviorSubject.seeded([
    Table(
      "table_01",
      [User("a", "Usuario A", "id_A")],
      "id_A",
      "Sala de pruebas 1",
    ),
    dummyTestTable,
  ]);
  final BehaviorSubject<Table> _tableSubject = BehaviorSubject();
  final BehaviorSubject<PlanningSession> _sessionSubject = BehaviorSubject();

  @override
  Future<void> setTable(Table table) async {
    var tables = _subject.valueOrNull ?? [];
    if (tables.where((t) => t.id == table.id).isNotEmpty) {
    } else {
      var update = [table, ...tables];
      _subject.add(update);
    }
  }

  @override
  Future<void> disablePresence(String id) async {}

  @override
  Future<void> enablePresence(String id) async {}

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

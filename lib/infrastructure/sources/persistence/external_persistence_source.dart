import 'dart:collection';

import 'package:card/domain/planning_session/entities/planning_session.dart';
import 'package:card/domain/tables/entities/table.dart';
import 'package:card/domain/user/entities/user.dart';
import 'package:card/infrastructure/sources/persistence/session_converter.dart';
import 'package:card/infrastructure/sources/persistence/table_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

abstract class ExternalPersistenceSource {
  Stream<List<Table>> tables();
  Future<void> addTable(Table table);
  Future<void> updateTable(Table table);
  Stream<Table> table(Table table);

  Future<void> enablePresence(String id);
  Future<void> disablePresence(String id);

  Stream<PlanningSession> session(Table table);
}

class FirestorePersistenceSource extends ExternalPersistenceSource {
  static final _log = Logger('FirestorePersistenceSource');
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

    /*return _tablesRef.doc("summary").snapshots()
        .map((snapshot) => snapshot.data() ?? [])
        .doOnData((data) => snapshot = data);*/
  }

  @override
  Future<void> addTable(Table table) async {
    _tablesRef.doc(table.id).set(table);
  }

  @override
  Future<void> updateTable(Table table) async {
    _tablesRef.doc(table.id).set(table);
  }

  @override
  Stream<Table> table(Table table) {
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
  Stream<PlanningSession> session(Table table) {
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
}

class DummyPersistenceSource extends ExternalPersistenceSource {
  final BehaviorSubject<List<Table>> _subject = BehaviorSubject.seeded([
    Table("table_01", [User("a", "Usuario A", "id_A")], "id_A",
        "Sala de pruebas 1"),
    Table(
        "table_02",
        [
          User("b", "Usuario B", "id_B"),
          User("c", "Usuario C", "id_C"),
        ],
        "id_B",
        "Sala de pruebas 2")
  ]);
  final BehaviorSubject<Table> _tableSubject = BehaviorSubject();
  final BehaviorSubject<PlanningSession> _sessionSubject = BehaviorSubject();

  @override
  Future<void> addTable(Table table) async {
    var value = _subject.valueOrNull ?? [];
    var update = [table, ...value];
    _subject.add(update);
  }

  @override
  Future<void> disablePresence(String id) async {}

  @override
  Future<void> enablePresence(String id) async {}

  @override
  Stream<Table> table(Table table) {
    _tableSubject.add(table);
    return _tableSubject;
  }

  @override
  Stream<List<Table>> tables() {
    return _subject;
  }

  @override
  Future<void> updateTable(Table table) async {}

  @override
  Stream<PlanningSession> session(Table table) {
    _sessionSubject.add(PlanningSession(
      [],
      null,
      false,
      HashMap(),
    ));
    return _sessionSubject;
  }
}

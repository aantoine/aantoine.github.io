import 'package:card/domain/tables/entities/table.dart';
import 'package:card/infrastructure/models/table_data.dart';
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
}

class FirestorePersistenceSource extends ExternalPersistenceSource {
  static final _log = Logger('FirestorePersistenceSource');
  final FirebaseFirestore instance;

  FirestorePersistenceSource() : instance = FirebaseFirestore.instance;
  late List<Table> snapshot;


  late final _tablesRef = instance
      .collection('tables')
      .withConverter<Table>(
      fromFirestore: _fromFirestore, toFirestore: _toFirestore);

  Table _fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    if (data == null) {
      _log.info('No data found on Firestore, returning empty list');
      //return [];
      throw Exception("Illegal state: empty data");
    }
    return TableData.fromJson(data);

    /*final list = List.castFrom<Object?, Map<String, Object?>>(data);

    try {
      return list.map((raw) => TableData.fromJson(raw)).toList();
    } catch (e) {
      throw Exception('Failed to parse data from Firestore: $e');
    }*/
  }

  Map<String, Object?> _toFirestore(Table table, SetOptions? options) {
    //return {'tables': tables.map((t) => t.toJson()).toList()};
    return table.toJson();
  }

  @override
  Stream<List<Table>> tables() {
    return _tablesRef.snapshots()
        .map((snapshot) => snapshot.docs.map((tableDoc) => tableDoc.data()).toList());

    /*return _tablesRef.doc("summary").snapshots()
        .map((snapshot) => snapshot.data() ?? [])
        .doOnData((data) => snapshot = data);*/
  }

  @override
  Future<void> addTable(Table table) async {
    /*var newSnapshot = [...snapshot, table];
    await _tablesRef.doc("summary").set(newSnapshot);*/
    _tablesRef.doc(table.id).set(table);
  }

  @override
  Future<void> updateTable(Table table) async {
    /*var newSnapshot = snapshot.map((e) {
      if (table.id == e.id) {
        return table;
      }
      return e;
    }).toList();
    await _tablesRef.doc("summary").set(newSnapshot);*/
    _tablesRef.doc(table.id).set(table);
  }

  @override
  Stream<Table> table(Table table) {
    return _tablesRef.doc(table.id).snapshots()
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
}

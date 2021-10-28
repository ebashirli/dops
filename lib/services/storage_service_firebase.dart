import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dops/models/base_model.dart';
import 'package:dops/models/firebase_storage_model.dart';

import 'storage_service.dart';

class StorageServiceFirebase extends StorageService {
  //Firestore operation

  FirebaseFirestore get db => FirebaseFirestore.instance;

  late CollectionReference collection;

  late DocumentSnapshot documents;


  collectionReference = firebaseFirestore.collection("lists");

    dropdownSourceLists.bindStream(getAllDropdownSourceLists());

    lists.forEach((key, value) {
      collectionReference.doc(key).set({'list': value});
    });

  Future<T> find(int id) async {
    final dbClient = await db;
    var map = await dbClient.query(tableName, where: "id = ?", whereArgs: [id]);
    return fromJson(map.first) as T;
  }

  Future<List<T>> getAll() async {
    var dbClient = await db;
    var map = await dbClient.query(tableName);
    return List.generate(map.length, (i) => fromJson(map[i]) as T);
  }

  Future<int> create(BaseModel model) async {
    var dbClient = await db;
    return await dbClient.insert(tableName, model.toJson());
  }

  Future<void> update(BaseModel model) async {
    final dbClient = await db;
    await dbClient.update(
      tableName,
      model.toJson(),
      where: "id = ?",
      whereArgs: [model.id],
    );
  }

  Future<void> delete(BaseModel model) async {
    final dbClient = await db;
    await dbClient.delete(tableName, where: "id = ?", whereArgs: [model.id]);
  }

  Future<void> deleteById(int id) async {
    final dbClient = await db;
    await dbClient.delete(tableName, where: "id = ?", whereArgs: [id]);
  }
}

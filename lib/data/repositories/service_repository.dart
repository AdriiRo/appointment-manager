import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/service_model.dart';

class ServiceRepository {
  final _db = FirebaseFirestore.instance;
  String get _businessId => FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _collection => _db.collection('services');

  Stream<List<ServiceModel>> watchServices() {
    return _collection
        .where('businessId', isEqualTo: _businessId)
        .orderBy('name')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => ServiceModel.fromFirestore(doc)).toList());
  }

  Future<void> addService(ServiceModel service) {
    return _collection.add(service.toMap());
  }

  Future<void> updateService(ServiceModel service) {
    return _collection.doc(service.id).update(service.toMap());
  }

  Future<void> deleteService(String id) {
    return _collection.doc(id).delete();
  }
}
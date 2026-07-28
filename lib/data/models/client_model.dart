import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/client.dart';

class ClientModel extends Client {
  const ClientModel({
    required super.id,
    required super.businessId,
    required super.name,
    required super.phone,
  });

  factory ClientModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClientModel(
      id: doc.id,
      businessId: data['businessId'] as String,
      name: data['name'] as String,
      phone: data['phone'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'name': name,
      'phone': phone,
    };
  }
}
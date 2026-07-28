import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.businessId,
    required super.name,
    required super.durationMinutes,
    required super.price,
  });

  factory ServiceModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ServiceModel(
      id: doc.id,
      businessId: data['businessId'] as String,
      name: data['name'] as String,
      durationMinutes: data['durationMinutes'] as int,
      price: (data['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'name': name,
      'durationMinutes': durationMinutes,
      'price': price,
    };
  }
}
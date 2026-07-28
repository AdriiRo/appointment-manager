import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/appointment.dart';

class AppointmentModel extends Appointment {
  const AppointmentModel({
    required super.id,
    required super.businessId,
    required super.serviceId,
    required super.clientId,
    required super.startTime,
    required super.status,
  });

  factory AppointmentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppointmentModel(
      id: doc.id,
      businessId: data['businessId'] as String,
      serviceId: data['serviceId'] as String,
      clientId: data['clientId'] as String,
      startTime: (data['startTime'] as Timestamp).toDate(),
      status: AppointmentStatus.values.byName(data['status'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'businessId': businessId,
      'serviceId': serviceId,
      'clientId': clientId,
      'startTime': Timestamp.fromDate(startTime),
      'status': status.name,
    };
  }
}
enum AppointmentStatus { scheduled, completed, cancelled }

class Appointment {
  final String id;
  final String businessId;
  final String serviceId;
  final String clientId;
  final DateTime startTime;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.businessId,
    required this.serviceId,
    required this.clientId,
    required this.startTime,
    required this.status,
  });
}
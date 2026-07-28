class Service {
  final String id;
  final String businessId;
  final String name;
  final int durationMinutes;
  final double price;

  const Service({
    required this.id,
    required this.businessId,
    required this.name,
    required this.durationMinutes,
    required this.price,
  });
}
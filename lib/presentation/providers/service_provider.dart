import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/service_model.dart';
import '../../data/repositories/service_repository.dart';

final serviceRepositoryProvider =
    Provider<ServiceRepository>((ref) => ServiceRepository());

final servicesStreamProvider = StreamProvider<List<ServiceModel>>((ref) {
  return ref.watch(serviceRepositoryProvider).watchServices();
});
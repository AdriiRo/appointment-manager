import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/service_provider.dart';
import '../../../data/models/service_model.dart';
import 'service_form_screen.dart';

class ServicesScreen extends ConsumerWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final servicesAsync = ref.watch(servicesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Servicios')),
      body: servicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (services) {
          if (services.isEmpty) {
            return const Center(
              child: Text('Aún no tienes servicios. Añade el primero.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final service = services[index];
              return Card(
                child: ListTile(
                  title: Text(service.name),
                  subtitle: Text(
                      '${service.durationMinutes} min · ${service.price.toStringAsFixed(2)} €'),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ServiceFormScreen(service: service),
                        ));
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref, service);
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'edit', child: Text('Editar')),
                      PopupMenuItem(value: 'delete', child: Text('Eliminar')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ServiceFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, ServiceModel service) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Eliminar servicio'),
        content: Text('¿Seguro que quieres eliminar "${service.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              ref.read(serviceRepositoryProvider).deleteService(service.id);
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/service_provider.dart';
import '../../../data/models/service_model.dart';

class ServiceFormScreen extends ConsumerStatefulWidget {
  final ServiceModel? service;

  const ServiceFormScreen({super.key, this.service});

  @override
  ConsumerState<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends ConsumerState<ServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _durationController;
  late final TextEditingController _priceController;
  bool _saving = false;

  bool get _isEditing => widget.service != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service?.name ?? '');
    _durationController = TextEditingController(
        text: widget.service?.durationMinutes.toString() ?? '');
    _priceController =
        TextEditingController(text: widget.service?.price.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _durationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Editar servicio' : 'Nuevo servicio')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del servicio',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Introduce un nombre'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Duración (minutos)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = int.tryParse(v ?? '');
                  return (n == null || n <= 0) ? 'Duración inválida' : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio (€)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = double.tryParse(v ?? '');
                  return (n == null || n < 0) ? 'Precio inválido' : null;
                },
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _submit,
                style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
                child: _saving
                    ? const SizedBox(
                        height: 20, width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : Text(_isEditing ? 'Guardar cambios' : 'Crear servicio'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);
    final repository = ref.read(serviceRepositoryProvider);
    final businessId = FirebaseAuth.instance.currentUser!.uid;

    final service = ServiceModel(
      id: widget.service?.id ?? '',
      businessId: businessId,
      name: _nameController.text.trim(),
      durationMinutes: int.parse(_durationController.text),
      price: double.parse(_priceController.text),
    );

    if (_isEditing) {
      await repository.updateService(service);
    } else {
      await repository.addService(service);
    }

    if (mounted) Navigator.of(context).pop();
  }
}
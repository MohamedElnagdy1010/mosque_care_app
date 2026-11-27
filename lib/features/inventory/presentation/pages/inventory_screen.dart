import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';

import '../../../home/presentation/models/user_role.dart';

import '../../../mosques/domain/entities/mosque.dart';
import '../../../mosques/data/repositories/remote_mosque_repository.dart';
import '../../../mosques/presentation/cubit/mosques/mosques_cubit.dart';
import '../../../mosques/presentation/pages/mosques_screen.dart';

import '../../../requests/presentation/widgets/request_supervisor_fields.dart';

import '../../domain/entities/inventory_draft.dart';
import '../cubit/inventory_cubit.dart';
import '../widgets/inventory_item_card.dart';
import 'inventory_review_screen.dart';

import '../../../requests/data/repositories/service_catalog_repository.dart';
import '../../../requests/presentation/cubit/catalog/catalog_cubit.dart';
import '../../../requests/presentation/cubit/catalog/catalog_state.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => InventoryCubit()),
        BlocProvider(
          create: (context) =>
              CatalogCubit(ServiceCatalogRepository(context.read<ApiClient>()))
                ..loadCatalog(),
        ),
      ],
      child: const _InventoryContent(),
    );
  }
}

class _InventoryContent extends StatefulWidget {
  const _InventoryContent();

  @override
  State<_InventoryContent> createState() => _InventoryContentState();
}

class _InventoryContentState extends State<_InventoryContent> {
  static const _brown = Color(0xFF4A2A16);
  static const _background = Color(0xFFFFF4E2);

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();
  final _notesController = TextEditingController();

  Mosque? _selectedMosque;

  Future<void> _chooseMosque() async {
    final apiClient = context.read<ApiClient>();

    final selected = await Navigator.of(context).push<Mosque>(
      MaterialPageRoute<Mosque>(
        builder: (_) => BlocProvider(
          create: (_) =>
              MosquesCubit(RemoteMosqueRepository(apiClient))..loadMosques(),
          child: const MosquesScreen(
            role: UserRole.authenticatedUser,
            selectionMode: true,
          ),
        ),
      ),
    );

    if (!mounted || selected == null) return;

    setState(() {
      _selectedMosque = selected;
    });
  }

  void _reviewInventory(InventoryState state) {
    final draft = InventoryDraft(
      mosqueId: int.tryParse(_selectedMosque?.id ?? '') ?? 0,
      supervisorName: _nameController.text,
      supervisorPhone: _phoneController.text,
      supervisorRole: _roleController.text,
      generalNotes: _notesController.text,
      items: state.entries.map((entry) => entry.item).toList(),
    );

    final error = draft.validate();

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => InventoryReviewScreen(
          draft: draft,
          mosqueName: _selectedMosque!.name,
          entries: state.entries,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<CatalogCubit>().state;

    if (catalogState is! CatalogLoaded) {
      return Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          title: const Text('توثيق الموجودات'),
          centerTitle: true,
          backgroundColor: _background,
          foregroundColor: _brown,
        ),
        body: Center(
          child: catalogState is CatalogError
              ? Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(catalogState.message, textAlign: TextAlign.center),
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: () {
                          context.read<CatalogCubit>().loadCatalog();
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                )
              : const CircularProgressIndicator(),
        ),
      );
    }

    final categories = catalogState.catalog.categories
        .where((category) => category.items.isNotEmpty)
        .toList();

    if (categories.isEmpty) {
      return Scaffold(
        backgroundColor: _background,
        appBar: AppBar(
          title: const Text('توثيق الموجودات'),
          centerTitle: true,
          backgroundColor: _background,
          foregroundColor: _brown,
        ),
        body: const Center(child: Text('لا توجد خدمات متاحة للتوثيق حاليًا.')),
      );
    }

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('توثيق الموجودات'),
        centerTitle: true,
        backgroundColor: _background,
        foregroundColor: _brown,
      ),
      body: BlocBuilder<InventoryCubit, InventoryState>(
        builder: (context, state) {
          final cubit = context.read<InventoryCubit>();

          return ListView(
            padding: const EdgeInsets.all(16),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'بيانات المسجد',
                      style: TextStyle(
                        color: _brown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_selectedMosque != null) ...[
                      Text(_selectedMosque!.name),
                      Text(_selectedMosque!.neighborhood),
                      const SizedBox(height: 10),
                    ],
                    OutlinedButton.icon(
                      onPressed: _chooseMosque,
                      icon: const Icon(Icons.mosque_outlined),
                      label: Text(
                        _selectedMosque == null
                            ? 'اختيار المسجد'
                            : 'تغيير المسجد',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              RequestSupervisorFields(
                nameController: _nameController,
                phoneController: _phoneController,
                roleController: _roleController,
              ),
              const SizedBox(height: 20),
              Text(
                'الموجودات (${state.entries.length}/30)',
                style: const TextStyle(
                  color: _brown,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              for (var i = 0; i < state.entries.length; i++)
                InventoryItemCard(
                  key: ValueKey(state.entries[i].id),
                  entry: state.entries[i],
                  index: i + 1,
                  categories: categories,
                ),
              OutlinedButton.icon(
                onPressed: state.canAdd ? cubit.addItem : null,
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('إضافة عنصر آخر'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'الملاحظات العامة',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _reviewInventory(state),
                icon: const Icon(Icons.fact_check_outlined),
                label: const Text('مراجعة التوثيق'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
    );
  }
}

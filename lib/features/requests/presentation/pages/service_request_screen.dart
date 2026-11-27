import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/service_catalog_repository.dart';
import '../cubit/catalog/catalog_cubit.dart';
import '../cubit/catalog/catalog_state.dart';
import '../../domain/entities/request_draft.dart';
import '../widgets/request_supervisor_fields.dart';

import '../../../home/presentation/models/user_role.dart';
import '../../../mosques/domain/entities/mosque.dart';
import '../../../mosques/data/repositories/remote_mosque_repository.dart';
import '../../../mosques/presentation/cubit/mosques/mosques_cubit.dart';
import '../../../mosques/presentation/pages/mosques_screen.dart';

import '../widgets/request_selected_needs_section.dart';

import 'package:image_picker/image_picker.dart';

import '../../data/models/service_catalog_model.dart';
import 'request_review_screen.dart';

import '../../data/repositories/request_photo_repository.dart';
import '../../data/repositories/request_repository.dart';
import '../../data/services/request_submission_service.dart';

class ServiceRequestScreen extends StatelessWidget {
  const ServiceRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CatalogCubit(ServiceCatalogRepository(context.read<ApiClient>()))
            ..loadCatalog(),
      child: const _ServiceRequestContent(),
    );
  }
}

class _ServiceRequestContent extends StatefulWidget {
  const _ServiceRequestContent();

  @override
  State<_ServiceRequestContent> createState() => _ServiceRequestContentState();
}

class _ServiceRequestContentState extends State<_ServiceRequestContent> {
  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  final Map<String, RequestNeedDraft> _selected = {};

  final Map<String, XFile> _needPhotos = {};

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _roleController = TextEditingController();

  Mosque? _selectedMosque;

  Future<void> _chooseMosque() async {
    final selected = await Navigator.of(context).push<Mosque>(
      MaterialPageRoute<Mosque>(
        builder: (routeContext) => BlocProvider(
          create: (context) =>
              MosquesCubit(RemoteMosqueRepository(context.read<ApiClient>()))
                ..loadMosques(),
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

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  String _selectionKey(String category, String item) => '$category::$item';

  void _updateNeed(RequestNeedDraft updatedNeed) {
    final key = updatedNeed.selectionKey;

    if (!_selected.containsKey(key)) return;

    setState(() {
      _selected[key] = updatedNeed;
    });
  }

  void _updateNeedPhoto(String selectionKey, XFile? photo) {
    if (!_selected.containsKey(selectionKey)) return;

    setState(() {
      if (photo == null) {
        _needPhotos.remove(selectionKey);
      } else {
        _needPhotos[selectionKey] = photo;
      }
    });
  }

  void _reviewRequest(List<ServiceCatalogCategory> categories) {
    final draft = RequestDraft(
      supervisorName: _nameController.text,
      supervisorPhone: _phoneController.text,
      supervisorRole: _roleController.text,
      mosqueId: int.tryParse(_selectedMosque?.id ?? '') ?? 0,
      needs: _selected.values.toList(),
    );

    final error = draft.validate();

    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final apiClient = context.read<ApiClient>();

    final submissionService = RequestSubmissionService(
      photoRepository: RequestPhotoRepository(apiClient),
      requestRepository: RequestRepository(apiClient),
    );

    final photos = Map<String, XFile>.of(_needPhotos);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => RequestReviewScreen(
          draft: draft,
          mosqueName: _selectedMosque!.name,
          mosqueNeighborhood: _selectedMosque!.neighborhood,
          categories: categories,
          needPhotos: photos,
          onConfirm: () async {
            final requestId = await submissionService.submit(
              draft: draft,
              needPhotos: photos,
            );

            if (mounted) {
              setState(() {
                _selected.clear();
                _needPhotos.clear();
                _selectedMosque = null;

                _nameController.clear();
                _phoneController.clear();
                _roleController.clear();
              });
            }

            return requestId;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: const Text('طلب خدمة'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF4E2),
        foregroundColor: _brown,
      ),
      body: BlocBuilder<CatalogCubit, CatalogState>(
        builder: (context, state) {
          if (state is CatalogInitial || state is CatalogLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CatalogError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => context.read<CatalogCubit>().loadCatalog(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is! CatalogLoaded) {
            return const SizedBox.shrink();
          }

          final categories = state.catalog.categories;

          if (categories.isEmpty) {
            return const Center(
              child: Text('لا توجد أقسام خدمات متاحة حاليًا'),
            );
          }

          return Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حدد احتياجات المسجد',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _brown,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'يمكنك اختيار أكثر من احتياج '
                      'من أقسام مختلفة.',
                      style: TextStyle(color: _brown),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'الاحتياجات المختارة: ${_selected.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _brown,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  itemCount: categories.length + 3,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE8D9C3),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'المسجد المطلوب خدمته',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: _brown,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (_selectedMosque != null) ...[
                                  Text(
                                    _selectedMosque!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _brown,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedMosque!.neighborhood,
                                    style: const TextStyle(
                                      color: Color(0xFF9B8B7A),
                                    ),
                                  ),
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
                          const SizedBox(height: 14),
                        ],
                      );
                    }

                    if (index == 1) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8, bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '01 — اختيار الاحتياجات',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: _brown,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'اختر الخدمات المطلوبة من الأقسام التالية.',
                              style: TextStyle(color: Color(0xFF8A7868)),
                            ),
                          ],
                        ),
                      );
                    }

                    if (index == categories.length + 2) {
                      if (_selected.isEmpty) {
                        return const SizedBox.shrink();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 18),
                          const Divider(
                            color: Color(0xFFD6A343),
                            thickness: 1.5,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            '02 — الاحتياجات المختارة',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: _brown,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'راجع احتياجاتك وحدد الأولوية والملاحظات لكل عنصر.',
                            style: TextStyle(color: Color(0xFF8A7868)),
                          ),
                          const SizedBox(height: 16),

                          RequestSelectedNeedsSection(
                            categories: categories,
                            selectedNeeds: _selected,
                            onNeedChanged: _updateNeed,
                            needPhotos: _needPhotos,
                            onPhotoChanged: _updateNeedPhoto,
                          ),

                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _reviewRequest(categories),
                              icon: const Icon(Icons.fact_check_outlined),
                              label: const Text('مراجعة الطلب'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _brown,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                    final category = categories[index - 2];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ExpansionTile(
                        iconColor: _gold,
                        title: Text(
                          category.name,
                          style: const TextStyle(
                            color: _brown,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('${category.items.length} عناصر'),
                        children: category.items.map((item) {
                          final key = _selectionKey(category.key, item.key);

                          return CheckboxListTile(
                            title: Text(item.name),
                            value: _selected.containsKey(key),
                            activeColor: _brown,
                            controlAffinity: ListTileControlAffinity.leading,

                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  if (_selected.length >= 30) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'الحد الأقصى هو 30 احتياجًا لكل طلب.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  _selected[key] = RequestNeedDraft(
                                    catalogCategory: category.key,
                                    itemKey: item.key,
                                  );
                                } else {
                                  _selected.remove(key);
                                  _needPhotos.remove(key);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

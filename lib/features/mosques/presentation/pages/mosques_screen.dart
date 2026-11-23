import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../home/presentation/models/user_role.dart';

import '../cubit/mosques/mosques_cubit.dart';
import '../cubit/mosques/mosques_state.dart';
import '../widgets/mosque_card.dart';
import '../widgets/mosque_search_bar.dart';

import 'mosque_details_screen.dart';
import '../../../../core/network/api_client.dart';
import '../../data/repositories/remote_mosque_repository.dart';
import '../cubit/mosque_details/mosque_details_cubit.dart';
import '../cubit/mosque_details/mosque_details_state.dart';
import '../widgets/mosque_details_skeleton.dart';

import '../widgets/mosques_list_skeleton.dart';

import '../../data/repositories/mosque_needs_repository.dart';
import '../cubit/mosque_needs/mosque_needs_cubit.dart';

class MosquesScreen extends StatefulWidget {
  const MosquesScreen({
    super.key,
    required this.role,
    this.selectionMode = false,
  });

  final UserRole role;
  final bool selectionMode;

  @override
  State<MosquesScreen> createState() => _MosquesScreenState();
}

class _MosquesScreenState extends State<MosquesScreen> {
  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  Timer? _debounce;

  String _search = '';
  String _status = 'all';
  String _sort = 'newest';

  void _reload() {
    context.read<MosquesCubit>().loadMosques(
      search: _search,
      status: _status,
      sort: _sort,
    );
  }

  void _onSearchChanged(String value) {
    _search = value.trim();

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      if (mounted) _reload();
    });
  }

  void _changeStatus(String value) {
    if (_status == value) return;

    _debounce?.cancel();

    setState(() => _status = value);
    _reload();
  }

  void _changeSort(String value) {
    if (_sort == value) return;

    _debounce?.cancel();

    setState(() => _sort = value);
    _reload();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: Text(widget.selectionMode ? 'اختيار المسجد' : 'دليل المساجد'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF4E2),
        foregroundColor: _brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MosqueSearchBar(onChanged: _onSearchChanged),
            const SizedBox(height: 12),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _statusChip('all', 'جميع المساجد'),
                  const SizedBox(width: 8),
                  _statusChip('under_review', 'تحتاج صيانة'),
                  const SizedBox(width: 8),
                  _statusChip('in_progress', 'قيد التنفيذ'),
                  const SizedBox(width: 8),
                  _statusChip('completed', 'مكتملة'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.sort_rounded, color: _brown),
                const SizedBox(width: 8),
                const Text('ترتيب حسب', style: TextStyle(color: _brown)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _sort,
                    isExpanded: true,
                    underline: const SizedBox.shrink(),
                    items: const [
                      DropdownMenuItem(value: 'newest', child: Text('الأحدث')),
                      DropdownMenuItem(
                        value: 'name_asc',
                        child: Text('الاسم: أ - ي'),
                      ),
                      DropdownMenuItem(
                        value: 'name_desc',
                        child: Text('الاسم: ي - أ'),
                      ),
                      DropdownMenuItem(
                        value: 'most_needy',
                        child: Text('الأكثر احتياجًا'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) _changeSort(value);
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: BlocBuilder<MosquesCubit, MosquesState>(
                builder: (context, state) {
                  if (state is MosquesInitial || state is MosquesLoading) {
                    return const MosquesListSkeleton();
                  }

                  if (state is MosquesError) {
                    return _message(state.message, onRetry: _reload);
                  }

                  if (state is! MosquesLoaded) {
                    return const SizedBox.shrink();
                  }

                  if (state.mosques.isEmpty) {
                    return _message(
                      'لا توجد مساجد مطابقة للبحث أو الفلاتر.',
                      onRetry: _reload,
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<MosquesCubit>().refresh(),
                    child: ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: state.mosques.length + (state.hasMore ? 1 : 0),
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == state.mosques.length) {
                          return Center(
                            child: state.loadingMore
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: CircularProgressIndicator(),
                                  )
                                : TextButton.icon(
                                    onPressed: () =>
                                        context.read<MosquesCubit>().loadMore(),
                                    icon: Icon(
                                      state.loadMoreError
                                          ? Icons.refresh
                                          : Icons.expand_more,
                                    ),
                                    label: Text(
                                      state.loadMoreError
                                          ? 'فشل التحميل، حاول مرة أخرى'
                                          : 'تحميل المزيد',
                                    ),
                                  ),
                          );
                        }

                        final mosque = state.mosques[index];

                        return MosqueCard(
                          name: mosque.name,
                          neighborhood: mosque.neighborhood,
                          imageUrl: mosque.imageUrl,
                          serviceStatus: mosque.serviceStatus,
                          openNeedsCount: mosque.openNeedsCount,
                          mosqueType: mosque.mosqueType,

                          onTap: () {
                            if (widget.selectionMode) {
                              Navigator.of(context).pop(mosque);
                              return;
                            }

                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (routeContext) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider<MosqueDetailsCubit>(
                                      create: (_) => MosqueDetailsCubit(
                                        RemoteMosqueRepository(
                                          routeContext.read<ApiClient>(),
                                        ),
                                      )..loadMosque(mosque.id),
                                    ),
                                    BlocProvider<MosqueNeedsCubit>(
                                      create: (_) => MosqueNeedsCubit(
                                        MosqueNeedsRepository(
                                          routeContext.read<ApiClient>(),
                                        ),
                                      )..loadNeeds(mosque.id),
                                    ),
                                  ],
                                  child:
                                      BlocBuilder<
                                        MosqueDetailsCubit,
                                        MosqueDetailsState
                                      >(
                                        builder: (context, state) {
                                          if (state is MosqueDetailsInitial ||
                                              state is MosqueDetailsLoading) {
                                            return const MosqueDetailsSkeleton();
                                          }

                                          if (state is MosqueDetailsError) {
                                            return Scaffold(
                                              backgroundColor: const Color(
                                                0xFFFFF4E2,
                                              ),
                                              appBar: AppBar(
                                                title: const Text(
                                                  'تفاصيل المسجد',
                                                ),
                                                backgroundColor: const Color(
                                                  0xFFFFF4E2,
                                                ),
                                              ),
                                              body: Center(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      state.message,
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 12),
                                                    OutlinedButton.icon(
                                                      onPressed: () {
                                                        context
                                                            .read<
                                                              MosqueDetailsCubit
                                                            >()
                                                            .loadMosque(
                                                              mosque.id,
                                                            );
                                                      },
                                                      icon: const Icon(
                                                        Icons.refresh,
                                                      ),
                                                      label: const Text(
                                                        'إعادة المحاولة',
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }

                                          if (state is MosqueDetailsLoaded) {
                                            final updatedMosque = state.mosque;

                                            return MosqueDetailsScreen(
                                              mosqueId: updatedMosque.id,
                                              name: updatedMosque.name,
                                              neighborhood:
                                                  updatedMosque.neighborhood,
                                              locationUrl:
                                                  updatedMosque.locationUrl,
                                              role: widget.role,
                                              mosque: updatedMosque,
                                            );
                                          }

                                          return const SizedBox.shrink();
                                        },
                                      ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String value, String label) {
    final selected = _status == value;

    return ChoiceChip(
      label: Text(label),
      selected: selected,
      selectedColor: _gold.withValues(alpha: 0.22),
      labelStyle: TextStyle(
        color: _brown,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: selected ? _gold : const Color(0xFFE8D9C3)),
      onSelected: (_) => _changeStatus(value),
    );
  }

  Widget _message(String text, {required VoidCallback onRetry}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.mosque_outlined, color: _gold, size: 48),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: _brown),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}

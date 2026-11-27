import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/request_repository.dart';
import '../../domain/entities/request_details.dart';
import '../cubit/request_details/request_details_cubit.dart';
import '../widgets/request_status_badge.dart';

class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key, required this.requestId});

  final int requestId;

  static const background = Color(0xFFFFF4E2);
  static const darkBrown = Color(0xFF4A2A16);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          RequestDetailsCubit(RequestRepository(context.read<ApiClient>()))
            ..loadDetails(requestId),
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: const Text('تفاصيل الطلب'),
          centerTitle: true,
          backgroundColor: background,
          foregroundColor: darkBrown,
        ),
        body: BlocBuilder<RequestDetailsCubit, RequestDetailsState>(
          builder: (context, state) {
            if (state is RequestDetailsLoaded) {
              return _RequestDetailsContent(details: state.details);
            }

            if (state is RequestDetailsFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => context
                            .read<RequestDetailsCubit>()
                            .loadDetails(requestId),
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(color: darkBrown),
            );
          },
        ),
      ),
    );
  }
}

class _RequestDetailsContent extends StatelessWidget {
  const _RequestDetailsContent({required this.details});

  final RequestDetails details;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () =>
          context.read<RequestDetailsCubit>().loadDetails(details.id),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        children: [
          _DetailsSection(
            title: 'بيانات الطلب',
            children: [
              Text('رقم الطلب: ${details.id}'),
              Text('المسجد: ${details.mosqueName}'),
              RequestStatusBadge(status: details.status),
            ],
          ),
          const SizedBox(height: 16),
          _DetailsSection(
            title: 'بيانات مقدم الطلب',
            children: [
              Text('الاسم: ${details.supervisorName}'),
              Text('الجوال: ${details.supervisorPhone}'),
              Text('الصفة: ${details.supervisorRole}'),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'الاحتياجات (${details.needs.length})',
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A2A16),
            ),
          ),
          const SizedBox(height: 12),
          for (final need in details.needs)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _NeedDetailsCard(need: need),
            ),
          if (details.generalNotes.isNotEmpty)
            _DetailsSection(
              title: 'الملاحظات العامة',
              children: [Text(details.generalNotes)],
            ),
        ],
      ),
    );
  }
}

class _NeedDetailsCard extends StatelessWidget {
  const _NeedDetailsCard({required this.need});

  final RequestNeedDetails need;

  String _priorityLabel(String value) {
    return switch (value) {
      'high' => 'عالية',
      'medium' => 'متوسطة',
      'low' => 'منخفضة',
      _ => 'غير محددة',
    };
  }

  @override
  Widget build(BuildContext context) {
    return _DetailsSection(
      title: need.title,
      children: [
        RequestStatusBadge(status: need.status),
        Text(
          'أولوية المشرف: '
          '${_priorityLabel(need.supervisorPriority)}',
        ),
        if (need.adminPriority.isNotEmpty)
          Text(
            'الأولوية المعتمدة: '
            '${_priorityLabel(need.adminPriority)}',
          ),
        if (need.notes.isNotEmpty) Text('الملاحظات: ${need.notes}'),
        if (need.photoUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              need.photoUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (_, error, stackTrace) {
                return const SizedBox(
                  height: 100,
                  child: Center(child: Text('تعذر تحميل الصورة')),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5D7B9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Color(0xFF4A2A16),
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 12),
          for (final child in children)
            Padding(padding: const EdgeInsets.only(bottom: 10), child: child),
        ],
      ),
    );
  }
}

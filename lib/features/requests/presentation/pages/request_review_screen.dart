import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/request_draft.dart';
import '../../data/models/service_catalog_model.dart';

class RequestReviewScreen extends StatefulWidget {
  const RequestReviewScreen({
    super.key,
    required this.draft,
    required this.mosqueName,
    required this.mosqueNeighborhood,
    required this.categories,
    required this.needPhotos,
    this.onConfirm,
  });

  final RequestDraft draft;
  final String mosqueName;
  final String mosqueNeighborhood;
  final List<ServiceCatalogCategory> categories;
  final Map<String, XFile> needPhotos;
  final Future<int> Function()? onConfirm;

  @override
  State<RequestReviewScreen> createState() => _RequestReviewScreenState();
}

class _RequestReviewScreenState extends State<RequestReviewScreen> {
  static const _brown = Color(0xFF4A2A16);
  static const _gold = Color(0xFFD6A343);

  bool _isSubmitting = false;
  int? _requestId;
  String? _submitError;

  Future<void> _confirmRequest() async {
    if (_isSubmitting || widget.onConfirm == null) return;

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final requestId = await widget.onConfirm!();

      if (!mounted) return;

      setState(() {
        _requestId = requestId;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _submitError = _getErrorMessage(error);
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  String _getErrorMessage(Object error) {
    if (error is FormatException) {
      return error.message.toString();
    }

    if (error is StateError) {
      return error.message.toString();
    }

    if (error is DioException) {
      final data = error.response?.data;

      if (data is Map) {
        final message = data['message'];

        if (message is String && message.trim().isNotEmpty) {
          return message;
        }
      }

      return 'تعذر الاتصال بالخادم. تحقق من الإنترنت وحاول مرة أخرى.';
    }

    return 'حدث خطأ أثناء إرسال الطلب. يرجى المحاولة مرة أخرى.';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isSubmitting,
      child: Scaffold(
        backgroundColor: const Color(0xFFFFF4E2),
        appBar: AppBar(
          title: const Text('مراجعة طلب الخدمة'),
          centerTitle: true,
          backgroundColor: const Color(0xFFFFF4E2),
          foregroundColor: _brown,
        ),
        body: _requestId != null
            ? _buildSuccessContent()
            : _buildReviewContent(),
      ),
    );
  }

  Widget _buildReviewContent() {
    final draft = widget.draft;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'راجع بيانات الطلب قبل الإرسال',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: _brown,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'يمكنك الرجوع لتعديل البيانات أو الاحتياجات.',
          style: TextStyle(color: _brown),
        ),
        const SizedBox(height: 20),

        _sectionCard(
          title: 'بيانات مقدم الطلب',
          icon: Icons.person_outline,
          children: [
            _detailRow('الاسم', draft.supervisorName),
            _detailRow('رقم الجوال', draft.supervisorPhone),
            _detailRow('الصفة', draft.supervisorRole),
          ],
        ),

        const SizedBox(height: 14),

        _sectionCard(
          title: 'بيانات المسجد',
          icon: Icons.mosque_outlined,
          children: [
            _detailRow('اسم المسجد', widget.mosqueName),
            _detailRow('الحي', widget.mosqueNeighborhood),
          ],
        ),

        const SizedBox(height: 14),

        ...widget.categories.map((category) {
          final needs = draft.needs
              .where((need) => need.catalogCategory == category.key)
              .toList();

          if (needs.isEmpty) {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _sectionCard(
              title: category.name,
              icon: Icons.checklist_rounded,
              children: needs.map((need) {
                final matchingItems = category.items.where(
                  (item) => item.key == need.itemKey,
                );

                final itemName = matchingItems.isNotEmpty
                    ? matchingItems.first.name
                    : need.itemKey;

                final priorityLabel = switch (need.priority) {
                  'high' => 'عالية',
                  'low' => 'منخفضة',
                  _ => 'متوسطة',
                };

                final photo = widget.needPhotos[need.selectionKey];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _detailRow('الاحتياج', itemName),
                    _detailRow('الأولوية', priorityLabel),

                    if (need.notes.trim().isNotEmpty)
                      _detailRow('الملاحظات', need.notes),

                    if (photo != null) ...[
                      const Text(
                        'صورة المشكلة',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A7868),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(photo.path),
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Padding(
                              padding: EdgeInsets.all(12),
                              child: Text('تعذر عرض الصورة المرفقة.'),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],

                    const Divider(height: 20),
                  ],
                );
              }).toList(),
            ),
          );
        }),

        const SizedBox(height: 12),

        if (_submitError != null) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _submitError!,
              style: TextStyle(
                color: Colors.red.shade800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],

        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isSubmitting || widget.onConfirm == null
                ? null
                : _confirmRequest,
            icon: _isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send_rounded),
            label: Text(
              _isSubmitting ? 'جارٍ إرسال الطلب...' : 'تأكيد وإرسال الطلب',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _brown,
              foregroundColor: Colors.white,
              disabledBackgroundColor: const Color(0xFFD6C9B8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.edit_outlined),
          label: const Text('الرجوع لتعديل الطلب'),
        ),
      ],
    );
  }

  Widget _buildSuccessContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_rounded,
              size: 90,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'تم إرسال طلب الخدمة بنجاح',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _brown,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'تم استلام طلبك وسيتم مراجعته من قبل الإدارة.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF8A7868), fontSize: 15),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE8D9C3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'رقم الطلب',
                    style: TextStyle(color: Color(0xFF8A7868)),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_requestId',
                    style: const TextStyle(
                      color: _brown,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brown,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('العودة'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8D9C3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _gold),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: _brown,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF8A7868)),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _brown,
            ),
          ),
        ],
      ),
    );
  }
}

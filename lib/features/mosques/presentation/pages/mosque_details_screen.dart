import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../home/presentation/models/user_role.dart';
import '../../domain/entities/mosque.dart';
import '../../domain/entities/mosque_request.dart';
import '../models/mosque_permissions.dart';
import '../models/mosque_request_item.dart';
import '../../domain/entities/mosque_visit.dart';
import '../widgets/mosque_info_card.dart';
import '../widgets/mosque_last_visit_card.dart';
import '../widgets/mosque_recent_requests_card.dart';

class MosqueDetailsScreen extends StatelessWidget {
  const MosqueDetailsScreen({
    super.key,
    required this.name,
    required this.neighborhood,
    required this.mosqueId,
    required this.role,
    this.assignedMosqueId,
    this.locationUrl,
    this.mosque,
    this.lastVisit,
    this.requests = const [],
  });

  final Mosque? mosque;
  final String name;
  final String neighborhood;
  final String mosqueId;
  final UserRole role;
  final String? assignedMosqueId;
  final String? locationUrl;
  final MosqueVisit? lastVisit;
  final List<MosqueRequest> requests;

  @override
  Widget build(BuildContext context) {
    final canViewMosque = MosquePermissions.canViewMosque(
      role: role,
      mosqueId: mosqueId,
      assignedMosqueId: assignedMosqueId,
    );

    final showOperationalDetails =
        MosquePermissions.canViewOperationalDetails(role) && canViewMosque;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: const Text('تفاصيل المسجد'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF4E2),
      ),
      body: !canViewMosque
          ? const Center(
              child: Text(
                'ليس لديك صلاحية لعرض هذا المسجد',
                style: TextStyle(color: Color(0xFF4A2A16), fontSize: 16),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE8D9C3)),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.mosque_outlined,
                          size: 60,
                          color: Color(0xFF8A5A2B),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A2A16),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'حي $neighborhood - المزاحمية',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF9B8B7A),
                          ),
                        ),

                        if (locationUrl != null && locationUrl!.isNotEmpty) ...[
                          const SizedBox(height: 12),

                          TextButton.icon(
                            onPressed: () async {
                              final uri = Uri.tryParse(locationUrl!);

                              if (uri == null ||
                                  !['https', 'http'].contains(uri.scheme)) {
                                return;
                              }

                              try {
                                final opened = await launchUrl(
                                  uri,
                                  mode: LaunchMode.platformDefault,
                                );

                                if (!opened && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تعذر فتح موقع المسجد'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                debugPrint('MAP LAUNCH ERROR: $e');
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('تعذر فتح موقع المسجد'),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.location_on_outlined,
                              color: Color(0xFF8A5A2B),
                            ),
                            label: const Text(
                              'عرض موقع المسجد',
                              style: TextStyle(
                                color: Color(0xFF8A5A2B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // المعلومات العامة: تظهر لجميع الأدوار
                  MosqueInfoCard(
                    imamName: mosque?.imamName ?? 'غير محدد',
                    muezzinName: mosque?.muezzinName ?? 'غير محدد',
                    registrationSource:
                        mosque?.registrationSource ?? 'غير محدد',
                    mosqueType: mosque?.mosqueType ?? 'غير محدد',
                  ),

                  // المعلومات التشغيلية: تظهر للأدوار المصرح لها فقط
                  if (showOperationalDetails) ...[
                    const SizedBox(height: 14),

                    MosqueLastVisitCard(
                      visitDate:
                          lastVisit != null &&
                              lastVisit!.mosqueId == mosqueId &&
                              lastVisit!.status == 'مكتملة'
                          ? '${lastVisit!.visitDate.day}/'
                                '${lastVisit!.visitDate.month}/'
                                '${lastVisit!.visitDate.year}'
                          : null,
                      serviceType:
                          lastVisit != null &&
                              lastVisit!.mosqueId == mosqueId &&
                              lastVisit!.status == 'مكتملة'
                          ? lastVisit!.serviceType
                          : null,
                      visitStatus:
                          lastVisit != null &&
                              lastVisit!.mosqueId == mosqueId &&
                              lastVisit!.status == 'مكتملة'
                          ? lastVisit!.status
                          : null,
                    ),

                    const SizedBox(height: 14),

                    MosqueRecentRequestsCard(
                      requests: requests
                          .where((request) => request.mosqueId == mosqueId)
                          .map(
                            (request) => MosqueRequestItem(
                              title: request.title,
                              source: request.source,
                              status: request.status,
                              date: request.createdAt,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
    );
  }
}

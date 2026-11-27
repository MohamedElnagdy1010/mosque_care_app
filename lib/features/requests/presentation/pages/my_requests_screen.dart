import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_client.dart';
import '../../data/repositories/request_repository.dart';
import '../cubit/my_requests/my_requests_cubit.dart';
import '../cubit/my_requests/my_requests_state.dart';
import '../widgets/my_request_card.dart';
import 'request_details_screen.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyRequestsCubit(RequestRepository(context.read<ApiClient>()))
            ..loadRequests(),
      child: const _MyRequestsContent(),
    );
  }
}

class _MyRequestsContent extends StatelessWidget {
  const _MyRequestsContent();

  static const background = Color(0xFFFFF4E2);
  static const darkBrown = Color(0xFF4A2A16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('طلباتي'),
        centerTitle: true,
        backgroundColor: background,
        foregroundColor: darkBrown,
      ),
      body: BlocBuilder<MyRequestsCubit, MyRequestsState>(
        builder: (context, state) {
          final cubit = context.read<MyRequestsCubit>();

          if (state.status == MyRequestsStatus.initial ||
              state.status == MyRequestsStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: darkBrown),
            );
          }

          if (state.status == MyRequestsStatus.failure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.errorMessage ?? 'تعذر تحميل الطلبات.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: cubit.loadRequests,
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            color: darkBrown,
            onRefresh: cubit.refresh,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'إجمالي الطلبات: ${state.total}',
                  style: const TextStyle(
                    color: darkBrown,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                if (state.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: darkBrown,
                        ),
                        SizedBox(height: 16),
                        Text('لا توجد طلبات حتى الآن'),
                      ],
                    ),
                  ),
                for (final request in state.items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: MyRequestCard(
                      request: request,
                      onTap: () async {
                        await Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) =>
                                RequestDetailsScreen(requestId: request.id),
                          ),
                        );

                        if (context.mounted) {
                          await cubit.refresh();
                        }
                      },
                    ),
                  ),
                if (state.isLoadingMore)
                  const Center(
                    child: CircularProgressIndicator(color: darkBrown),
                  )
                else if (state.hasMore)
                  OutlinedButton(
                    onPressed: cubit.loadMore,
                    child: const Text('تحميل المزيد'),
                  ),
                if (state.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      state.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

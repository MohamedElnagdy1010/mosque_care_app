import 'package:flutter/material.dart';

import '../../../home/presentation/models/user_role.dart';

import '../widgets/mosque_search_bar.dart';
import '../widgets/mosque_card.dart';
import 'mosque_details_screen.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/mosques_cubit.dart';
import '../cubit/mosques_state.dart';

class MosquesScreen extends StatefulWidget {
  const MosquesScreen({super.key, required this.role});

  final UserRole role;

  @override
  State<MosquesScreen> createState() => _MosquesScreenState();
}

class _MosquesScreenState extends State<MosquesScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4E2),
      appBar: AppBar(
        title: const Text('المساجد'),
        centerTitle: true,
        backgroundColor: const Color(0xFFFFF4E2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            MosqueSearchBar(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim();
                });
              },
            ),
            const SizedBox(height: 16),

            Expanded(
              child: BlocBuilder<MosquesCubit, MosquesState>(
                builder: (context, state) {
                  if (state is MosquesLoading || state is MosquesInitial) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is MosquesError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is MosquesLoaded) {
                    final filteredMosques = state.mosques.where((mosque) {
                      return mosque.name.contains(_searchQuery) ||
                          mosque.neighborhood.contains(_searchQuery);
                    }).toList();

                    if (filteredMosques.isEmpty) {
                      return const Center(
                        child: Text(
                          'لا توجد مساجد مطابقة للبحث',
                          style: TextStyle(
                            color: Color(0xFF9B8B7A),
                            fontSize: 15,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: filteredMosques.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final mosque = filteredMosques[index];

                        return MosqueCard(
                          name: mosque.name,
                          neighborhood: mosque.neighborhood,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MosqueDetailsScreen(
                                  mosqueId: mosque.id,
                                  name: mosque.name,
                                  neighborhood: mosque.neighborhood,
                                  locationUrl: mosque.locationUrl,
                                  role: widget.role,
                                  mosque: mosque,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

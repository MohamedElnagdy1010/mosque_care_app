import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mosque_care_app/features/mosques/data/repositories/local_mosque_repository.dart';

import 'package:mosque_care_app/features/mosques/presentation/cubit/mosques_cubit.dart';
import 'package:mosque_care_app/features/mosques/presentation/cubit/mosques_state.dart';

void main() {
  group('MosquesCubit', () {
    blocTest<MosquesCubit, MosquesState>(
      'emits Loading then Loaded when mosques load successfully',
      build: () => MosquesCubit(LocalMosqueRepository()),
      act: (cubit) => cubit.loadMosques(),
      expect: () => [
        isA<MosquesLoading>(),
        isA<MosquesLoaded>().having(
          (state) => state.mosques.length,
          'mosques count',
          4,
        ),
      ],
    );
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_cached_tutor_list.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_next_tutor_list.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_tutor_list.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:cotor/features/tutor_profile_list/bloc/tutor_profile_list_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetTutorProfilesList extends Mock implements GetTutorList {}

class MockGetNextTutorProfilesList extends Mock implements GetNextTutorList {}

class MockGetCachedTutorProfilesList extends Mock
    implements GetCachedTutorList {}

void main() {
  group('TutorProfileListBloc', () {
    TutorProfileListBloc profilesBloc;
    MockGetTutorProfilesList getTutorProfileList;
    MockGetNextTutorProfilesList getNextProfileList;
    MockGetCachedTutorProfilesList getCachedProfileList;

    setUp(() {
      getTutorProfileList = MockGetTutorProfilesList();
      getNextProfileList = MockGetNextTutorProfilesList();
      getCachedProfileList = MockGetCachedTutorProfilesList();
      profilesBloc = TutorProfileListBloc(
        getTutorProfileList: getTutorProfileList,
        getNextTutorProfileList: getNextProfileList,
        getCachedTutorProfileList: getCachedProfileList,
      );
    });

    tearDown(() {
      profilesBloc?.close();
    });

    group('Throws null if any params isn\'t present', () {
      test('throws AssertionError if getTutorProfileList is null', () {
        expect(
          () => TutorProfileListBloc(
            getTutorProfileList: null,
            getNextTutorProfileList: getNextProfileList,
            getCachedTutorProfileList: getCachedProfileList,
          ),
          throwsA(isAssertionError),
        );
      });
      test('throws AssertionError if getCachedTutorProfileList is null', () {
        expect(
          () => TutorProfileListBloc(
            getTutorProfileList: getTutorProfileList,
            getCachedTutorProfileList: null,
            getNextTutorProfileList: getNextProfileList,
          ),
          throwsA(isAssertionError),
        );
      });
      test('throws AssertionError if getNextTutorProfileList is null', () {
        expect(
          () => TutorProfileListBloc(
            getTutorProfileList: getTutorProfileList,
            getCachedTutorProfileList: getCachedProfileList,
            getNextTutorProfileList: null,
          ),
          throwsA(isAssertionError),
        );
      });
    });

    test('initial state is correct', () {
      expect(profilesBloc.initialState, Loading());
    });

    test('close does not emit new states', () {
      expectLater(
        profilesBloc,
        emitsInOrder(<dynamic>[Loading(), emitsDone]),
      );
      profilesBloc.close();
    });

    group('Get Profile List', () {
      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [Loading, TutorProfilesLoaded.normal] when successful and there\'re profiles',
        build: () async {
          when(getTutorProfileList(any)).thenAnswer(
            (_) async => Right(<TutorProfile>[TutorProfileModel()]),
          );
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetTutorProfileList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <TutorProfileListState>[
          Loading(),
          TutorProfilesLoaded.normal(
            profiles: <TutorProfileModel>[TutorProfileModel()],
          )
        ],
      );
      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [Loading, TutorProfilesLoaded.empty] when successful and there\'s no profiles',
        build: () async {
          when(getTutorProfileList(any)).thenAnswer(
            (_) async => Right(<TutorProfile>[]),
          );
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetTutorProfileList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <TutorProfileListState>[
          Loading(),
          TutorProfilesLoaded.normal(
            profiles: const [],
          )
        ],
      );

      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [Loading, InitialTutorProfilesLoadError(NETWORK_FAILURE_MSG)] when attempting without internet',
        build: () async {
          when(getTutorProfileList(any)).thenAnswer(
            (_) async => Left(NetworkFailure()),
          );
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetTutorProfileList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <TutorProfileListState>[
          Loading(),
          InitialTutorProfilesLoadError(
            message: NETWORK_FAILURE_MSG,
            isCacheError: false,
          )
        ],
      );

      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [Loading, InitialTutorProfilesLoadError(SERVER_FAILURE_MSG)] when server fails to retrieve data',
        build: () async {
          when(getTutorProfileList(any)).thenAnswer(
            (_) async => Left(ServerFailure()),
          );
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetTutorProfileList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <TutorProfileListState>[
          Loading(),
          InitialTutorProfilesLoadError(
            message: SERVER_FAILURE_MSG,
            isCacheError: false,
          )
        ],
      );
    });
    group('Get Next Profile List', () {
      void _setUpMockGetTutorProfileListCall() {
        when(getTutorProfileList(any)).thenAnswer(
          (_) async => Right(<TutorProfile>[
            TutorProfileModel(),
          ]),
        );
      }

      final List<TutorProfileListState> initialPlusLoading =
          <TutorProfileListState>[
        TutorProfilesLoaded.normal(
          profiles: <TutorProfileModel>[TutorProfileModel()],
        ),
        TutorProfilesLoaded.normal(
          profiles: <TutorProfileModel>[TutorProfileModel()],
        ).copyWith(
          isFetching: true,
        ),
      ];

      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [TutorProfilesLoaded(isFetching: true), TutorProfilesLoaded(profiles: newProfiles, isFetching: false)] when successful and there\'s  more profiles',
        build: () async {
          _setUpMockGetTutorProfileListCall();
          profilesBloc.add(GetTutorProfileList());
          when(getNextProfileList(any)).thenAnswer((_) async => Right(
                <TutorProfile>[TutorProfileModel()],
              ));
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextTutorProfileList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <TutorProfileListState>[
          ...initialPlusLoading,
          TutorProfilesLoaded.normal(
            profiles: <TutorProfileModel>[
              TutorProfileModel(),
              TutorProfileModel(),
            ],
          )
        ],
      );
      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [TutorProfilesLoaded(isFetching: true), TutorProfilesLoaded(isEnd: true, isFetching: false)] when successful and there\'s no more profiles',
        build: () async {
          _setUpMockGetTutorProfileListCall();
          profilesBloc.add(GetTutorProfileList());
          when(getNextProfileList(any)).thenAnswer((_) async => Right(
                null,
              ));
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextTutorProfileList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <TutorProfileListState>[
          ...initialPlusLoading,
          TutorProfilesLoaded.normal(
            profiles: <TutorProfileModel>[TutorProfileModel()],
          ).copyWith(isEnd: true)
        ],
      );

      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [TutorProfilesLoaded(isFetching: true),TutorProfilesLoaded(isGetNextListError: true)]  when attempting without internet',
        build: () async {
          _setUpMockGetTutorProfileListCall();
          profilesBloc.add(GetTutorProfileList());
          when(getNextProfileList(any))
              .thenAnswer((_) async => Left(NetworkFailure()));
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextTutorProfileList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <TutorProfileListState>[
          ...initialPlusLoading,
          TutorProfilesLoaded.normal(
            profiles: <TutorProfileModel>[TutorProfileModel()],
          ).copyWith(isGetNextListError: true)
        ],
      );

      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [Loading, TutorProfilesLoaded(isGetNextListError: true)] when server fails to retrieve data',
        build: () async {
          _setUpMockGetTutorProfileListCall();
          profilesBloc.add(GetTutorProfileList());
          when(getNextProfileList(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextTutorProfileList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <TutorProfileListState>[
          ...initialPlusLoading,
          TutorProfilesLoaded.normal(
            profiles: <TutorProfileModel>[TutorProfileModel()],
          ).copyWith(isGetNextListError: true)
        ],
      );
    });
    group('Get Cache Profile List', () {
      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [Loading, TutorProfilesLoaded(asssignments: assigmentList, isCachedList: true,)] when there\'s cached profiles',
        build: () async {
          when(getCachedProfileList(any)).thenAnswer(
            (_) async => Right(<TutorProfile>[TutorProfileModel()]),
          );
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetCachedTutorProfileList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <TutorProfileListState>[
          Loading(),
          TutorProfilesLoaded.normal(
            profiles: <TutorProfileModel>[TutorProfileModel()],
          ).copyWith(isCachedList: true)
        ],
      );

      blocTest<TutorProfileListBloc, TutorProfileListEvent,
          TutorProfileListState>(
        'emits [Loading, InitialTutorProfilesLoadError(CACHE_FAILURE_MSG)] when there is no cached profiles',
        build: () async {
          when(getCachedProfileList(any)).thenAnswer(
            (_) async => Left(CacheFailure()),
          );
          return profilesBloc;
        },
        act: (bloc) async {
          bloc.add(GetCachedTutorProfileList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <TutorProfileListState>[
          Loading(),
          InitialTutorProfilesLoadError(
            message: CACHE_FAILURE_MSG,
            isCacheError: true,
          )
        ],
      );
    });
  });
}

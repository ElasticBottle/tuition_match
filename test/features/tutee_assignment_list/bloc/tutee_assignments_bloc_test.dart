import 'package:bloc_test/bloc_test.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_cached_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_next_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_tutee_assignment_list.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/tutee_assignments_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockGetTuteeAssignmentList extends Mock
    implements GetTuteeAssignmentList {}

class MockGetNextTuteeAssignmentList extends Mock
    implements GetNextTuteeAssignmentList {}

class MockGetCachedTuteeAssignmentList extends Mock
    implements GetCachedTuteeAssignmentList {}

void main() {
  group('AssignmentsBloc', () {
    AssignmentsBloc assignmentsBloc;
    MockGetTuteeAssignmentList getAssignmentList;
    MockGetNextTuteeAssignmentList getNextAssignmentList;
    MockGetCachedTuteeAssignmentList getCachedAssignmentList;

    setUp(() {
      getAssignmentList = MockGetTuteeAssignmentList();
      getNextAssignmentList = MockGetNextTuteeAssignmentList();
      getCachedAssignmentList = MockGetCachedTuteeAssignmentList();
      assignmentsBloc = AssignmentsBloc(
        getAssignmentList: getAssignmentList,
        getNextAssignments: getNextAssignmentList,
        getCachedAssignments: getCachedAssignmentList,
      );
    });

    tearDown(() {
      assignmentsBloc?.close();
    });

    group('Throws null if any params isn\'t present', () {
      test('throws AssertionError if getAssignmentList is null', () {
        expect(
          () => AssignmentsBloc(
            getAssignmentList: null,
            getCachedAssignments: getCachedAssignmentList,
            getNextAssignments: getNextAssignmentList,
          ),
          throwsA(isAssertionError),
        );
      });
      test('throws AssertionError if getCachedAssignments is null', () {
        expect(
          () => AssignmentsBloc(
            getAssignmentList: getAssignmentList,
            getCachedAssignments: null,
            getNextAssignments: getNextAssignmentList,
          ),
          throwsA(isAssertionError),
        );
      });
      test('throws AssertionError if getNextAssignments is null', () {
        expect(
          () => AssignmentsBloc(
            getAssignmentList: getAssignmentList,
            getCachedAssignments: getCachedAssignmentList,
            getNextAssignments: null,
          ),
          throwsA(isAssertionError),
        );
      });
    });

    test('initial state is correct', () {
      expect(assignmentsBloc.initialState, Loading());
    });

    test('close does not emit new states', () {
      expectLater(
        assignmentsBloc,
        emitsInOrder(<dynamic>[Loading(), emitsDone]),
      );
      assignmentsBloc.close();
    });

    group('Get Assignment List', () {
      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [Loading, AssignmentLoaded.normal] when successful and there\'s assignments',
        build: () async {
          when(getAssignmentList(any)).thenAnswer(
            (_) async => Right(<TuteeAssignment>[TuteeAssignment()]),
          );
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetAssignmentList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <AssignmentsState>[
          Loading(),
          AssignmentLoaded.normal(
            assignments: const <TuteeAssignment>[TuteeAssignment()],
          )
        ],
      );
      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [Loading, AssignmentLoaded.empty] when successful and there\'s no assignments',
        build: () async {
          when(getAssignmentList(any)).thenAnswer(
            (_) async => Right(<TuteeAssignment>[]),
          );
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetAssignmentList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <AssignmentsState>[
          Loading(),
          AssignmentLoaded.normal(
            assignments: const [],
          )
        ],
      );

      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [Loading, InitialAssignmentsLoadError(NETWORK_FAILURE_MSG)] when attempting without internet',
        build: () async {
          when(getAssignmentList(any)).thenAnswer(
            (_) async => Left(NetworkFailure()),
          );
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetAssignmentList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <AssignmentsState>[
          Loading(),
          InitialAssignmentsLoadError(
            message: Strings.networkFailureErrorMsg,
            isCacheError: false,
          )
        ],
      );

      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [Loading, InitialAssignmentsLoadError(SERVER_FAILURE_MSG)] when server fails to retrieve data',
        build: () async {
          when(getAssignmentList(any)).thenAnswer(
            (_) async => Left(ServerFailure()),
          );
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetAssignmentList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <AssignmentsState>[
          Loading(),
          InitialAssignmentsLoadError(
            message: Strings.serverFailureErrorMsg,
            isCacheError: false,
          )
        ],
      );
    });
    group('Get Next Assignment List', () {
      void _setUpMockGetAssignmentListCall() {
        when(getAssignmentList(any)).thenAnswer(
          (_) async => Right(<TuteeAssignment>[
            TuteeAssignment(),
          ]),
        );
      }

      final List<AssignmentsState> initialPlusLoading = <AssignmentsState>[
        AssignmentLoaded.normal(
          assignments: const <TuteeAssignment>[TuteeAssignment()],
        ),
        AssignmentLoaded.normal(
          assignments: const <TuteeAssignment>[TuteeAssignment()],
        ).copyWith(
          isFetching: true,
        ),
      ];

      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [AssignmentLoaded(isFetching: true), AssignmentLoaded(assignments: newAssignments, isFetching: false)] when successful and there\'s  more assignments',
        build: () async {
          _setUpMockGetAssignmentListCall();
          assignmentsBloc.add(GetAssignmentList());
          when(getNextAssignmentList(any)).thenAnswer((_) async => Right(
                <TuteeAssignment>[TuteeAssignment()],
              ));
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextAssignmentList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <AssignmentsState>[
          ...initialPlusLoading,
          AssignmentLoaded.normal(
            assignments: const <TuteeAssignment>[
              TuteeAssignment(),
              TuteeAssignment(),
            ],
          )
        ],
      );
      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [AssignmentLoaded(isFetching: true), AssignmentLoaded(isEnd: true, isFetching: false)] when successful and there\'s no more assignments',
        build: () async {
          _setUpMockGetAssignmentListCall();
          assignmentsBloc.add(GetAssignmentList());
          when(getNextAssignmentList(any)).thenAnswer((_) async => Right(
                null,
              ));
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextAssignmentList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <AssignmentsState>[
          ...initialPlusLoading,
          AssignmentLoaded.normal(
            assignments: const <TuteeAssignment>[TuteeAssignment()],
          ).copyWith(isEnd: true)
        ],
      );

      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [AssignmentLoaded(isFetching: true),AssignmentLoaded(isGetNextListError: true)]  when attempting without internet',
        build: () async {
          _setUpMockGetAssignmentListCall();
          assignmentsBloc.add(GetAssignmentList());
          when(getNextAssignmentList(any))
              .thenAnswer((_) async => Left(NetworkFailure()));
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextAssignmentList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <AssignmentsState>[
          ...initialPlusLoading,
          AssignmentLoaded.normal(
            assignments: const <TuteeAssignment>[TuteeAssignment()],
          ).copyWith(isGetNextListError: true)
        ],
      );

      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [Loading, AssignmentLoaded(isGetNextListError: true)] when server fails to retrieve data',
        build: () async {
          _setUpMockGetAssignmentListCall();
          assignmentsBloc.add(GetAssignmentList());
          when(getNextAssignmentList(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetNextAssignmentList());
        },
        wait: const Duration(milliseconds: 1000),
        expect: <AssignmentsState>[
          ...initialPlusLoading,
          AssignmentLoaded.normal(
            assignments: const <TuteeAssignment>[TuteeAssignment()],
          ).copyWith(isGetNextListError: true)
        ],
      );
    });
    group('Get Cache Assignment List', () {
      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [Loading, AssignmentLoaded(asssignments: assigmentList, isCachedList: true,)] when there\'s cached assignments',
        build: () async {
          when(getCachedAssignmentList(any)).thenAnswer(
            (_) async => Right(<TuteeAssignment>[TuteeAssignment()]),
          );
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetCachedAssignmentList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <AssignmentsState>[
          Loading(),
          AssignmentLoaded.normal(
            assignments: const <TuteeAssignment>[TuteeAssignment()],
          ).copyWith(isCachedList: true)
        ],
      );

      blocTest<AssignmentsBloc, AssignmentsEvent, AssignmentsState>(
        'emits [Loading, InitialAssignmentsLoadError(CACHE_FAILURE_MSG)] when there is no cached assignments',
        build: () async {
          when(getCachedAssignmentList(any)).thenAnswer(
            (_) async => Left(CacheFailure()),
          );
          return assignmentsBloc;
        },
        act: (bloc) async {
          bloc.add(GetCachedAssignmentList());
        },
        skip: 0,
        wait: const Duration(milliseconds: 500),
        expect: <AssignmentsState>[
          Loading(),
          InitialAssignmentsLoadError(
            message: Strings.cacheFailureErrorMsg,
            isCacheError: true,
          )
        ],
      );
    });
  });
}

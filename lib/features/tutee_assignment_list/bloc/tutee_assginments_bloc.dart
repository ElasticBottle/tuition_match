import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cotor/features/tutee_assignment_list/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_cached_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_next_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_tutee_assignment_list.dart';
import 'package:flutter/material.dart';

const String SERVER_FAILURE_MSG =
    'Sorry, Our Server is having problems processing the request (||^_^), retrieving last fetched list';
const String NETWORK_FAILURE_MSG =
    'No internet access, please check your connection, retrieving last fetched list';
const String CACHE_FAILURE_MSG =
    'No last fetched list, please try again when you\'re online!';
const String UNKNOWN_FAILURE_MSG =
    'Something went wrong and we don\'t know why, drop us a message at jeffhols18@gami.com and we\'ll get you sorted right away.';

class AssignmentsBloc extends Bloc<AssignmentsEvent, AssignmentsState> {
  AssignmentsBloc({
    @required this.getAssignmentList,
    @required this.getNextAssignments,
    @required this.getCachedAssignments,
  })  : assert(getAssignmentList != null),
        assert(getNextAssignments != null),
        assert(getCachedAssignments != null);
  final GetTuteeAssignmentList getAssignmentList;
  final GetNextTuteeAssignmentList getNextAssignments;
  final GetCachedTuteeAssignmentList getCachedAssignments;
  List<TuteeAssignment> assignments = [];
  @override
  AssignmentsState get initialState => InitialAssignmentsState();

  @override
  Stream<AssignmentsState> transformEvents(
    Stream<AssignmentsEvent> events,
    Stream<AssignmentsState> Function(AssignmentsEvent event) next,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! GetNextAssignmentList;
    });
    final debounceStream = events.where((event) {
      return event is GetNextAssignmentList;
    }).debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      next,
    );
  }

  @override
  Stream<AssignmentsState> mapEventToState(
    AssignmentsEvent event,
  ) async* {
    if (event is GetAssignmentList) {
      yield* _mapGetAssignmentListToState(event);
    } else if (event is GetNextAssignmentList) {
      yield* _mepGetNextAssignmentListToState(event);
    } else if (event is GetCachedAssignmentList) {
      yield* _mapGetCachedAssignmentListToState(event);
    }
  }

  Stream<AssignmentsState> _mapGetAssignmentListToState(
      GetAssignmentList event) async* {
    yield AssignmentLoading();
    assignments.clear();
    final result = await getAssignmentList(NoParams());
    yield* result.fold(
      (failure) async* {
        yield AssignmentError(message: _mapFailureToFailureMessage(failure));
      },
      (assignmentList) async* {
        assignments.addAll(assignmentList);
        yield AssignmentLoaded(assignments: assignments);
      },
    );
  }

  Stream<AssignmentsState> _mepGetNextAssignmentListToState(
      GetNextAssignmentList event) async* {
    yield NextAssignmentLoading(assignments: assignments);
    final result = await getNextAssignments(NoParams());
    yield* result.fold(
      (failure) async* {
        yield AssignmentError(message: _mapFailureToFailureMessage(failure));
      },
      (assignmentList) async* {
        if (assignmentList != null) {
          assignments.addAll(assignmentList);
          yield AssignmentLoaded(assignments: assignments);
        } else {
          yield AllAssignmentLoaded(assignments: assignments);
        }
      },
    );
  }

  Stream<AssignmentsState> _mapGetCachedAssignmentListToState(
      GetCachedAssignmentList event) async* {
    yield AssignmentLoading();
    final result = await getCachedAssignments(NoParams());
    yield* result.fold(
      (failure) async* {
        yield CachedAssignmentError(
            message: _mapFailureToFailureMessage(failure));
      },
      (assignmentList) async* {
        assignments.addAll(assignmentList);
        yield CachedAssignmentLoaded(assignments: assignmentList);
      },
    );
  }

  String _mapFailureToFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return NETWORK_FAILURE_MSG;
        break;
      case ServerFailure:
        return SERVER_FAILURE_MSG;
        break;
      case CacheFailure:
        return CACHE_FAILURE_MSG;
        break;
      default:
        return UNKNOWN_FAILURE_MSG;
        break;
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

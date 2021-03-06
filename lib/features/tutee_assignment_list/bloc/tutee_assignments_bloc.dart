import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_cached_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_next_tutee_assignment_list.dart';
import 'package:cotor/domain/usecases/tutee_assignments/get_tutee_assignment_list.dart';
import 'package:flutter/material.dart';

part 'tutee_assignments_event.dart';
part 'tutee_assignments_state.dart';

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
  List<TuteeAssignmentModel> assignments = [];
  @override
  AssignmentsState get initialState => Loading();

  @override
  Stream<Transition<AssignmentsEvent, AssignmentsState>> transformEvents(
    Stream<AssignmentsEvent> events,
    Stream<Transition<AssignmentsEvent, AssignmentsState>> Function(
            AssignmentsEvent event)
        transitionFn,
  ) {
    final nonDebounceStream = events.where((event) {
      return event is! GetNextAssignmentList;
    });
    final debounceStream = events.where((event) {
      return event is GetNextAssignmentList;
    }).debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(
        nonDebounceStream.mergeWith([debounceStream]), transitionFn);
  }

  @override
  Stream<AssignmentsState> mapEventToState(
    AssignmentsEvent event,
  ) async* {
    if (event is GetAssignmentList) {
      yield* _mapGetAssignmentListToState();
    } else if (event is GetNextAssignmentList) {
      yield* _mepGetNextAssignmentListToState(event);
    } else if (event is GetCachedAssignmentList) {
      yield* _mapGetCachedAssignmentListToState(event);
    }
  }

  Stream<AssignmentsState> _mapGetAssignmentListToState() async* {
    yield Loading();
    assignments.clear();
    final result = await getAssignmentList(NoParams());
    yield* result.fold(
      (failure) async* {
        yield InitialAssignmentsLoadError(
          message: _mapFailureToFailureMessage(failure),
          isCacheError: false,
        );
      },
      (assignmentList) async* {
        if (assignmentList.isNotEmpty) {
          assignments.addAll(assignmentList
              .map((e) => TuteeAssignmentModel.fromDomainEntity(e)));
          yield AssignmentLoaded.normal(
            assignments: assignments,
          );
        } else {
          yield AssignmentLoaded.empty();
        }
      },
    );
  }

  Stream<AssignmentsState> _mepGetNextAssignmentListToState(
      GetNextAssignmentList event) async* {
    if (state is AssignmentLoaded) {
      final AssignmentLoaded currentState = state;
      yield currentState.update(isFetching: true);
      final result = await getNextAssignments(NoParams());
      yield* result.fold(
        (failure) async* {
          yield currentState.copyWith(
            isGetNextListError: true,
          );
        },
        (assignmentList) async* {
          if (assignmentList != null) {
            assignments.addAll(assignmentList
                .map((e) => TuteeAssignmentModel.fromDomainEntity(e)));
            yield currentState.update(assignments: assignments);
          } else {
            yield currentState.update(
              assignments: assignments,
              isEnd: true,
            );
          }
        },
      );
    }
  }

  Stream<AssignmentsState> _mapGetCachedAssignmentListToState(
      GetCachedAssignmentList event) async* {
    yield Loading();
    final result = await getCachedAssignments(NoParams());
    yield* result.fold(
      (failure) async* {
        yield InitialAssignmentsLoadError(
          message: _mapFailureToFailureMessage(failure),
          isCacheError: true,
        );
      },
      (assignmentList) async* {
        assignments = assignmentList
            .map((e) => TuteeAssignmentModel.fromDomainEntity(e))
            .toList();
        yield AssignmentLoaded(
          assignments: assignments,
          isCachedList: true,
          isEnd: false,
          isFetching: false,
          isGetNextListError: false,
        );
      },
    );
  }

  String _mapFailureToFailureMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return Strings.networkFailureErrorMsg;
        break;
      case ServerFailure:
        return Strings.serverFailureErrorMsg;
        break;
      case CacheFailure:
        return Strings.cacheFailureErrorMsg;
        break;
      default:
        return Strings.unknownFailureErrorMsg;
        break;
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

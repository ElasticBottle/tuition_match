import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/usecases/usecase.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/get_cached_tutee_assignment_list.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/get_next_tutee_assignment_list.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/get_tutee_assignment_list.dart';
import './bloc.dart';

const String SERVER_FAILURE_MSG =
    'Sorry, Our Server is having problems processing the request (||^_^)';
const String NETWORK_FAILURE_MSG =
    'No internet access, please check your connection.';
const String CACHE_FAILURE_MSG =
    'No internet access, please check your connection.';
const String UNKNOWN_FAILURE_MSG =
    'Something went wrong and we don\'t know why, drop us a message at jeffhols18@gami.com and we\'ll get you sorted right away.';

class AssignmentsBloc extends Bloc<AssignmentsEvent, AssignmentsState> {
  AssignmentsBloc(
    this.getAssignmentList,
    this.getNextAssignments,
    this.getCachedAssignments,
  )   : assert(getAssignmentList != null),
        assert(getNextAssignments != null),
        assert(getCachedAssignments != null);
  final GetTuteeAssignmentList getAssignmentList;
  final GetNextTuteeAssignmentList getNextAssignments;
  final GetCachedTuteeAssignmentList getCachedAssignments;

  @override
  AssignmentsState get initialState => InitialAssignmentsState();

  @override
  Stream<AssignmentsState> mapEventToState(
    AssignmentsEvent event,
  ) async* {
    if (event is GetAssignmentList) {
      _mapGetAssignmentListToState(event);
    } else if (event is GetNextAssignmentList) {
      _mepGetNextAssignmentListToState(event);
    } else if (event is GetCachedAssignmentList) {
      _mapGetCachedAssignmentListToState(event);
    }
  }

  Stream<AssignmentsState> _mapGetAssignmentListToState(
      GetAssignmentList event) async* {
    yield AssignmentLoading();
    final result = await getAssignmentList(NoParams());
    yield* result.fold(
      (failure) async* {
        yield AssignmentError(message: _mapFailureToFailureMessage(failure));
        add(GetCachedAssignmentList());
      },
      (assignmentList) async* {
        yield AssignmentLoaded(assignments: assignmentList);
      },
    );
  }

  Stream<AssignmentsState> _mepGetNextAssignmentListToState(
      GetNextAssignmentList event) async* {
    yield NextAssignmentLoading();
    final result = await getNextAssignments(NoParams());
    yield* result.fold(
      (failure) async* {
        add(GetCachedAssignmentList());
        yield NextAssignmentError(
            message: _mapFailureToFailureMessage(failure));
      },
      (assignmentList) async* {
        yield NextAssignmentLoaded(assignments: assignmentList);
      },
    );
  }

  Stream<AssignmentsState> _mapGetCachedAssignmentListToState(
      GetCachedAssignmentList event) async* {
    yield CachedAssignmentLoading();
    final result = await getCachedAssignments(NoParams());
    yield* result.fold(
      (failure) async* {
        yield CachedAssignmentError(
            message: _mapFailureToFailureMessage(failure));
      },
      (assignmentList) async* {
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
}

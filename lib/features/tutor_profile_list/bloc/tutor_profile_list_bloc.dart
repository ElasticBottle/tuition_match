import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_cached_tutor_list.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_next_tutor_list.dart';
import 'package:cotor/domain/usecases/tutor_profile/get_tutor_list.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:flutter/material.dart';

part 'tutor_profile_list_event.dart';
part 'tutor_profile_list_state.dart';

class TutorProfileListBloc
    extends Bloc<TutorProfileListEvent, TutorProfileListState> {
  TutorProfileListBloc({
    @required this.getTutorProfileList,
    @required this.getNextTutorProfileList,
    @required this.getCachedTutorProfileList,
  })  : assert(getTutorProfileList != null),
        assert(getNextTutorProfileList != null),
        assert(getCachedTutorProfileList != null);

  final GetTutorList getTutorProfileList;
  final GetNextTutorList getNextTutorProfileList;
  final GetCachedTutorList getCachedTutorProfileList;
  List<TutorProfileModel> profiles = [];
  @override
  TutorProfileListState get initialState => Loading();

  @override
  Stream<Transition<TutorProfileListEvent, TutorProfileListState>>
      transformEvents(Stream<TutorProfileListEvent> events, transitionFn) {
    final nonDebounceStream = events.where((event) {
      return event is! GetNextTutorProfileList;
    });
    final debounceStream = events.where((event) {
      return event is GetNextTutorProfileList;
    }).debounceTime(Duration(milliseconds: 500));
    return super.transformEvents(
      nonDebounceStream.mergeWith([debounceStream]),
      transitionFn,
    );
  }

  @override
  Stream<TutorProfileListState> mapEventToState(
    TutorProfileListEvent event,
  ) async* {
    if (event is GetTutorProfileList) {
      yield* _mapGetTutorProfileListToState();
    } else if (event is GetNextTutorProfileList) {
      yield* _mepGetNextTutorProfileListToState();
    } else if (event is GetCachedTutorProfileList) {
      yield* _mapGetCachedTutorProfileListToState();
    }
  }

  Stream<TutorProfileListState> _mapGetTutorProfileListToState() async* {
    yield Loading();
    profiles.clear();
    final result = await getTutorProfileList(NoParams());
    yield* result.fold(
      (failure) async* {
        yield InitialTutorProfilesLoadError(
          message: _mapFailureToFailureMessage(failure),
          isCacheError: false,
        );
      },
      (tutorProfileList) async* {
        if (tutorProfileList.isNotEmpty) {
          profiles.addAll(tutorProfileList
              .map((e) => TutorProfileModel.fromDomainEntity(e)));
          yield TutorProfilesLoaded.normal(
            profiles: profiles,
          );
        } else {
          yield TutorProfilesLoaded.empty();
        }
      },
    );
  }

  Stream<TutorProfileListState> _mepGetNextTutorProfileListToState() async* {
    final TutorProfilesLoaded currentState = state;
    yield currentState.update(isFetching: true);
    final result = await getNextTutorProfileList(NoParams());
    yield* result.fold(
      (failure) async* {
        yield currentState.copyWith(
          isGetNextListError: true,
        );
      },
      (tutorProfileList) async* {
        if (tutorProfileList != null) {
          profiles.addAll(tutorProfileList
              .map((e) => TutorProfileModel.fromDomainEntity(e)));
          yield currentState.update(profiles: profiles);
        } else {
          yield currentState.update(profiles: profiles, isEnd: true);
        }
      },
    );
  }

  Stream<TutorProfileListState> _mapGetCachedTutorProfileListToState() async* {
    yield Loading();
    final result = await getCachedTutorProfileList(NoParams());
    yield* result.fold(
      (failure) async* {
        yield InitialTutorProfilesLoadError(
          message: _mapFailureToFailureMessage(failure),
          isCacheError: true,
        );
      },
      (tutorProfileList) async* {
        profiles = tutorProfileList
            .map((e) => TutorProfileModel.fromDomainEntity(e))
            .toList();
        yield TutorProfilesLoaded(
          profiles: profiles,
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

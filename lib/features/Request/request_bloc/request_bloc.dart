import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:cotor/domain/entities/post/applications/application_export.dart';
import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:cotor/domain/entities/user/user_export.dart';
import 'package:cotor/domain/usecases/auth_service/get_current_user.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/domain/usecases/user/request/reqeust_stream.dart';
import 'package:cotor/domain/usecases/user/user_info/get_user_profile.dart';
import 'package:cotor/domain/usecases/user/user_info/user_profile_stream.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';

part 'request_event.dart';
part 'request_state.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  RequestBloc({
    @required this.userProfileStream,
    @required this.getCurrentUser,
    @required this.requestStream,
  })  : assert(userProfileStream != null),
        assert(getCurrentUser != null),
        assert(requestStream != null);
  GetCurrentUser getCurrentUser;
  UserProfileStream userProfileStream;
  RequestStream requestStream;
  StreamSubscription userProfileSubscription;
  Map<String, Application> newRequests = <String, Application>{};
  Map<String, StreamSubscription> requestStreams =
      <String, StreamSubscription>{};

  void _cancelStreams(String id, StreamSubscription streamSubscription) {
    streamSubscription?.cancel();
  }

  @override
  Future<void> close() {
    requestStreams.forEach(_cancelStreams);
    userProfileSubscription?.cancel();
    return super.close();
  }

  @override
  RequestState get initialState => RequestStateImpl.initial();

  @override
  Stream<RequestState> mapEventToState(
    RequestEvent event,
  ) async* {
    if (event is InitialiseRequestBloc) {
      yield* _mapInitialiseRequestBlocToState();
    } else if (event is RequestUserUpdated) {
      yield* _mapRequestUserUpdatedToState(event.user);
    } else if (event is RequestForId) {
      yield* _mapRequestForIdToState(event.id);
    } else if (event is RequestLoaded) {
      yield* _mapRequestLoadedToState(event.id, event.requests);
    } else if (event is RequestNewReqeustAvailable) {
      yield* _mapRequestNewRequestAvailableToState();
    } else if (event is RequestLoadNewRequest) {
      yield* _mapRequestLoadNewReqeustToState();
    } else if (event is RequestReviewd) {
      yield* _mapRequestMarkReviedToState();
    } else if (event is RequestAccept) {
      yield* _mapRequestMarkAcceptToState();
    } else if (event is RequestDeclined) {
      yield* _mapRequestDeclinedToState();
    }
  }

  Stream<RequestState> _mapInitialiseRequestBlocToState() async* {
    requestStreams.forEach(_cancelStreams);
    userProfileSubscription?.cancel();
    final result = await getCurrentUser(NoParams());
    yield* result.fold(
      (l) async* {
        print(l);
      },
      (r) async* {
        userProfileSubscription = userProfileStream(r.identity.uid).listen(
          (user) {
            add(RequestUserUpdated(user));
          },
          onError: (dynamic error) {
            print(error.toString());
          },
        );
      },
    );
  }

  Stream<RequestState> _mapRequestUserUpdatedToState(User user) async* {
    // check if profile has been listened too
    if (user.profile != null && user.profile.identity != null) {
      if (requestStreams[user.profile.uid] == null) {
        yield state.update(isLoadingProfile: true);
        final StreamSubscription streamSubscription = requestStream(
                RequestStreamParams(id: user.identity.uid, isProfile: true))
            .listen(
          (applications) {
            for (Application application in applications) {
              final TuteeAssignment assignment = application.applicationInfo;
              newRequests[assignment.postId] = application;
            }
            if (state.id == user.profile.identity.uid) {
              add(RequestNewReqeustAvailable());
            } else {
              add(RequestLoaded(
                  id: user.identity.uid, requests: {...newRequests}));
              newRequests.clear();
            }
          },
        );
        yield state.update(isLoadingProfile: false);
        requestStreams[user.profile.uid] = streamSubscription;
      }
    }

    // TODO(EB): double check
    if (user.assignments != null && user.assignments.isNotEmpty) {
      for (TuteeAssignment assignment in user.assignments.values) {
        // check whether each assignment has been listend too
        if (requestStreams[assignment.postId] == null) {
          yield state.update(isLoadingAssignment: true);
          // listen to assignment if not already listened too
          final StreamSubscription streamSubscription = requestStream(
                  RequestStreamParams(id: assignment.postId, isProfile: false))
              .listen(
            (applications) {
              for (Application application in applications) {
                newRequests[application.applicationInfo.identity.uid] =
                    application;
              }
              if (state.id == assignment.postId) {
                add(RequestNewReqeustAvailable());
              } else {
                add(RequestLoaded(
                  id: assignment.postId,
                  requests: {...newRequests},
                ));
                newRequests.clear();
              }
            },
          );
          yield state.update(isLoadingAssignment: false);
          requestStreams[assignment.postId] = streamSubscription;
        }
      }
    }
  }

  Stream<RequestState> _mapRequestLoadedToState(
      String id, Map<String, Application> requests) async* {
    state.requests.addAll(<String, Map<String, Application>>{id: requests});
    yield state.update(requests: state.requests);
  }

  Stream<RequestState> _mapRequestNewRequestAvailableToState() async* {
    yield state.update(isNewRequestAvailable: true);
  }

  Stream<RequestState> _mapRequestForIdToState(String id) async* {
    yield state.copyWith(id: id);
  }

  Stream<RequestState> _mapRequestLoadNewReqeustToState() async* {
    state.requests[state.id]?.addAll(newRequests);
    yield state.update(requests: state.requests);
  }

  Stream<RequestState> _mapRequestMarkReviedToState() async* {
    // TODO(EB): implement
  }
  Stream<RequestState> _mapRequestMarkAcceptToState() async* {
    // TODO(EB): implement
  }
  Stream<RequestState> _mapRequestDeclinedToState() async* {
    // TODO(EB): implement
  }
}

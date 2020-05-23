import 'package:cotor/common_widgets/bars/bottom_action_bar_new.dart';
import 'package:cotor/common_widgets/platform_alert_dialog.dart';
import 'package:cotor/domain/entities/post/applications/application_export.dart';
import 'package:cotor/domain/entities/post/base_post/post_base.dart';
import 'package:cotor/domain/entities/post/tutee_assignment/assignment.dart';
import 'package:cotor/features/Request/request_bloc/request_bloc.dart';
import 'package:cotor/features/request_tutor/select_existing_assignment/bloc/select_existing_assignment_bloc.dart';
import 'package:cotor/features/user_profile_bloc/user_profile_bloc.dart';
import 'package:cotor/routing/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomBarDecider extends StatefulWidget {
  const BottomBarDecider({this.post});
  final PostBase post;
  @override
  _BottomBarDeciderState createState() => _BottomBarDeciderState();
}

class _BottomBarDeciderState extends State<BottomBarDecider> {
  UserProfileBloc userProfileBloc;
  SelectExistingAssignmentBloc selectExistingAssignmentBloc;
  RequestBloc requestBloc;
  VoidCallback likePressed = () {};
  bool likeBloc = false;

  @override
  void initState() {
    super.initState();
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    selectExistingAssignmentBloc =
        BlocProvider.of<SelectExistingAssignmentBloc>(context);
    requestBloc = BlocProvider.of<RequestBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.post.isProfile) {
      final List<dynamic> isApplied = _checkIfIsApplied(
          widget.post.identity.uid, requestBloc.state.requests);

      if (widget.post.identity?.uid ==
          userProfileBloc.state.userProfile.identity.uid) {
        return BottomActionBarNew.userBar(
          viewAppsCallback: () {
            requestBloc.add(RequestForId(id: widget.post.identity.uid));
            Navigator.of(context).pushNamed(Routes.requestListPage);
          },
          isProfile: true,
        );
      } else if (isApplied[0]) {
        final ApplicationStatus status = requestBloc
            .state.requests[isApplied[1]][widget.post.identity.uid].status;
        if (status == ApplicationStatus.TO_REVIEW) {
          return BottomActionBarNew.acceptDeny(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            reviewedCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content:
                    'By accepting, you are assuring that the student will have space if she chooses to take you up',
                defaultActionText: 'Accept',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestReviewd());
              }
            },
            denyCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content: 'You cannot change your mind once confirmed',
                defaultActionText: 'Decline',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestDeclined());
              }
            },
          );
        }

        // awaiting review
        if (status == ApplicationStatus.AWAITING_REVIEW) {
          return BottomActionBarNew.statusBar(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            isProfile: false,
            requestCount: widget.post.stats.requestCount,
            onPressed: () {
              PlatformAlertDialog(
                title: 'Awaiting Review',
                content: 'Currently waiting for tutor to review your profile',
                defaultActionText: 'Okay',
              ).show(context);
            },
          );
        }

        // Confirm or deny reviewed assignment
        if (status == ApplicationStatus.TO_ACCEPT) {
          return BottomActionBarNew.acceptDeny(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            reviewedCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content:
                    'By confirming you want this student, you are agreeing to take the student on',
                defaultActionText: 'Accept',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestAccept());
              }
            },
            denyCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content: 'You cannot change your mind once confirmed',
                defaultActionText: 'Decline',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestDeclined());
              }
            },
          );
        }

        // awaiting confirmation
        if (status == ApplicationStatus.AWAITING_ACCEPTANCE) {
          return BottomActionBarNew.statusBar(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            isProfile: false,
            requestCount: widget.post.stats.requestCount,
            onPressed: () {
              PlatformAlertDialog(
                title: 'Awaiting Acceptance',
                content: 'Checking if the tutor is still interested',
                defaultActionText: 'Okay',
              ).show(context);
            },
          );
        }

        // accepted
        if (status == ApplicationStatus.ACCEPTED) {}
      }
      return BottomActionBarNew.requestWithLike(
        isLiked: likeBloc,
        likedOnPress: likePressed,
        requestCount: widget.post.stats?.requestCount,
        applyOnPress: () {
          selectExistingAssignmentBloc.add(
            InitialiseSelectExistingAssignment(
              requestingProfile: widget.post,
              userDetails: userProfileBloc.state.userProfile,
            ),
          );
          Navigator.of(context).pushNamed(Routes.selectAssignmentPage);
        },
        isProfile: true,
      );
    } else if (widget.post.isAssignment) {
      final TuteeAssignment assignment = widget.post;
      final List<dynamic> isAppliedAssignment =
          _checkIfIsApplied(assignment.postId, requestBloc.state.requests);
      if (userProfileBloc
              .state.userProfile.assignments[assignment.identity?.postId] !=
          null) {
        return BottomActionBarNew.userBar(
          viewAppsCallback: () {
            requestBloc.add(RequestForId(id: assignment.postId));
            Navigator.of(context).pushNamed(Routes.requestListPage);
          },
          isProfile: false,
        );
      } else if (isAppliedAssignment[0]) {
        final ApplicationStatus status = requestBloc
            .state.requests[isAppliedAssignment[1]][assignment.postId].status;

        // review or deny incoming
        if (status == ApplicationStatus.TO_REVIEW) {
          return BottomActionBarNew.acceptDeny(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            reviewedCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content:
                    'By accepting, you are assuring that the student will have space if she chooses to take you up',
                defaultActionText: 'Accept',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestReviewd());
              }
            },
            denyCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content: 'You cannot change your mind once confirmed',
                defaultActionText: 'Decline',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestDeclined());
              }
            },
          );
        }

        // awaiting review
        if (status == ApplicationStatus.AWAITING_REVIEW) {
          return BottomActionBarNew.statusBar(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            isProfile: false,
            requestCount: assignment.stats.requestCount,
            onPressed: () {
              PlatformAlertDialog(
                title: 'Awaiting Review',
                content: 'Currently waiting for tutor to review your profile',
                defaultActionText: 'Okay',
              ).show(context);
            },
          );
        }

        // Confirm or deny reviewed assignment
        if (status == ApplicationStatus.TO_ACCEPT) {
          return BottomActionBarNew.acceptDeny(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            reviewedCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content:
                    'By confirming you want this student, you are agreeing to take the student on',
                defaultActionText: 'Accept',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestAccept());
              }
            },
            denyCallback: () async {
              final bool isConfirm = await PlatformAlertDialog(
                title: 'Are you sure?',
                content: 'You cannot change your mind once confirmed',
                defaultActionText: 'Decline',
                cancelActionText: 'Cancel',
              ).show(context);
              if (isConfirm) {
                requestBloc.add(RequestDeclined());
              }
            },
          );
        }

        // awaiting confirmation
        if (status == ApplicationStatus.AWAITING_ACCEPTANCE) {
          return BottomActionBarNew.statusBar(
            isLiked: likeBloc,
            likedOnPress: likePressed,
            isProfile: false,
            requestCount: assignment.stats.requestCount,
            onPressed: () {
              PlatformAlertDialog(
                title: 'Awaiting Acceptance',
                content: 'Checking if the tutor is still interested',
                defaultActionText: 'Okay',
              ).show(context);
            },
          );
        }

        // accepted
        if (status == ApplicationStatus.ACCEPTED) {}
      }
      return BottomActionBarNew.requestWithLike(
        isLiked: likeBloc,
        likedOnPress: likePressed,
        requestCount: widget.post.stats?.requestCount,
        applyOnPress: () {},
      );
    }
    return Container();
  }

  List<dynamic> _checkIfIsApplied(
      String postId, Map<String, Map<String, Application>> requests) {
    final List<dynamic> toReturn = <dynamic>[false, null];
    for (MapEntry request in requests.entries) {
      if (request.value[postId] != null) {
        toReturn[0] = true;
        toReturn[1] = request.key;
      }
    }
    return toReturn;
  }
}

part of 'view_tutor_profile_bloc.dart';

abstract class ViewTutorProfileEvent extends Equatable {
  const ViewTutorProfileEvent();
}

class InitialiseViewTutorProfile extends ViewTutorProfileEvent {
  const InitialiseViewTutorProfile(
      {this.isUser, this.isInNestedScrollView, this.profile});
  final TutorProfile profile;
  final bool isUser;
  final bool isInNestedScrollView;
  @override
  List<Object> get props => [profile, isUser, isInNestedScrollView];

  @override
  String toString() =>
      'ViewProfile(profile: $profile, isUser: $isUser, isInNestedScrollView: $isInNestedScrollView)';
}

part of 'view_tutor_profile_bloc.dart';

abstract class ViewTutorProfileEvent extends Equatable {
  const ViewTutorProfileEvent();
}

class ViewProfile extends ViewTutorProfileEvent {
  const ViewProfile({this.profile});
  final TutorProfileModel profile;
  @override
  List<Object> get props => [profile];

  @override
  String toString() => 'ViewProfile { profile : $profile}';
}

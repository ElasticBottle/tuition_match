part of 'view_tutor_profile_bloc.dart';

abstract class ViewTutorProfileState extends Equatable {
  TutorProfileModel get profile;
}

class ViewTutorProfileStateImpl extends ViewTutorProfileState {
  ViewTutorProfileStateImpl({TutorProfileModel profile}) : _profile = profile;

  final TutorProfileModel _profile;

  @override
  TutorProfileModel get profile => _profile;

  @override
  List<Object> get props => [profile];

  @override
  String toString() => 'ViewProfile { profile : $profile }';
}

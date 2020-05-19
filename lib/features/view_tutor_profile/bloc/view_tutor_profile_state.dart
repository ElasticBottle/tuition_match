part of 'view_tutor_profile_bloc.dart';

abstract class ViewTutorProfileState extends Equatable {
  TutorProfile get profile;
  bool get isUser;
  bool get isInNestedScrollView;
}

class ViewTutorProfileStateImpl extends ViewTutorProfileState {
  ViewTutorProfileStateImpl(
      {TutorProfile profile, bool isUser, bool isInNestedScrollView})
      : _profile = profile,
        _isUser = isUser,
        _isNestedScrollView = isInNestedScrollView;
  factory ViewTutorProfileStateImpl.initial() {
    return ViewTutorProfileStateImpl(
      isInNestedScrollView: false,
      isUser: true,
      profile: TutorProfile(),
    );
  }
  final TutorProfile _profile;
  final bool _isUser;
  final bool _isNestedScrollView;

  @override
  TutorProfile get profile => _profile;
  @override
  bool get isInNestedScrollView => _isNestedScrollView;
  @override
  bool get isUser => _isUser;

  @override
  List<Object> get props => [
        profile,
        isUser,
        isInNestedScrollView,
      ];

  @override
  String toString() => '''ViewTutorProfileStateImpl(
    profile: $profile, 
    isUser: $isUser, 
    isNestedScrollView: $isInNestedScrollView
  )''';
}

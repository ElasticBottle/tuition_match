part of 'user_profile_page_bloc.dart';

abstract class UserProfilePageEvent extends Equatable {
  const UserProfilePageEvent();

  @override
  List<Object> get props => [];
}

class AddTutorProfile extends UserProfilePageEvent {}

class EditTutorProfile extends UserProfilePageEvent {}

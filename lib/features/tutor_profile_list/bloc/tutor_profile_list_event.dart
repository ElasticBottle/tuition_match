part of 'tutor_profile_list_bloc.dart';

abstract class TutorProfileListEvent extends Equatable {
  const TutorProfileListEvent();
  @override
  List<Object> get props => [];
}

// Retrieving Profile List
class GetTutorProfileList extends TutorProfileListEvent {
  @override
  String toString() => 'GetTutorProfileList';
}

class GetNextTutorProfileList extends TutorProfileListEvent {
  @override
  String toString() => 'GetNextTutorProfileList';
}

class GetCachedTutorProfileList extends TutorProfileListEvent {
  @override
  String toString() => 'GetCachedTutorProfileList';
}

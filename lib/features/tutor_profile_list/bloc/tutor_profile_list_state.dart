part of 'tutor_profile_list_bloc.dart';

abstract class TutorProfileListState extends Equatable {
  const TutorProfileListState();
  @override
  List<Object> get props => [];
}

class Loading extends TutorProfileListState {
  @override
  String toString() => 'Loading()';
}

class TutorProfilesLoaded extends TutorProfileListState {
  const TutorProfilesLoaded({
    this.profiles,
    this.isFetching,
    this.isEnd,
    this.isCachedList,
    this.isGetNextListError,
  });
  factory TutorProfilesLoaded.empty() {
    return TutorProfilesLoaded(
      profiles: const [],
      isFetching: false,
      isEnd: false,
      isCachedList: false,
      isGetNextListError: false,
    );
  }
  factory TutorProfilesLoaded.normal({List<TutorProfileModel> profiles}) {
    return TutorProfilesLoaded(
      profiles: profiles,
      isFetching: false,
      isEnd: false,
      isCachedList: false,
      isGetNextListError: false,
    );
  }
  final List<TutorProfileModel> profiles;
  final bool isFetching;
  final bool isEnd;
  final bool isCachedList;
  final bool isGetNextListError;

  TutorProfilesLoaded update({
    List<TutorProfileModel> profiles,
    bool isFetching,
    bool isEnd,
    bool isCachedList,
  }) {
    return copyWith(
      profiles: profiles,
      isFetching: isFetching,
      isEnd: isEnd,
      isCachedList: isCachedList,
      isGetNextListError: false,
    );
  }

  TutorProfilesLoaded copyWith({
    List<TutorProfileModel> profiles,
    bool isFetching,
    bool isEnd,
    bool isCachedList,
    bool isGetNextListError,
  }) {
    return TutorProfilesLoaded(
      profiles: profiles ?? this.profiles,
      isFetching: isFetching ?? this.isFetching,
      isEnd: isEnd ?? this.isEnd,
      isCachedList: isCachedList ?? this.isCachedList,
      isGetNextListError: isGetNextListError ?? this.isGetNextListError,
    );
  }

  @override
  List<Object> get props => [
        profiles,
        isFetching,
        isEnd,
        isCachedList,
        isGetNextListError,
      ];

  @override
  String toString() => '''TutorProfilesLoaded {
     profiles : $profiles 
     isFetching: $isFetching
     isEnd: $isEnd
     isCachedList : $isCachedList
     isGetNextListError: $isGetNextListError,
     }''';
}

class TutorProfilesError extends TutorProfileListState {
  const TutorProfilesError(
      {@required this.message, @required this.isCacheError});
  final String message;
  final bool isCacheError;

  @override
  List<Object> get props => [message, isCacheError];

  @override
  String toString() =>
      'TutorProfilesError { error: $message , ,isCacheError : $isCacheError}';
}

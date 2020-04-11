class FirestorePath {
  static String users(String username) => 'users/$username';
  static String assignment(String postId) => 'assignments/$postId';
  static String tutorProfile(String username) => 'tutors/$username';

  // static String userAssignment({String postId, String username}) =>
  //     'users/$username/posts/$postId/';

  static String likeAssignment(String postId) => 'likes/assignments/$postId';

  static String likeProfiles(String username) => 'likes/tutors/$username';
}

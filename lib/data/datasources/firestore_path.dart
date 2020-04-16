class FirestorePath {
  static String users(String uid) => 'users/$uid';
  static String assignment(String postId) => 'assignments/$postId';
  static String tutorProfile(String uid) => 'tutors/$uid';

  // static String userAssignment({String postId, String uid}) =>
  //     'users/$uid/posts/$postId/';

  static String likeAssignment(String postId) => 'likesAssignments/$postId';

  static String likeProfiles(String uid) => 'likesProfiles/$uid';
}

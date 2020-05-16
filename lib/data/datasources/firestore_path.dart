class FirestorePath {
  static String users(String uid) => 'users/$uid';
  static String usersContactInfo(String uid) => 'users/$uid/private/contact';
  static String usersAllowedContactInfo(String uid) =>
      'users/$uid/private/allowed';
  static String usersReviews(String uid) => 'users/$uid/reviews';
  static String userLikedTutors(String uid) => 'users/$uid/liked/tutors';
  static String userLikedAssignments(String uid) =>
      'users/$uid/liked/assignments';

  static String assignmentCollection() => 'assignments';
  static String assignment(String postId) => 'assignments/$postId';
  static String assignmentRequests(String postId, String uid) =>
      'assignments/$postId/requests/$uid';
  static String assignmentStats(String postId) => 'assignments/$postId/stats';

  static String tutorProfile(String uid) => 'tutors/$uid';
  static String tutorProfileRequests(String uid, String postId) =>
      'tutors/$uid/requests/$postId';
  static String tutorProfileStats(String uid) => 'tutors/$uid/stats';

  static String request(String id) => 'reqeusts/$id';
  static String requestCollection() => 'reqeusts';
}

class FirestorePath {
  static String users(String uid) => 'users/$uid';
  static String usersPrivateInfo(String uid) => 'users/$uid/private/contact';
  static String userRequestedTutors(String uid) => 'users/$uid/request/tutors';
  static String userAppliedAssignments(String uid) =>
      'users/$uid/applied/assignments';
  static String userLikedTutors(String uid) => 'users/$uid/liked/tutors';
  static String userLikedAssignments(String uid) =>
      'users/$uid/liked/assignments';

  static String assignment(String postId) => 'assignments/$postId';
  static String assignmentApplications(
          String assignmentPostId, String tutorUid) =>
      'assignments/$assignmentPostId/applications/$tutorUid';

  static String tutorProfile(String uid) => 'tutors/$uid';
  static String tutorRequests(String requestUID, String assignmentPostId) =>
      'tutors/$requestUID/requests/$assignmentPostId';
}

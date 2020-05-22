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
  static String assignmentRequestsCollection(String postId) =>
      'assignments/$postId/requests';
  static String assignmentRequests(String postId, String uid) =>
      'assignments/$postId/requests/$uid';
  static String assignmentStats(String postId) => 'assignments/$postId/stats';
  static String assignmentStatsLiked(String postId) =>
      'assignments/$postId/stats/liked';
  static String assignmentStatsDeclinedBy(String postId) =>
      'assignments/$postId/stats/declinedBy';
  static String assignmentStatsAccepted(String postId) =>
      'assignments/$postId/stats/accepted';
  static String assignmentStatsAcceptBy(String postId) =>
      'assignments/$postId/stats/acceptBy';
  static String assignmentStatsFinished(String postId) =>
      'assignments/$postId/stats/finish';
  static String assignmentStatsPending(String postId) =>
      'assignments/$postId/stats/pending';
  static String assignmentStatsIncoming(String postId) =>
      'assignments/$postId/stats/incoming';
  static String assignmentStatsOutgoing(String postId) =>
      'assignments/$postId/stats/outgoing';

  static String tutorProfile(String uid) => 'tutors/$uid';
  static String tutorProfileRequestsCollection(String uid) =>
      'tutors/$uid/requests';
  static String tutorProfileRequests(String uid, String postId) =>
      'tutors/$uid/requests/$postId';
  static String tutorProfileStats(String uid) => 'tutors/$uid/stats';
  static String tutorProfileStatsLiked(String uid) => 'tutors/$uid/stats/liked';
  static String tutorProfileStatsDeclinedBy(String uid) =>
      'tutors/$uid/stats/declinedBy';
  static String tutorProfileStatsAccepted(String uid) =>
      'tutors/$uid/stats/accepted';
  static String tutorProfileStatsAcceptBy(String uid) =>
      'tutors/$uid/stats/acceptBy';
  static String tutorProfileStatsFinished(String uid) =>
      'tutors/$uid/stats/finish';
  static String tutorProfileStatsPending(String uid) =>
      'tutors/$uid/stats/pending';
  static String tutorProfileStatsIncoming(String uid) =>
      'tutors/$uid/stats/incoming';
  static String tutorProfileStatsOutgoing(String uid) =>
      'tutors/$uid/stats/outgoing';

  static String request(String id) => 'reqeusts/$id';
  static String requestCollection() => 'reqeusts';
}

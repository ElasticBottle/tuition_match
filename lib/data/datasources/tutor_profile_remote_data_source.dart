import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/tutor_profile_model.dart';

abstract class TutorProfileRemoteDataSource {
  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TutorProfileModel>> getProfileByCriterion(
      TutorCriteriaParams params);
  Future<List<TutorProfileModel>> getNextCriterionList();

  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TutorProfileModel>> getProfileList();
  Future<List<TutorProfileModel>> getNextProfileList();
}

const int DOCUMENT_RETRIEVAL_LIMIT = 2;

class TutorProfileRemoteDataSourceImpl implements TutorProfileRemoteDataSource {
  // firebase dependency here
  TutorProfileRemoteDataSourceImpl({this.remoteStore});
  Firestore remoteStore;
  DocumentSnapshot mostRecentProfileDocument;
  DocumentSnapshot mostRecentCriterionDocument;
  Query mostRecentCriterionQuery;

  @override
  Future<List<TutorProfileModel>> getProfileByCriterion(
      TutorCriteriaParams params) async {
    final Query query = remoteStore
        .collection('tutors')
        .where('status', isEqualTo: 0)
        .where('level', isEqualTo: params.level)
        .where('subject', isEqualTo: params.subject)
        .where('rateMin', isGreaterThanOrEqualTo: params.rateMin)
        .where('rateMax', isLessThanOrEqualTo: params.rateMax)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    mostRecentCriterionQuery = query;

    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentCriterionDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TutorProfileModel>> getNextCriterionList() async {
    final Query query = mostRecentCriterionQuery
        .startAfterDocument(mostRecentCriterionDocument);

    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentCriterionDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TutorProfileModel>> getProfileList() async {
    final Query query = remoteStore
        .collection('tutor')
        .where('status', isEqualTo: 0)
        .orderBy('dateModified', descending: true)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentProfileDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TutorProfileModel>> getNextProfileList() async {
    final Query query = remoteStore
        .collection('assignments')
        .where('status', isEqualTo: 0)
        .orderBy('dateModified', descending: true)
        .limit(DOCUMENT_RETRIEVAL_LIMIT)
        .startAfterDocument(mostRecentProfileDocument);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentProfileDocument = snapshot[snapshot.length - 1];
    });
  }

  Future<List<TutorProfileModel>> _attemptQuery(
      Query query, Function toSave) async {
    try {
      final QuerySnapshot snapshot = await query.getDocuments();
      // print(snapshot.documents[0].data);
      if (snapshot.documents.isNotEmpty) {
        final List<TutorProfileModel> result = snapshot.documents
            .map((e) => TutorProfileModel.fromDocumentSnapshot(
                json: e.data, postId: e.documentID))
            .toList();
        toSave(snapshot.documents);
        return result;
      }
      return null;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/del_params.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';

abstract class TuteeAssignmentRemoteDataSource {
  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TuteeAssignmentModel>> getAssignmentByCriterion(
      CriteriaParams params);
  Future<List<TuteeAssignmentModel>> getNextCriterionList();

  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TuteeAssignmentModel>> getAssignmentList();
  Future<List<TuteeAssignmentModel>> getNextAssignmentList();
}

const int DOCUMENT_RETRIEVAL_LIMIT = 2;

class TuteeAssignmentRemoteDataSourceImpl
    implements TuteeAssignmentRemoteDataSource {
  // firebase dependency here
  TuteeAssignmentRemoteDataSourceImpl({this.remoteStore});
  Firestore remoteStore;
  DocumentSnapshot mostRecentAssignmentDocument;
  DocumentSnapshot mostRecentCriterionDocument;
  Query mostRecentCriterionQuery;

  @override
  Future<List<TuteeAssignmentModel>> getAssignmentByCriterion(
      CriteriaParams params) async {
    final Query query = remoteStore
        .collection('assignments')
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
  Future<List<TuteeAssignmentModel>> getNextCriterionList() async {
    final Query query = mostRecentCriterionQuery
        .startAfterDocument(mostRecentCriterionDocument);

    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentCriterionDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TuteeAssignmentModel>> getAssignmentList() async {
    final Query query = remoteStore
        .collection('assignments')
        .where('status', isEqualTo: 0)
        .orderBy('dateAdded', descending: true)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentAssignmentDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TuteeAssignmentModel>> getNextAssignmentList() async {
    final Query query = remoteStore
        .collection('assignments')
        .where('status', isEqualTo: 0)
        .limit(DOCUMENT_RETRIEVAL_LIMIT)
        .orderBy('dateAdded', descending: true)
        .startAfterDocument(mostRecentAssignmentDocument);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentAssignmentDocument = snapshot[snapshot.length - 1];
    });
  }

  Future<List<TuteeAssignmentModel>> _attemptQuery(
      Query query, Function toSave) async {
    try {
      final QuerySnapshot snapshot = await query.getDocuments();
      // print(snapshot.documents[0].data);
      if (snapshot.documents.isNotEmpty) {
        final List<TuteeAssignmentModel> result = snapshot.documents
            .map((e) => TuteeAssignmentModel.fromDocumentSnapshot(
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

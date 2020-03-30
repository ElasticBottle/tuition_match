import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/entities/tutee_assignment.dart';

abstract class TuteeAssignmentRemoteDataSource {
  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TuteeAssignmentModel>> getAssignmentByCriterion({
    Level level,
    Subject subject,
    double rateMin,
    double rateMax,
  });

  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TuteeAssignmentModel>> getAssignmentList();
}

const int DOCUMENT_RETRIEVAL_LIMIT = 20;

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
      {Level level, Subject subject, double rateMin, double rateMax}) async {
    final Query query = remoteStore
        .collection('assignments')
        .where('level', isEqualTo: level)
        .where('subject', isEqualTo: subject)
        .where('rateMin', isGreaterThanOrEqualTo: rateMin)
        .where('rateMax', isLessThanOrEqualTo: rateMax)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    mostRecentCriterionQuery = query;
    final QuerySnapshot snapshot = await query.getDocuments();
    final List<TuteeAssignmentModel> result =
        snapshot.documents.map((e) => TuteeAssignmentModel.fromJson(e.data));
    mostRecentCriterionDocument =
        snapshot.documents[snapshot.documents.length - 1];
    return Future.value(result);
  }

  Future<List<TuteeAssignmentModel>> getNextCriterionList() async {
    final Query query = mostRecentCriterionQuery
        .startAfterDocument(mostRecentCriterionDocument);
    final QuerySnapshot snapshot = await query.getDocuments();
    final List<TuteeAssignmentModel> result =
        snapshot.documents.map((e) => TuteeAssignmentModel.fromJson(e.data));
    mostRecentAssignmentDocument =
        snapshot.documents[snapshot.documents.length - 1];
    return Future.value(result);
  }

  @override
  Future<List<TuteeAssignmentModel>> getAssignmentList() async {
    final Query query = remoteStore.collection('assignments').limit(20);
    final QuerySnapshot snapshot = await query.getDocuments();
    final List<TuteeAssignmentModel> result =
        snapshot.documents.map((e) => TuteeAssignmentModel.fromJson(e.data));
    mostRecentAssignmentDocument =
        snapshot.documents[snapshot.documents.length - 1];
    return Future.value(result);
  }

  Future<List<TuteeAssignmentModel>> getNextAssignmentList() async {
    final Query query = remoteStore
        .collection('assignments')
        .limit(DOCUMENT_RETRIEVAL_LIMIT)
        .startAfterDocument(mostRecentAssignmentDocument);
    final QuerySnapshot snapshot = await query.getDocuments();
    final List<TuteeAssignmentModel> result =
        snapshot.documents.map((e) => TuteeAssignmentModel.fromJson(e.data));
    mostRecentAssignmentDocument =
        snapshot.documents[snapshot.documents.length - 1];
    return Future.value(result);
  }
}

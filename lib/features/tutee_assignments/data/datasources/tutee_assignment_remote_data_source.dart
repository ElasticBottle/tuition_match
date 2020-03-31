import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/features/tutee_assignments/data/models/criteria_params.dart';
import 'package:cotor/features/tutee_assignments/data/models/tutee_assignment_model.dart';
import 'package:cotor/features/tutee_assignments/domain/usecases/del_tutee_assignment.dart';

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

  Future<bool> delAssignment(DelParams params);

  Future<bool> setTuteeAssignment({TuteeAssignmentModel tuteeParmas});

  Future<bool> updateTuteeAssignment({TuteeAssignmentModel tuteeParmas});
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
      CriteriaParams params) async {
    final Query query = remoteStore
        .collection('assignments')
        .where('level', isEqualTo: params.level)
        .where('subject', isEqualTo: params.subject)
        .where('rateMin', isGreaterThanOrEqualTo: params.rateMin)
        .where('rateMax', isLessThanOrEqualTo: params.rateMax)
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

  @override
  Future<bool> delAssignment(DelParams params) {
    // TODO: implement delAssignment
    throw UnimplementedError();
  }

  @override
  Future<bool> setTuteeAssignment({TuteeAssignmentModel tuteeParmas}) {
    // TODO: implement setTuteeAssignment
    throw UnimplementedError();
  }

  @override
  Future<bool> updateTuteeAssignment({TuteeAssignmentModel tuteeParmas}) {
    // TODO: implement updateTuteeAssignment
    throw UnimplementedError();
  }
}

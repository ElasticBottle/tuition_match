import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/tutee_assignment_entity.dart';
import 'package:cotor/domain/entities/tutee_criteria_params.dart';

abstract class TuteeAssignmentRemoteDataSource {
  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TuteeAssignmentEntity>> getAssignmentByCriterion(
      TuteeCriteriaParams params);
  Future<List<TuteeAssignmentEntity>> getNextCriterionList();

  ///
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TuteeAssignmentEntity>> getAssignmentList();
  Future<List<TuteeAssignmentEntity>> getNextAssignmentList();
}

const int DOCUMENT_RETRIEVAL_LIMIT = 2;

class TuteeAssignmentRemoteDataSourceImpl
    implements TuteeAssignmentRemoteDataSource {
  // firebase dependency here
  TuteeAssignmentRemoteDataSourceImpl({this.remoteStore});
  final Firestore remoteStore;
  DocumentSnapshot mostRecentAssignmentDocument;
  DocumentSnapshot mostRecentCriterionDocument;
  Query mostRecentCriterionQuery;

  @override
  Future<List<TuteeAssignmentEntity>> getAssignmentByCriterion(
      TuteeCriteriaParams params) async {
    final Query query = remoteStore
        .collection('assignments')
        .where(IS_OPEN, isEqualTo: true)
        .where(IS_PUBLIC, isEqualTo: true)
        .where(LEVELS, arrayContainsAny: params.levels)
        .where(SUBJECTS, arrayContainsAny: params.subjects)
        .where(GENDER, arrayContainsAny: params.genders)
        .where(TUTOR_OCCUPATION, arrayContainsAny: params.tutorOccupations)
        .where(CLASS_FORMATS, arrayContainsAny: params.formats)
        .where(RATEMIN, isGreaterThanOrEqualTo: params.rateMin)
        .where(RATEMAX, isLessThanOrEqualTo: params.rateMax)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    mostRecentCriterionQuery = query;

    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentCriterionDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TuteeAssignmentEntity>> getNextCriterionList() async {
    final Query query = mostRecentCriterionQuery
        .startAfterDocument(mostRecentCriterionDocument);

    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentCriterionDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TuteeAssignmentEntity>> getAssignmentList() async {
    final Query query = remoteStore
        .collection('assignments')
        .where(IS_OPEN, isEqualTo: true)
        .where(IS_PUBLIC, isEqualTo: true)
        .orderBy(DATE_ADDED, descending: true)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentAssignmentDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TuteeAssignmentEntity>> getNextAssignmentList() async {
    final Query query = remoteStore
        .collection('assignments')
        .where(IS_OPEN, isEqualTo: true)
        .where(IS_PUBLIC, isEqualTo: true)
        .limit(DOCUMENT_RETRIEVAL_LIMIT)
        .orderBy(DATE_ADDED, descending: true)
        .startAfterDocument(mostRecentAssignmentDocument);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentAssignmentDocument = snapshot[snapshot.length - 1];
    });
  }

  Future<List<TuteeAssignmentEntity>> _attemptQuery(
      Query query, Function toSave) async {
    try {
      final QuerySnapshot snapshot = await query.getDocuments();
      // print(snapshot.documents[0].data);
      if (snapshot.documents.isNotEmpty) {
        final List<TuteeAssignmentEntity> result = snapshot.documents.map(
          (e) {
            return TuteeAssignmentEntity.fromDocumentSnapshot(
                json: e.data, postId: e.documentID);
          },
        ).toList();
        toSave(snapshot.documents);
        return result;
      }
      return null;
    } catch (e) {
      print('tutee assignment remote data source' + e.toString());
      throw ServerException();
    }
  }
}

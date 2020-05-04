import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/tutor_criteria_params_entity.dart';
import 'package:cotor/data/models/tutor_profile_entity.dart';

abstract class TutorProfileRemoteDataSource {
  /// Retrieves a copy of the latest [List<TutorProfileEntity>] based on [params]
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TutorProfileEntity>> getProfileByCriterion(
      TutorCriteriaParamsEntity params);

  /// Retrieves next [List<TutorProfileEntity>] based on [params] as left of by [getProfileByCriterion(params)]
  ///
  /// [getProfileByCriterion(params)] should be called at least once before this
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TutorProfileEntity>> getNextCriterionList();

  /// Retrieves a copy of the latest [List<TutorProfileEntity>]
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TutorProfileEntity>> getProfileList();

  /// Retrieves the next assignment list as left off by [getProfileList()]
  ///
  /// [getProfileList()] should be called at least once before this
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<TutorProfileEntity>> getNextProfileList();
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
  Future<List<TutorProfileEntity>> getProfileByCriterion(
      TutorCriteriaParamsEntity params) async {
    final Query query = remoteStore
        .collection('tutors')
        .where(IS_PUBLIC, isEqualTo: true)
        .where(LEVELS_TAUGHT, arrayContainsAny: params.levelsTaught)
        .where(SUBJECTS, arrayContainsAny: params.subjects)
        .where(CLASS_FORMATS, arrayContainsAny: params.formats)
        .where(TUTOR_OCCUPATION, whereIn: params.tutorOccupations)
        .where(GENDER, whereIn: params.genders)
        .where(RATEMIN, isGreaterThanOrEqualTo: params.rateMin)
        .where(RATEMAX, isLessThanOrEqualTo: params.rateMax)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    mostRecentCriterionQuery = query;

    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentCriterionDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TutorProfileEntity>> getNextCriterionList() async {
    final Query query = mostRecentCriterionQuery
        .startAfterDocument(mostRecentCriterionDocument);

    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentCriterionDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TutorProfileEntity>> getProfileList() async {
    final Query query = remoteStore
        .collection('tutors')
        .where(IS_PUBLIC, isEqualTo: true)
        .orderBy(DATE_MODIFIED, descending: true)
        .limit(DOCUMENT_RETRIEVAL_LIMIT);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentProfileDocument = snapshot[snapshot.length - 1];
    });
  }

  @override
  Future<List<TutorProfileEntity>> getNextProfileList() async {
    final Query query = remoteStore
        .collection('tutors')
        .where(IS_PUBLIC, isEqualTo: true)
        .orderBy(DATE_MODIFIED, descending: true)
        .limit(DOCUMENT_RETRIEVAL_LIMIT)
        .startAfterDocument(mostRecentProfileDocument);
    return _attemptQuery(query, (List<DocumentSnapshot> snapshot) {
      mostRecentProfileDocument = snapshot[snapshot.length - 1];
    });
  }

  Future<List<TutorProfileEntity>> _attemptQuery(
      Query query, Function toSave) async {
    try {
      final QuerySnapshot snapshot = await query.getDocuments();
      // print(snapshot.documents[0].data);
      if (snapshot.documents.isNotEmpty) {
        final List<TutorProfileEntity> result = snapshot.documents.map(
          (e) {
            return TutorProfileEntity.fromDocumentSnapshot(
                json: e.data, postId: e.documentID);
          },
        ).toList();
        toSave(snapshot.documents);
        return result;
      }
      return null;
    } catch (e) {
      print('tutor profile remote data source' + e.toString());
      throw ServerException();
    }
  }
}

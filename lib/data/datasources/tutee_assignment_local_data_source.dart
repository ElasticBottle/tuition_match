import 'dart:convert';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/tutee_assignment_entity.dart';
import 'package:cotor/data/models/tutee_criteria_params_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_ASSIGNMENT_LIST = 'CACHED_ASSIGNMENT_LIST';
const CACHED_TUTEE_CRITERION = 'CACHED_TUTEE_CRITERION';
const CACHED_ASSIGNMENT = 'CACHED_ASSIGNMENT';

abstract class TuteeAssignmentLocalDataSource {
  /// Gets the cached [TuteeAssignmnetModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<TuteeAssignmentEntity>> getLastAssignmentList();

  Future<void> cacheAssignmentList(
    List<TuteeAssignmentEntity> assignmentsToCache, {
    bool isNew = true,
  });

  /// Gets the cached [TuteeCriteriaParamsEntity] which was used when the user attempted
  /// to search for assignments matching a particular set of criterion
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<TuteeCriteriaParamsEntity> getCachedParams();
  Future<void> cacheCriterion(TuteeCriteriaParamsEntity params);

  Future<TuteeAssignmentEntity> getCachedTuteeAssignmentToSet();
  Future<void> cacheTuteeAssignmentToSet(TuteeAssignmentEntity tuteeAssignment);
}

class TuteeAssignmentLocalDataSourceImpl
    implements TuteeAssignmentLocalDataSource {
  TuteeAssignmentLocalDataSourceImpl({this.sharedPreferences});
  SharedPreferences sharedPreferences;

  @override
  Future<void> cacheCriterion(TuteeCriteriaParamsEntity params) {
    return sharedPreferences.setString(
      CACHED_TUTEE_CRITERION,
      json.encode(params.toMap()),
    );
  }

  @override
  Future<TuteeCriteriaParamsEntity> getCachedParams() {
    final String jsonString =
        sharedPreferences.getString(CACHED_TUTEE_CRITERION);
    if (jsonString != null) {
      final Map<String, dynamic> criterionList =
          Map<String, dynamic>.from(json.decode(jsonString));
      return Future.value(TuteeCriteriaParamsEntity.fromMap(criterionList));
    } else {
      print('tutee_assignment local data source error getCachedParams');
      throw CacheException();
    }
  }

  @override
  Future<void> cacheAssignmentList(
    List<TuteeAssignmentEntity> assignmentsToCache, {
    bool isNew = true,
  }) async {
    List<Map<String, dynamic>> toEncode;
    assignmentsToCache == null
        ? toEncode = []
        : toEncode = assignmentsToCache.map((e) => e.toJson());

    if (!isNew) {
      final String jsonString =
          sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);

      if (jsonString != null) {
        final List<Map<String, dynamic>> assignmentString =
            List<Map<String, dynamic>>.from(json.decode(jsonString));
        assignmentString.addAll(toEncode);
        return sharedPreferences.setString(
          CACHED_ASSIGNMENT_LIST,
          json.encode(assignmentString),
        );
      }
    }

    return sharedPreferences.setString(
      CACHED_ASSIGNMENT_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<List<TuteeAssignmentEntity>> getLastAssignmentList() {
    final String jsonString =
        sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);
    if (jsonString != null) {
      final List<Map<String, dynamic>> assignmentString =
          List<Map<String, dynamic>>.from(json.decode(jsonString));
      final List<TuteeAssignmentEntity> toReturn = assignmentString
          .map((e) => TuteeAssignmentEntity.fromJson(e))
          .toList();
      return Future.value(toReturn);
    } else {
      print('tutee_assignment local data source error getLastAssingemntList');
      throw CacheException();
    }
  }

  @override
  Future<TuteeAssignmentEntity> getCachedTuteeAssignmentToSet() {
    final String jsonString =
        sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);
    if (jsonString != null) {
      final Map<String, dynamic> cachedAssignmentString =
          json.decode(jsonString);
      return Future.value(
          TuteeAssignmentEntity.fromJson(cachedAssignmentString));
    } else {
      print(
          'tutee_assignment local data source error getCachedTuteeAssignmentToSet');
      throw CacheException();
    }
  }

  @override
  Future<void> cacheTuteeAssignmentToSet(
      TuteeAssignmentEntity tuteeAssignment) {
    return sharedPreferences.setString(
      CACHED_ASSIGNMENT,
      json.encode(tuteeAssignment.toJson()),
    );
  }
}

import 'dart:convert';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_ASSIGNMENT_LIST = 'CACHED_ASSIGNMENT_LIST';
const CACHED_CRITERION = 'CACHED_CRITERION';
const CACHED_ASSIGNMENT = 'CACHED_ASSIGNMENT';

abstract class TuteeAssignmentLocalDataSource {
  /// Gets the cached [TuteeAssignmnetModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<TuteeAssignmentModel>> getLastAssignmentList();

  Future<void> cacheAssignmentList(
    List<TuteeAssignmentModel> assignmnetsToCache,
  );

  Future<void> cacheToExistingAssignmentList(
    List<TuteeAssignmentModel> assignmnetsToCache,
  );

  Future<void> cacheCriterion(CriteriaParams params);

  /// Gets the cached [CriteriaParams] which was used when the user attempted
  /// to search for assignments matching a particular set of criterion
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<CriteriaParams> getCachedParams();

  Future<TuteeAssignmentModel> getCachedTuteeAssignmentToSet();

  Future<void> cacheTuteeAssignmentToSet(TuteeAssignmentModel params);
}

class TuteeAssignmentLocalDataSourceImpl
    implements TuteeAssignmentLocalDataSource {
  TuteeAssignmentLocalDataSourceImpl({this.sharedPreferences});
  SharedPreferences sharedPreferences;

  @override
  Future<void> cacheCriterion(CriteriaParams params) {
    return sharedPreferences.setString(
      CACHED_CRITERION,
      json.encode(params.toMap()),
    );
  }

  @override
  Future<CriteriaParams> getCachedParams() {
    final String jsonString = sharedPreferences.getString(CACHED_CRITERION);
    if (jsonString != null) {
      final Map<String, dynamic> criterionList = json.decode(jsonString);
      final CriteriaParams result = CriteriaParams.fromMap(criterionList);
      return Future.value(result);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheAssignmentList(
      List<TuteeAssignmentModel> assignmnetsToCache) {
    final List<Map<String, dynamic>> toEncode = (assignmnetsToCache
            ?.map((TuteeAssignmentModel e) => e.toJson())
            .toList()) ??
        [];
    return sharedPreferences.setString(
      CACHED_ASSIGNMENT_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<void> cacheToExistingAssignmentList(
      List<TuteeAssignmentModel> assignmnetsToCache) async {
    final List<Map<String, dynamic>> toEncode =
        assignmnetsToCache.map((TuteeAssignmentModel e) => e.toJson()).toList();

    final String jsonString =
        sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);
    if (jsonString != null) {
      final List<dynamic> assignmentString =
          List<dynamic>.from(json.decode(jsonString));
      assignmentString.addAll(toEncode);
      return sharedPreferences.setString(
        CACHED_ASSIGNMENT_LIST,
        json.encode(assignmentString),
      );
    }
    return sharedPreferences.setString(
      CACHED_ASSIGNMENT_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<List<TuteeAssignmentModel>> getLastAssignmentList() {
    final String jsonString =
        sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);
    if (jsonString != null) {
      final List<dynamic> assignmentString =
          List<dynamic>.from(json.decode(jsonString));
      final List<TuteeAssignmentModel> result = assignmentString
          .map((dynamic e) => TuteeAssignmentModel.fromJson(e))
          .toList();
      return Future.value(result);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<TuteeAssignmentModel> getCachedTuteeAssignmentToSet() {
    final String jsonString =
        sharedPreferences.getString(CACHED_ASSIGNMENT_LIST);
    if (jsonString != null) {
      final Map<String, dynamic> cachedAssignmentString =
          json.decode(jsonString);
      final TuteeAssignmentModel result =
          TuteeAssignmentModel.fromJson(cachedAssignmentString);
      return Future.value(result);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheTuteeAssignmentToSet(TuteeAssignmentModel params) {
    final Map<String, dynamic> toEncode = params.toJson();
    return sharedPreferences.setString(
      CACHED_ASSIGNMENT,
      json.encode(toEncode),
    );
  }
}

import 'dart:convert';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/criteria_params.dart';
import 'package:cotor/data/models/tutee_assignment_model.dart';
import 'package:cotor/data/models/tutor_profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_PROFILE_LIST = 'CACHED_PROFILE_LIST';
const CACHED_CRITERION = 'CACHED_CRITERION';
const CACHED_PROFILE = 'CACHED_PROFILE';

abstract class TutorProfileLocalDataSource {
  /// Gets the cached [TuteeAssignmnetModel] which was gotten the last time
  /// the user had an internet connection.
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<TutorProfileModel>> getLastProfileList();

  Future<void> cacheProfileList(
    List<TutorProfileModel> profilesToCache,
  );

  Future<void> cacheToExistingProfileList(
    List<TutorProfileModel> profilesToCache,
  );

  Future<void> cacheCriterion(TutorCriteriaParams params);

  /// Gets the cached [CriteriaParams] which was used when the user attempted
  /// to search for assignments matching a particular set of criterion
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<TutorCriteriaParams> getCachedParams();

  Future<TuteeAssignmentModel> getCachedTutorProfileToSet();

  Future<void> cacheTutorProfileToSet(TutorProfileModel params);
}

class TutorProfileLocalDataSourceImpl implements TutorProfileLocalDataSource {
  TutorProfileLocalDataSourceImpl({this.sharedPreferences});
  SharedPreferences sharedPreferences;

  @override
  Future<void> cacheCriterion(CriteriaParams params) {
    return sharedPreferences.setString(
      CACHED_CRITERION,
      json.encode(params.toMap()),
    );
  }

  @override
  Future<TutorCriteriaParams> getCachedParams() {
    final String jsonString = sharedPreferences.getString(CACHED_CRITERION);
    if (jsonString != null) {
      final Map<String, dynamic> criterionList = json.decode(jsonString);
      final TutorCriteriaParams result =
          TutorCriteriaParams.fromMap(criterionList);
      return Future.value(result);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProfileList(List<TutorProfileModel> profilesToCache) {
    final List<Map<String, dynamic>> toEncode =
        (profilesToCache?.map((TutorProfileModel e) => e.toJson()).toList()) ??
            [];
    return sharedPreferences.setString(
      CACHED_PROFILE_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<void> cacheToExistingProfileList(
      List<TutorProfileModel> assignmnetsToCache) async {
    final List<Map<String, dynamic>> toEncode =
        assignmnetsToCache.map((TutorProfileModel e) => e.toJson()).toList();

    final String jsonString = sharedPreferences.getString(CACHED_PROFILE_LIST);
    if (jsonString != null) {
      final List<dynamic> profileString =
          List<dynamic>.from(json.decode(jsonString));
      profileString.addAll(toEncode);
      return sharedPreferences.setString(
        CACHED_PROFILE_LIST,
        json.encode(profileString),
      );
    }
    return sharedPreferences.setString(
      CACHED_PROFILE_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<List<TutorProfileModel>> getLastProfileList() {
    final String jsonString = sharedPreferences.getString(CACHED_PROFILE_LIST);
    if (jsonString != null) {
      final List<dynamic> profileString =
          List<dynamic>.from(json.decode(jsonString));
      final List<TutorProfileModel> result = profileString
          .map((dynamic e) => TutorProfileModel.fromJson(e))
          .toList();
      return Future.value(result);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<TuteeAssignmentModel> getCachedTutorProfileToSet() {
    final String jsonString = sharedPreferences.getString(CACHED_PROFILE_LIST);
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
  Future<void> cacheTutorProfileToSet(TutorProfileModel params) {
    final Map<String, dynamic> toEncode = params.toJson();
    return sharedPreferences.setString(
      CACHED_PROFILE,
      json.encode(toEncode),
    );
  }
}

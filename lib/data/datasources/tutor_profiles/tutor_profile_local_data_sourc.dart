import 'dart:convert';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/tutor_criteria_params_entity.dart';
import 'package:cotor/data/models/tutor_profile_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_PROFILE_LIST = 'CACHED_PROFILE_LIST';
const CACHED_TUTOR_CRITERION = 'CACHED_TUTOR_CRITERION';

abstract class TutorProfileLocalDataSource {
  /// Returns the cached [List<TutorProfileEntity>] that the user last retrieved
  /// with an internet connection
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<List<TutorProfileEntity>> getLastProfileList();

  /// Cache the [List<TutorProfileEntity>] to be retrieved later
  Future<void> cacheProfileList(
    List<TutorProfileEntity> profilesToCache, {

    /// Wether caching to an existing List
    /// or caching to a new list
    bool isNew = true,
  });

  /// Cache the [TutorCriteriaParamsEntity] for possible retrieval later
  Future<void> cacheCriterion(TutorCriteriaParamsEntity params);

  /// Gets the cached [TutorCriteriaParamsEntity] which was used when the user attempted
  /// to search for assignments matching a particular set of criterion
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<TutorCriteriaParamsEntity> getCachedParams();
}

class TutorProfileLocalDataSourceImpl implements TutorProfileLocalDataSource {
  TutorProfileLocalDataSourceImpl({this.sharedPreferences});
  SharedPreferences sharedPreferences;

  @override
  Future<void> cacheCriterion(TutorCriteriaParamsEntity params) {
    return sharedPreferences.setString(
      CACHED_TUTOR_CRITERION,
      json.encode(params),
    );
  }

  @override
  Future<TutorCriteriaParamsEntity> getCachedParams() {
    final String jsonString =
        sharedPreferences.getString(CACHED_TUTOR_CRITERION);
    if (jsonString != null) {
      final Map<String, dynamic> criterionList = Map<String, dynamic>.from(
        json.decode(jsonString),
      );
      return Future.value(TutorCriteriaParamsEntity.fromMap(criterionList));
    } else {
      print('tutor profile lcoal data source getCachedParams');
      throw CacheException();
    }
  }

  @override
  Future<void> cacheProfileList(
    List<TutorProfileEntity> profileToCache, {
    bool isNew = true,
  }) async {
    List<Map<String, dynamic>> toEncode;
    profileToCache == null
        ? toEncode = []
        : toEncode = profileToCache.map((e) => e.toJson()).toList();

    if (!isNew) {
      final String jsonString =
          sharedPreferences.getString(CACHED_PROFILE_LIST);
      if (jsonString != null) {
        final List<Map<String, dynamic>> profileString =
            List<Map<String, dynamic>>.from(json.decode(jsonString));
        profileString.addAll(toEncode);
        return sharedPreferences.setString(
          CACHED_PROFILE_LIST,
          json.encode(profileString),
        );
      }
    }
    return sharedPreferences.setString(
      CACHED_PROFILE_LIST,
      json.encode(toEncode),
    );
  }

  @override
  Future<List<TutorProfileEntity>> getLastProfileList() {
    final String jsonString = sharedPreferences.getString(CACHED_PROFILE_LIST);
    if (jsonString != null) {
      final List<Map<String, dynamic>> profileString =
          List<Map<String, dynamic>>.from(json.decode(jsonString));
      final List<TutorProfileEntity> toReturn =
          profileString.map((e) => TutorProfileEntity.fromJson(e)).toList();
      return Future.value(toReturn);
    } else {
      print('tutor profile lcoal data source getLastProfileList');
      throw CacheException();
    }
  }
}

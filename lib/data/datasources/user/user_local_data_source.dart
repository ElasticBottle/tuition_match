import 'dart:convert';

import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/models/tutor_profile_entity.dart';
import 'package:cotor/data/models/tutee_assignment_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

const CACHED_PROFILE = 'CACHED_PROFILE';
const CACHED_ASSIGNMENT = 'CACHED_ASSIGNMENT';

abstract class UserLocalDataSource {
  /// Returns the cached [TutorProfileEntity] that the user saved
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<TutorProfileEntity> getCachedTutorProfileToSet();

  /// Cache the [TutorProfileEntity] to be retrieved later
  Future<void> cacheTutorProfileToSet(TutorProfileEntity profile);

  /// Clears the current Cached [TutorProfileEntity] if any
  Future<bool> clearCacheTutorProfile();

  /// Gets the cached [TuteeAssignmnetEntity] that the user saved
  ///
  /// Throws [CacheException] if no cached data is present.
  Future<TuteeAssignmentEntity> getCachedTuteeAssignmentToSet();

  /// Cache the [TuteeAssignmnetEntity] to be retrieved later
  Future<void> cacheTuteeAssignmentToSet(TuteeAssignmentEntity tuteeAssignment);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  UserLocalDataSourceImpl({this.sharedPreferences});
  SharedPreferences sharedPreferences;
  @override
  Future<TutorProfileEntity> getCachedTutorProfileToSet() {
    final String jsonString = sharedPreferences.getString(CACHED_PROFILE);
    if (jsonString != null) {
      final Map<String, dynamic> cachedAssignmentString =
          Map<String, dynamic>.from(json.decode(jsonString));
      return Future.value(TutorProfileEntity.fromJson(cachedAssignmentString));
    } else {
      print('tutor profile local data source getcachedTutorProfileToSet');
      throw CacheException();
    }
  }

  @override
  Future<void> cacheTutorProfileToSet(TutorProfileEntity profile) {
    return sharedPreferences.setString(
      CACHED_PROFILE,
      json.encode(profile.toJson()),
    );
  }

  @override
  Future<bool> clearCacheTutorProfile() async {
    return await sharedPreferences.remove(CACHED_PROFILE);
  }

  @override
  Future<TuteeAssignmentEntity> getCachedTuteeAssignmentToSet() {
    final String jsonString = sharedPreferences.getString(CACHED_ASSIGNMENT);
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

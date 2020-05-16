import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/applications/application_enttiy.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/tutor_profile_entity.dart';
import 'package:cotor/data/models/user/user_entity.dart';
import 'package:cotor/data/models/user/withheld_info_entity.dart';
import 'package:cotor/domain/entities/user/user_export.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class UserRemoteDataSource {
//   ___                       _                      _       __
//  / __|___ _ _  ___ _ _ __ _| |  _  _ ___ ___ _ _  (_)_ _  / _|___
// | (_ / -_) ' \/ -_) '_/ _` | | | || (_-</ -_) '_| | | ' \|  _/ _ \
//  \___\___|_||_\___|_| \__,_|_|  \_,_/__/\___|_|   |_|_||_|_| \___/
//

  /// Returns a [Stream<UserEntity>] listening to the user public info
  ///
  /// Trigger everytime the logged in user updates the profile.
  /// This includes changes to user's [TutorProfile] and [TuteeAssignment]
  /// This does no include changes to user's [RequestedTutors], [AppliedAssignments], and [Likes]
  Stream<UserEntity> userProfileStream(String uid);

  /// Retreives [UserEntity] of the user corresponding to [uid]
  ///
  /// Throws:
  /// * [NoUserException] if document does not exist for that particulat [uid]
  /// * [ServerException] for all other errors.
  Future<UserEntity> getUserInfo(String uid);

  /// Gets the private info of user [uid]
  ///
  /// Throw [ServerException] for all errors.
  Future<WithheldInfoEntity> getUserWithheldInfo(String uid);

  /// Creates a new database entry for user [uid]
  ///
  /// Throws [ServerException] for all errors
  Future<void> createNewUserDocument({
    String uid,
    String photoUrl,
    String firstname,
    String lastname,
    String phoneNum,
    String countryCode,
  });

  //  _   _                 _          _                         _
// | | | |___ ___ _ _    /_\   _____(_)__ _ _ _  _ __  ___ _ _| |_
// | |_| (_-</ -_) '_|  / _ \ (_-<_-< / _` | ' \| '  \/ -_) ' \  _|
//  \___//__/\___|_|   /_/ \_\/__/__/_\__, |_||_|_|_|_\___|_||_\__|
//                                    |___/

  /// Sets and updates user Assignment
  ///
  /// Throws __[ServerException]__ when there are errors processing the request
  Future<bool> setAssignment(
      {TuteeAssignmentEntity assignment, bool isNew = true});

  // /// Creates new user Assignment
  // ///
  // /// Throws __[ServerException]__ when there are errors processing the request
  // Future<bool> setTuteeAssignment({TuteeAssignmentEntity tuteeParams});

  // /// Updates user assignment
  // ///
  // /// Throws __[ServerException]__ when there are errors processing the request
  // Future<bool> updateTuteeAssignment({TuteeAssignmentEntity tuteeParams});

  /// Deletes specified user assignment
  ///
  /// Throws __[ServerException]__ when there are errors processing the request
  Future<bool> delAssignment({String postId, String uid});

//  _   _               ___          __ _ _
// | | | |___ ___ _ _  | _ \_ _ ___ / _(_) |___
// | |_| (_-</ -_) '_| |  _/ '_/ _ \  _| | / -_)
//  \___//__/\___|_|   |_| |_| \___/_| |_|_\___|

  /// Sets and update user Profile
  ///
  /// Throws __[ServerException]__ when there are errors processing the request
  Future<bool> setProfile(
      {TutorProfileEntity tutorProfile, bool isNew = false});

  // /// Creates new user Profile
  // ///
  // /// Throws __[ServerException]__ when there are errors processing the request
  // Future<bool> setTutorProfile({TutorProfileEntity tutorProfile});

  // /// Updates user Profile
  // ///
  // /// Throws __[ServerException]__ when there are errors processing the request
  // Future<bool> updateTutorProfile({TutorProfileEntity tutorProfile});

  /// Deletes specified user Profile
  ///
  /// Throws __[ServerException]__ when there are errors processing the request
  Future<bool> delProfile({String uid});

//  ___                      _
// | _ \___ __ _ _  _ ___ __| |_ ___
// |   / -_) _` | || / -_|_-<  _(_-<
// |_|_\___\__, |\_,_\___/__/\__/__/
//            |_|

  /// Adds an ApplicationEntity to the reqeusts collection
  ///
  /// Saves the users request to their exisiting assignment if they wish
  /// or updates user profile if they want
  ///
  /// Throws__[ServerException]__ when there are errors processing the request
  Future<bool> setApplication({
    ApplicationEntity application,
    bool isNewApp,
    bool toSave,
  });
}

class FirestoreUserDataSource implements UserRemoteDataSource {
  FirestoreUserDataSource({this.store, this.auth});
  final Firestore store;
  final FirebaseAuth auth;

//   ___                       _                      _       __
//  / __|___ _ _  ___ _ _ __ _| |  _  _ ___ ___ _ _  (_)_ _  / _|___
// | (_ / -_) ' \/ -_) '_/ _` | | | || (_-</ -_) '_| | | ' \|  _/ _ \
//  \___\___|_||_\___|_| \__,_|_|  \_,_/__/\___|_|   |_|_||_|_| \___/
//
  @override
  Stream<UserEntity> userProfileStream(String uid) {
    return store.document(FirestorePath.users(uid)).snapshots().map(
        (DocumentSnapshot userProfileDoc) => UserEntity.fromDocumentSnapshot(
            userProfileDoc.data, userProfileDoc.documentID));
  }

  @override
  Future<void> createNewUserDocument({
    @required String uid,
    @required String photoUrl,
    @required String firstname,
    @required String lastname,
    @required String phoneNum,
    @required String countryCode,
  }) async {
    final DocumentReference publicInfo =
        store.document(FirestorePath.users(uid));
    final DocumentReference contactInfo =
        store.document(FirestorePath.usersContactInfo(uid));
    final DocumentReference allowedContactInfo =
        store.document(FirestorePath.usersAllowedContactInfo(uid));
    final DocumentReference likedTutors =
        store.document(FirestorePath.userLikedTutors(uid));
    final DocumentReference likedAssignments =
        store.document(FirestorePath.userLikedAssignments(uid));
    final WriteBatch batch = store.batch();
    batch.setData(publicInfo, <String, dynamic>{
      USER_IDENTITY: <String, dynamic>{
        NAME: <String, String>{
          FIRSTNAME: firstname,
          LASTNAME: lastname,
        },
        PHOTO_URL: photoUrl,
        IS_VERIFIED_ACCOUNT: false,
        ACCOUNT_TYPE: AccountType.BASIC.toString(),
      },
      USER_ASSIGNMENTS: <String, Map<String, dynamic>>{},
      USER_PROFILE: <String, dynamic>{},
    });
    batch.setData(contactInfo, <String, dynamic>{
      PHONE_NUMBER: phoneNum,
      COUNTRY_CODE: countryCode,
    });
    batch.setData(allowedContactInfo, <String, dynamic>{});
    batch.setData(likedTutors, <String, dynamic>{});
    batch.setData(likedAssignments, <String, dynamic>{});
    try {
      await batch.commit();
    } catch (e) {
      print('user remote data source CreateNewUserDocument' + e.toString());
      throw ServerException();
    }
  }

  @override
  Future<UserEntity> getUserInfo(String uid) async {
    final DocumentReference ref = store.document(FirestorePath.users(uid));
    try {
      final DocumentSnapshot result = await ref.get();
      if (result.data == null) {
        throw NoUserException();
      }
      return UserEntity.fromDocumentSnapshot(result.data, result.documentID);
    } catch (e, stacktrace) {
      print(stacktrace);
      print('user remote data source getUserInfo ' + e.toString());
      if (e is NoUserException) {
        throw NoUserException();
      }
      throw ServerException();
    }
  }

  @override
  Future<WithheldInfoEntity> getUserWithheldInfo(String uid) async {
    final DocumentReference privateRef =
        store.document(FirestorePath.usersContactInfo(uid));
    try {
      final DocumentSnapshot result = await privateRef.get();
      // TODO(ElasticBottle): figure out return type
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace);
      throw ServerException();
    }
  }

//  _   _                 _          _                         _
// | | | |___ ___ _ _    /_\   _____(_)__ _ _ _  _ __  ___ _ _| |_
// | |_| (_-</ -_) '_|  / _ \ (_-<_-< / _` | ' \| '  \/ -_) ' \  _|
//  \___//__/\___|_|   /_/ \_\/__/__/_\__, |_||_|_|_|_\___|_||_\__|
//                                    |___/

  @override
  Future<bool> setAssignment(
      {TuteeAssignmentEntity assignment, bool isNew = true}) async {
    final DocumentReference userRef =
        store.document(FirestorePath.users(assignment.uid));

    try {
      await store.runTransaction(
        (Transaction tx) async {
          final DocumentSnapshot userSnapshot = await tx.get(userRef);
          String postId = assignment.postId;
          if (isNew) {
            final DocumentReference idPath = store
                .collection(FirestorePath.assignmentCollection())
                .document();
            postId = idPath.documentID;
          }

          // creating map to be used for update
          final Map<String, dynamic> assignmentMap =
              assignment.toDocumentSnapshot(isNew: isNew, freeze: false);
          userSnapshot.data[USER_ASSIGNMENTS][postId] = assignmentMap;

          // updating user and assignment collections
          tx.update(
            userRef,
            <String, Map<String, dynamic>>{
              USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
            },
          );
          tx.update(
            store.document(FirestorePath.assignment(postId)),
            assignmentMap,
          );
        },
      );
      return true;
    } catch (e, stacktrace) {
      print(e.toString() + ' ' + stacktrace.toString());
      throw ServerException();
    }
  }

  // @override
  // Future<bool> setTuteeAssignment({TuteeAssignmentEntity tuteeParams}) async {
  //   final DocumentReference userRef =
  //       store.document(FirestorePath.users(tuteeParams.uid));
  //   final DocumentReference idPath =
  //       store.collection(FirestorePath.assignmentCollection()).document();
  //   final String postId = idPath.documentID;

  //   try {
  //     await store.runTransaction(
  //       (Transaction tx) async {
  //         // creating assignment map to add
  //         final Map<String, dynamic> toAdd = tuteeParams.toDocumentSnapshot(
  //           isNew: true,
  //           freeze: false,
  //         );

  //         // adding assignment map to user profile and assignment collection
  //         final DocumentSnapshot userSnapshot = await tx.get(userRef);
  //         userSnapshot.data[USER_ASSIGNMENTS][postId] = toAdd;
  //         tx.update(
  //           userRef,
  //           <String, Map<String, dynamic>>{
  //             USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
  //           },
  //         );
  //         tx.set(
  //           store.document(FirestorePath.assignment(postId)),
  //           toAdd,
  //         );
  //       },
  //     );
  //     return true;
  //   } catch (e, stacktrace) {
  //     print(e.toString() + ' ' + stacktrace.toString());
  //     throw ServerException();
  //   }
  // }

  // @override
  // Future<bool> updateTuteeAssignment(
  //     {TuteeAssignmentEntity tuteeParams}) async {
  //   final DocumentReference userRef =
  //       store.document(FirestorePath.users(tuteeParams.uid));

  //   try {
  //     await store.runTransaction(
  //       (Transaction tx) async {
  //         final DocumentSnapshot userSnapshot = await tx.get(userRef);
  //         final String postId = tuteeParams.postId;

  //         // creating map to be used for update
  //         final Map<String, dynamic> toAdd =
  //             tuteeParams.toDocumentSnapshot(isNew: false, freeze: false);
  //         userSnapshot.data[USER_ASSIGNMENTS][postId] = toAdd;

  //         // updating user and assignment collections
  //         tx.update(
  //           userRef,
  //           <String, Map<String, dynamic>>{
  //             USER_ASSIGNMENTS: userSnapshot.data[USER_ASSIGNMENTS]
  //           },
  //         );
  //         tx.update(
  //           store.document(FirestorePath.assignment(postId)),
  //           toAdd,
  //         );
  //       },
  //     );
  //     return true;
  //   } catch (e, stacktrace) {
  //     print(e.toString() + ' ' + stacktrace.toString());
  //     throw ServerException();
  //   }
  // }

  @override
  Future<bool> delAssignment({String postId, String uid}) async {
    // TODO(EB): Change all existing application status to...
    final DocumentReference userRef = store.document(FirestorePath.users(uid));
    try {
      await store.runTransaction((Transaction tx) async {
        final DocumentSnapshot userSnapshot = await tx.get(userRef);
        final Map<String, Map<String, dynamic>> userAssignments =
            userSnapshot.data[USER_ASSIGNMENTS];
        userAssignments.remove(postId);
        tx.update(
            userRef, <String, dynamic>{USER_ASSIGNMENTS: userAssignments});
        tx.delete(store.document(FirestorePath.assignment(postId)));
      });
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

//  _   _               ___          __ _ _
// | | | |___ ___ _ _  | _ \_ _ ___ / _(_) |___
// | |_| (_-</ -_) '_| |  _/ '_/ _ \  _| | / -_)
//  \___//__/\___|_|   |_| |_| \___/_| |_|_\___|

  @override
  Future<bool> setProfile(
      {TutorProfileEntity tutorProfile, bool isNew = false}) async {
    final DocumentReference profileRef =
        store.document(FirestorePath.tutorProfile(tutorProfile.uid));
    try {
      await store.runTransaction(
        (Transaction tx) async {
          final Map<String, dynamic> profileMap =
              tutorProfile.toDocumentSnapshot(isNew: isNew, freeze: false);

          tx.update(
            store.document(FirestorePath.users(tutorProfile.uid)),
            <String, Map<String, dynamic>>{USER_PROFILE: profileMap},
          );
          tx.update(
            profileRef,
            profileMap,
          );
        },
      );
      return true;
    } catch (e, stacktrace) {
      print(stacktrace);
      print(e.toString());
      throw ServerException();
    }
  }

  // @override
  // Future<bool> setTutorProfile({TutorProfileEntity tutorProfile}) async {
  //   final Map<String, dynamic> toAdd =
  //       tutorProfile.toDocumentSnapshot(isNew: true, freeze: false);

  //   final WriteBatch batch = store.batch();
  //   batch.updateData(
  //     store.document(FirestorePath.users(tutorProfile.identity.uid)),
  //     <String, dynamic>{
  //       USER_PROFILE: toAdd,
  //       IS_TUTOR: true,
  //     },
  //   );
  //   batch.setData(
  //     store.document(FirestorePath.tutorProfile(tutorProfile.uid)),
  //     toAdd,
  //   );
  //   try {
  //     await batch.commit();
  //     return true;
  //   } catch (e, stacktrace) {
  //     print(stacktrace);
  //     print(e.toString());
  //     throw ServerException();
  //   }
  // }

  // @override
  // Future<bool> updateTutorProfile({TutorProfileEntity tutorProfile}) async {
  //   final DocumentReference tutorProfileRef =
  //       store.document(FirestorePath.tutorProfile(tutorProfile.uid));
  //   try {
  //     await store.runTransaction(
  //       (Transaction tx) async {
  //         final DocumentSnapshot profileSnapshot =
  //             await tx.get(tutorProfileRef);

  //         final Map<String, dynamic> toAdd =
  //             tutorProfile.toExistingDocumentSnapshot(profileSnapshot.data);
  //         toAdd[DATE_MODIFIED] = FieldValue.serverTimestamp();

  //         tx.update(
  //           store.document(FirestorePath.users(tutorProfile.uid)),
  //           <String, Map<String, dynamic>>{USER_PROFILE: toAdd},
  //         );
  //         tx.update(
  //           tutorProfileRef,
  //           toAdd,
  //         );
  //       },
  //     );
  //     return true;
  //   } catch (e, stacktrace) {
  //     print(stacktrace);
  //     print(e.toString());
  //     throw ServerException();
  //   }
  // }

  @override
  Future<bool> delProfile({String uid}) async {
    // TODO(EB): handle existing request
    try {
      await store.runTransaction((Transaction tx) async {
        tx.update(store.document(FirestorePath.users(uid)),
            <String, dynamic>{USER_PROFILE: '', IS_TUTOR: false});
        tx.delete(store.document(FirestorePath.tutorProfile(uid)));
      });
      return true;
    } catch (e) {
      print(e.toString());
      throw ServerException();
    }
  }

//  ___                      _
// | _ \___ __ _ _  _ ___ __| |_ ___
// |   / -_) _` | || / -_|_-<  _(_-<
// |_|_\___\__, |\_,_\___/__/\__/__/
//            |_|

  @override
  Future<bool> setApplication({
    ApplicationEntity application,
    bool isNewApp,
    bool toSave,
  }) async {
    final WriteBatch batch = store.batch();
    final bool isApplicantAssignment = application.applicationInfo.isAssignment;

    TuteeAssignmentEntity assignment;
    if (isApplicantAssignment) {
      assignment = application.applicationInfo;
    } else {
      assignment = application.requestedInfo;
    }

    final DocumentReference applicantRequestRef = isApplicantAssignment
        ? store.document(FirestorePath.assignmentRequests(
            assignment.postId,
            application.requestedInfo.identity.uid,
          ))
        : store.document(FirestorePath.tutorProfileRequests(
            application.requestedInfo.identity.uid,
            assignment.postId,
          ));
    final DocumentReference requestedRequestRef = isApplicantAssignment
        ? store.document(FirestorePath.tutorProfileRequests(
            application.requestedInfo.identity.uid,
            assignment.postId,
          ))
        : store.document(FirestorePath.assignmentRequests(
            assignment.postId,
            application.requestedInfo.identity.uid,
          ));

    // storing tutor info in assignment request sub collection
    batch.setData(
      applicantRequestRef,
      application.toRequestedInfoDocumentSnapshot(
        dateType: ApplicationDateType.request,
      ),
    );
    // storing assignment Info in tutor request sub collection
    batch.setData(
      requestedRequestRef,
      application.toApplicantInfoDocumentSnapshot(
        dateType: ApplicationDateType.request,
        isNew: isNewApp,
      ),
    );

    try {
      batch.commit();
      if (toSave) {
        if (application.applicationInfo.isAssignment) {
          setAssignment(
            assignment: application.applicationInfo,
            isNew: isNewApp,
          );
        } else {
          setProfile(
            tutorProfile: application.applicationInfo,
            isNew: false,
          );
        }
      }
      return true;
    } catch (e, stacktrace) {
      print(e.toString() + ' ' + stacktrace.toString());
      throw ServerException();
    }
  }
}

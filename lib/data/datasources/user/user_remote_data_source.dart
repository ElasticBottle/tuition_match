import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cotor/core/error/exception.dart';
import 'package:cotor/data/datasources/firestore_path.dart';
import 'package:cotor/data/models/map_key_strings.dart';
import 'package:cotor/data/models/post/applications/application_enttiy.dart';
import 'package:cotor/data/models/post/applications/base_application/application_date_type.dart';
import 'package:cotor/data/models/post/base_post/base_stats/stats_simple_entity.dart';
import 'package:cotor/data/models/post/tutee_assignment/tutee_assignment_entity.dart';
import 'package:cotor/data/models/post/tutor_profile/tutor_profile_entity.dart';
import 'package:cotor/data/models/user/account_type_entity.dart';
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
  /// Returns the string of the user assignment that was updated
  ///
  /// Throws __[ServerException]__ when there are errors processing the request
  Future<String> setAssignment(
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

  /// Returns a [Stream<ApplicationEntity>] listening to the request subcollection of a particular post
  ///
  /// Trigger everytime a new request is added ro changes are made to existing request
  Stream<List<ApplicationEntity>> requestStream({String id, bool isProfile});
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
  Future<String> setAssignment(
      {TuteeAssignmentEntity assignment, bool isNew = true}) async {
    final DocumentReference userRef =
        store.document(FirestorePath.users(assignment.uid));
    String postId;
    try {
      await store.runTransaction(
        (Transaction tx) async {
          final DocumentSnapshot userSnapshot = await tx.get(userRef);
          postId = assignment.postId;
          if (isNew) {
            final DocumentReference idPath = store
                .collection(FirestorePath.assignmentCollection())
                .document();
            postId = idPath.documentID;
          }

          // creating map to be used for update
          final Map<String, dynamic> assignmentMap =
              assignment.toDocumentSnapshot(isNew: isNew, freeze: false);
          final Map<String, dynamic> toUpdate = userSnapshot.data;

          toUpdate[USER_ASSIGNMENTS][postId] = assignmentMap;

          if (isNew) {
            final AccountTypeEntity accountTypeEntity =
                AccountTypeEntity.fromString(
                    toUpdate[USER_IDENTITY][ACCOUNT_TYPE]);
            toUpdate[USER_IDENTITY][ACCOUNT_TYPE] =
                AccountTypeEntity.fromDomainEntity(
                        accountTypeEntity.makeStudent())
                    .toString();
          }

          // updating user and assignment collections
          tx.update(
            userRef,
            <String, dynamic>{
              USER_ASSIGNMENTS: toUpdate[USER_ASSIGNMENTS],
              USER_IDENTITY: toUpdate[USER_IDENTITY]
            },
          );
          tx.set(
            store.document(FirestorePath.assignment(postId)),
            assignmentMap,
          );

          if (isNew) {
            tx.set(
              store.document(FirestorePath.assignmentStatsLiked(postId)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(FirestorePath.assignmentStatsDeclinedBy(postId)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(FirestorePath.assignmentStatsAcceptBy(postId)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(FirestorePath.assignmentStatsAccepted(postId)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(FirestorePath.assignmentStatsFinished(postId)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(FirestorePath.assignmentStatsPending(postId)),
              <String, dynamic>{
                TO_REVIEW: 0,
                AWAITING_CONFIRM: 0,
                AWAITING_REVIEW: 0,
                TO_CONFIRM: 0,
              },
            );
            tx.set(
              store.document(FirestorePath.assignmentStatsIncoming(postId)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(FirestorePath.assignmentStatsOutgoing(postId)),
              <String, dynamic>{},
            );
          }
        },
      );
      return postId;
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
    final DocumentReference userRef =
        store.document(FirestorePath.users(tutorProfile.uid));
    try {
      await store.runTransaction(
        (Transaction tx) async {
          final DocumentSnapshot userProfile = await tx.get(userRef);

          final Map<String, dynamic> profileMap =
              tutorProfile.toDocumentSnapshot(isNew: isNew, freeze: false);

          Map<String, dynamic> userUpdateMap = <String, dynamic>{
            USER_PROFILE: profileMap
          };

          if (isNew) {
            final AccountTypeEntity accountType = AccountTypeEntity.fromString(
                userProfile.data[USER_IDENTITY][ACCOUNT_TYPE]);
            final Map<String, dynamic> toUpdate =
                userProfile.data[USER_IDENTITY];
            toUpdate[ACCOUNT_TYPE] =
                AccountTypeEntity.fromDomainEntity(accountType.makeTutor())
                    .toString();

            userUpdateMap = <String, dynamic>{
              USER_PROFILE: profileMap,
              USER_IDENTITY: toUpdate,
            };
          }

          tx.update(
            userRef,
            userUpdateMap,
          );
          tx.set(
            profileRef,
            profileMap,
          );
          if (isNew) {
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsLiked(tutorProfile.uid)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsDeclinedBy(tutorProfile.uid)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsAcceptBy(tutorProfile.uid)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsAccepted(tutorProfile.uid)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsFinished(tutorProfile.uid)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsPending(tutorProfile.uid)),
              <String, dynamic>{
                TO_REVIEW: 0,
                AWAITING_CONFIRM: 0,
                AWAITING_REVIEW: 0,
                TO_CONFIRM: 0,
              },
            );
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsIncoming(tutorProfile.uid)),
              <String, dynamic>{},
            );
            tx.set(
              store.document(
                  FirestorePath.tutorProfileStatsOutgoing(tutorProfile.uid)),
              <String, dynamic>{},
            );
          }
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
            <String, dynamic>{USER_PROFILE: ''});
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
    String id;
    final bool isApplicantAssignment = application.applicationInfo.isAssignment;
    TuteeAssignmentEntity assignment;
    if (isApplicantAssignment) {
      assignment = application.applicationInfo;
    } else {
      assignment = application.requestedInfo;
    }
    try {
      if (toSave) {
        if (isApplicantAssignment) {
          id = await setAssignment(
            assignment: application.applicationInfo,
            isNew: isNewApp,
          );
        } else {
          id = application.applicationInfo.identity.uid;
          await setProfile(
            tutorProfile: application.applicationInfo,
            isNew: false,
          );
        }
      } else {
        if (isNewApp && isApplicantAssignment) {
          id = store.document(FirestorePath.assignmentCollection()).documentID;
        } else if (isApplicantAssignment) {
          id = assignment.postId;
        } else {
          id = application.applicationInfo.identity.uid;
        }
      }
      final WriteBatch batch = store.batch();

      final DocumentReference applicantRequestRef = isApplicantAssignment
          ? store.document(FirestorePath.assignmentRequests(
              id,
              application.requestedInfo.identity.uid,
            ))
          : store.document(FirestorePath.tutorProfileRequests(
              id,
              assignment.postId,
            ));
      final DocumentReference requestedRequestRef = isApplicantAssignment
          ? store.document(FirestorePath.tutorProfileRequests(
              application.requestedInfo.identity.uid,
              id,
            ))
          : store.document(FirestorePath.assignmentRequests(
              assignment.postId,
              id,
            ));

      // upate request collection for both parties
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
      // update stats simple for requested applicant
      final DocumentReference requestRef = isApplicantAssignment
          ? store.document(FirestorePath.tutorProfile(
              application.requestedInfo.identity.uid))
          : store.document(FirestorePath.assignment(assignment.postId));

      batch.updateData(requestRef, <String, dynamic>{
        STATS_SIMPLE:
            StatsSimpleEntity.fromDomainEntity(application.requestedInfo.stats)
                .toFirebaseMap(requestIncrement: 1)
      });

      // update detail stats incoming and outgoing for reqeust and application respectively
      final DocumentReference applicationOutgoingStats = isApplicantAssignment
          ? store.document(FirestorePath.assignmentStatsOutgoing(id))
          : store.document(FirestorePath.tutorProfileStatsOutgoing(id));
      final DocumentReference requesterIncomingStats = isApplicantAssignment
          ? store.document(FirestorePath.tutorProfileStatsIncoming(
              application.requestedInfo.identity.uid))
          : store.document(
              FirestorePath.assignmentStatsOutgoing(assignment.postId));
      batch.updateData(
        applicationOutgoingStats,
        <String, dynamic>{
          application.requestedInfo.identity.uid: FieldValue.serverTimestamp()
        },
      );
      batch.updateData(
        requesterIncomingStats,
        <String, dynamic>{id: FieldValue.serverTimestamp()},
      );

      // update pending stats for both.
      final DocumentReference applicationPendingStats = isApplicantAssignment
          ? store.document(FirestorePath.assignmentStatsPending(id))
          : store.document(FirestorePath.tutorProfileStatsPending(id));
      final DocumentReference requesterPendingStats = isApplicantAssignment
          ? store.document(FirestorePath.tutorProfileStatsPending(
              application.requestedInfo.identity.uid))
          : store.document(
              FirestorePath.assignmentStatsPending(assignment.postId));
      batch.updateData(
        applicationPendingStats,
        <String, dynamic>{AWAITING_REVIEW: FieldValue.increment(1)},
      );
      batch.updateData(
        requesterPendingStats,
        <String, dynamic>{TO_REVIEW: FieldValue.increment(1)},
      );
      batch.commit();
      return true;
    } catch (e, stacktrace) {
      print(e.toString() + ' ' + stacktrace.toString());
      throw ServerException();
    }
  }

  @override
  Stream<List<ApplicationEntity>> requestStream({String id, bool isProfile}) {
    return isProfile
        ? store
            .collection(FirestorePath.tutorProfileRequestsCollection(id))
            .snapshots()
            .map((event) {
            return event.documentChanges
                .map((e) => ApplicationEntity.fromDocumentSnapshot(
                      e.document.data,
                      creatorApp: ({dynamic entity, json}) =>
                          TuteeAssignmentEntity.fromDocumentSnapshot(
                        json,
                        postId: e.document.documentID,
                      ),
                      creatorReq: ({dynamic entity, json}) =>
                          TutorProfileEntity.fromDocumentSnapshot(json,
                              needId: false),
                    ))
                .toList();
          })
        : store
            // TODO(EB): might need to add id for creatorApp.
            .collection(FirestorePath.assignmentRequestsCollection(id))
            .snapshots()
            .map(
            (event) {
              return event.documentChanges
                  .map((e) => ApplicationEntity.fromDocumentSnapshot(
                        e.document.data,
                        creatorApp: ({dynamic entity, json}) =>
                            TutorProfileEntity.fromDocumentSnapshot(json,
                                needId: false),
                        creatorReq: ({dynamic entity, json}) =>
                            TuteeAssignmentEntity.fromDocumentSnapshot(json,
                                needId: false),
                      ))
                  .toList();
            },
          );
  }
}

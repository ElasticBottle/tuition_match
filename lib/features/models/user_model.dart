import 'package:cotor/domain/entities/name.dart';
import 'package:cotor/domain/entities/tutee_assignment.dart';
import 'package:cotor/domain/entities/tutor_profile.dart';
import 'package:cotor/domain/entities/user.dart';
import 'package:cotor/features/models/name_model.dart';
import 'package:cotor/features/models/tutee_assignment_model.dart';
import 'package:cotor/features/models/tutor_profile_model.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable implements User {
  UserModel({
    Name name,
    String uid,
    String photoUrl,
    bool isTutor,
    bool isVerifiedAccount,
    bool isVerifiedTutor,
    bool isEmailVerified,
    Map<String, TuteeAssignment> userAssignments,
    TutorProfile tutorProfile,
  })  : _name = name == null ? null : NameModel.fromDomainEntity(name),
        _uid = uid,
        _photoUrl = photoUrl,
        _isTutor = isTutor,
        _isVerifiedAccount = isVerifiedAccount,
        _isVerifiedTutor = isVerifiedTutor,
        _isEmailVerified = isEmailVerified,
        _userAssignments = userAssignments?.map((key, value) =>
            MapEntry(key, TuteeAssignmentModel.fromDomainEntity(value))),
        _tutorProfile = TutorProfileModel.fromDomainEntity(tutorProfile);

  factory UserModel.empty() {
    return UserModel(
      name: NameModel.empty(),
      photoUrl: '',
      uid: '',
      isEmailVerified: false,
      isTutor: false,
      isVerifiedTutor: false,
      isVerifiedAccount: false,
      tutorProfile: TutorProfileModel(),
      userAssignments: const <String, TuteeAssignmentModel>{},
    );
  }
  factory UserModel.fromDomainEntity(User user) {
    if (user == null) {
      return null;
    }
    return UserModel(
      name: user.name,
      photoUrl: user.photoUrl,
      uid: user.uid,
      isEmailVerified: user.isEmailVerified,
      isTutor: user.isTutor,
      isVerifiedTutor: user.isVerifiedTutor,
      isVerifiedAccount: user.isVerifiedAccount,
      tutorProfile: user.tutorProfile,
      userAssignments: user.userAssignments,
    );
  }

  final NameModel _name;
  final String _uid;
  final String _photoUrl;
  final bool _isTutor;
  final bool _isVerifiedAccount;
  final bool _isVerifiedTutor;
  final bool _isEmailVerified;
  final Map<String, TuteeAssignmentModel> _userAssignments;
  final TutorProfileModel _tutorProfile;

  @override
  NameModel get name => _name;
  @override
  String get uid => _uid;
  @override
  String get photoUrl => _photoUrl;
  @override
  bool get isTutor => _isTutor;
  @override
  bool get isVerifiedAccount => _isVerifiedAccount;
  @override
  bool get isVerifiedTutor => _isVerifiedTutor;
  @override
  bool get isEmailVerified => _isEmailVerified;
  @override
  Map<String, TuteeAssignmentModel> get userAssignments => _userAssignments;
  @override
  TutorProfileModel get tutorProfile => _tutorProfile;

  User toDomainEntity() {
    return UserModel(
        uid: uid,
        isEmailVerified: isEmailVerified,
        isTutor: isTutor,
        isVerifiedAccount: isVerifiedAccount,
        isVerifiedTutor: isVerifiedTutor,
        name: name?.toDomainEntity(),
        photoUrl: photoUrl,
        tutorProfile: tutorProfile.toDomainEntity(),
        userAssignments: userAssignments
            ?.map((key, value) => MapEntry(key, value.toDomainEntity())));
  }

  User copyWith(
    String username,
    Name name,
    String uid,
    String photoUrl,
    bool isTutor,
    bool isVerifiedAccount,
    bool isVerifiedTutor,
    bool isEmailVerified,
    List<TuteeAssignment> userAssignments,
    TutorProfile tutorProfile,
  ) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      photoUrl: photoUrl ?? this.photoUrl,
      isTutor: isTutor ?? this.isTutor,
      isVerifiedAccount: isVerifiedAccount ?? this.isVerifiedAccount,
      isVerifiedTutor: isVerifiedTutor ?? this.isVerifiedTutor,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      userAssignments: userAssignments ?? this.userAssignments,
      tutorProfile: tutorProfile ?? this.tutorProfile,
    );
  }

  @override
  List<Object> get props => [
        name,
        uid,
        photoUrl,
        isTutor,
        isVerifiedAccount,
        isVerifiedTutor,
        isEmailVerified,
        userAssignments,
        tutorProfile,
      ];

  @override
  String toString() => '''UserModel {
    uid : $uid,
    name : $name,
    photoUrl : $photoUrl,
    isTutor : $isTutor,
    isVerifiedAccount : $isVerifiedAccount,
    isVerifiedTutor : $isVerifiedTutor,
    isEmailVerified: $isEmailVerified,
    userAssignments : $userAssignments,
    tutorProfile : $tutorProfile,
  }''';
}

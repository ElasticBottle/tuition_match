import 'package:equatable/equatable.dart';

const String basic = 'basic';
const String student = 'student';
const String tutor = 'tutor';
const String verifiedTutor = 'Verified Tutor';
const String studentTutor = 'Student Tutor';
const String studentVerifiedTutor = 'Student Verified Tutor';

class AccountType extends Equatable {
  const AccountType(String type) : _accountType = type;

  final String _accountType;
  String get accountType => _accountType;

  @override
  List<Object> get props => [_accountType];

  @override
  String toString() => _accountType;

  static const AccountType BASIC = AccountType(basic);
  static const AccountType STUDENT = AccountType(student);
  static const AccountType TUTOR = AccountType(tutor);
  static const AccountType VERIFIED_TUTOR = AccountType(verifiedTutor);
  static const AccountType STUDENT_TUTOR = AccountType(studentTutor);
  static const AccountType STUDENT_VERIFIED_TUTOR =
      AccountType(studentVerifiedTutor);

  bool isTutor() {
    return accountType == tutor ||
        accountType == verifiedTutor ||
        accountType == studentTutor ||
        accountType == studentVerifiedTutor;
  }
}

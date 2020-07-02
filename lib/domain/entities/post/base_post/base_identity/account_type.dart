import 'package:equatable/equatable.dart';

const String basic = '.b';
const String student = '.s';
const String tutor = '.t';
const String verifiedTutor = '.vt';
const String verifiedAccount = '.va';

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
  static const AccountType STUDENT_TUTOR = AccountType(student + tutor);
  static const AccountType STUDENT_VERIFIED_TUTOR =
      AccountType(student + verifiedTutor);
  static const AccountType VERIFIED_ACCOUNT = AccountType(verifiedAccount);

  bool isStudent() {
    final List<String> toCheck = accountType.split('.');
    for (String type in toCheck) {
      if (type == student[1]) {
        return true;
      }
    }
    return false;
  }

  bool isTutor() {
    final List<String> toCheck = accountType.split('.');
    for (String type in toCheck) {
      if (type == tutor[1] || type == verifiedTutor.substring(1)) {
        return true;
      }
    }
    return false;
  }

  bool isVerTutor() {
    final List<String> toCheck = accountType.split('.');
    for (String type in toCheck) {
      if (type == verifiedTutor.substring(1)) {
        return true;
      }
    }
    return false;
  }

  bool isVerAcc() {
    final List<String> toCheck = accountType.split('.');
    for (String type in toCheck) {
      if (type == verifiedAccount.substring(1)) {
        return true;
      }
    }
    return false;
  }

  AccountType makeTutor() {
    if (accountType == basic) {
      return TUTOR;
    } else {
      return AccountType(accountType + tutor);
    }
  }

  AccountType makeStudent() {
    if (accountType == basic) {
      return STUDENT;
    } else if (isStudent()) {
      return AccountType(accountType);
    } else {
      return AccountType(accountType + student);
    }
  }
}

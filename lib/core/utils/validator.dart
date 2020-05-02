abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  RegexValidator({this.regexSource});
  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final RegExp regex = RegExp(regexSource);
      final Iterable<Match> matches = regex.allMatches(value);
      for (Match match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }
      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class EmailRegistrationRegexValidator extends RegexValidator {
// Valid Email has the symbols @ and
// It also has text before, in between, and after those two symbols.
// e.g. Hello@test.com, 1@2.3
  EmailRegistrationRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

class PhoneNumValidator extends RegexValidator {
  PhoneNumValidator() : super(regexSource: r'^[8|9][0-9]{7}$');
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    if (value == null) {
      return false;
    }
    return value.isNotEmpty;
  }
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}

class IsDoubleValidator extends StringValidator {
  @override
  bool isValid(String value) {
    try {
      double.parse(value);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class EmailAndPasswordValidators {
  final StringValidator emailRegistrationValidator =
      EmailRegistrationRegexValidator();
  final StringValidator passwordRegistrationValidator =
      MinLengthStringValidator(8);
  final StringValidator nonEmptyStringValidator = NonEmptyStringValidator();
  final IsDoubleValidator isDoubleValidator = IsDoubleValidator();
  final PhoneNumValidator phoneNumValidator = PhoneNumValidator();
}

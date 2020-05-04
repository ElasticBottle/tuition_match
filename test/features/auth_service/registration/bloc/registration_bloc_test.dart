import 'package:bloc_test/bloc_test.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/create_user_document.dart';
import 'package:cotor/features/auth_service/registration/bloc/registration_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockCreateAccountWithEmail extends Mock
    implements CreateAccountWithEmail {}

class MockCreateUserDocument extends Mock implements CreateUserDocument {}

class MockEmailAndPasswordValidators extends Mock
    implements EmailAndPasswordValidators {}

class MockNonEmptyStringValidator extends Mock
    implements NonEmptyStringValidator {}

class MockEmailRegistrationRegexValidator extends Mock
    implements EmailRegistrationRegexValidator {}

class MockMinLengthStringValidator extends Mock
    implements MinLengthStringValidator {}

class MockPhoneNumValidator extends Mock implements PhoneNumValidator {}

void main() {
  group('Registration Bloc', () {
    RegistrationBloc registrationBloc;
    CreateAccountWithEmail createAccountWithEmail;
    CreateUserDocument createUserDocument;
    EmailAndPasswordValidators validators;
    NonEmptyStringValidator nonEmptyStringValidator;
    EmailRegistrationRegexValidator emailRegistrationRegexValidator;
    MinLengthStringValidator minLengthStringValidator;
    PhoneNumValidator phoneNumValidator;

    setUp(() {
      createAccountWithEmail = MockCreateAccountWithEmail();
      createUserDocument = MockCreateUserDocument();
      validators = MockEmailAndPasswordValidators();
      nonEmptyStringValidator = MockNonEmptyStringValidator();
      emailRegistrationRegexValidator = MockEmailRegistrationRegexValidator();
      minLengthStringValidator = MockMinLengthStringValidator();
      phoneNumValidator = MockPhoneNumValidator();
      registrationBloc = RegistrationBloc(
        createUserDocument: createUserDocument,
        createAccountWithEmail: createAccountWithEmail,
        validator: validators,
      );
    });

    tearDown(() {
      registrationBloc?.close();
    });

    group('Throws null if any params isn\'t present', () {
      test('Throws AssertionError is createAccoutnWithEmail is null', () {
        expect(
          () => RegistrationBloc(
            createAccountWithEmail: null,
            createUserDocument: createUserDocument,
            validator: validators,
          ),
          throwsA(isAssertionError),
        );
      });
      test('Throws AssertionError if createUserDocument is null', () {
        expect(
          () => RegistrationBloc(
            createAccountWithEmail: createAccountWithEmail,
            createUserDocument: null,
            validator: validators,
          ),
          throwsA(isAssertionError),
        );
      });
      test('Throws AssertionError if validator is null', () {
        expect(
          () => RegistrationBloc(
            createAccountWithEmail: createAccountWithEmail,
            createUserDocument: createUserDocument,
            validator: null,
          ),
          throwsA(isAssertionError),
        );
      });
    });

    test('initial state is correct', () {
      expect(registrationBloc.initialState, RegistrationStateImpl.empty());
    });

    test('close does not emit new state', () {
      expectLater(
        registrationBloc,
        emitsInOrder(<dynamic>[RegistrationStateImpl.empty(), emitsDone]),
      );
      registrationBloc.close();
    });

    group('Email Changed', () {
      void _getEmailValidator() {
        when(validators.emailRegistrationValidator)
            .thenReturn(emailRegistrationRegexValidator);
      }

      void _verifyInteractions() {
        verify(validators.emailRegistrationValidator).called(1);
        verify(emailRegistrationRegexValidator.isValid(any)).called(1);
        verifyNoMoreInteractions(validators);
        verifyNoMoreInteractions(emailRegistrationRegexValidator);
      }

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl(isEmailError:true)] when email is invalid',
        build: () async {
          _getEmailValidator();
          when(emailRegistrationRegexValidator.isValid(any))
              .thenAnswer((realInvocation) => false);
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(EmailChanged(email: 'invalid@email'));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME + 300),
        expect: <RegistrationState>[
          RegistrationStateImpl.empty().copyWith(
            isEmailError: true,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl(isEmailError:false)] when email is valid',
        build: () async {
          _getEmailValidator();
          when(emailRegistrationRegexValidator.isValid(any))
              .thenAnswer((realInvocation) => true);
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(EmailChanged(email: 'valid@email.com'));
        },
        skip: 0,
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.empty().copyWith(
            isEmailError: false,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });

    group('Password Changed', () {
      void _getPasswordSignInValidator() {
        when(validators.passwordRegistrationValidator)
            .thenReturn(minLengthStringValidator);
      }

      void _verifyInteractions() {
        verify(validators.passwordRegistrationValidator).called(1);
        verify(minLengthStringValidator.isValid(any)).called(1);
        verifyNoMoreInteractions(validators);
        verifyNoMoreInteractions(minLengthStringValidator);
      }

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl(isPasswordError:true)] when password is below the minimum required length',
        build: () async {
          _getPasswordSignInValidator();
          when(minLengthStringValidator.isValid(any)).thenAnswer((_) => false);
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(PasswordChanged(password: 'too_short'));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME + 300),
        expect: <RegistrationState>[
          RegistrationStateImpl.empty().copyWith(
            isPasswordError: true,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl(isPasswordError:false)] when password is above the minimum required length',
        build: () async {
          _getPasswordSignInValidator();
          when(minLengthStringValidator.isValid(any))
              .thenAnswer((realInvocation) => true);
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(PasswordChanged(password: 'string_is_long_enough'));
        },
        skip: 0,
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.empty().copyWith(
            isPasswordError: false,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });

    group('Name changed', () {
      void _verifyInteractions() {
        verify(validators.nonEmptyStringValidator).called(1);
        verify(nonEmptyStringValidator.isValid(any)).called(1);
        verifyNoMoreInteractions(validators);
        verifyNoMoreInteractions(nonEmptyStringValidator);
      }

      void _getNonEmptyStringValidator() {
        when(validators.nonEmptyStringValidator)
            .thenReturn(nonEmptyStringValidator);
      }

      void _nonEmptyValidtorReturnTrue() {
        when(nonEmptyStringValidator.isValid(any)).thenAnswer((_) => true);
      }

      void _nonEmptyValidtorReturnFalse() {
        when(nonEmptyStringValidator.isValid(any)).thenAnswer((_) => false);
      }

      group('first name Changed', () {
        blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
          'should return [RegistrationStateImpl(isFirstNameError:false)] when firstName is not empty',
          build: () async {
            _getNonEmptyStringValidator();
            _nonEmptyValidtorReturnTrue();
            return registrationBloc;
          },
          act: (bloc) async {
            bloc.add(FirstNameChanged(firstName: 'Your_name'));
          },
          skip: 0,
          wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
          expect: <RegistrationState>[
            RegistrationStateImpl.empty().copyWith(
              isFirstNameError: false,
            )
          ],
          verify: (bloc) async {
            _verifyInteractions();
          },
        );

        blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
          'should return [RegistrationStateImpl(isFirstNameError:true)] when firstName is empty',
          build: () async {
            _getNonEmptyStringValidator();
            _nonEmptyValidtorReturnFalse();
            return registrationBloc;
          },
          act: (bloc) async {
            bloc.add(FirstNameChanged(firstName: ''));
          },
          wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
          expect: <RegistrationState>[
            RegistrationStateImpl.empty().copyWith(
              isFirstNameError: true,
            )
          ],
          verify: (bloc) async {
            _verifyInteractions();
          },
        );
      });

      group('Last name Changed', () {
        blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
          'should return [RegistrationStateImpl(isLastNameError:false)] when lastName is not empty',
          build: () async {
            _getNonEmptyStringValidator();
            _nonEmptyValidtorReturnTrue();
            return registrationBloc;
          },
          act: (bloc) async {
            bloc.add(LastNameChanged(lastName: 'Your_name'));
          },
          skip: 0,
          wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
          expect: <RegistrationState>[
            RegistrationStateImpl.empty().copyWith(
              isLastNameError: false,
            )
          ],
          verify: (bloc) async {
            _verifyInteractions();
          },
        );

        blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
          'should return [RegistrationStateImpl(isLastNameError:true)] when lastName is empty',
          build: () async {
            _getNonEmptyStringValidator();
            _nonEmptyValidtorReturnFalse();
            return registrationBloc;
          },
          act: (bloc) async {
            bloc.add(LastNameChanged(lastName: ''));
          },
          wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
          expect: <RegistrationState>[
            RegistrationStateImpl.empty().copyWith(
              isLastNameError: true,
            )
          ],
          verify: (bloc) async {
            _verifyInteractions();
          },
        );
      });
    });

    group('PhoneNum Changed', () {
      void _getPhoneNumValidator() {
        when(validators.phoneNumValidator).thenReturn(phoneNumValidator);
      }

      void _verifyInteractions() {
        verify(validators.phoneNumValidator).called(1);
        verify(phoneNumValidator.isValid(any)).called(1);
        verifyNoMoreInteractions(validators);
        verifyNoMoreInteractions(phoneNumValidator);
      }

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl(isPhoneNumError:false)] when Phone num is valid.',
        build: () async {
          _getPhoneNumValidator();
          when(phoneNumValidator.isValid(any))
              .thenAnswer((realInvocation) => true);
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(PhoneNumChanged(phoneNum: '87654321'));
        },
        skip: 0,
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.empty().copyWith(
            isPhoneNumError: false,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl(isPhoneNumError:true)] when phoneNum is not valid',
        build: () async {
          _getPhoneNumValidator();
          when(phoneNumValidator.isValid(any))
              .thenAnswer((realInvocation) => false);
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(PhoneNumChanged(phoneNum: 'invalid'));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.empty().copyWith(
            isPhoneNumError: true,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });

    group('Submitted (register With Email and Password)', () {
      void _verifyInteractions() {
        verify(createAccountWithEmail(
                argThat(isA<CreateAccountWithEmailParams>())))
            .called(1);
        verifyNoMoreInteractions(createAccountWithEmail);
      }

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.success()] when successfully registerd with Email and Password',
        build: () async {
          when(createAccountWithEmail(any))
              .thenAnswer((realInvocation) async => Right(true));
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(Submitted(
            email: 'test',
            password: 'password',
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.success(),
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.failure(failureMessage: [AuthErrorMsg])] when error registering user',
        build: () async {
          when(createAccountWithEmail(any)).thenAnswer(
            (realInvocation) async =>
                Left(AuthenticationFailure(message: 'Email in use')),
          );
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(Submitted(
            email: 'test',
            password: 'password',
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.failure('Email in use')
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.failure(failureMessage: [Strings.serverFailureErrorMsg])] when error creating user profile',
        build: () async {
          when(createAccountWithEmail(any)).thenAnswer(
            (realInvocation) async => Left(ServerFailure()),
          );
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(Submitted(
            email: 'test',
            password: 'password',
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.failure(Strings.serverFailureErrorMsg)
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.failure(failureMessage: Stirngs.networkFailureErrorMsg)] when no internet connection',
        build: () async {
          when(createAccountWithEmail(any)).thenAnswer(
            (realInvocation) async => Left(NetworkFailure()),
          );
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(Submitted(
            email: 'test',
            password: 'password',
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.failure(Strings.networkFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });

    group('External Sign Up Submission', () {
      void _verifyInteractions() {
        verify(createUserDocument(argThat(isA<CreateUserDocumentParams>())))
            .called(1);
        verifyNoMoreInteractions(createUserDocument);
      }

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.success()] when successfully created user documents',
        build: () async {
          when(createUserDocument(any))
              .thenAnswer((realInvocation) async => Right(true));
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(ExternalSignUpSubmission(
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.success(),
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.failure(failureMessage: [AuthErrorMsg])] when error registering user',
        build: () async {
          when(createUserDocument(any)).thenAnswer(
            (realInvocation) async => Left(NoUserFailure()),
          );
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(ExternalSignUpSubmission(
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.failure(Strings.noUserFailureErrorMsg)
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.failure(failureMessage: [Strings.serverFailureErrorMsg])] when error creating user profile',
        build: () async {
          when(createUserDocument(any)).thenAnswer(
            (realInvocation) async => Left(ServerFailure()),
          );
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(ExternalSignUpSubmission(
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.failure(Strings.serverFailureErrorMsg)
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<RegistrationBloc, RegistrationEvent, RegistrationState>(
        'should return [RegistrationStateImpl.submitting(), RegistrationStateImpl.failure(failureMessage: Stirngs.networkFailureErrorMsg)] when no internet connection',
        build: () async {
          when(createUserDocument(any)).thenAnswer(
            (realInvocation) async => Left(NetworkFailure()),
          );
          return registrationBloc;
        },
        act: (bloc) async {
          bloc.add(ExternalSignUpSubmission(
            firstName: 'john',
            lastName: 'mary',
            phoneNum: '98765432',
          ));
        },
        wait: Duration(milliseconds: REGISTRATION_BLOC_DEBOUNCE_TIME),
        expect: <RegistrationState>[
          RegistrationStateImpl.submitting(),
          RegistrationStateImpl.failure(Strings.networkFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });
  });
}

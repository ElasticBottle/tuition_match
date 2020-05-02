import 'package:bloc_test/bloc_test.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/domain/usecases/auth_service/create_account_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/forget_password.dart';
import 'package:cotor/features/auth_service/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockForgotPassword extends Mock implements ForgotPassword {}

class MockEmailRegistrationRegexValidator extends Mock
    implements EmailRegistrationRegexValidator {}

class MockEmailAndPasswordValidators extends Mock
    implements EmailAndPasswordValidators {}

void main() {
  group('Forgot Password Bloc', () {
    ForgotPasswordBloc forgotPasswordBloc;
    ForgotPassword forgotPassword;
    EmailAndPasswordValidators validators;
    EmailRegistrationRegexValidator emailRegistrationRegexValidator;

    setUp(() {
      forgotPassword = MockForgotPassword();
      validators = MockEmailAndPasswordValidators();
      emailRegistrationRegexValidator = MockEmailRegistrationRegexValidator();
      forgotPasswordBloc = ForgotPasswordBloc(
        forgotPassword: forgotPassword,
        validator: validators,
      );
    });

    tearDown(() {
      forgotPasswordBloc?.close();
    });

    group('Throws null if any params isn\'t present', () {
      test('Throws AssertionError is createAccoutnWithEmail is null', () {
        expect(
          () => ForgotPasswordBloc(
            forgotPassword: null,
            validator: validators,
          ),
          throwsA(isAssertionError),
        );
      });
      test('Throws AssertionError if validator is null', () {
        expect(
          () => ForgotPasswordBloc(
            forgotPassword: forgotPassword,
            validator: null,
          ),
          throwsA(isAssertionError),
        );
      });
    });

    test('initial state is correct', () {
      expect(forgotPasswordBloc.initialState, ForgotPasswordStateImpl.empty());
    });

    test('close does not emit new state', () {
      expectLater(
        forgotPasswordBloc,
        emitsInOrder(<dynamic>[ForgotPasswordStateImpl.empty(), emitsDone]),
      );
      forgotPasswordBloc.close();
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

      blocTest<ForgotPasswordBloc, ForgotPasswordEvent, ForgotPasswordState>(
        'should return [ForgotPasswordStateImpl(isEmailError:false)] when email is valid',
        build: () async {
          _getEmailValidator();
          when(emailRegistrationRegexValidator.isValid(any))
              .thenAnswer((realInvocation) => true);
          return forgotPasswordBloc;
        },
        act: (bloc) async {
          bloc.add(EmailChanged(email: 'test@test.com'));
        },
        skip: 0,
        wait: Duration(milliseconds: FORGOT_PASSWORD_BLOC_DEBOUNCE_TIME),
        expect: <ForgotPasswordState>[
          ForgotPasswordStateImpl.empty().copyWith(
            isEmailError: false,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordEvent, ForgotPasswordState>(
        'should return [ForgotPasswordStateImpl(isEmailError:true)] when email is invalid (refer to previous test for valid email definition',
        build: () async {
          _getEmailValidator();
          when(emailRegistrationRegexValidator.isValid(any))
              .thenAnswer((realInvocation) => false);
          return forgotPasswordBloc;
        },
        act: (bloc) async {
          bloc.add(EmailChanged(email: 'hello@1234.'));
        },
        wait: Duration(milliseconds: FORGOT_PASSWORD_BLOC_DEBOUNCE_TIME * 2),
        expect: <ForgotPasswordState>[
          ForgotPasswordStateImpl.empty().copyWith(
            isEmailError: true,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });

    group('Submitted (register With Email and Password)', () {
      void _verifyInteractions() {
        verify(forgotPassword(argThat(isA<ForgotPasswordParams>()))).called(1);
        verifyNoMoreInteractions(forgotPassword);
      }

      blocTest<ForgotPasswordBloc, ForgotPasswordEvent, ForgotPasswordState>(
        'should return [ForgotPasswordStateImpl.submitting(), ForgotPasswordStateImpl.success()] when successfully registerd with Email and Password',
        build: () async {
          when(forgotPassword(any))
              .thenAnswer((realInvocation) async => Right(true));
          return forgotPasswordBloc;
        },
        act: (bloc) async {
          bloc.add(Submitted(
            email: 'test',
          ));
        },
        wait: Duration(milliseconds: FORGOT_PASSWORD_BLOC_DEBOUNCE_TIME),
        expect: <ForgotPasswordState>[
          ForgotPasswordStateImpl.submitting(),
          ForgotPasswordStateImpl.success(),
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordEvent, ForgotPasswordState>(
        'should return [ForgotPasswordStateImpl.submitting(), ForgotPasswordStateImpl.failure(failureMessage: [AuthErrorMsg])] when error registering user',
        build: () async {
          when(forgotPassword(any)).thenAnswer(
            (realInvocation) async =>
                Left(AuthenticationFailure(message: 'Email not found')),
          );
          return forgotPasswordBloc;
        },
        act: (bloc) async {
          bloc.add(Submitted(
            email: 'test',
          ));
        },
        wait: Duration(milliseconds: FORGOT_PASSWORD_BLOC_DEBOUNCE_TIME),
        expect: <ForgotPasswordState>[
          ForgotPasswordStateImpl.submitting(),
          ForgotPasswordStateImpl.failure('Email not found')
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<ForgotPasswordBloc, ForgotPasswordEvent, ForgotPasswordState>(
        'should return [ForgotPasswordStateImpl.submitting(), ForgotPasswordStateImpl.failure(failureMessage: Stirngs.networkFailureErrorMsg)] when no internet connection',
        build: () async {
          when(forgotPassword(any)).thenAnswer(
            (realInvocation) async => Left(NetworkFailure()),
          );
          return forgotPasswordBloc;
        },
        act: (bloc) async {
          bloc.add(Submitted(
            email: 'test',
          ));
        },
        wait: Duration(milliseconds: FORGOT_PASSWORD_BLOC_DEBOUNCE_TIME),
        expect: <ForgotPasswordState>[
          ForgotPasswordStateImpl.submitting(),
          ForgotPasswordStateImpl.failure(Strings.networkFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });
  });
}

import 'package:bloc_test/bloc_test.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/core/utils/validator.dart';
import 'package:cotor/data/models/user_entity.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_email.dart';
import 'package:cotor/domain/usecases/auth_service/sign_in_with_goolge.dart';
import 'package:cotor/features/auth_service/login/bloc/login_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSignInWithEmail extends Mock implements SignInWithEmail {}

class MockSignInWithGoogle extends Mock implements SignInWithGoogle {}

class MockEmailAndPasswordValidators extends Mock
    implements EmailAndPasswordValidators {}

class MockNonEmptyStringValidator extends Mock
    implements NonEmptyStringValidator {}

void main() {
  group('Login Bloc', () {
    LoginBloc loginBloc;
    SignInWithEmail signInWithEmail;
    MockSignInWithGoogle signInWithGoogle;
    EmailAndPasswordValidators validators;
    NonEmptyStringValidator nonEmptyStringValidator;

    setUp(() {
      signInWithEmail = MockSignInWithEmail();
      signInWithGoogle = MockSignInWithGoogle();
      validators = MockEmailAndPasswordValidators();
      nonEmptyStringValidator = MockNonEmptyStringValidator();
      loginBloc = LoginBloc(
        signInWithEmail: signInWithEmail,
        signInWithGoogle: signInWithGoogle,
        validator: validators,
      );
    });

    tearDown(() {
      loginBloc?.close();
    });

    group('Throws null if any params isn\'t present', () {
      test('Throws AssertionError is signInWithEmail is null', () {
        expect(
          () => LoginBloc(
            signInWithEmail: null,
            signInWithGoogle: signInWithGoogle,
            validator: validators,
          ),
          throwsA(isAssertionError),
        );
      });
      test('Throws AssertionError if signInWithGoogle is null', () {
        expect(
          () => LoginBloc(
            signInWithEmail: null,
            signInWithGoogle: signInWithGoogle,
            validator: validators,
          ),
          throwsA(isAssertionError),
        );
      });
      test('Throws AssertionError if validator is null', () {
        expect(
          () => LoginBloc(
            signInWithEmail: null,
            signInWithGoogle: signInWithGoogle,
            validator: validators,
          ),
          throwsA(isAssertionError),
        );
      });
    });

    test('initial state is correct', () {
      expect(loginBloc.initialState, LoginFormState.initial());
    });

    test('close does not emit new state', () {
      expectLater(
        loginBloc,
        emitsInOrder(<dynamic>[LoginFormState.initial(), emitsDone]),
      );
      loginBloc.close();
    });

    group('Email Changed', () {
      void _getNonEmptyStringValidator() {
        when(validators.nonEmptyStringValidator)
            .thenReturn(nonEmptyStringValidator);
      }

      void _verifyInteractions() {
        verify(validators.nonEmptyStringValidator).called(1);
        verify(nonEmptyStringValidator.isValid(any)).called(1);
        verifyNoMoreInteractions(validators);
        verifyNoMoreInteractions(nonEmptyStringValidator);
      }

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState(isEmailError:false)] when email is non empty',
        build: () async {
          _getNonEmptyStringValidator();
          when(nonEmptyStringValidator.isValid(any))
              .thenAnswer((realInvocation) => true);
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(EmailChanged(email: 'non_empty_string'));
        },
        skip: 0,
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.initial().copyWith(
            isEmailError: false,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState(isEmailError:true)] when email is empty',
        build: () async {
          _getNonEmptyStringValidator();
          when(nonEmptyStringValidator.isValid(any))
              .thenAnswer((realInvocation) => false);
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(EmailChanged(email: ''));
        },
        wait: Duration(milliseconds: 400),
        expect: <LoginState>[
          LoginFormState.initial().copyWith(
            isEmailError: true,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });

    group('Password Changed', () {
      void _getPasswordSignInValidator() {
        when(validators.nonEmptyStringValidator)
            .thenReturn(nonEmptyStringValidator);
      }

      void _verifyInteractions() {
        verify(validators.nonEmptyStringValidator).called(1);
        verify(nonEmptyStringValidator.isValid(any)).called(1);
        verifyNoMoreInteractions(validators);
        verifyNoMoreInteractions(nonEmptyStringValidator);
      }

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState(isPasswordError:false)] when password is non empty',
        build: () async {
          _getPasswordSignInValidator();
          when(nonEmptyStringValidator.isValid(any))
              .thenAnswer((realInvocation) => true);
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(PasswordChanged(password: 'non_empty_string'));
        },
        skip: 0,
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.initial().copyWith(
            isPasswordError: false,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState(isPasswordError:true)] when password is empty',
        build: () async {
          _getPasswordSignInValidator();
          when(nonEmptyStringValidator.isValid(any))
              .thenAnswer((realInvocation) => false);
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(PasswordChanged(password: ''));
        },
        wait: Duration(milliseconds: 400),
        expect: <LoginState>[
          LoginFormState.initial().copyWith(
            isPasswordError: true,
          )
        ],
        verify: (bloc) async {
          _verifyInteractions();
        },
      );
    });

    group('Sign In With Google', () {
      void _verifyInteraction() {
        verify(signInWithGoogle(any)).called(1);
        verifyNoMoreInteractions(signInWithGoogle);
      }

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState.submitting(), LoginFormState.success()] when successfully logged in with Google',
        build: () async {
          when(signInWithGoogle(any))
              .thenAnswer((realInvocation) async => Right(UserEntity()));
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(LoginWithGooglePressed());
        },
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.submitting(),
          LoginFormState.success(),
        ],
        verify: (bloc) async {
          _verifyInteraction();
        },
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState.submitting(), LoginFormState.failure(\'Email not valid\')] when password is empty',
        build: () async {
          when(signInWithGoogle(any)).thenAnswer(
            (realInvocation) async =>
                Left(AuthenticationFailure(message: 'Email not valid')),
          );
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(LoginWithGooglePressed());
        },
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.submitting(),
          LoginFormState.failure('Email not valid')
        ],
        verify: (bloc) async {
          _verifyInteraction();
        },
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState.submitting(), LoginFormState.failure(\'Email not valid\')] when password is empty',
        build: () async {
          when(signInWithGoogle(any)).thenAnswer(
            (realInvocation) async => Left(NetworkFailure()),
          );
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(LoginWithGooglePressed());
        },
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.submitting(),
          LoginFormState.failure(Strings.networkFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifyInteraction();
        },
      );
    });

    group('Sign In With Email and Password', () {
      void _verifyInteraction() {
        verify(signInWithEmail(argThat(isA<SignInWithEmailParams>())))
            .called(1);
        verifyNoMoreInteractions(signInWithEmail);
      }

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState.submitting(), LoginFormState.success()] when successfully logged in with Email and Password',
        build: () async {
          when(signInWithEmail(any))
              .thenAnswer((realInvocation) async => Right(UserEntity()));
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(LoginWithCredentialsPressed(
            email: 'test',
            password: 'password',
          ));
        },
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.submitting(),
          LoginFormState.success(),
        ],
        verify: (bloc) async {
          _verifyInteraction();
        },
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState.submitting(), LoginFormState.failure(\'Email not valid\')] when password is empty',
        build: () async {
          when(signInWithEmail(any)).thenAnswer(
            (realInvocation) async =>
                Left(AuthenticationFailure(message: 'Email not valid')),
          );
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(LoginWithCredentialsPressed(
            email: 'test',
            password: 'password',
          ));
        },
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.submitting(),
          LoginFormState.failure('Email not valid')
        ],
        verify: (bloc) async {
          _verifyInteraction();
        },
      );

      blocTest<LoginBloc, LoginEvent, LoginState>(
        'should return [LoginFormState.submitting(), LoginFormState.failure(\'Email not valid\')] when password is empty',
        build: () async {
          when(signInWithEmail(any)).thenAnswer(
            (realInvocation) async => Left(NetworkFailure()),
          );
          return loginBloc;
        },
        act: (bloc) async {
          bloc.add(LoginWithCredentialsPressed(
            email: 'test',
            password: 'password',
          ));
        },
        wait: Duration(milliseconds: 300),
        expect: <LoginState>[
          LoginFormState.submitting(),
          LoginFormState.failure(Strings.networkFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifyInteraction();
        },
      );
    });
  });
}

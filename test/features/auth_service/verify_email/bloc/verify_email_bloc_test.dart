import 'package:bloc_test/bloc_test.dart';
import 'package:cotor/constants/strings.dart';
import 'package:cotor/core/error/failures.dart';
import 'package:cotor/domain/usecases/auth_service/send_email_verification.dart';
import 'package:cotor/domain/usecases/auth_service/sign_out.dart';
import 'package:cotor/domain/usecases/usecase.dart';
import 'package:cotor/features/auth_service/verify_email/bloc/verify_email_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockSendEmailVerification extends Mock implements SendEmailVerification {}

class MockSignOut extends Mock implements SignOut {}

void main() {
  group('Verify Email Bloc', () {
    SendEmailVerification sendEmailVerification;
    SignOut signOut;
    VerifyEmailBloc verifyEmailBloc;
    setUp(() {
      sendEmailVerification = MockSendEmailVerification();
      signOut = MockSignOut();
      verifyEmailBloc = VerifyEmailBloc(
        sendEmailVerification: sendEmailVerification,
        signOut: signOut,
      );
    });

    tearDown(() {
      verifyEmailBloc?.close();
    });

    group('Throws null if any params isn\'t present', () {
      test('Throws AssertionError is sendEmailVerification is null', () {
        expect(
          () => VerifyEmailBloc(
            sendEmailVerification: null,
            signOut: signOut,
          ),
          throwsA(isAssertionError),
        );
      });
      test('Throws AssertionError if signOut is null', () {
        expect(
          () => VerifyEmailBloc(
            sendEmailVerification: sendEmailVerification,
            signOut: null,
          ),
          throwsA(isAssertionError),
        );
      });
    });

    test('initial state is correct', () {
      expect(verifyEmailBloc.initialState, VerifyEmailState.initial());
    });

    test('close does not emit new state', () {
      expectLater(
        verifyEmailBloc,
        emitsInOrder(<dynamic>[VerifyEmailState.initial(), emitsDone]),
      );
      verifyEmailBloc.close();
    });

    group('LogOut', () {
      void _verifySignOutInteractions() {
        verify(signOut(argThat(isA<NoParams>()))).called(1);
        verifyNoMoreInteractions(signOut);
      }

      blocTest<VerifyEmailBloc, VerifyEmailEvent, VerifyEmailState>(
        'should return [VerifyEmailState.signingOut(), VerifyEmailState.initial()] when LogOut event is successfully executed',
        build: () async {
          when(signOut(any)).thenAnswer(
            (_) async => Right<Failure, void>(null),
          );
          return verifyEmailBloc;
        },
        act: (bloc) async {
          bloc.add(LogOut());
        },
        expect: <VerifyEmailState>[
          VerifyEmailState.signingOut(),
          VerifyEmailState.initial(),
        ],
        verify: (bloc) async {
          _verifySignOutInteractions();
        },
      );
      blocTest<VerifyEmailBloc, VerifyEmailEvent, VerifyEmailState>(
        'should return [VerifyEmailState.signingOut(), VerifyEmailState.error(Strings.networkFailureErrorMsg)] when LogOut event is unsuccessfully executed',
        build: () async {
          when(signOut(any)).thenAnswer(
            (_) async => Left<Failure, void>(NetworkFailure()),
          );
          return verifyEmailBloc;
        },
        act: (bloc) async {
          bloc.add(LogOut());
        },
        expect: <VerifyEmailState>[
          VerifyEmailState.signingOut(),
          VerifyEmailState.error(Strings.networkFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifySignOutInteractions();
        },
      );
    });
    group('Send Verification Email', () {
      void _verifySignOutInteractions() {
        verify(sendEmailVerification(argThat(isA<NoParams>()))).called(1);
        verifyNoMoreInteractions(sendEmailVerification);
      }

      blocTest<VerifyEmailBloc, VerifyEmailEvent, VerifyEmailState>(
        'should return [VerifyEmailState.sendingVerificationEmail(), VerifyEmailState.sentVerificationEmail()] when sendVerificationEmail event is successfully executed',
        build: () async {
          when(sendEmailVerification(any)).thenAnswer(
            (_) async => Right<Failure, bool>(true),
          );
          return verifyEmailBloc;
        },
        act: (bloc) async {
          bloc.add(SendVerificationEmail());
        },
        expect: <VerifyEmailState>[
          VerifyEmailState.sendingVerificationEmail(),
          VerifyEmailState.sentVerificationEmail(),
        ],
        verify: (bloc) async {
          _verifySignOutInteractions();
        },
      );
      blocTest<VerifyEmailBloc, VerifyEmailEvent, VerifyEmailState>(
        'should return [VerifyEmailState.sendingVerificationEmail(), VerifyEmailState.error(Strings.networkFailureErrorMsg)] when sendVerificationEmail event attempted without internet connection',
        build: () async {
          when(sendEmailVerification(any)).thenAnswer(
            (_) async => Left<Failure, bool>(NetworkFailure()),
          );
          return verifyEmailBloc;
        },
        act: (bloc) async {
          bloc.add(SendVerificationEmail());
        },
        expect: <VerifyEmailState>[
          VerifyEmailState.sendingVerificationEmail(),
          VerifyEmailState.error(Strings.networkFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifySignOutInteractions();
        },
      );
      blocTest<VerifyEmailBloc, VerifyEmailEvent, VerifyEmailState>(
        'should return [VerifyEmailState.sendingVerificationEmail(), VerifyEmailState.error(Strings.sendEmailFailureErrorMsg)] when sendVerificationEmail is unsuccessfully executed',
        build: () async {
          when(sendEmailVerification(any)).thenAnswer(
            (_) async => Left<Failure, bool>(SendEmailFailure()),
          );
          return verifyEmailBloc;
        },
        act: (bloc) async {
          bloc.add(SendVerificationEmail());
        },
        expect: <VerifyEmailState>[
          VerifyEmailState.sendingVerificationEmail(),
          VerifyEmailState.error(Strings.sendEmailFailureErrorMsg),
        ],
        verify: (bloc) async {
          _verifySignOutInteractions();
        },
      );
    });
  });
}

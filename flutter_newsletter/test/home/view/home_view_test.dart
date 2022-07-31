import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lyform/flutter_lyform.dart';
import 'package:flutter_newsletter/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newsletter_form/newsletter_form.dart';

import '../../helpers/helpers.dart';

class MockEmailInputBloc extends MockCubit<LyInputState<String>>
    implements LyInput<String> {}

class MockNewsletterForm
    extends MockBloc<LyFormEvent, LyFormState<String, String>>
    implements NewsletterForm {
  @override
  final email = MockEmailInputBloc();
}

void main() {
  group('HomeView', () {
    testWidgets(
      'renders a Text with "Hey, I\'m a Mobile Developer."',
      (tester) async {
        final newsletterForm = MockNewsletterForm();
        when(() => newsletterForm.state).thenReturn(const LyFormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(value: '', pureValue: '', lastNotNullValue: ''),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        expect(find.text("Hey, I'm a Mobile Developer."), findsOneWidget);
      },
    );
    testWidgets(
      'renders NewsletterField widget',
      (tester) async {
        final newsletterForm = MockNewsletterForm();
        when(() => newsletterForm.state).thenReturn(const LyFormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(value: '', pureValue: '', lastNotNullValue: ''),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        expect(find.byType(NewsletterField), findsOneWidget);
      },
    );
  });

  group('NewsletterField', () {
    testWidgets(
      'renders a Text with "Subscribe to my newsletter"',
      (tester) async {
        final newsletterForm = MockNewsletterForm();
        when(() => newsletterForm.state).thenReturn(const LyFormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(value: '', pureValue: '', lastNotNullValue: ''),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        expect(find.text('Subscribe to my newsletter'), findsOneWidget);
      },
    );

    testWidgets(
      'renders a grey Button when the TextField is pure',
      (tester) async {
        const inactiveSubcribeButton = Key('key_or_else_subscribe_button');
        final newsletterForm = MockNewsletterForm();
        when(() => newsletterForm.state).thenReturn(const LyFormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(value: '', pureValue: '', lastNotNullValue: ''),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        await tester.tap(find.byKey(inactiveSubcribeButton));

        expect(find.byKey(inactiveSubcribeButton), findsOneWidget);
      },
    );

    testWidgets(
      'renders a grey Button when the email is invalid and show error message',
      (tester) async {
        const inactiveSubcribeButton = Key('key_or_else_subscribe_button');
        final newsletterForm = MockNewsletterForm();
        when(() => newsletterForm.state).thenReturn(const LyFormInvalidState());
        when(() => newsletterForm.email.isInvalid).thenReturn(true);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(
            value: 'laura@gmail',
            pureValue: '',
            lastNotNullValue: '',
            error: 'Email is not valid.',
          ),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        await tester.tap(find.byKey(inactiveSubcribeButton));

        expect(find.text('Email is not valid.'), findsOneWidget);
        expect(find.byKey(inactiveSubcribeButton), findsOneWidget);
      },
    );

    testWidgets(
      'renders a `CircularProgressIndicator` when when the '
      'state is FormLoadingState ',
      (tester) async {
        final newsletterForm = MockNewsletterForm();
        when(() => newsletterForm.state).thenReturn(const LyFormLoadingState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(
            value: 'laura@gmail.com',
            lastNotNullValue: '',
            pureValue: '',
          ),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets(
      'submit email when TextButton is pressed and the email is valid',
      (tester) async {
        const mockEmail = 'laura@gmail.com';
        const subcribeButtonKey = Key('key_on_valid_subscribe_button');
        const newsletterTextFieldKey =
            Key('key_newsletterForm_nameInput_textField');
        final newsletterForm = MockNewsletterForm();
        when(() => newsletterForm.state).thenReturn(const LyFormValidState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(
            value: mockEmail,
            lastNotNullValue: '',
            pureValue: '',
          ),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        await tester.enterText(find.byKey(newsletterTextFieldKey), mockEmail);
        await tester.ensureVisible(find.byKey(subcribeButtonKey));
        await tester.tap(find.byKey(subcribeButtonKey));

        verify(newsletterForm.submit).called(1);
      },
    );

    testWidgets(
      'render a SnackBar when is sumited suscefully and clean the TextField',
      (tester) async {
        const mockEmail = 'laura@gmail.com';
        final newsletterForm = MockNewsletterForm();

        whenListen<LyFormState>(
          newsletterForm,
          Stream.fromIterable([
            const LyFormPureState<String, String>(),
            const LyFormValidState<String, String>(),
            const LyFormLoadingState<String, String>(),
            const LyFormSuccessState<String, String>(
              'You have successfully subscribed!',
            )
          ]),
          initialState: const LyFormPureState<String, String>(),
        );

        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(
          LyInputState(
            value: mockEmail,
            pureValue: '',
            lastNotNullValue: '',
          ),
        );

        await tester.pumpApp(
          BlocProvider<NewsletterForm>.value(
            value: newsletterForm,
            child: const HomeView(),
          ),
        );

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('You have successfully subscribed!'), findsOneWidget);
      },
    );
  });
}

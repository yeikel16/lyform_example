import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lyform/flutter_lyform.dart';
import 'package:flutter_newsletter/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newsletter_form/newsletter_form.dart';

import '../../helpers/helpers.dart';

class MockEmailInputBloc
    extends MockBloc<InputBlocEvent<String>, InputBlocState<String>>
    implements InputBloc<String> {}

class MockNewsletterForm
    extends MockBloc<FormBlocEvent, FormBlocState<String, String>>
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
        when(() => newsletterForm.state).thenReturn(const FormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(InputBlocState(''));

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
        when(() => newsletterForm.state).thenReturn(const FormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(InputBlocState(''));

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
        when(() => newsletterForm.state).thenReturn(const FormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(InputBlocState(''));

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
        when(() => newsletterForm.state).thenReturn(const FormPureState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state).thenReturn(InputBlocState(''));

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
        when(() => newsletterForm.state).thenReturn(const FormInvalidState());
        when(() => newsletterForm.email.isInvalid).thenReturn(true);
        when(() => newsletterForm.email.state)
            .thenReturn(InputBlocState('laura@gmail', 'Email is not valid.'));

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
        when(() => newsletterForm.state).thenReturn(const FormLoadingState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state)
            .thenReturn(InputBlocState('laura@gmail.com'));

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
        when(() => newsletterForm.state).thenReturn(const FormValidState());
        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state)
            .thenReturn(InputBlocState(mockEmail));

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

        whenListen(
          newsletterForm,
          Stream.fromIterable([
            const FormPureState<String, String>(),
            const FormValidState<String, String>(),
            const FormLoadingState<String, String>(),
            const FormSuccessState<String, String>(
              'You have successfully subscribed!',
            )
          ]),
          initialState: const FormPureState<String, String>(),
        );

        when(() => newsletterForm.email.isInvalid).thenReturn(false);
        when(() => newsletterForm.email.state)
            .thenReturn(InputBlocState(mockEmail));

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

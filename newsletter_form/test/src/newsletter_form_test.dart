import 'package:bloc_test/bloc_test.dart';
import 'package:lyform/lyform.dart';
import 'package:newsletter_form/newsletter_form.dart';
import 'package:test/test.dart';

void main() {
  group('NewsletterForm', () {
    const validEmail = 'laura@gmail.com';
    const inValidEmail = 'laura@gmail';

    blocTest<NewsletterForm, LyFormState>(
      'should emit `LyFormValidState` when the email is valid',
      build: NewsletterForm.new,
      act: (bloc) => bloc.email.dirty(validEmail),
      expect: () => <LyFormState<String, String>>[
        const LyFormValidState(),
      ],
    );

    blocTest<NewsletterForm, LyFormState>(
      'should emit `LyFormInvalidState` when the email is invalid',
      build: NewsletterForm.new,
      act: (bloc) => bloc.email.dirty(inValidEmail),
      expect: () => <LyFormState<String, String>>[
        const LyFormInvalidState(),
      ],
    );

    blocTest<NewsletterForm, LyFormState>(
      'should emit `LyFormSuccessState` when onSubmit is call',
      build: NewsletterForm.new,
      act: (bloc) => bloc
        ..email.dirty(validEmail)
        ..submit(),
      wait: const Duration(seconds: 2),
      expect: () => <LyFormState<String, String>>[
        const LyFormValidState(),
        // const LyFormLoadingState(),
        // const LyFormSuccessState('You have successfully subscribed!'),
        // const LyFormPureState(),
      ],
    );
  });
}

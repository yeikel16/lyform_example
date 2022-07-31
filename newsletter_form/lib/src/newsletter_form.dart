import 'package:lyform/lyform.dart';
import 'package:lyform_validators/lyform_validators.dart';

/// {@template newsletter_form}
/// Form for user subscription to the newsletter via email.
/// {@endtemplate}
class NewsletterForm extends LyForm<String, String> {
  /// {@macro newsletter_form}
  NewsletterForm() : super() {
    addInputs([email]);
  }

  /// Email field for user subscription.
  final email = LyInput<String>(
    pureValue: '',
    validationType: LyValidationType.always,
    validator: LyStringRequired('Email is required.') &
        LyStringIsEmail('Email is not valid.'),
    debugName: 'email',
  );

  @override
  Stream<LyFormState<String, String>> onSubmit() async* {
    await Future<void>.delayed(const Duration(seconds: 1));
    yield const LyFormSuccessState('You have successfully subscribed!');
  }
}

import 'package:lyform/lyform.dart';
import 'package:lyform_validators/lyform_validators.dart';

/// {@template newsletter_form}
/// Form for user subscription to the newsletter via email.
/// {@endtemplate}
class NewsletterForm extends FormBloc<String, String> {
  /// Email field for user subscription.
  final email = InputBloc<String>(
    pureValue: '',
    validationType: ValidationType.always,
    validator: StringRequired('Email is required.') &
        StringIsEmail('Email is not valid.'),
    debugName: 'email',
  );

  @override
  List<InputBloc> get inputs => [email];

  @override
  Stream<FormBlocState<String, String>> onSubmit() async* {
    await Future<void>.delayed(const Duration(seconds: 3));
    yield const FormSuccessState('You have successfully subscribed!');
  }
}

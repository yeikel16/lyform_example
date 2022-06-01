// ignore_for_file: prefer_const_constructors
import 'package:lyform/lyform.dart';
import 'package:newsletter_form/newsletter_form.dart';
import 'package:test/test.dart';

void main() {
  final form = NewsletterForm();

  tearDownAll(form.close);
  group('NewsletterForm', () {
    const validEmail = 'laura@gmail.com';
    const inValidEmail = 'laura@gmail';

    test('should return `FormValidState` when the email is valid', () async {
      form.email.dirty(validEmail);
      await Future<void>.delayed(Duration.zero);
      expect(form.state, isA<FormValidState>());
    });

    test('should return `FormInvalidState` when the email is invalid',
        () async {
      form.email.dirty(inValidEmail);
      await Future<void>.delayed(Duration.zero);
      expect(form.state, isA<FormInvalidState>());
    });

    test('should return `FormSuccessState` when onSubmit is call', () async {
      form.email.dirty(validEmail);
      await Future<void>.delayed(Duration.zero);
      form.submit();
      await Future<void>.delayed(Duration(seconds: 4));
      expect(form.state, isA<FormSuccessState>());
    });
  });
}

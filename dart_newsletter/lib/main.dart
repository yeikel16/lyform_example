import 'package:newsletter_form/newsletter_form.dart';

void main(List<String> args) async {
  final form = NewsletterForm();

  print(form.state); // LyFormPureState()

  form.email.dirty('laura@gmail');
  await Future.delayed(Duration.zero);
  print(form.state); // LyFormInvalidState()

  form.email.dirty('laura@gmail.com');
  await Future.delayed(Duration.zero);
  print(form.state); // LyFormValidState()

  form.submit();
  await Future.delayed(const Duration(seconds: 2));
  print(form.state); // LyFormSuccessState(You have successfully subscribed!)

  form.close(); // Don't forget to close your bloc.
}

# Dart newsletter example

A example Newsletter form using [lyform](https://pub.dev/packages/lyform) package in pure [Dart](https://dart.dev).

```dart
import 'package:newsletter_form/newsletter_form.dart';


void main(List<String> args) async {
  final form = NewsletterForm();

  print(form.state); // FormPureState()

  form.email.dirty('laura@gmail');
  await Future.delayed(Duration.zero);
  print(form.state); // FormInvalidState()

  form.email.dirty('laura@gmail.com');
  await Future.delayed(Duration.zero);
  print(form.state); // FormValidState()

  form.submit();
  await Future.delayed(const Duration(seconds: 4));
  print(form.state); // FormSuccessState(You have successfully subscribed!)

  form.close(); // Don't forget to close your bloc.
}
```

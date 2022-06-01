import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_newsletter/home/home.dart';
import 'package:newsletter_form/newsletter_form.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NewsletterForm(),
      child: const HomeView(),
    );
  }
}

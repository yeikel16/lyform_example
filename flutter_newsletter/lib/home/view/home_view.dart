import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lyform/flutter_lyform.dart';
import 'package:newsletter_form/newsletter_form.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: ListView(
        children: [
          Container(height: 32),
          CircleAvatar(
            radius: (width * 0.06).clamp(60, 250),
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: (width * 0.06).clamp(50, 250),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Text(
              "Hey, I'm a Mobile Developer.",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: (width * 0.06).clamp(45, 120),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NewsletterField(),
    );
  }
}

class NewsletterField extends StatefulWidget {
  const NewsletterField({
    Key? key,
  }) : super(key: key);

  @override
  State<NewsletterField> createState() => _NewsletterFieldState();
}

class _NewsletterFieldState extends State<NewsletterField> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return LyFormListener<NewsletterForm, String, String>(
      bloc: context.read<NewsletterForm>(),
      onSuccess: (value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(value)),
        );
        _emailController.clear();
      },
      child: Container(
        color: Colors.white,
        height: context.watch<NewsletterForm>().email.isInvalid ? 125 : 100,
        child: Column(
          children: [
            Text(
              'Subscribe to my newsletter',
              style: TextStyle(fontSize: (width * .02).clamp(16, 22)),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: LyInputBuilder(
                      lyInput: context.read<NewsletterForm>().email,
                      builder: (context, state) {
                        return TextFormField(
                          key: const Key(
                            'key_newsletterForm_nameInput_textField',
                          ),
                          controller: _emailController,
                          onChanged: context.read<NewsletterForm>().email.dirty,
                          decoration: InputDecoration(
                            hintText: 'Add your email',
                            icon: const Icon(Icons.email),
                            border: const OutlineInputBorder(),
                            errorText: state.error,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LyFormBuilder<NewsletterForm>(
                      bloc: context.read<NewsletterForm>(),
                      onLoading: () => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      onValid: () => MaterialButton(
                        key: const Key('key_on_valid_subscribe_button'),
                        color: Colors.blue,
                        height: 60,
                        onPressed: context.read<NewsletterForm>().submit,
                        child: const Text(
                          'Subscribe',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      orElse: () => MaterialButton(
                        key: const Key('key_or_else_subscribe_button'),
                        height: 60,
                        color: Colors.grey,
                        child: const Text(
                          'Subscribe',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

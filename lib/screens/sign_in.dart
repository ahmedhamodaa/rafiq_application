import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

import 'package:rafiq/screens/sign_up.dart';
import 'package:rafiq/screens/home_screen.dart';
import 'package:rafiq/screens/forget_password.dart';

import 'package:rafiq/widgets/password_field.dart';
import 'package:rafiq/widgets/label_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme theme = Theme.of(context).textTheme;
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('Sign in')),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: AutofillGroup(
                  child: Column(children: [
                TextFormField(
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    autofocus: true,
                    controller: emailController,
                    validator: (value) => EmailValidator.validate(value ?? "")
                        ? null
                        : "Invalid email",
                    decoration: const InputDecoration(
                        labelText: 'Email', prefixIcon: Icon(Icons.email))),
                const SizedBox(height: 16),
                DefaultPassword(
                    controller: passwordController, label: 'Password'),
                Align(
                    alignment: AlignmentDirectional.bottomEnd,
                    child: TextButton(
                      child: Text('Forgot Password?', style: theme.labelMedium),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ForgetPassword()),
                      ),
                    )),
                FilledButton(
                    child: const Text('Sign in'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomeScreen(),
                          ));
                      if (_formKey.currentState!.validate()) {
                        debugPrint('Email: ${emailController.text}');
                        debugPrint('Password: ${passwordController.text}');
                      }
                    }),
                const SizedBox(height: 16),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Don\'t have an account? '),
                  LabelButton(
                      label: 'Sign up',
                      style: const TextStyle(color: Color(0xff088395)),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupForm())))
                ])
              ])),
            )));
  }
}

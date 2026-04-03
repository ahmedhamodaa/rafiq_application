import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq/screens/otp_verification.dart';
import 'package:rafiq/screens/sign_in.dart';
import 'package:rafiq/widgets/phonenumber_field.dart';
import 'package:rafiq/widgets/password_field.dart';
import 'package:rafiq/widgets/label_button.dart';
import 'package:email_validator/email_validator.dart';
import 'package:vector_graphics/vector_graphics.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});
  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool agreeToTerms = false;
  final _formKey = GlobalKey<FormState>();
  PhonenumberController phoneController = PhonenumberController(null);

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text("Sign up")),
        body: Form(
            key: _formKey,
            child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: AutofillGroup(
                    child: Column(spacing: 16, children: [
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      autofocus: true,
                      decoration: const InputDecoration(
                          labelText: 'Name', prefixIcon: Icon(Icons.person))),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      autofillHints: const [AutofillHints.email],
                      validator: (value) => EmailValidator.validate(value ?? "")
                          ? null
                          : "Invalid email",
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          labelText: 'Email', prefixIcon: Icon(Icons.email))),
                  PhonenumberTextField(controller: phoneController),
                  TextFormField(
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.datetime,
                      decoration: InputDecoration(
                          labelText: 'Date of Birth',
                          hintText: 'dd/mm/yyyy',
                          prefixIcon: const Icon(Icons.calendar_today),
                          suffixIcon: ExcludeFocus(
                              child: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2101));
                              if (picked != null) {
                                debugPrint(picked.toLocal().toString()); // TODO
                              }
                            },
                          )))),
                  const DefaultPassword(
                      label: 'Password',
                      autofillHints: [AutofillHints.newPassword],
                      textInputAction: TextInputAction.next),
                  const DefaultPassword(
                      label: 'Confirm Password',
                      autofillHints: [AutofillHints.newPassword]),
                  Row(children: [
                    Checkbox(
                        value: agreeToTerms,
                        onChanged: (value) =>
                            setState(() => agreeToTerms = value!)),
                    const Text('I accept the '),
                    LabelButton(
                        label: 'Terms and Conditions',
                        onPressed: () {},
                        style: TextStyle(
                            color: theme.colorScheme.secondary,
                            decoration: TextDecoration.underline))
                  ]),
                  FilledButton(
                      onPressed: agreeToTerms
                          ? () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OtpVerification(
                                      title: Text("Verify Account"),
                                      image: SvgPicture(AssetBytesLoader(
                                          "images/logins/otp_security.svg.vec")))))
                          : null,
                      child: const Text('Sign up')),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Already have an account? '),
                    LabelButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginForm())),
                        label: 'Sign in',
                        style: TextStyle(color: theme.colorScheme.secondary)),
                  ])
                ])))));
  }
}

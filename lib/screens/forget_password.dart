import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rafiq/screens/otp_verification.dart';
import 'package:vector_graphics/vector_graphics.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Center(
            child: SvgPicture(
              AssetBytesLoader("images/logins/forgotpassword.svg.vec"),
              fit: BoxFit.cover,
            ),
          ),
          Text('Enter your email address', style: theme.textTheme.titleMedium),
          const Text('We’ll send the code to your email'),
          const SizedBox(height: 16),
          TextFormField(
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: (value) =>
                  EmailValidator.validate(value ?? "") ? null : "Invalid email",
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  labelText: 'Email', prefixIcon: Icon(Icons.email))),
          const SizedBox(height: 16),
          FilledButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const OtpVerification(
                          title: Text('Verify'),
                          image: SvgPicture(AssetBytesLoader(
                              "images/logins/palm_recognition.svg.vec"))),
                    ));
              },
              child: const Text('Send Code'))
        ]),
      ),
    );
  }
}

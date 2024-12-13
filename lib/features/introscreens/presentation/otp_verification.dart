import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rafiq_application/features/introscreens/presentation/academic_category.dart';
import 'package:rafiq_application/features/introscreens/presentation/reset_password.dart';
import 'package:rafiq_application/widgets/OTPfields.dart';
import 'package:rafiq_application/widgets/button.dart';
import 'package:rafiq_application/widgets/resend_code_widget.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key, required this.title});
  final String title;

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title == "Verify OTP" ? 'Verify OTP ' : 'Verify Password',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.title == 'Verify OTP'
                  ? Center(
                      child: SvgPicture.asset(
                        "images/logins/otp_security.svg",
                        height: 343,
                        width: 343,
                      ),
                    )
                  : Center(
                      child: SvgPicture.asset(
                        "images/logins/palm_recognition.svg",
                        height: 343,
                        width: 343,
                      ),
                    ),
              const SizedBox(
                height: 34,
              ),
              const Text(
                'Check Your email',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
              const Text(
                'We’ve send code to your email',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xff999999)),
              ),
              const SizedBox(
                height: 24,
              ),
              OTPInput(),
              const SizedBox(
                height: 24,
              ),
              widget.title == 'Verify OTP'
                  ? Button(onClick: () {}, text: 'Verify OTP')
                  : Button(
                      onClick: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPassword(),
                            ));
                      },
                      text: 'Verify OTP'),
              const SizedBox(
                height: 16,
              ),
              ResendCodeWidget()
            ],
          ),
        ),
      ),
    );
  }
}

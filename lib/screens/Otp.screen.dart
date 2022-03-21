import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/OtpController.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  OtpController otpController = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
                "OTP Code has been sent to your email (${otpController.args[3]})"),
            SizedBox(
              height: 16,
            ),
            Text("Please enter your OTP Code then submit."),
            SizedBox(
              height: 60,
            ),
            OTPTextField(
              length: 5,
              width: MediaQuery.of(context).size.width,
              fieldWidth: 80,
              style: const TextStyle(fontSize: 17),
              textFieldAlignment: MainAxisAlignment.spaceAround,
              fieldStyle: FieldStyle.box,
              onCompleted: (pin) {
                otpController.changePin(pin);
              },
            ),
            SizedBox(
              height: 60,
            ),
            Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 62, 81, 255),
                ),
                onPressed: () {
                  otpController.actionSubmitOtp();
                },
                child: Text(
                  "Submit OTP",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

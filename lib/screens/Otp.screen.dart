import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:myasset/controllers/OtpController.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    OtpController otpController = Get.put(OtpController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                    "OTP Code has been sent to your email (${otpController.args[0]})"),
                const SizedBox(
                  height: 16,
                ),
                Text(
                    "Please enter your OTP Code then submit with ${otpController.args[2]}."),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  width: Get.width * 0.2,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: otpField,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      otpController.pin.value = value;
                    },
                    onFieldSubmitted: (value) {
                      otpController.pin.value = value;
                      otpController.actionSubmitOtp();
                    },
                  ),
                ),
                const SizedBox(
                  height: 60,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 62, 81, 255),
                    ),
                    onPressed: () {
                      otpController.actionSubmitOtp();
                    },
                    child: const Text(
                      "Submit OTP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 45, 60, 197),
                    ),
                    onPressed: () {
                      otpController.actionResendOtp();
                      otpField.text = "";
                    },
                    child: const Text(
                      "Resend OTP",
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
        ),
      ),
    );
  }
}

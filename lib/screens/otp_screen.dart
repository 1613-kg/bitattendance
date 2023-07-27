import 'package:bitattendance/constants.dart';
import 'package:bitattendance/screens/successScreen.dart';
import 'package:bitattendance/services/auth.dart';
import 'package:bitattendance/services/database_services.dart';
import 'package:bitattendance/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../services/loginData.dart';

class otpScreen extends StatefulWidget {
  String verificationId;
  otpScreen({super.key, required this.verificationId});

  @override
  State<otpScreen> createState() => _otpScreenState();
}

class _otpScreenState extends State<otpScreen> {
  String? otpCode;
  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: (isLoading)
          ? loading()
          : SingleChildScrollView(
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back)),
                        ),
                        Container(
                          height: 250,
                          width: 250,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/otp.jpg",
                          ),
                        ),
                        Text(
                          "Verification",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Enter the OTP sent to your phone number",
                          style: TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 18),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Pinput(
                          length: 6,
                          showCursor: true,
                          defaultPinTheme: PinTheme(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.purpleAccent),
                              ),
                              textStyle: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          onCompleted: (value) {
                            setState(() {
                              otpCode = value;
                            });
                          },
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                if (otpCode != null) {
                                  verifyOtp(context, otpCode!);
                                } else {
                                  showSnackbar(context, Colors.purpleAccent,
                                      "Enter 6-digit otp code");
                                }
                              },
                              child: Text(
                                "Verify",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Didn't recieve the code?"),
                            TextButton(
                                onPressed: () {}, child: Text("Resend code")),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  void verifyOtp(BuildContext context, String otpCode) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    ap.verifyOtp(
        context: context,
        verificatonId: widget.verificationId,
        otp: otpCode,
        onSuccess: () {
          DatabaseServices(uid: FirebaseAuth.instance.currentUser!.uid)
              .checkExistingUser()
              .then((value) async {
            await LoginData.saveUserLoggedInStatus(true);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => successScreen(
                          isExists: value,
                        )),
                (route) => false);
          });
        });
  }
}

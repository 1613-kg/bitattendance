import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../widgets/loading.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController _phoneController = TextEditingController();

  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
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
                    children: [
                      Container(
                        height: 250,
                        width: 250,
                        padding: EdgeInsets.all(10),
                        child: Image.asset(
                          "assets/images/login.png",
                        ),
                      ),
                      Text(
                        "Login with your phone number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        "Enter your phone number. We'll send you a verification code",
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phoneController,
                        decoration: InputDecoration(
                          hintText: "Enter Your phone number",
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide(color: Colors.black45),
                          ),
                          prefixIcon: Container(
                            padding: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Text(
                                "${selectedCountry.flagEmoji} +${selectedCountry.phoneCode}",
                                style: TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: () {
                              final ap = Provider.of<AuthProvider>(context,
                                  listen: false);
                              String phoneNumber = _phoneController.text.trim();
                              ap.signInWithPhone(
                                  "+${selectedCountry.phoneCode}$phoneNumber",
                                  context);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                            ),
                          )),
                    ],
                  ),
                ),
              )),
            ),
    );
  }
}

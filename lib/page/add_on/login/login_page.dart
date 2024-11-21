import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/key/decoder.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const nameRoute = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColor.background(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              padding: EdgeInsets.symmetric(horizontal:  ScreenSize.setWidthPercent(context, 15.5)),
              child: Image.asset('assets/image/hp_group.png'),
            )),
            Center(
              child: Container(
              height: ScreenSize.setHeightPercent(context, 45),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20), color: Colors.white),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText('ePortal Login', style: CustomFont.titleLogin()),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AutoSizeText(
                          'Login menggunakan E-Mail/ NIK pegawai dan password.',
                          style: CustomFont.headingEmpatColorful(),
                          textAlign: TextAlign.center,
                        ),
                        // TextField untuk E-Mail atau NIK Pegawai
                        TextField(
                          cursorHeight: 16,
                          style: CustomFont.headingEmpat(),
                          decoration: InputDecoration(
                            hintText: 'E-Mail/ NIK Pegawai',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CustomColor.secondaryColor(),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CustomColor.secondaryColor(),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CustomColor.primary(),
                                width: 1.5,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [
                            AutofillHints.email,
                            AutofillHints.username
                          ], // Autofill untuk email
                        ),
                        // TextField untuk Password
                        TextField(
                          cursorHeight: 16,
                          style: CustomFont.headingEmpat(),
                          obscureText:
                              true, // Untuk menyembunyikan teks password
                          decoration: InputDecoration(
                            hintText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CustomColor.secondaryColor(),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CustomColor.secondaryColor(),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: CustomColor.primary(),
                                width: 1.5,
                              ),
                            ),
                          ),
                          autofillHints: [
                            AutofillHints.password
                          ], // Autofill untuk password
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  // Logika login
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  decoration: CustomContainer.buttonSecondary(),
                                  child: Center(
                                    child: AutoSizeText('Login',
                                        style: CustomFont
                                            .headingTigaBoldSecondary()),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: CustomColor.secondaryColor(),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.fingerprint,
                                size: 42,
                                color: CustomColor.secondaryColor(),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  AutoSizeText(
                    'Lupa Password',
                    style: CustomFont.forgotPassword(),
                  ),
                ],
              ),
                        ),
            ),
              
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/joe.png'),
            )),
        ],
      ),
    );
  }
}
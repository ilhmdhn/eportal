import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/data/model/user.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/dashboard/dashboard_page.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/biometric.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/subsribe.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class LoginPage extends StatefulWidget {
  static const nameRoute = '/login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController tfUser = TextEditingController();
  TextEditingController tfPass = TextEditingController();
  final key = SharedPreferencesData.getKey();
  User? user = SharedPreferencesData.getUser();
  bool isLoading = true;

  void keyChecker(){
    if(key != null){
      try {
        subscribeToTopic();
        getIt<NavigationService>().pushNamedAndRemoveUntil(DashboardPage.nameRoute);
      } catch (e) {
        ShowToast.warning('Gagal beripindah ke halaman dashboard');
      }
    }else{
      setState(() {
        isLoading = false;
      });
    }
    if(user != null){
      tfUser.text = user?.username??'';
      tfPass.text = user?.password??'';
    }
  }

  @override
  void initState(){
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      keyChecker();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColor.dashboardBackground(),
      body: 
      isLoading?
      ShimmerLoading.dashboardShimmer(context):
      
      Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(top: 60),
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
                          controller: tfUser,
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
                          controller: tfPass,
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
                          autofillHints: const [
                            AutofillHints.password
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async{
                                  final user = tfUser.text.trim(); 
                                  final pass = tfPass.text.trim();
                                  if(isNullOrEmpty(user) || isNullOrEmpty(pass)){
                                    ShowToast.warning('Lengkapi user dan password');
                                    return;
                                  }else{
                                    executeLogin(user, pass);
                                  }
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
                            InkWell(
                              onTap: ()async{
                                final isAllowBiometric = SharedPreferencesData.getBiometric();
                                if(isAllowBiometric != true){
                                  ShowToast.warning('Autentikasi biometric belum diaktifkan');
                                  return;
                                }
                                final biometricRequest = await BiometricAuth().requestFingerprintAuth();
                                if(biometricRequest){
                                  if(user != null){
                                    executeLogin(user!.username, user!.password);
                                  }
                                }
                              },
                              child: Container(
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

  void executeLogin(String user, String pass)async{
    EasyLoading.show();
    final loginRequest = await NetworkRequest.login(user, pass);
    EasyLoading.dismiss();
    if(loginRequest.state == true){
      getIt<NavigationService>().pushNamedAndRemoveUntil(DashboardPage.nameRoute);
    }else{
      ShowToast.warning('Gagal login ${loginRequest.message}');
    }
  }
}
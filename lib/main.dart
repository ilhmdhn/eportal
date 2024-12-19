import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/page/attendance/attendance_page.dart';
import 'package:eportal/page/cuti/cuti_page.dart';
import 'package:eportal/page/error/error_page.dart';
import 'package:eportal/page/ijin/ijin_page.dart';
import 'package:eportal/page/lembur/lembur_page.dart';
import 'package:eportal/page/lipeng/substitute_page.dart';
import 'package:eportal/page/login/login_page.dart';
import 'package:eportal/page/dashboard/dashboard_page.dart';
import 'package:eportal/page/gps_attendance/gps_attendance_page.dart';
import 'package:eportal/page/permission/permission_page.dart';
import 'package:eportal/page/sallary/sallary_page.dart';
import 'package:eportal/provider/list_outlet_provider.dart';
import 'package:eportal/provider/max_date.dart';
import 'package:eportal/util/init_firebase.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  configLoading();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
    createNotif(message.data['Title'], message.data['Body']);
  });
  
  FirebaseTools.getToken();
  await SharedPreferencesData.initialize();
  await dotenv.load(fileName: ".env");
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: MaxDateProvider()
        ),
        ChangeNotifierProvider.value(
          value: ListOutletProvider(),
        ),
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return SafeArea(
      child: MaterialApp(
        navigatorKey: GetIt.instance<NavigationService>().navigatorKey,
        
        title: 'ePortal',
        builder: EasyLoading.init(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: LoginPage.nameRoute,
        routes: {
          LoginPage.nameRoute: (context) => const LoginPage(),
          DashboardPage.nameRoute: (context) => const DashboardPage(),
          AttendancePage.nameRoute: (context) => const AttendancePage(),
          GpsAttendancePage.nameRoute: (context) => const GpsAttendancePage(),
          PermissionPage.nameRoute: (context) => const PermissionPage(),
          CutiPage.nameRoute: (context) => const CutiPage(),
          IjinPage.nameRoute: (context) => const IjinPage(),
          OvertimePage.nameRoute: (context) => const OvertimePage(),
          ErrorPage.nameRoute: (context) => const ErrorPage(),
          SallaryPage.nameRoute: (context) => const SallaryPage(),
          SubstitutePage.nameRoute: (context) => const SubstitutePage()
        },
      ),
    );
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..progressColor = CustomColor.primary()
    // ..backgroundColor = Colors.green
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = false;
}

void createNotif(title, content) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    NotificationStyle.info(context, title, content);
  }
}
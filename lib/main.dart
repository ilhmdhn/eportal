import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/page/add_on/login/login_page.dart';
import 'package:eportal/page/dashboard/dashboard_page.dart';
import 'package:eportal/page/gps_attendance/gps_attendance_page.dart';
import 'package:eportal/page/permission/permission_page.dart';
import 'package:eportal/provider/location_provider.dart';
import 'package:eportal/util/init_firebase.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    createNotif(message.data['Title'], message.data['Body']);
  });
  
  FirebaseTools.getToken();
  await SharedPreferencesData.initialize();
  await dotenv.load(fileName: ".env");
  setupLocator();
  runApp(ChangeNotifierProvider(
    create: (_) => LocationProvider(),
    child: const MyApp(),
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
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
          GpsAttendancePage.nameRoute: (context) => const GpsAttendancePage(),
          PermissionPage.nameRoute: (context) => const PermissionPage()
        },
      ),
    );
  }
}

void createNotif(title, content) {
  final context = navigatorKey.currentContext;
  if (context != null) {
    NotificationStyle.info(context, title, content);
  }
}
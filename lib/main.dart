import 'package:eportal/page/dashboard/dashboard_page.dart';
import 'package:eportal/page/gps_attendance/gps_attendance_page.dart';
import 'package:eportal/page/permission/permission_page.dart';
import 'package:eportal/util/init_firebase.dart';
import 'package:eportal/util/notification.dart';
import 'package:eportal/util/optimizer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    createNotif(message.data['Title'], message.data['Body']);
  });
  FirebaseTools.getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        navigatorKey: navigatorKey,
        title: 'ePortal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: DashboardPage.nameRoute,
        routes: {
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
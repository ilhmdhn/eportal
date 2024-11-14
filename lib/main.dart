import 'package:eportal/page/dashboard/dashboard_page.dart';
import 'package:eportal/util/init_firebase.dart';
import 'package:eportal/util/notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Received a message in foreground: ${message.messageId}");
    print("Message data: ${message.data}");

    if (message.notification != null) {
      print("Notification Title: ${message.notification!.title}");
      print("Notification Body: ${message.notification!.body}");
    }
  });
  FirebaseTools.getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Portal(
      child: MaterialApp(
        title: 'ePortal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: DashboardPage.nameRoute,
        routes: {
          DashboardPage.nameRoute: (context) => const DashboardPage()
        },
      ),
    );
  }
}
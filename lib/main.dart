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
import 'package:eportal/page/schedule/schedule_page.dart';
import 'package:eportal/page/ssp/ssp_page.dart';
import 'package:eportal/provider/list_outlet_provider.dart';
import 'package:eportal/provider/max_date.dart';
import 'package:eportal/util/init_firebase.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:eportal/util/show_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  configLoading();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.data['type'] == 'NOTIFICATION') {
      // createNotif(message.data['title'], message.data['message']);
      print('isinyaa ${message.data}');
      // ShowNotification.showAttendanceNotification(message.data['title'], message.data['message']);
    }
  });
  
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message){
    // if(message.data['type'] == 'NOTIFICATION'){
      print('isinyaa ${message.data}');
      // createNotif(message.data['title'], message.data['message']);
    // }
  });
  

  FirebaseTools.getToken();
  await SharedPreferencesData.initialize();
  await dotenv.load(fileName: ".env");
  setupLocator();
  await initializeNotifications();
  initializeDateFormatting().then((_)=> runApp(
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
  ));
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
          SubstitutePage.nameRoute: (context) => const SubstitutePage(),
          SspPage.nameRoute: (context) => const SspPage(),
          SchedulePage.nameRoute: (context) => const SchedulePage()
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
    ..indicatorColor = CustomColor.primary()
    ..indicatorSize = 56
    ..backgroundColor = Colors.transparent
    ..textColor = Colors.yellow
    ..boxShadow = <BoxShadow>[]
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

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  if (Platform.isIOS || Platform.isMacOS) {
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        ),
      ],
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
}

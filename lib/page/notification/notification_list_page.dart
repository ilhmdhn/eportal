import 'package:eportal/page/add_on/background.dart';
import 'package:flutter/material.dart';

class NotificationListPage extends StatefulWidget {
  const NotificationListPage({super.key});
  static const nameRoute = '/notification-list';
  @override
  State<NotificationListPage> createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: backgroundPage(
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Text('aaaa')
            ],
          ),
        )
      ),
    );
  }
}
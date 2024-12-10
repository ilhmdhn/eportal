import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/lembur/lembur_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OvertimePage extends StatefulWidget {
  static const nameRoute = '/overtime';
  const OvertimePage({super.key});

  @override
  State<OvertimePage> createState() => OvertimePageState();
}

class OvertimePageState extends State<OvertimePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      floatingActionButton: Container(
        height: 48,
        width: 48,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: CustomColor.primary()
        ),
        child: InkWell(
          onTap: (){
            OvertimeDialog.showOvertimeDialog(context);
          },
          child: const Icon(Icons.add, color: Colors.white, size: 32,)),
      ),
      body: Column(
        children: [
          
        ],
      ),
    );
  }
}
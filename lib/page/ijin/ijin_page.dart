import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/ijin/ijin_dialog.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

class IjinPage extends StatefulWidget {
  static const nameRoute = '/ijin';
  const IjinPage({super.key});

  @override
  State<IjinPage> createState() => _IjinPageState();
}

class _IjinPageState extends State<IjinPage> {
  
  void getData(){

  }

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.background(),
        body: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: SizedBox(
                width: ScreenSize.setWidthPercent(context, 50),
                child: Image.asset('assets/image/joe.png'),
              )
            ),
            Positioned(
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Column(
                children: [
                  ElevatedButton(onPressed: (){
                    IjinDialog.showIjinDialog(context);
                  }, child: const Text('Show add dialog'))      
                ],
              )
            )
          ],
        ),
      ));
  }
}
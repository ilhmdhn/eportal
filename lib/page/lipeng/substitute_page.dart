import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

class SubstitutePage extends StatefulWidget {
  static const nameRoute = '/substitute';
  const SubstitutePage({super.key});

  @override
  State<SubstitutePage> createState() => _SubstitutePageState();
}

class _SubstitutePageState extends State<SubstitutePage> {

  bool isLoading = true;

  void getData()async{
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: isLoading?
      ShimmerLoading.listShimmer(context):
      Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/joe.png'),
            ))
        ],
      ),
    );
  }
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});
  static const nameRoute = '/permission';

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

  enum PermissionState { granted, limited, denied }
  
  class _PermissionPageState extends State<PermissionPage> {
    PermissionState notificationPermissionState = PermissionState.denied;
    PermissionState locationPermissionState = PermissionState.denied;
    PermissionState cameraPermissionState = PermissionState.denied;
    PermissionState phonePermissionState = PermissionState.denied;

    bool getPermissionState = false;

    void permissionChecker() async{
      getPermissionState = true;
      if(await Permission.notification.isGranted == true){
        notificationPermissionState = PermissionState.granted;
      }else if(await Permission.notification.isDenied == true || await Permission.notification.isPermanentlyDenied == true){
        notificationPermissionState = PermissionState.denied;
      }else if(await Permission.notification.isLimited == true || await Permission.notification.isProvisional || await Permission.notification.isRestricted){
        notificationPermissionState = PermissionState.limited;
      }

      if(await Permission.location.isGranted == true){
        locationPermissionState = PermissionState.granted;
      }else if(await Permission.location.isDenied == true || await Permission.location.isPermanentlyDenied == true){
        locationPermissionState = PermissionState.denied;
      }else if(await Permission.location.isLimited == true || await Permission.location.isProvisional || await Permission.location.isRestricted){
        locationPermissionState = PermissionState.limited;
      }

      if(await Permission.camera.isGranted == true){
        cameraPermissionState = PermissionState.granted;
      }else if(await Permission.camera.isDenied == true || await Permission.camera.isPermanentlyDenied == true){
        cameraPermissionState = PermissionState.denied;
      }else if(await Permission.camera.isLimited == true || await Permission.camera.isProvisional || await Permission.camera.isRestricted){
        cameraPermissionState = PermissionState.limited;
      }

      if(await Permission.phone.isGranted == true){
        phonePermissionState = PermissionState.granted;
      }else if(await Permission.phone.isDenied == true || await Permission.phone.isPermanentlyDenied == true){
        phonePermissionState = PermissionState.denied;
      }else if(await Permission.phone.isLimited == true || await Permission.phone.isProvisional || await Permission.phone.isRestricted){
        phonePermissionState = PermissionState.limited;
      }
      setState(() {
        notificationPermissionState;
        locationPermissionState;
        cameraPermissionState;
        phonePermissionState;
      });
    }

  @override
  Widget build(BuildContext context) {
    if(getPermissionState == false){
      permissionChecker();
    }
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 21),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(
                blurRadius: 0.3,
              )],
              // border: Border.all(width: 0.7, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                AutoSizeText('Permission', style: CustomFont.headingEmpatBold(),),
                Text('Permission untuk mengaktifkan interaksi aplikasi dengan perangkat smartphone. Jika permission tidak diberikan, aplikasi akan tetap menjalankan fitur yang ada', style: CustomFont.headingLima(), textAlign: TextAlign.justify,),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 19,),
                      InkWell(
                        onTap: () async{
                          if(notificationPermissionState == PermissionState.granted){
                            print('Sudah disetujui');
                            return;
                          }
                          Permission.notification.onDeniedCallback(() {
                            // Your code
                          }).onGrantedCallback(() {
                            // Your code
                          }).onPermanentlyDeniedCallback(() {
                            // Your code
                          }).onRestrictedCallback(() {
                            // Your code
                          }).onLimitedCallback(() {
                            // Your code
                          }).onProvisionalCallback(() {
                            // Your code
                          }).request();
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Notifikasi', style: CustomFont.headingEmpatBold()),
                                      AutoSizeText("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s", style: CustomFont.headingEmpat(),
                                        minFontSize: 13, maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify,),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 19,),
                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: Transform.scale(
                                    scale: 1.3,
                                    child: Checkbox(
                                      value: notificationPermissionState == PermissionState.granted?true: false,
                                      
                                      activeColor: CustomColor.primary(),
                                      checkColor: Colors.white,
                                      onChanged: ((value){
                                    
                                      }),
                                    ),
                                  ),
                                )                            ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1.4,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(vertical: 6),
                      ),
                      InkWell(
                        onTap: () async {
                          if (locationPermissionState ==
                              PermissionState.granted) {
                            print('Sudah disetujui');
                            return;
                          }
                          Permission.location.onDeniedCallback(() {
                            // Your code
                          }).onGrantedCallback(() {
                            // Your code
                          }).onPermanentlyDeniedCallback(() {
                            // Your code
                          }).onRestrictedCallback(() {
                            // Your code
                          }).onLimitedCallback(() {
                            // Your code
                          }).onProvisionalCallback(() {
                            // Your code
                          }).request();
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Location',
                                          style: CustomFont.headingEmpatBold()),
                                      AutoSizeText(
                                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                        style: CustomFont.headingEmpat(),
                                        minFontSize: 13,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 19,
                                ),
                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: Transform.scale(
                                    scale: 1.3,
                                    child: Checkbox(
                                      value: locationPermissionState == PermissionState.granted? true: false,
                                      activeColor: CustomColor.primary(),
                                      checkColor: Colors.white,
                                      onChanged: ((value) {}),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1.4,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(vertical: 6),
                      ),
                      InkWell(
                        onTap: () async {
                          if (cameraPermissionState ==
                              PermissionState.granted) {
                            print('Sudah disetujui');
                            return;
                          }
                          Permission.camera.onDeniedCallback(() {
                            // Your code
                          }).onGrantedCallback(() {
                            // Your code
                          }).onPermanentlyDeniedCallback(() {
                            // Your code
                          }).onRestrictedCallback(() {
                            // Your code
                          }).onLimitedCallback(() {
                            // Your code
                          }).onProvisionalCallback(() {
                            // Your code
                          }).request();
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Kamera',
                                          style: CustomFont.headingEmpatBold()),
                                      AutoSizeText(
                                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                        style: CustomFont.headingEmpat(),
                                        minFontSize: 13,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 19,
                                ),
                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: Transform.scale(
                                    scale: 1.3,
                                    child: Checkbox(
                                      value: cameraPermissionState == PermissionState.granted? true: false,
                                      activeColor: CustomColor.primary(),
                                      checkColor: Colors.white,
                                      onChanged: ((value) {}),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 1.4,
                        color: Colors.grey,
                        margin: EdgeInsets.symmetric(vertical: 6),
                      ),
                      InkWell(
                        onTap: () async{
                          if(phonePermissionState == PermissionState.granted){
                            print('Sudah disetujui');
                            return;
                          }
                          Permission.phone.onDeniedCallback(() {
                            // Your code
                          }).onGrantedCallback(() {
                            // Your code
                          }).onPermanentlyDeniedCallback(() {
                            // Your code
                          }).onRestrictedCallback(() {
                            // Your code
                          }).onLimitedCallback(() {
                            // Your code
                          }).onProvisionalCallback(() {
                            // Your code
                          }).request();
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Phone',
                                          style: CustomFont.headingEmpatBold()),
                                      AutoSizeText(
                                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                                        style: CustomFont.headingEmpat(),
                                        minFontSize: 13,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 19,
                                ),
                                SizedBox(
                                  width: 26,
                                  height: 26,
                                  child: Transform.scale(
                                    scale: 1.3,
                                    child: Checkbox(
                                      value: phonePermissionState == PermissionState.granted? true: false,
                                      activeColor: CustomColor.primary(),
                                      checkColor: Colors.white,
                                      onChanged: ((value) {}),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: ScreenSize.setWidthPercent(context, 50),
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: Image.asset('assets/image/joe.png')))
            ],
          )
        ],
      ),
    );
  }
}
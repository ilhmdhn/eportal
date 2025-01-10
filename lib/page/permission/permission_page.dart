import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/optimizer.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
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
      getPermissionState = true;
      permissionChecker();
    }
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 21),
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [BoxShadow(
                blurRadius: 0.3,
              )],
              // border: Border.all(width: 0.7, color: Colors.grey),
              borderRadius: BorderRadius.circular(10)
            ),
            child: Column(
              children: [
                AutoSizeText('Permission', style: CustomFont.headingEmpatBold(),),
                Text('Permission untuk mengaktifkan interaksi aplikasi dengan perangkat smartphone. Jika permission tidak diberikan, aplikasi tidak dapat menjalankan fitur yang ada', style: CustomFont.headingLima(), textAlign: TextAlign.justify,),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 19,),
                      InkWell(
                        onTap: () async{
                          if(notificationPermissionState == PermissionState.granted){
                            ShowToast.warning('Sudah disetujui');
                            return;
                          }

                          await Permission.notification.onDeniedCallback(() {
                          }).onGrantedCallback(() {
                          }).onPermanentlyDeniedCallback(() async{
                            await openAppSettings();
                          }).onRestrictedCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).onLimitedCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).onProvisionalCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).request();
                          permissionChecker();
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
                                      AutoSizeText("Pastikan kamu sudah mengaktifkan lokasi ini agar tidak ketinggalan info penting dari E-Portal.", style: CustomFont.headingLima(),
                                        minFontSize: 13, maxLines: 3, overflow: TextOverflow.ellipsis, textAlign: TextAlign.justify,),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6,),
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: notificationPermissionState == PermissionState.granted ? Colors.white : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: notificationPermissionState == PermissionState.granted ? Colors.green : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      notificationPermissionState == PermissionState.granted ? Icons.check : Icons.close,
                                      color: notificationPermissionState == PermissionState.granted ? Colors.green : Colors.red,
                                      size: 19,
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
                        margin: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      InkWell(
                        onTap: () async {
                          if (locationPermissionState ==PermissionState.granted) {
                            ShowToast.warning('Sudah disetujui');
                            return;
                          }
                          await Permission.location.onDeniedCallback(() {
                           }).onGrantedCallback(() {
                          }).onPermanentlyDeniedCallback(() async{
                            await openAppSettings();
                          }).onRestrictedCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).onLimitedCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).onProvisionalCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).request();
                          
                          permissionChecker();

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
                                        "Akses lokasi dibutuhkan agar kamu dapat absen menggunakan GPS, pastikan sudah tercentang ya!",
                                        style: CustomFont.headingLima(),
                                        minFontSize: 13,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: locationPermissionState == PermissionState.granted ? Colors.white : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: locationPermissionState == PermissionState.granted ? Colors.green : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      locationPermissionState == PermissionState.granted ? Icons.check : Icons.close,
                                      color: locationPermissionState == PermissionState.granted ? Colors.green : Colors.red,
                                      size: 19,
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
                        margin: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      InkWell(
                        onTap: () async {
                          if (cameraPermissionState == PermissionState.granted) {
                            ShowToast.warning('Sudah disetujui');
                            return;
                          }
                          await Permission.camera.onDeniedCallback(() {
                          }).onGrantedCallback(() {
                          }).onPermanentlyDeniedCallback(() async{
                            await openAppSettings();
                          }).onRestrictedCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).onLimitedCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).onProvisionalCallback(() {
                            ShowToast.warning('Akses Terbatas');
                          }).request();

                          permissionChecker();
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
                                      Text('Kamera', style: CustomFont.headingEmpatBold()),
                                      AutoSizeText(
                                        'Beberapa fitur E-Portal membutuhkan akses kamera, pastikan akses kamera sudah aktif agar dapat digunakan.',
                                        style: CustomFont.headingLima(),
                                        minFontSize: 13,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    color: cameraPermissionState == PermissionState.granted ? Colors.white : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: cameraPermissionState == PermissionState.granted ? Colors.green : Colors.grey,
                                      width: 2,
                                    ),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      cameraPermissionState == PermissionState.granted ? Icons.check : Icons.close,
                                      color: cameraPermissionState == PermissionState.granted ? Colors.green : Colors.red,
                                      size: 19,
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
                        margin: const EdgeInsets.symmetric(vertical: 6),
                      ),
                      Platform.isAndroid?
                      InkWell(
                        onTap: () async{
                          Optimizer().requestIgnoreBatteryOptimization();
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
                                      AutoSizeText('Optimalkan penggunaan aplikasi', style: CustomFont.headingEmpatBold(), minFontSize: 6, maxLines: 1,),
                                      AutoSizeText(
                                        "Agar E-Portal tidak terhenti dan kamu tidak mendapatkan pemberitahuan, maka pastikan E-Portal sudah diaktifkan di menu ini ya!",
                                        style: CustomFont.headingLima(),
                                        minFontSize: 13,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.justify,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ):const SizedBox(),
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
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
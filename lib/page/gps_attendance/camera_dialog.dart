import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/page/dashboard/dashboard_page.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CameraDialog {
  static void showCameraDialog(BuildContext context, num distance, String outlet) async{
    XFile? capturedImage;
    int selectorType = 1;
    late List<CameraDescription> cameras;
    CameraController cameraController;

    cameras = await availableCameras();
    
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    
    cameraController = CameraController(frontCamera, ResolutionPreset.medium);

    try {
      await cameraController.initialize();
    } catch (e) {
      ShowToast.error('Error initializing camera: $e');
      NavigationService.back();
    }    
    
    if(!context.mounted){
      NavigationService.back();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result){
            cameraController.dispose();
          },
          child: StatefulBuilder(builder: (BuildContext ctx, StateSetter setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              titlePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              actionsPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 2),
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 36, height: 36),
                    Text('Ambil Foto', style: CustomFont.headingTiga()),
                    SizedBox(
                      width: 36,
                      height: 36,
                      child: InkWell(
                        onTap: () {
                          cameraController.dispose();
                          Navigator.pop(context);
                        },
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
              ),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isNotNullOrEmpty(capturedImage?.path)
                        ? Flexible(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(-1.0, 1.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Image.file(File(capturedImage!.path)),
                              ),
                            ),
                          )
                        : Container(
                            height: MediaQuery.of(context).size.height * 0.5,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..scale(-1.0, 1.0, 1.0),
                              child: CameraPreview(cameraController),
                            ),
                          ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: RadioListTile(
                            title:
                                AutoSizeText('Datang', style: CustomFont.headingEmpat(), minFontSize: 6, maxLines: 1,),
                            value: 1,
                            activeColor: CustomColor.primary(),
                            contentPadding: const EdgeInsets.all(0),
                            groupValue: selectorType,
                            onChanged: (value) {
                              setState(() {
                                selectorType = value!;
                              });
                            },
                          ),
                        ),
                        Flexible(
                          child: RadioListTile(
                            title: AutoSizeText('Pulang', style: CustomFont.headingEmpat(), minFontSize: 6, maxLines: 1,),
                            value: 2,
                            activeColor: CustomColor.primary(),
                            contentPadding: const EdgeInsets.all(0),
                            groupValue: selectorType,
                            onChanged: (value) {
                              setState(() {
                                selectorType = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                capturedImage == null
                    ? InkWell(
                        onTap: () async {
                          if (cameraController.value.isTakingPicture) return;
                          final image = await cameraController.takePicture();
                          setState(() {
                            capturedImage = image;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: CustomContainer.buttonPrimary(),
                          child: Center(
                            child: Text(
                              'Ambil',
                              style: CustomFont.buttonSecondary(),
                            ),
                          ),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  File(capturedImage!.path).delete();
                                  capturedImage = null;
                                });
                              },
                              child: Container(
                                height: 36,
                                decoration: CustomContainer.buttonCancel(),
                                child: Center(
                                  child: Text('Hapus',
                                      style: CustomFont.buttonSecondary()),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () async {
                                EasyLoading.show();
                                final attendanceResponse = await NetworkRequest.postGpsAttendance(capturedImage, outlet, distance.round(), selectorType);
                                EasyLoading.dismiss();
                                if(attendanceResponse.state == true){
                                  if(context.mounted){
                                    NotificationStyle.info(context, 'Success', 'Absensi berhasil');
                                  }
                                  NavigationService.moveRemoveUntil(DashboardPage.nameRoute);
                                }
                              },
                              child: Container(
                                height: 36,
                                decoration: CustomContainer.buttonPrimary(),
                                child: Center(
                                  child: Text('Absen',
                                      style: CustomFont.buttonSecondary()),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            );
          }),
        );
      },
    );
  }
}

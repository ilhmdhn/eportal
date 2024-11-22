import 'dart:convert';
import 'dart:io';

import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraDialog{
    static void showCameraDialog(BuildContext context, CameraController cameraController) {
    XFile? capturedImage;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
        builder: (BuildContext ctx, StateSetter setState) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isNotNullOrEmpty(capturedImage?.path)
                    ? Column(
                        children: [
                          SizedBox(
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.identity()
                                  ..scale(-1.0, 1.0, 1.0),
                                child: Image.file(File(capturedImage!.path))),
                          ),],
                      ):
                      Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(-1.0, 1.0, 1.0),
                            child: CameraPreview(cameraController),
                          )
              ],
            ),
            actions: [
              capturedImage == null?
              InkWell(
                onTap: () async {
                  if (cameraController.value.isTakingPicture) return;
          
                  final image = await cameraController.takePicture();
                  setState(() {
                    capturedImage = image;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: CustomContainer.buttonPrimary(),
                  child: Center(
                      child: Text(
                    'Ambil',
                    style: CustomFont.buttonSecondary(),
                  )),
                ),
              ): SizedBox(
                      height: 46,
                      child: Row(
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
                                        style: CustomFont.buttonSecondary())),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: ()async{
                                final attendanceResponse = await NetworkRequest.postGpsAttendance(capturedImage, 'HP000', 1, 1);
                                ShowToast.warning(attendanceResponse.state.toString() + (attendanceResponse.message??''));

                              },
                              child: Container(
                                height: 36,
                                decoration: CustomContainer.buttonPrimary(),
                                child: Center(
                                    child: Text('Absen',
                                        style: CustomFont.buttonSecondary())),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
            ],
          );
      });
      },
    );
  }

}
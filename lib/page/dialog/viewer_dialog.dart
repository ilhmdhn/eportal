import 'dart:io';

import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:no_screenshot/no_screenshot.dart';

class CustomViewer{

  static pdfFile(BuildContext ctx, File pdfFile) async{
    final noScreenshot = NoScreenshot.instance;
    await noScreenshot.screenshotOff();
    if(!ctx.mounted){
      ShowToast.warning('Membuka dokumen dibatalkan');
      return;
    }
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) => noScreenshot.screenshotOn(),
          child: Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              dialogBackgroundColor: Colors.black,          ),
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(ctx).size.width,
                height: MediaQuery.of(ctx).size.height,
                child: SfPdfViewer.file(
                  pdfFile,
                  scrollDirection: PdfScrollDirection.horizontal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static detectImageOrPdf(BuildContext ctx, url)async{
    if(url.toLowerCase().endsWith('.pdf')){
      pdfNetwork(ctx, url);
    }else{
      networkPhoto(ctx, url);
    }
  }

  static pdfNetwork(BuildContext ctx, String url) async {
    final noScreenshot = NoScreenshot.instance;
    await noScreenshot.screenshotOff();
    if(!ctx.mounted){
      ShowToast.warning('Lihat dokumen dibatalkan');
      return;
    }
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) =>
              noScreenshot.screenshotOn(),
          child: Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              dialogBackgroundColor: Colors.black,
            ),
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(ctx).size.width,
                height: MediaQuery.of(ctx).size.height,
                child: SfPdfViewer.network(
                  url,
                  scrollDirection: PdfScrollDirection.horizontal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static networkPhoto(BuildContext ctx, String imageUrl) async {
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {},
          child: Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.transparent,
              dialogBackgroundColor: Colors.transparent,
            ),
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                    width: MediaQuery.of(ctx).size.width,
                    height: MediaQuery.of(ctx).size.height,
                    child: PhotoView(
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent
                      ),
                      imageProvider: NetworkImage(imageUrl)),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: () {
                        NavigationService.back();
                      },
                      child: const Icon(Icons.close),
                    )
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static networkPhotoBgWhite(BuildContext ctx, String imageUrl) async {
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {},
          child: Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.transparent,
              dialogBackgroundColor: Colors.transparent,
            ),
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(ctx).size.width,
                child: PhotoView(
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.white
                  ),
                  imageProvider: NetworkImage(imageUrl)),
              ),
            ),
          ),
        );
      },
    );
  }

  static filePhoto(BuildContext ctx, File fileImage) async {
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result)
          {

          },
          child: Theme(
            data: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: Colors.black,
              dialogBackgroundColor: Colors.black,
            ),
            child: Dialog(
              insetPadding: EdgeInsets.zero,
              child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(ctx).size.width,
                height: MediaQuery.of(ctx).size.height,
                child: PhotoView(
                  imageProvider:  FileImage(fileImage)
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
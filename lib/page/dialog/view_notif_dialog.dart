import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/provider/notification_provider.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationDialog {
  OverlayEntry? _overlayEntry;

void showNotificationOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      return;
    }


    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              closeOverlay();
            },
            child: Container(
              color: Colors.black.withOpacity(0.2),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Positioned(
            top: 25.0,
            right: 20.0,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: ScreenSize.setWidthPercent(context, 70),
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8),
                constraints: BoxConstraints(
                  maxHeight: ScreenSize.setHeightPercent(context, 35),
                  minHeight: ScreenSize.setHeightPercent(context, 10),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications, color: CustomColor.primary()),
                        const SizedBox(width: 8),
                        const Text(
                          "Notifikasi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            closeOverlay();
                          },
                          child: const Icon(Icons.close, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 1,
                      width: double.maxFinite,
                      color: Colors.grey,
                    ),
                    Expanded(
                      child: Consumer<NotificationProvider>(
                        builder: (ctxConsumer, notif, child) {
                          return ListView.builder(
                            itemCount: notif.length,
                            itemBuilder: (context, indexNotif) {
                              final data = notif.data[indexNotif];
                              return _buildNotificationItem(
                                data.type,
                                data.isViewed,
                                data.title,
                                data.content,
                                data.time
                              );
                            },
                          );
                        }
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: AutoSizeText('view more', style: CustomFont.headingLimaColorUnderlined(),)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }
  
  Widget _buildNotificationItem(String type, bool isViewed, String title, String message, String time) {
    return InkWell(
      onTap: (){
        
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 2,),
                    type == '1'? const Icon(Icons.info, color: Colors.green, size: 16):
                    type == '2'? Icon(Icons.check_circle, color: CustomColor.primary(), size: 16):
                    type == '3'? Container(width: 14, height: 14, decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(7)),child: const Icon(Icons.close_rounded, color: Colors.white, size: 12)): const SizedBox(),
                  ],
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: CustomFont.headingLimaBold(),
                      ),
                      Text(
                        message,
                        style: CustomFont.headingLima(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            // Container(
            //   width: double.infinity,
            //   height: 0.7,
            //   color: Colors.grey,
            // )
          ],
        ),
      ),
    );
  }

  void closeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}
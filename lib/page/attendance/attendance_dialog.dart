import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

class AttendanceDialog{
  static void detailAttendance(BuildContext ctx, AttendanceListModel data){
    bool isLate = false;
    bool isEarly = false;
    bool inGps = false;
    bool outGps = false;
    bool workDate = false;
    bool holiday = false;
    bool permit = false;
    bool offDay = false;
    bool arriveForget = false;
    bool leavedForget = false;

    if ((data.jko ?? '').toLowerCase().contains('kerja')) {
      workDate = true;
    }

    if ((data.jko ?? '').toLowerCase().contains('off')) {
      holiday = true;
    }

    if ((data.jko ?? '').toLowerCase().contains('izin')) {
      permit = true;
    }

    if ((data.jko ?? '').toLowerCase().contains('cuti')) {
      offDay = true;
    }

    if ((data.arrivalDescription ?? '').toLowerCase().contains('late')) {
      isLate = true;
    }

    if ((data.arrivalDescription ?? '').toLowerCase().contains('gps')) {
      inGps = true;
    }

    if ((data.leaveDescription ?? '').toLowerCase().contains('early')) {
      isEarly = true;
    }

    if ((data.leaveDescription ?? '').toLowerCase().contains('gps')) {
      outGps = true;
    }

    if ((data.leaveDescription ?? '').toLowerCase().contains('lupa')) {
      leavedForget = true;
    }

    if ((data.arrivalDescription ?? '').toLowerCase().contains('lupa')) {
      arriveForget = true;
    }

    showDialog(
      context: ctx,
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          iconPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          buttonPadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            constraints: BoxConstraints(maxHeight: ScreenSize.setHeightPercent(ctx, 70)),
            width: ScreenSize.setWidthPercent(ctx, 85),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.3, color: Colors.grey)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24,),
                    Center(child: Text('Rincian Absen', style: CustomFont.headingTigaSemiBold(),)),
                    InkWell(
                      onTap: ()async{
                        NavigationService.back();
                      },
                      child: const SizedBox(width: 24, child: 
                      Icon(Icons.close),),
                    ),
                  ],
                ),
                const SizedBox(height: 12,),
                AutoSizeText(
                  'Tanggal',
                  style: CustomFont.headingEmpatSemiBold(),
                  maxLines: 1,
                ),
                const SizedBox(
                  height: 2,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1, 
                      color: Colors.grey
                    ),
                    borderRadius: BorderRadius.circular(6)
                  ),
                  child: Text(CustomConverter.dateTimeToDay(DateTime.parse(data.date!)),
                    style: CustomFont.headingEmpat(),
                  )
                ),
                const SizedBox(
                  height: 12,
                ),
                
                holiday?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Status',
                        style: CustomFont.headingEmpatSemiBold(),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1, 
                            color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Text('Hari Libur',
                          style: CustomFont.headingEmpatReject(),
                        )
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ): 
                offDay?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Status',
                        style: CustomFont.headingEmpatSemiBold(),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1, 
                            color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Text('Cuti',
                          style: CustomFont.headingEmpatReject(),
                        )
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ):
                permit?
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Status',
                        style: CustomFont.headingEmpatSemiBold(),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1, 
                            color: Colors.grey
                          ),
                          borderRadius: BorderRadius.circular(6)
                        ),
                        child: Text('Izin',
                          style: CustomFont.headingEmpatWaiting(),
                        )
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  ):
                workDate?
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      'Jam Kerja',
                      style: CustomFont.headingEmpatSemiBold(),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1, 
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text('${data.arrivalSchedule} - ${data.leaveSchedule}',
                        style: CustomFont.headingEmpat(),
                      )
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    AutoSizeText(
                      'Absen Datang',
                      style: CustomFont.headingEmpatSemiBold(),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1, 
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Row(
                        children: [
                          Text(
                            '${arriveForget?'Lupa Absen':data.arrived}${inGps?'(GPS)':''}',
                            style: isLate||arriveForget?CustomFont.headingEmpatReject(): CustomFont.headingEmpat(),
                          ),
                        ],
                      )
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    
                    AutoSizeText(
                      'Absen Pulang',
                      style: CustomFont.headingEmpatSemiBold(),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1, 
                          color: Colors.grey
                        ),
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: 
                        Text(
                          '${leavedForget ? 'Lupa Absen' : data.leaveDescription}${outGps ? '(GPS)' : ''}',
                          style: isEarly || leavedForget
                          ? CustomFont.headingEmpatReject(): CustomFont.headingEmpat(),
                        )
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ):const SizedBox(),
              ],
            ),
          ),
        );
      }
    );
  }
}
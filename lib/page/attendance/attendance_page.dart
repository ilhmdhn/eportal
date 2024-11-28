import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:intl/intl.dart';

class AttendancePage extends StatefulWidget {
  static const nameRoute = '/attendance';
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}



class _AttendancePageState extends State<AttendancePage> {

  AttendanceListResponse? attendanceListResponse;
  String monthName = '';

  void getData(String month) async{
    EasyLoading.show();
    attendanceListResponse = await NetworkRequest.getAttendance(month);
    setState(() {
      attendanceListResponse;
      monthName = CustomConverter.monthCheck(month);
    });
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();
    String monthYear = DateFormat('MM-yyyy').format(DateTime.now());
    getData(monthYear);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: Stack(
        children: [ Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/joe.png'))),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  height: ScreenSize.setHeightPercent(context, 17),
                  decoration: BoxDecoration(
                    color: CustomColor.primary(),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      AutoSizeText('Data Absensi', style: CustomFont.headingTigaSemiBoldSecondary(),),
                      const SizedBox(height: 12,),
                      Row(
                        children: [
                          AutoSizeText('Bulan: ', style: CustomFont.headingEmpatSecondary()),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: ()async{
                              showMonthPicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    cancelWidget: Text('Batal', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),),
                                    confirmWidget: Text('Confirm', style: CustomFont.headingEmpatColorful(),),
                                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now().add(const Duration(days: 60)),
                                    monthPickerDialogSettings:
                                        MonthPickerDialogSettings(
                                          headerSettings: PickerHeaderSettings(
                                            headerBackgroundColor: CustomColor.primary(),
                                          ),
                                          buttonsSettings: PickerButtonsSettings(
                                            monthTextStyle: CustomFont.headingLimaSemiBold(),
                                            selectedMonthBackgroundColor: CustomColor.primary(),
                                            unselectedMonthsTextColor: Colors.black
                                          ),
                                      dialogSettings: const PickerDialogSettings(
                                        dialogBackgroundColor: Colors.white
                                      ),
                                    ),
                                  ).then((date) async {
                                    if (date != null) {
                                      String formattedDate = DateFormat('MM-yyyy').format(date);
                                      getData(formattedDate);
                                    }
                                  });
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                AutoSizeText(monthName, style: CustomFont.headingEmpatSecondary()),
                                const Icon(
                                      Icons.change_circle_outlined,
                                      color: Colors.white,
                                      size: 19,
                                    ),
                              ],
                            ),
                          ),
                        ],
                      ),
                     /*SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                       child: GroupButton(
                          isRadio: true,
                          buttonBuilder: (selected, value, context) {
                            return Badge.count(
                              count: 1,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: AutoSizeText(value, style: CustomFont.standartFont(),),
                              ),
                            );
                          },
                          buttons: const ['All', 'Tepat Waktu','Cuti', 'Sakit', 'Izin','Terlambat', 'All',
                                'Tepat Waktu',
                                'Cuti',
                                'Sakit',
                                'Izin',
                                'Terlambat'
                              ],
                        ),
                     )
                    */],
                  ),
                ),

                Container(
                  height: ScreenSize.setHeightPercent(context, 80),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: 
                  
                  attendanceListResponse?.state != true?
                  Center(
                    child: AutoSizeText(attendanceListResponse?.message??''),
                  ):
                  ListView.builder(
                    itemCount: attendanceListResponse?.listAbsen.length??0,
                    itemBuilder: (BuildContext ctxList, index){
                      final dataAbsen = attendanceListResponse?.listAbsen[index];
                      final date = dataAbsen?.date??'1990-01-01';
                      bool isLate = false;
                      bool isEarly = false;

                      if((dataAbsen?.arrivalDescription ?? '').contains('late')){
                        isLate = false;
                      }

                      if((dataAbsen?.leaveDescription??'').contains('early')){
                        isEarly = true;
                      }


                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.3,
                                color: Colors.grey
                              ),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.lightBlue.shade50,
                                    borderRadius: BorderRadius.circular(18)
                                  ),
                                  child: Center(child: Text(date.substring(8, 10), style: CustomFont.headingTigaSemiBold(),)),
                                ),
                                const SizedBox(width: 6,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      AutoSizeText(CustomConverter.dateToDay(date), style: CustomFont.headingLimaBold(),),
                                      const SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(child: 
                                            Row(
                                              children: [
                                                const Icon(Icons.login, color: Colors.green, size: 16,),
                                                const SizedBox(width: 4,),
                                                AutoSizeText(dataAbsen?.arrived??'?', 
                                                style: isLate? CustomFont.headingLimaWarning()
                                                  : CustomFont.headingLimaSemiBold(),
                                                
                                                )
                                              ],
                                            )
                                          ),
                                          Expanded(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.logout, color: Colors.red, size: 16),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                AutoSizeText(
                                                  dataAbsen?.leaved??'00:00',
                                                  style: isEarly? CustomFont.headingLimaWarning()
                                                  : CustomFont.headingLimaSemiBold(),
                                                )
                                              ]
                                            )
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6,),
                                Center(
                                    child: 
                                    dataAbsen?.jko != 'V'?
                                    SizedBox(
                                      child: Text('Libur', style: CustomFont.announcement(),),
                                    ):
                                  SizedBox(
                                    child:  (isEarly || isLate)
                                    ? const Icon(
                                      Icons.warning_amber_rounded,
                                      color:Colors.amber,
                                      weight: 12,
                                    ): const Icon(
                                        Icons.check,
                                        color:Colors.green,
                                        weight: 12,
                                    ),
                                  )
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
                )
              ])
          ),
        ],
      ),
    );
  }
}
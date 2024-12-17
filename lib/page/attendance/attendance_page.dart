import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
// ignore: depend_on_referenced_packages
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
  bool isLoading = true;

  void getData(String month) async{
    attendanceListResponse = await NetworkRequest.getAttendance(month);
    if(mounted){
      isLoading = false;
      setState(() {
        attendanceListResponse;
        monthName = CustomConverter.monthCheck(month);
      });
    }
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
      body: 
      
      isLoading?
      ShimmerLoading.listShimmer(context):
      Stack(
        children: [ 
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/joe.png'))),
          Positioned(
            top: 0,
            right: 12,
            bottom: 0,
            left: 12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 0.6,
                      color: Colors.grey
                    ),
                    color: Colors.white
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Column(
                    children: [
                      AutoSizeText('Data Absensi', style: CustomFont.headingTigaSemiBold(),),
                      const SizedBox(height: 6,),
                      Row(
                        children: [
                          InkWell(
                            onTap: ()async{
                              showMonthPicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    cancelWidget: Text('Batal', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),),
                                    confirmWidget: Text('Confirm', style: CustomFont.headingEmpatColorful(),),
                                    firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                    lastDate: DateTime.now(),
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
                                Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 0.3,
                                      color: Colors.grey
                                    ),
                                    borderRadius: BorderRadius.circular(11)
                                  ),
                                  child: Icon(
                                        Icons.calendar_month,
                                        color: CustomColor.primary(),
                                        size: 16,
                                      ),
                                ),
                                const SizedBox(width: 3,),
                                AutoSizeText(monthName, style: CustomFont.headingEmpatSemiBold()),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12,),
                      Row(
                        children: [
                        Expanded(child: Container(
                          height: 51,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green
                            ),
                            borderRadius: BorderRadius.circular(11)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText('On Time', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, minFontSize: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText('31', style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                  
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        ),
                        const SizedBox(width: 6,),
                       Expanded(child: Container(
                        height: 51,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red
                            ),
                            borderRadius: BorderRadius.circular(11)
                          ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             AutoSizeText('Telat', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, minFontSize: 6,),
                             Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText('31', style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                 
                                 ),
                               ],
                             )
                           ],
                         ),
                       ),
                       ),
                       const SizedBox(width: 6,),
                        Expanded(child: Container(
                          height: 51,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.red
                            ),
                            borderRadius: BorderRadius.circular(11)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText('Pulang Cepat', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, minFontSize: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText('31', style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                  
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        ),
                        
                      ],
                      ),
                      const SizedBox(height: 6,),
                      Row(
                        children: [
                        Expanded(child: Container(
                          height: 51,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.green
                            ),
                            borderRadius: BorderRadius.circular(11)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText('GPS', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, minFontSize: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText('31', style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                  
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        ),
                        const SizedBox(width: 6,),
                       Expanded(child: Container(
                        height: 51,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: CustomColor.primary()
                            ),
                            borderRadius: BorderRadius.circular(11)
                          ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             AutoSizeText('Cuti', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, minFontSize: 6,),
                             Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                               children: [
                                 Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText('31', style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                 ),
                               ],
                             )
                           ],
                         ),
                       ),
                       ),
                       const SizedBox(width: 6,),
                        Expanded(child: Container(
                          height: 51,
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.amber
                            ),
                            borderRadius: BorderRadius.circular(11)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText('Izin', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, minFontSize: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  AutoSizeText('31', style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                ],
                              )
                            ],
                          ),
                        ),
                        ),
                        
                      ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText('Daftar Absensi', style: CustomFont.headingEmpatSemiBold(),),
                    InkWell(
                      child: Icon(Icons.sort_rounded),
                    )
                  ],
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ListView.builder(
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
                  ),
                )
              ])
          ),
        ],
      ),
    );
  }
}
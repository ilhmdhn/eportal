import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/attendance/attendance_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
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

  List<AttendanceListModel> attendanceListResponse = [];
  String monthName = '';
  bool isLoading = true;
  DateTime selectedMonth = DateTime.now();
  bool asc = true;

  void getData(String month) async{
    final networkResponse = await NetworkRequest.getAttendance(month);
    if(mounted){
      isLoading = false;
      setState(() {
        attendanceListResponse = networkResponse.listAbsen;
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

    int onTime = 0;
    int late = 0;
    int early = 0;
    int gps = 0;
    int offDay = 0;
    int permit = 0;

    for (var value in attendanceListResponse) {
      if((value.jko??'').toLowerCase().contains('kerja')){

      }else if((value.jko??'').toLowerCase().contains('off')){

      }else if((value.jko??'').toLowerCase().contains('izin')){
        permit += 1;
      }else if((value.jko??'').toLowerCase().contains('cuti')){
        offDay += 1;
      }

      if((value.arrivalDescription??'').toLowerCase().contains('on_time')){
        onTime += 1;
      }

      if((value.arrivalDescription??'').toLowerCase().contains('late')){
        late += 1;
      }

      if((value.arrivalDescription??'').toLowerCase().contains('gps')){
        gps += 1;
      }

      if((value.leaveDescription??'').toLowerCase().contains('on_time')){
        onTime += 1;
      }

      if((value.leaveDescription??'').toLowerCase().contains('early')){
        early += 1;
      }

      if((value.leaveDescription??'').toLowerCase().contains('gps')){
        gps += 1;
      }
    }

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
                                initialDate: selectedMonth,
                                cancelWidget: Text('Batal', style: GoogleFonts.poppins(fontSize: 16, color: Colors.red),),
                                confirmWidget: Text('Confirm', style: CustomFont.headingEmpatColorful(),),
                                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now(),
                                monthPickerDialogSettings:MonthPickerDialogSettings(
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
                                  selectedMonth = date;
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
                                    child: AutoSizeText(onTime.toString(), style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                  
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
                                  child: AutoSizeText(late.toString(), style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                 
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
                                    child: AutoSizeText(early.toString(), style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                  
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
                                    child: AutoSizeText(gps.toString(), style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
                                  
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
                                  child: AutoSizeText(offDay.toString(), style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
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
                                  AutoSizeText(permit.toString(), style: CustomFont.headingLimaSemiBold(), textAlign: TextAlign.end,),
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
                      onTap: (){
                        setState(() {
                          if(asc){
                            attendanceListResponse.sort((a, b) => b.date!.compareTo(a.date!));
                          }else{
                            attendanceListResponse.sort((a, b) => a.date!.compareTo(b.date!));
                          }
                          asc = !asc;
                        });
                      },
                      child: const Icon(Icons.sort_rounded),
                    )
                  ],
                ),
                Expanded(
                    child: ListView.builder(
                      itemCount: attendanceListResponse.length,
                      itemBuilder: (BuildContext ctxList, index){
                        final dataAbsen = attendanceListResponse[index];
                        final date = dataAbsen.date??'1990-01-01';
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
                        
                        if((dataAbsen.jko??'').toLowerCase().contains('kerja')){
                          workDate = true;
                        }

                        if((dataAbsen.jko??'').toLowerCase().contains('off')){
                          holiday = true;
                        }

                        if((dataAbsen.jko??'').toLowerCase().contains('izin')){
                          permit = true;
                        }

                        if((dataAbsen.jko??'').toLowerCase().contains('cuti')){
                          offDay = true;
                        }

                        if((dataAbsen.arrivalDescription ?? '').toLowerCase().contains('late')){
                          isLate = true;
                        }

                        if((dataAbsen.arrivalDescription ?? '').toLowerCase().contains('gps')){
                          inGps = true;
                        }
                  
                        if((dataAbsen.leaveDescription??'').toLowerCase().contains('early')){
                          isEarly = true;
                        }

                        if((dataAbsen.leaveDescription??'').toLowerCase().contains('gps')){
                          outGps = true;
                        }

                        if((dataAbsen.leaveDescription??'').toLowerCase().contains('lupa')){
                          leavedForget = true;
                        }

                        if((dataAbsen.arrivalDescription??'').toLowerCase().contains('lupa')){
                          arriveForget = true;
                        }
                  
                        return InkWell(
                          onTap: (){
                            AttendanceDialog.detailAttendance(context, dataAbsen);
                          },
                          child: Container(
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
                                      workDate?
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: 
                                              Row(
                                                children: [
                                                  const Icon(Icons.login, color: Colors.green, size: 16,),
                                                  const SizedBox(width: 4,),
                                                  AutoSizeText('${arriveForget? 'Lupa Absen': dataAbsen.arrived ?? '?'} ${inGps ? '(GPS)' : ''}', 
                                                  style: isLate || arriveForget? CustomFont.headingLimaWarning(): CustomFont.headingLimaSemiBold(),
                                                )
                                              ],
                                            )
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                const Icon(Icons.logout, color: Colors.red, size: 16),
                                                const SizedBox(
                                                  width: 4,
                                                ),
                                                AutoSizeText('${leavedForget ? 'Lupa Absen' : dataAbsen.leaved??'?'} ${outGps?'(GPS)':''}',style: isEarly||leavedForget? CustomFont.headingLimaWarning(): CustomFont.headingLimaSemiBold(),
                                                )
                                              ]
                                            )
                                          ),
                                        ],
                                      ):
                                      holiday?
                                      AutoSizeText('Hari Libur', style: CustomFont.headingEmpatReject(),):
                                      offDay?
                                      AutoSizeText('Cuti', style: CustomFont.headingEmpatReject()):
                                      permit?
                                      AutoSizeText('Izin', style: CustomFont.headingEmpatWarning(),):
                                      AutoSizeText('Tidak Ada data', style: CustomFont.headingEmpatSemiBold())
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
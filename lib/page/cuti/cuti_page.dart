import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:calendar_slider/calendar_slider.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/page/add_on/animation.dart';
import 'package:eportal/page/cuti/add_cuti_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CutiPage extends StatefulWidget {
  static const nameRoute = '/cuti';
  const CutiPage({super.key});

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final int _startYear = 2000;
  final int _endYear = 2050;
  late List<String> _monthYearList;

  late PageController _pageController;
  int _currentIndex = 0;

  AttendanceListResponse? attendanceListResponse;

  @override
  void initState() async{
    super.initState();
    EasyLoading.show();
    attendanceListResponse = await NetworkRequest.getAttendance('11-2024');
    EasyLoading.dismiss();
    _monthYearList = _generateMonthYearList();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.4, // Item tengah lebih besar, sisi lebih kecil
    );
  }

  List<String> _generateMonthYearList() {
    List<String> monthYearList = [];
    for (int year = _startYear; year <= _endYear; year++) {
      for (String month in _months) {
        monthYearList.add("$month $year");
      }
    }
    return monthYearList;
  }

    @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      floatingActionButton: InkWell(
        onTap: (){
          CutiDialog.showAddCUtiDialog(context, 3);
        },
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: CustomColor.primary()
          ),
          child: Icon(Icons.add, color: Colors.white, size: 36,),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: 
            
            attendanceListResponse == null?
              SizedBox():
            attendanceListResponse?.state != true?
              Center(
                child: AutoSizeText(attendanceListResponse?.message??'')
              ):
                        
            ListView.builder(
              itemCount: attendanceListResponse?.listAbsen.length,
              itemBuilder: (BuildContext ctx, index){
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          AutoSizeText('CUT-1000AKT24112601', style: CustomFont.headingLimaSemiBold(),),
                        ],
                      ),
                      AutoSizeText('${CustomConverter.dateToMonth('2024-12-12')} - ${CustomConverter.dateToMonth('2024-12-13')}', style: CustomFont.headingLimaSemiBold(),),
                    ],
                  ),
                );
              }),
          )
          // CustomAnimation.loading()
         /* Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: ScreenSize.setHeightPercent(context, 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                    color: CustomColor.primary()
                  ),
                ),
             SizedBox(
                  height: ScreenSize.setHeightPercent(context, 10),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _monthYearList.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final isCurrent = index == _currentIndex;
                      return Center(
                        child: AnimatedOpacity(
                          opacity:
                              isCurrent ? 1.0 : 0.5, // Transparansi untuk efek fokus
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _monthYearList[index],
                            style: TextStyle(
                              fontSize: isCurrent ? 24 : 18, // Ukuran teks berubah
                              fontWeight:
                                  isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Selected: ${_monthYearList[_currentIndex]}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          ,SizedBox(
            width: ScreenSize.setWidthPercent(context, 50),
            child: Image.asset('assets/image/joe.png'),
          )*/
        ],
      ),
    );
  }
}

// ignore_for_file: depend_on_referenced_packages

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/jko_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});
  static const nameRoute = '/schedule';

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  bool isLoading = true;

  Set<JkoModel> jko = {};

  void getData()async{
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
    }

    final networkResponse = await NetworkRequest.getJko(_focusedDay);

    setState(() {
      isLoading = false;
    });

    if(isNotNullOrEmptyList(networkResponse.data)){
        initJko(networkResponse.data??[]);
    }
  }

  void addJko()async{

    final isAvailable = jko.where((data) => DateFormat('yyyy-MM').format(data.date) == DateFormat('yyyy-MM').format(_focusedDay)).toList();

    if(isNotNullOrEmptyList(isAvailable)){
      return;
    }

    EasyLoading.show();
    final networkResponse = await NetworkRequest.getJko(_focusedDay);
    EasyLoading.dismiss();

    if (isNotNullOrEmptyList(networkResponse.data)) {
      initJko(networkResponse.data ?? []);
    }
  }

  void initJko(List<JkoModel> data){
    final tempList = [...jko, ...data];
    
    setState(() {
      jko = {...tempList};
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    JkoModel? schedule = jko.firstWhereOrNull((data) => CustomConverter.dateTimeToDay(data.date) == CustomConverter.dateTimeToDay((_selectedDay??DateTime.now())));
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
              child: Image.asset('assets/image/joe.png'),
            )
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.parse('2024-09-01'),
                  lastDay: DateTime.now().add(const Duration(days: 31)),
                  locale: 'id_ID',
                  calendarFormat: _calendarFormat,
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      final text = DateFormat.E('ID'
                        
                      ).format(day);
                      return Center(
                        child: AutoSizeText(text, style: CustomFont.headingTigaSemiBold(),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.shade600
                          ),
                          child: Center(
                            child: AutoSizeText('${day.day}', style: CustomFont.headingEmpatSecondary()),
                          )
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: CustomColor.primary()
                          ),
                          child: Center(child: AutoSizeText('${day.day}', style: CustomFont.headingEmpatSecondary()),)),
                      );
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      if (jko.any((holiday) => isSameDay(holiday.date, day) && holiday.code.toLowerCase() == 'off')) {
                        return Center(child: AutoSizeText('${day.day}', style: CustomFont.headingEmpatReject()),);
                      }else if(jko.any((holiday) => isSameDay(holiday.date, day) && holiday.code.toLowerCase() == 'cuti')){
                        return Center(child: AutoSizeText('${day.day}', style: CustomFont.headingEmpatReject()),);                        
                      }else if(jko.any((holiday) => isSameDay(holiday.date, day) && holiday.code.toLowerCase() == 'libur pengganti')){
                        return Center(child: AutoSizeText('${day.day}', style: CustomFont.headingEmpatReject()),);                        
                      }
                      else if(jko.any((holiday) => isSameDay(holiday.date, day) && holiday.code.toLowerCase() == 'izin')){
                        return Center(child: AutoSizeText('${day.day}', style: CustomFont.headingEmpatWaiting()),);
                      }else{
                        return Center(child: AutoSizeText('${day.day}', style: CustomFont.headingEmpat()),);
                      }
                    },
                  ),
                  selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  onPageChanged: (focusedDay){
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                    addJko();
                  },
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    AutoSizeText(
                                    ' Hari kerja',
                                      style: CustomFont.headingEmpat(),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    AutoSizeText(
                                    ' Libur/ Cuti',
                                      style: CustomFont.headingEmpat(),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                          color: Colors.amber.shade800,
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    AutoSizeText(
                                    ' Izin',
                                      style: CustomFont.headingEmpat(),
                                    )
                                  ],
                              )
                                ],
                            )
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                          color: Colors.green.shade600,
                                          borderRadius:BorderRadius.circular(6)),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    AutoSizeText(
                                    'Hari Ini',
                                      style: CustomFont.headingEmpat(),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      width: 16,
                                      height: 16,
                                      decoration: BoxDecoration(
                                        color: CustomColor.primary(),
                                        borderRadius:BorderRadius.circular(6)),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    AutoSizeText(
                                    'Tanggal Dipilih',
                                      style: CustomFont.headingEmpat(),
                                    )
                                  ],
                                ),
                              ],
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      AutoSizeText(CustomConverter.dateTimeToDay(_selectedDay??DateTime.now()), style: CustomFont.headingEmpatSemiBold(),),
                      const SizedBox(height: 2,),
                      schedule?.code.toLowerCase() == 'kerja'?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText('Hari Kerja', style: CustomFont.headingDua()),
                          const SizedBox(height: 2,),
                          Row(
                            children: [
                              Text('Jam Kerja: ', style: CustomFont.headingEmpat(),),
                              const SizedBox(width: 3,),
                              Text('${CustomConverter.timeToString(schedule!.startTime!)} - ${CustomConverter.timeToString(schedule.endTime!)}', style: CustomFont.headingEmpat(),),
                            ],
                          ),
                        ],
                      )
                      : schedule?.code.toLowerCase() == 'off'?
                      Column(
                        children: [
                          AutoSizeText('Hari Libur', style: CustomFont.headingDuaRed(),),
                        ],
                      ):
                      schedule?.code.toLowerCase() == 'cuti'? 
                      AutoSizeText('Cuti', style: CustomFont.headingDuaRed(),):
                      schedule?.code.toLowerCase() == 'libur pengganti'? 
                      AutoSizeText('Libur Pengganti', style: CustomFont.headingDuaRed(),):
                      schedule?.code.toLowerCase() == 'izin'? 
                      AutoSizeText('Izin Tidak Masuk', style: CustomFont.headingDuaYellow(),):
                      AutoSizeText('Jadwal Kerja Belum Diupload', style: CustomFont.headingEmpat(),)
                    ],
                  ),
                )
              ],
            )
          )
        ],
      ),
    );
  }
}
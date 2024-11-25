import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

class AttendancePage extends StatefulWidget {
  static const nameRoute = '/attendance';
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
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
                  height: ScreenSize.setHeightPercent(context, 17),
                  decoration: BoxDecoration(
                    color: CustomColor.primary(),
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
                  ),
                  child: Column(
                    children: [
                      AutoSizeText('Data Absensi', style: CustomFont.headingTigaSemiBoldSecondary(),),
                      AutoSizeText('November 2024', style: CustomFont.headingTigaSemiBoldSecondary(),),
                      GroupButton(
                        isRadio: true,
                        buttonBuilder: (selected, value, context) {
                          return Badge.count(
                            count: 1,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Text(value),
                            ),
                          );
                        },
                        buttons: const ['All', 'Tepat Waktu','Cuti', 'Sakit', 'Izin','Terlambat'],
                      )
                    ],
                  ),
                ),

                Container(
                  height: ScreenSize.setHeightPercent(context, 80),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    itemCount: 30,
                    itemBuilder: (BuildContext ctxList, index){
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
                                  child: Center(child: Text('01', style: CustomFont.headingTigaSemiBold(),)),
                                ),
                                const SizedBox(width: 6,),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      AutoSizeText('Senin, 12 Agustus 2024', style: CustomFont.headingLimaBold(),),
                                      const SizedBox(height: 10,),
                                      Row(
                                        children: [
                                          Expanded(child: 
                                          Row(
                                            children: [
                                              const Icon(Icons.login, color: Colors.green, size: 16,),
                                              const SizedBox(width: 4,),
                                              AutoSizeText('07:53', style: CustomFont.headingLimaSemiBold(),)
                                            ],
                                          )),
                                          Expanded(child: Row(
                                            children: [
                                              const Icon(Icons.logout, color: Colors.red, size: 16),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                                                                            AutoSizeText(
                                                '17:35',
                                                style:
                                                    CustomFont.headingLimaSemiBold(),
                                              )
                                            ]
                                          )),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6,),
                                Container(
                                    height: 36,
                                    width: 36,
                                    decoration: BoxDecoration(
                                        // color: Colors.lightBlue.shade50,
                                        borderRadius:
                                            BorderRadius.circular(18)),
                                    child: const Center(
                                        child: Icon(Icons.check, color: Colors.green, weight: 12,)),
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
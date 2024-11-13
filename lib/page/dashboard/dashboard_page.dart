import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/add_on/button.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardPage extends StatefulWidget {
  static const nameRoute = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              ElevatedButton(onPressed: () {}, child: Text('Menu')),
            ],
          ),
        ),
        backgroundColor: CustomColor.background(),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: ScreenSize.setHeightPercent(context, 45),
                      child: Stack(
                        children: [
                          Container(
                            height: ScreenSize.setHeightPercent(context, 25),
                            width: ScreenSize.setWidthPercent(context, 100),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    bottomRight: Radius.elliptical(30, 20),
                                    bottomLeft: Radius.elliptical(30, 20)),
                                color: CustomColor.primary()),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 41,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipOval(
                                        child: SizedBox.fromSize(
                                          size: const Size.fromRadius(31),
                                          child: Image.network(
                                            'https://img.freepik.com/free-photo/smiling-young-male-professional-standing-with-arms-crossed-while-making-eye-contact-against-isolated-background_662251-838.jpg?semt=ais_hybrid',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Flexible(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AutoSizeText(
                                              'Muhammad Ferry Julyo',
                                              style: CustomFont.dashboardName(),
                                              overflow: TextOverflow.clip,
                                            ),
                                            AutoSizeText(
                                              'Eksekutif Programmer Ngebug',
                                              style: CustomFont
                                                  .dashboardPosition(),
                                              overflow: TextOverflow.clip,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: ScreenSize.setHeightPercent(context, 21),
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 8, right: 8, bottom: 8, top: 4),
                                height: ScreenSize.setHeightPercent(context, 23),
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                width: double.maxFinite,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          blurRadius: 0.5,
                                          color: Colors.grey.shade400)
                                    ],
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        AutoSizeText('Pengumuman', style: CustomFont.announcement()),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: AutoSizeText("Jadwal senam hari jum'at group A. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled", style: CustomFont.headingEmpat(), minFontSize: 14, textAlign: TextAlign.justify, overflow: TextOverflow.ellipsis, maxLines: 3,),
                                          )),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(height: 61, width: 61, child: Image.asset('assets/icon/announcement.png')),
                                            AutoSizeText('12 November 2024', style: CustomFont.announcementDate(),)
                                          ],
                                        )
                                      ],
                                    ),
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: ScreenSize.setHeightPercent(context, 36),
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                          BoxShadow(
                              blurRadius: 1, color: Colors.grey.shade400)
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Padding( padding: const EdgeInsets.only(left: 20),
                          //   child: Align(
                          //     alignment: Alignment.centerLeft,
                          //     child: AutoSizeText(
                          //       'Employee Menu',
                          //       style: CustomFont.menuTitle(),
                          //     ),
                          //   ),
                          // ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/attendance.png', 'Absensi'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/location_attendance.png',
                                    'Absensi GPS'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/cuti.png', 'Cuti'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/ijin.png', 'Ijin'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/overtime.png', 'Lembur'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/attendance.png',
                                    'Libur Pengganti'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/opd.png', 'OPD'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    'assets/icon/bpd.png', 'BPD'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AddOnButton.textImageButton(
                                  'assets/icon/salary.png', 'Slip Gaji'),
                              AddOnButton.textImageButton(
                                  'assets/icon/ssp.png', 'SSP'),
                              AddOnButton.textImageButton(
                                  'assets/icon/calendar.png', 'Jadwal Kerja'),
                              AddOnButton.textImageButton(
                                  'assets/icon/other.png', 'Lain lain'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 21,),
                    Container(
                      height: ScreenSize.setHeightPercent(context, 20),
                      width: double.maxFinite,
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                         borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(blurRadius: 1, color: Colors.grey.shade400)
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Activity', style: CustomFont.activityTitle(),),
                              Text('View More', style: CustomFont.activityTitle(),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12,)
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Builder(builder: (ctxDrawer) {
                    return IconButton(
                        onPressed: () {
                          Scaffold.of(ctxDrawer).openDrawer();
                        },
                        icon: const Icon(
                          Icons.menu,
                          color: Colors.white,
                        ));
                  }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Badge.count(
                        count: 3,
                        child: Icon(
                          Icons.notifications,
                          color: Colors.white
                        )),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

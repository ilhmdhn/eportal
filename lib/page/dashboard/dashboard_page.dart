import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/add_on/button.dart';
import 'package:eportal/page/dialog/view_notif_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/dummy.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardPage extends StatefulWidget {
  static const nameRoute = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final notificationDialog = NotificationDialog();
  bool biometricState = false;
  bool darkMode = false;
  List<String> getPhotos = DummyData.getImage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipOval(
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(24),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  'Mohammad Ferry Julyo',
                                  style: CustomFont.drawerName(),
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                ),
                                AutoSizeText(
                                  'View Profile',
                                  style: CustomFont.drawerViewProfile(),
                                  overflow: TextOverflow.clip,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      Container(
                        color: Colors.grey.shade400,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 1,
                        width: double.infinity,
                      ),
                      InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AutoSizeText('Autentikasi Biometrik', style: CustomFont.headingEmpat(),),
                              SizedBox(
                                height: 36,
                                width: 36,
                                child: Checkbox(value: biometricState,
                                activeColor: Colors.blue,
                                onChanged: (value){
                                  setState(() {
                                    biometricState = value??false;
                                  });
                                }),
                              )
                            ],
                          ),
                        ),
                      Container(
                        color: Colors.grey.shade400,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 1,
                        width: double.infinity,
                      ),
                      InkWell(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AutoSizeText(
                              'Mode Gelap',
                              style: CustomFont.headingEmpat(),
                            ),
                            SizedBox(
                              height: 36,
                              child: Transform.scale(
                                scale: 0.75,
                                child: Switch(
                                    value: darkMode,
                                    activeColor: Colors.blue.shade800,
                                    inactiveTrackColor: Colors.grey.shade300,
                                    activeTrackColor: CustomColor.secondaryColor(),
                                    onChanged: (value) {
                                      setState(() {
                                        darkMode = value;
                                      });
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.shade400,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 1,
                        width: double.infinity,
                      ),         
                    ],
                  ),
                  Container(
                    child: Row(
                      children: [
                        const Icon(Icons.logout, size: 36, color: Colors.red,),
                        Text("Keluar", style: CustomFont.headingTiga(),),
                      ],
                    ),
                  )
                ],
              ),
            ),
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
                                              'Mohammad Ferry Julyo',
                                              style: CustomFont.dashboardName(),
                                              overflow: TextOverflow.clip,
                                            ),
                                            AutoSizeText(
                                              'Eksekutif Programmer',
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
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      width: double.maxFinite,
                                      height: 30,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DefaultTextStyle(
                                            style: CustomFont.dashboardPosition(),
                                            child: AnimatedTextKit(
                                              repeatForever: true,
                                              animatedTexts: [
                                                RotateAnimatedText(
                                                    'Absen Hari ini'),
                                                RotateAnimatedText(
                                                    'Jam masuk: 08:15'),
                                                RotateAnimatedText(
                                                    'Kedatangan: 07:53'),
                                              ],
                                              onTap: () {
                                                print("Tap Event");
                                              },
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 6,
                                          ),
                                          Animate(
                                            onPlay: (controller) => controller.repeat(period: const Duration(seconds: 3),),
                                            effects: const [FadeEffect()],
                                            child:  SizedBox(
                                                  height: 26,
                                                  width: 26,
                                                  child: Image.asset(
                                                      'assets/icon/checkin.png')),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: ScreenSize.setHeightPercent(context, 3),)
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: ScreenSize.setHeightPercent(context, 21),
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8, top: 4),
                                height:
                                    ScreenSize.setHeightPercent(context, 23),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoSizeText('Pengumuman',
                                        style: CustomFont.announcement()),
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AutoSizeText(
                                        "Jadwal senam hari jum'at minggu ini group A. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled",
                                        style: CustomFont.headingEmpat(),
                                        minFontSize: 14,
                                        textAlign: TextAlign.justify,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                      ),
                                    )),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                            height: 61,
                                            width: 61,
                                            child: Image.asset(
                                                'assets/icon/announcement.png')),
                                        AutoSizeText(
                                          '12 November 2024',
                                          style: CustomFont.announcementDate(),
                                        )
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
                          BoxShadow(blurRadius: 1, color: Colors.grey.shade400)
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
                                child: AddOnButton.textImageButton(context,
                                    'assets/icon/attendance.png', 'Absensi'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    context,
                                    'assets/icon/location_attendance.png',
                                    'Absensi GPS'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    context, 'assets/icon/cuti.png', 'Cuti'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    context, 'assets/icon/ijin.png', 'Ijin'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(context,
                                    'assets/icon/overtime.png', 'Lembur'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    context,
                                    'assets/icon/attendance.png',
                                    'Libur Pengganti'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    context, 'assets/icon/opd.png', 'OPD'),
                              ),
                              Flexible(
                                flex: 1,
                                child: AddOnButton.textImageButton(
                                    context, 'assets/icon/bpd.png', 'BPD'),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AddOnButton.textImageButton(context,
                                  'assets/icon/salary.png', 'Slip Gaji'),
                              AddOnButton.textImageButton(
                                  context, 'assets/icon/ssp.png', 'SSP'),
                              AddOnButton.textImageButton(context,
                                  'assets/icon/calendar.png', 'Jadwal Kerja'),
                              AddOnButton.textImageButton(context,
                                  'assets/icon/other.png', 'Lain lain'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Container(
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
                              Text(
                                'Gallery Activities',
                                style: CustomFont.activityTitle(),
                              ),
                              // Text(
                              //   'View More',
                              //   style: CustomFont.activityTitle(),
                              // ),
                            ],
                          ),
                          const SizedBox(height: 8,),
                          CarouselSlider.builder(
                          itemCount: getPhotos.length,
                          options: CarouselOptions(
                            initialPage: 0,
                            // enlargeCenterPage: true,
                            height: ScreenSize.setHeightPercent(context, 20),
                            enlargeFactor: 0.3,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            autoPlay: true,
                            aspectRatio: 16/9,
                          ),
                          itemBuilder: (BuildContext ctxCarousel, int index,int pvIndex) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(9),                                
                            child: Image.network(getPhotos[index]),
                          );
                          },),
                                                    const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SizedBox(
                      width: ScreenSize.setWidthPercent(context, 50),
                      child: Image.asset('assets/image/hp_group.png')),
                    const SizedBox(height: 20,)
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
                  InkWell(
                    onTap: (){
                      notificationDialog.showNotificationOverlay(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Badge.count(
                          count: 3,
                          child: const Icon(Icons.notifications, color: Colors.white)),
                    ),
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

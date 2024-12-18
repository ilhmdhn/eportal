import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/overtime_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/lembur/lembur_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OvertimePage extends StatefulWidget {
  static const nameRoute = '/overtime';
  const OvertimePage({super.key});

  @override
  State<OvertimePage> createState() => OvertimePageState();
}

class OvertimePageState extends State<OvertimePage> {

  bool isLoading = true;
  List<OvertimeModel> listOvertime = [];
  void getData()async{
    if(isLoading != true){
      setState(() {
        isLoading = false;
      });
    }
    final networkResponse = await NetworkRequest.getOvertime();
    setState(() {
      isLoading = false;
    });
    if(isNotNullOrEmptyList(networkResponse.data)){
      setState(() {
        listOvertime = networkResponse.data!;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: isLoading? 
      ShimmerLoading.listShimmer(context): 
      Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/joe.png'),
            )),
          Positioned(
            top: 6,
            left: 12,
            right: 12,
            bottom: 6,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(
                      width: 0.3,
                      color: Colors.grey
                    )
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: SizedBox()),
                          AutoSizeText('Data Lembur', style: CustomFont.headingTigaSemiBold(),),
                          Expanded(
                            flex: 1,
                            child: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 0.3, color: Colors.grey),
                                      borderRadius: BorderRadius.circular(3)
                                    ),
                                    child: InkWell(
                                      onTap: (){
                                        OvertimeDialog.showOvertimeDialog(context);
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(Icons.add, size: 16, ),
                                          AutoSizeText('Ajukan', style: CustomFont.standartFont(),)
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12,),
                Expanded(
                  child: ListView.builder(
                    itemCount: listOvertime.length,
                    itemBuilder: (ctxList, index){
                      final data = listOvertime[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.3,
                            color: Colors.grey,
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: InkWell(
                          onTap: (){
                            OvertimeDialog.showOvertimeDetail(context, data);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(CustomConverter.dateTimeToDay(data.date), style: CustomFont.headingLimaSemiBold()),
                                  const SizedBox(height: 6,),
                                  Row(
                                    children: [
                                      AutoSizeText(CustomConverter.time(data.startTime), style: GoogleFonts.poppins(fontSize: 13, color: CustomColor.fontStandart(), fontWeight: FontWeight.w500),),
                                      Text(' - ', style: GoogleFonts.poppins(fontSize: 13, color: CustomColor.fontStandart(), fontWeight: FontWeight.w500)),
                                      AutoSizeText(CustomConverter.time(data.finishTime), style: GoogleFonts.poppins(fontSize: 13, color: CustomColor.fontStandart(), fontWeight: FontWeight.w500)),
                                    ],
                                  )
                                ],
                              ),
                              data.state == 2?
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.approval, color: Colors.green.shade800, size: 19),
                                  Text('Disetujui', style: GoogleFonts.poppins(fontSize: 14, color: Colors.green.shade800, fontWeight: FontWeight.w600))
                                ],
                              ):
                              data.state == 1?
                              Column(

                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.wifi_protected_setup_rounded, size: 19, color: Colors.amber.shade800,),
                                  Text('Menunggu', style: GoogleFonts.poppins(fontSize: 14, color: Colors.amber.shade800, fontWeight: FontWeight.w600))
                                ],
                              ):
                              data.state == 3?
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Icon(Icons.cancel_outlined, color: Colors.red.shade800, size: 19),
                                  Text('Ditolak', style: GoogleFonts.poppins(fontSize: 14, color: Colors.red.shade800, fontWeight: FontWeight.w600))
                                ],
                              ):
                              SizedBox()
                            ],
                          ),
                        ),
                      );
                    }
                  )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
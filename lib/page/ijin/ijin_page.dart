import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/izin_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/cuti/cuti_dialog.dart';
import 'package:eportal/page/ijin/ijin_dialog.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

class IjinPage extends StatefulWidget {
  static const nameRoute = '/ijin';
  const IjinPage({super.key});

  @override
  State<IjinPage> createState() => _IjinPageState();
}

class _IjinPageState extends State<IjinPage> {
  
  List<IzinListModel> izinList = [];
  bool isLoading = true;

  void getData() async{
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
  }    
    final networkResponse = await NetworkRequest.getIzin();
    
    setState(() {
      isLoading = false;
      izinList = networkResponse.data??[];
    });
  }

  void refreshData() async {
    EasyLoading.show();
    final networkResponse = await NetworkRequest.getIzin();
    EasyLoading.dismiss();
    setState(() {
      izinList = networkResponse.data??[];  
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose(){
    if(EasyLoading.isShow){
      EasyLoading.dismiss();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }
  
  @override
  Widget build(BuildContext context) {

    int approve = 0;
    int waiting = 0;
    int reject = 0;
    int cancel = 0;

    for (var value in izinList) {
      if(value.state == 1){
        waiting += value.finishDate!.difference(value.startDate!).inDays + 1;
      }else if(value.state == 2){
        approve += value.finishDate!.difference(value.startDate!).inDays + 1;
      }else if(value.state == 3){
        reject += value.finishDate!.difference(value.startDate!).inDays + 1;
      }else if(value.state == 4){
        cancel += value.finishDate!.difference(value.startDate!).inDays + 1;
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.background(),
        body: Stack(
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
              top: 6,
              right: 12,
              bottom: 6,
              left: 12,
              child: 
              isLoading?
              ShimmerLoading.listShimmer(context):
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border:
                            Border.all(width: 0.3, color: Colors.grey)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(flex: 1, child: SizedBox()),
                            AutoSizeText(
                              'Data Izin',
                              style: CustomFont.headingTigaSemiBold(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.3,
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                      child: InkWell(
                                        onTap: () async {
                                          final refresh = await IjinDialog.showIjinDialog(context);
                                          if(refresh){
                                            refreshData();
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.add,
                                              size: 16,
                                            ),
                                            AutoSizeText(
                                              'Ajukan',
                                              style: CustomFont
                                                  .standartFont(),
                                            )
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
                        const SizedBox(height: 6,),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.green.shade600
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: AutoSizeText('Disetujui', style: CustomFont.headingLimaGreen(), maxLines: 1, minFontSize: 1,)
                                  ),
                                  const SizedBox(height: 4,),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(approve.toString(), style: CustomFont.headingLimaGreen(),)
                                  )
                                ],
                              ),
                            )
                          ),
                          const SizedBox(width: 6,),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.amber.shade900
                                ),
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white,
                              ),
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: AutoSizeText('Menunggu', style: CustomFont.headingLimaYellow(), maxLines: 1, minFontSize: 1,)
                                  ),
                                  const SizedBox(height: 4,),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(waiting.toString() , style: CustomFont.headingLimaYellow(),)
                                  )
                                ],
                              ),
                            )
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                            child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.6,
                                  color: Colors.red.shade600
                                ),
                                borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: AutoSizeText('Ditolak', style: CustomFont.headingLimaRed(), maxLines: 1, minFontSize: 1)
                                ),
                                const SizedBox(height: 4,),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(reject.toString(), style: CustomFont.headingLimaRed(),)
                                ),
                              ],
                            ),
                          )),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                              child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 3),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 0.6,
                                  color: Colors.red.shade600),
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: AutoSizeText('Batal', style: CustomFont.headingLimaRed(), maxLines: 1, minFontSize: 1,)),
                                const SizedBox(
                                  height: 4,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    cancel.toString(),
                                    style: CustomFont.headingLimaRed(),
                                  )
                                ),
                              ],
                            ),
                          )),
                        ],
                      ),
                      const SizedBox(height: 6,),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: izinList.length,
                      itemBuilder: (BuildContext ctxList, int index){
                        IzinListModel data = izinList[index];
                        return InkWell(
                          onTap: ()async{
                            final refresh = await IjinDialog.showIzinDetail(context, data);
                            if(refresh){
                              refreshData();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            margin: const EdgeInsets.only(bottom: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.3,
                                color: Colors.black
                              ),
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          data.type == 1?
                                          'Izin Terlambat':
                                          data.type == 2?
                                          'Izin Pulang Cepat':
                                          data.type == 3?
                                          'Izin Keluar Kantor':
                                          data.type == 4?
                                          'Izin Tidak Masuk Kerja':
                                          data.type == 5?
                                          'Izin Sakit':
                                          data.type == 6?
                                          'Izin Lain':
                                          data.type == 7?
                                          'Izin Menikah':
                                          data.type == 8?
                                          'Izin Melahirkan':
                                          'Izin tidak diketahui',
                                          style: CustomFont.headingEmpatSemiBold(), maxLines: 1,
                                        ),
                                        AutoSizeText(CustomConverter.dateToDay(data.startDate.toString(),), style: CustomFont.headingLima(), maxLines: 1,),
                                      ],
                                    ),                                 
                                    Text(data.state == 1?' Menunggu': data.state == 2? ' Disetujui': data.state == 3? 'Ditolak' : data.state == 4?'Dibatalkan':'', 
                                    style:  data.state == 1? CustomFont.headingEmpatWaiting():
                                            data.state == 2? CustomFont.headingEmpatApprove():
                                            data.state == 3? CustomFont.headingEmpatReject():
                                            data.state == 4? CustomFont.headingEmpatReject():
                                            GoogleFonts.poppins(fontSize: 16, color:Colors.black)
                                    ),
                                 
                                  ],
                                ),
                                Text(data.reason??'', style: CustomFont.headingLima(), maxLines: 1, overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          ),
                        );
                      }),
                  ),      
                ],
              )
            )
          ],
        ),
      ));
  }
}
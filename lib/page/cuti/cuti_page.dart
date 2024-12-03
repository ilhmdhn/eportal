import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/cuti_response.dart';
import 'package:eportal/page/cuti/cuti_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CutiPage extends StatefulWidget {
  static const nameRoute = '/cuti';
  const CutiPage({super.key});

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {



  CutiResponse? _cutiResponse;

  void getData()async{
    EasyLoading.show();
    _cutiResponse = await NetworkRequest.getCuti();
    EasyLoading.dismiss();
    setState(() {
      _cutiResponse;
    });
  }

  @override
  void initState(){
    super.initState();
    getData();
  }


    @override
  void dispose() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      floatingActionButton: InkWell(
        onTap: (){
          CutiDialog.showAddCUtiDialog(context, _cutiResponse?.data?.cutiRemaining??0);
        },
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            color: CustomColor.primary()
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 36,),
        ),
      ),
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
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  height: ScreenSize.setHeightPercent(context, 10),
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: CustomColor.primary(),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Cuti', style: CustomFont.headingTigaSemiBoldSecondary(),),
                      Row(
                        children: [
                          Text('Sisa Cuti : ${_cutiResponse?.data?.cutiRemaining??12}', style: CustomFont.headingEmpatSecondary(),),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cutiResponse?.data?.listCuti?.length??0,
                    itemBuilder: (BuildContext ctxList, int index){
                      CutiListModel data = _cutiResponse!.data!.listCuti![index];
                      return InkWell(
                        onTap: (){
                          CutiDialog.detailCutiDialog(context, data);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AutoSizeText(DateFormat('dd/MM/yyy').format(data.startCuti), style: CustomFont.headingLimaSemiBold(),),
                                  AutoSizeText('mulai cuti: ${CustomConverter.dateToDay(data.startCuti.toString())}', style: CustomFont.headingLima(),),
                                  AutoSizeText('selesai cuti: ${CustomConverter.dateToDay(data.endCuti.toString())}', style: CustomFont.headingLima())
                                ],
                              ),
                              SizedBox(
                                child: Text(
                                  '${data.state == 1?'Menunggu' : data.state == 2? 'Disetujui': 'Ditolak'}',
                                  style: GoogleFonts.poppins(
                                    
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/izin_response.dart';
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
  
  IzinResponse networkResponse = IzinResponse();

  void getData() async{
    EasyLoading.show();
    networkResponse = await NetworkRequest.getIzin();
    setState(() {
      networkResponse;
    });
    EasyLoading.dismiss();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: InkWell(
          onTap: () {
            IjinDialog.showIjinDialog(context);
          },
          child: Container(
            margin: const EdgeInsets.only(right: 12, bottom: 12),
            decoration: CustomContainer.buttonPrimary(),
            child: const Icon(Icons.add, color: Colors.white, size: 40,),
          )),
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
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: networkResponse.data?.length??0,
                      itemBuilder: (BuildContext ctxList, int index){
                        IzinListModel data = networkResponse.data![index];
                        return InkWell(
                          onTap: (){
                            IjinDialog.showIzinDetail(context, data);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                            margin: const EdgeInsets.only(bottom: 6, left: 9, right: 9),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AutoSizeText(
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
                                    ),
                                    AutoSizeText(CustomConverter.dateToDay(data.startDate.toString(),), style: CustomFont.standartFont(), maxLines: 1,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Status:', style: CustomFont.headingEmpat(),),
                                    Text(data.state == 1?' Menunggu': data.state == 2? ' Disetujui': data.state == 3? 'Ditolak' : data.state == 4?'Dibatalkan':'', 
                                    style:  data.state == 1? GoogleFonts.poppins(fontSize: 16, color: Colors.yellow.shade700):
                                            data.state == 2? GoogleFonts.poppins(fontSize: 16, color: Colors.green):
                                            data.state == 3? GoogleFonts.poppins(fontSize: 16, color: Colors.red):
                                            data.state == 4? GoogleFonts.poppins(fontSize: 16, color: Colors.red):
                                            GoogleFonts.poppins(fontSize: 16, color:Colors.black)
                                    ),
                                  ],
                                )
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
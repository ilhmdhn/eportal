import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/cuti_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/cuti/cuti_dialog.dart';
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


  bool isLoading = true;
  CutiDetail? _cutiDetail;

  void getData()async{
    
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
    }

    final networkResponse = await NetworkRequest.getCuti();
    _cutiDetail = networkResponse.data;

    setState(() {
      _cutiDetail = networkResponse.data;
      isLoading = false;
    });
  }

  @override
  void initState(){
    super.initState();
    getData();
  }


  void refreshData()async{
    EasyLoading.show();

    final refreshResponse = await NetworkRequest.getCuti();

    if(refreshResponse.state){
      setState(() {
        _cutiDetail = refreshResponse.data;
      });
    }

    EasyLoading.dismiss();
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

    int approve = 0;
    int waiting = 0;
    int reject = 0;

    _cutiDetail?.listCuti?.forEach((value){
      if(value.state == 1){
        waiting += value.day;
      }else if(value.state == 2){
        approve += value.day;
      }else if(value.state == 3){
        reject += value.day;
      }
    });

    return Scaffold(
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
            left: 12,
            bottom: 6,
            right: 12,
            child: 
            
            isLoading?
            ShimmerLoading.listShimmer(context):
            Column(
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
                          AutoSizeText('Data Cuti', style: CustomFont.headingTigaSemiBold(),),
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
                                      onTap: ()async{
                                        final refresh = await CutiDialog.showAddCUtiDialog(context, _cutiDetail?.cutiRemaining??0);
                                        if(refresh){
                                          refreshData();
                                        }
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
                                    child: Text('Disetujui', style: CustomFont.headingLimaGreen(),)
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
                                    child: Text('Menunggu', style: CustomFont.headingLimaYellow(),)
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
                                  child: Text('Ditolak', style: CustomFont.headingLimaRed(),)
                                ),
                                const SizedBox(height: 4,),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(reject.toString(), style: CustomFont.headingLimaRed(),)
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
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _cutiDetail?.listCuti?.length??0,
                    itemBuilder: (BuildContext ctxList, int index){
                      CutiListModel data = _cutiDetail!.listCuti![index];
                      return InkWell(
                        onTap: ()async {
                          final edit = await CutiDialog.detailCutiDialog(context, data);
                          if(edit){
                            if(context.mounted){
                              final refresh = await CutiDialog.editCutiDialog(context, data);
                              if(refresh){
                                refreshData();
                              }
                            }
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(width: 0.3, color: Colors.black),
                            borderRadius: BorderRadius.circular(12)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(CustomConverter.dateToDay(data.startCuti.toString()), style: CustomFont.headingLimaSemiBold(),),
                                      AutoSizeText('Lama cuti: ${data.day} hari', style: CustomFont.headingLima(),),
                                    ],
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      child: AutoSizeText(
                                        data.state == 1?'Menunggu' : data.state == 2? 'Disetujui': 'Ditolak',
                                        style: 
                                        data.state == 1? CustomFont.headingEmpatWaiting():
                                        data.state == 2? CustomFont.headingEmpatApprove():
                                        data.state == 3? CustomFont.headingEmpatReject():CustomFont.headingEmpatReject(),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Text(data.cutiReason, style: CustomFont.headingLima(), maxLines: 1, overflow: TextOverflow.ellipsis,),
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

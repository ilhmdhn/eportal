import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/substitution_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/lipeng/substitute_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SubstitutePage extends StatefulWidget {
  static const nameRoute = '/substitute';
  const SubstitutePage({super.key});

  @override
  State<SubstitutePage> createState() => _SubstitutePageState();
}

class _SubstitutePageState extends State<SubstitutePage> {

  bool isLoading = true;
  
  List<SubstitutionModel> listLipeng = [];

  void getData()async{
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
    }

    final networkResponse = await NetworkRequest.getLipeng();

    if(networkResponse.state){
      listLipeng = networkResponse.data??[];
    }

    setState(() {
      listLipeng;
      isLoading = false;
    });
  }

  void refreshData()async{
    EasyLoading.show();

    final networkResponse = await NetworkRequest.getLipeng();
    setState(() {
      listLipeng = networkResponse.data??[];
    });

    EasyLoading.dismiss();
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

    for (var value in listLipeng) {
      if(value.state == 1){
        waiting += 1;
      }else if(value.state == 2){
        approve += 1;
      }else if(value.state == 3){
        reject += 1;
      }
    }

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
            )
          ),
          Positioned(
            bottom: 6,
            right: 12,
            top: 6,
            left: 12,
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
                          AutoSizeText('Data Libur Pengganti', style: CustomFont.headingTigaSemiBold(),),
                          Expanded(
                            flex: 1,
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
                                    onTap: ()async {
                                      final refresh = await SubstituteDialog.showAddLipengDialog(context);
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
                const SizedBox(height: 12,),
                Expanded(
                  child: ListView.builder(
                    itemCount: listLipeng.length,
                    itemBuilder: (ctxList, index){
                      final data = listLipeng[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        margin: const EdgeInsets.only(bottom: 3),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 0.3,
                            color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        child: InkWell(
                          onTap: (){
                            SubstituteDialog.showDetailLipengDialog(context, data);
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(CustomConverter.dateTimeToDay(data.dateFurlough), style: CustomFont.headingEmpatSemiBold(),),
                                  ),
                                  data.state == 1 ? Text('Menunggu', style: CustomFont.headingEmpatWaiting()):
                                  data.state == 2 ? Text('Disetujui', style: CustomFont.headingEmpatApprove()):
                                  data.state == 3 ? Text('Ditolak', style: CustomFont.headingEmpatReject()):
                                  const SizedBox()
                                ],
                              ),
                              Text(data.reason, style: CustomFont.headingLima(), maxLines: 1, overflow: TextOverflow.ellipsis,)
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
}
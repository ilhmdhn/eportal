import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/ssp_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/ssp/ssp_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SspPage extends StatefulWidget {
  const SspPage({super.key});
  static const nameRoute = '/ssp';

  @override
  State<SspPage> createState() => _SspPage();
}

class _SspPage extends State<SspPage> {

  List<SspModel> listData = [];
  SspValue? value;
  bool isLoading = true;

  void getData()async{
    if(!isLoading){
      setState(() {
        isLoading = true;
      });
    }

    final networkResponse = await NetworkRequest.getSsp();
    
    setState(() {
      isLoading = false;
    });
    
    if(isNotNullOrEmptyList(networkResponse.data)){
      setState(() {
        value = networkResponse.value;
        listData = networkResponse.data??[];
      });
    }
  }

  void refreshData() async {

    EasyLoading.show();

    final networkResponse = await NetworkRequest.getSsp();

    EasyLoading.dismiss();

    if (isNotNullOrEmptyList(networkResponse.data)) {
      setState(() {
        listData = networkResponse.data ?? [];
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
          isLoading?
          ShimmerLoading.listShimmer(context):
          Positioned(
            top: 6,
            right: 12,
            bottom: 12,
            left: 6,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 6
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 0.3,
                      color: Colors.black,
                    )
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: SizedBox()
                      ),
                      AutoSizeText('Data SSP', style: CustomFont.headingTigaSemiBold(),),
                      Expanded(
                        flex: 1,
                        child:Row(
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
                                  final isRefresh = await SspDialog.addSsp(context, value);
                                  if(isRefresh){
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
                ),
                const SizedBox(height: 12,),
                Expanded(
                  child: ListView.builder(
                    itemCount: listData.length,
                    itemBuilder: (BuildContext ctxList, int index){
                      final data = listData[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            width: 0.3,
                            color: Colors.black
                          ),
                          borderRadius: BorderRadius.circular(12)
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8
                        ),
                        child: InkWell(
                          onTap: ()async{
                            final result = await SspDialog.detailSsp(context, data);
                            if(result){
                              if(context.mounted){
                              final refresh = await SspDialog.editSsp(context, data);
                                if (refresh) {
                                  refreshData();
                                }
                              }

                            }
                          },
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AutoSizeText(
                                          data.type == 1? 'Pernikahan':
                                          data.type == 2? 'Kelahiran':
                                          data.type == 3? 'Kematian Keluarga':
                                          data.type == 4? 'Kematian Orang Tua':''
                                        , style: CustomFont.headingEmpatSemiBold(),),
                                        AutoSizeText(CustomConverter.dateTimeToDay(data.releaseDate), style: CustomFont.headingLimaSemiBold(),),
                                        isNotNullOrEmpty(data.note)? Text(data.note, style: CustomFont.headingLima(), overflow: TextOverflow.ellipsis,): const SizedBox()
                                      ],
                                    ),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: 
                                    data.state == 1? Text('Menunggu', style: CustomFont.headingEmpatWaiting(),):
                                    data.state == 2? Text('Disetujui', style: CustomFont.headingEmpatApprove(),):
                                    data.state == 3? Text('Ditolak', style: CustomFont.headingEmpatReject(),): const SizedBox()
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ))
              ],
            )
          )
        ],
      ),
    );
  }
}
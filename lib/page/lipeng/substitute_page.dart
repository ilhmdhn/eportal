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
            )
          ),
          Positioned(
            bottom: 6,
            right: 12,
            top: 6,
            left: 12,
            child: listLipeng.isEmpty?
              const SizedBox():
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
                                    onTap: (){
                                      SubstituteDialog.showAddLipengDialog(context);
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(CustomConverter.dateTimeToDay(data.dateFurlough), style: CustomFont.headingLimaSemiBold(),),
                                      Text(data.reason, style: CustomFont.standartFont(), maxLines: 1, overflow: TextOverflow.ellipsis,)
                                    ],
                                  ),
                                ),
                                data.state == 1 ?
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Icon(Icons.filter_list_alt, color: Colors.yellow.shade900,),
                                      Text('Menunggu', style: CustomFont.headingLimaWarning())
                                    ],
                                  ),
                                ):
                                data.state == 2 ?
                                SizedBox(
                                  child: Column(
                                    children: [
                                      Icon(Icons.check, color: Colors.green.shade900,),
                                      Text('Disetujui', style: CustomFont.headingLimaWarning())
                                    ],
                                  ),
                                ):
                                data.state == 3 ?
                                Column(
                                  children: [
                                    Icon(Icons.close, color: Colors.red.shade900,),
                                    Text('Ditolak', style: CustomFont.headingLimaWarning())
                                  ],
                                ):
                                const SizedBox()
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
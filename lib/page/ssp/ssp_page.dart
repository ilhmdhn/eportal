import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/ssp_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/ssp/ssp_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
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
          Expanded(
            child: ShimmerLoading.listShimmer(context)
          ):
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
                                    SspDialog.addSsp(context);
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
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 0,
                    itemBuilder: (BuildContext ctxList, int index){
                      return Container(
                        
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
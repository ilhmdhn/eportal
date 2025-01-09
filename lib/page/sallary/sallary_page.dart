import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/sallary_response.dart';
import 'package:eportal/page/add_on/loading.dart';
import 'package:eportal/page/dialog/viewer_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/biometric.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SallaryPage extends StatefulWidget {
  const SallaryPage({super.key});
  static const nameRoute = '/sallary';
  
  @override
  State<SallaryPage> createState() => _SallaryPageState();
}

class _SallaryPageState extends State<SallaryPage> {

  bool isLoading = true;
  bool isLocked = true;
  List<SallaryModel> sallaryList = [];

  void getData()async{
    final networkResponse = await NetworkRequest.getSallary();
    sallaryList = networkResponse.data??[];
    setState(() {
      sallaryList;
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
      body: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/joe.png'))
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: isLoading?
              ShimmerLoading.listShimmer(context):
              Column(
                children: [
                  AutoSizeText('Slip Gaji', style: CustomFont.headingDuaSemiBold(),),
                  const SizedBox(height: 12,),
                  Expanded(
                    child: ListView.builder(
                      itemCount: sallaryList.length,
                      itemBuilder: (ctxList, index){
                        SallaryModel data = sallaryList[index];
                    
                        return InkWell(
                          onTap: ()async{

                            if(isLocked){
                              final auth = await BiometricAuth().requestFingerprintAuth();

                              if(!auth){
                                return;
                              }else{
                                setState(() {
                                  isLocked = false;  
                                });
                              }
                            }

                            EasyLoading.show();
                            final linkResponse = await NetworkRequest.getSallaryPdf(data.period);
                            EasyLoading.dismiss();
                            if(linkResponse.state != true){
                              return ShowToast.error('Generate PDF File failed');
                            }
                            if(context.mounted){
                              CustomViewer.detectImageOrPdf(context, Uri.parse(linkResponse.data??'').toString());
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                width: 0.7,
                                color: Colors.grey,
                              ),
                              borderRadius: BorderRadius.circular(6)
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data.period, style: CustomFont.headingEmpatSemiBold(),),
                                  ],
                                ),
                                const SizedBox(height: 12,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data.grade, style: CustomFont.headingLimaSemiBold(),),
                                    InkWell(
                                      onTap: ()async{
                                        if(isLocked){
                                          final auth = await BiometricAuth().requestFingerprintAuth();

                                          if(!auth){
                                            return;
                                          }else{
                                            setState(() {
                                              isLocked = false;  
                                            });
                                          }
                                        }
                                        setState(() {
                                        data.show = !data.show;
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          AutoSizeText((data.show == true ?data.wages:'Rp *******'), style: CustomFont.headingEmpatSemiBoldColorful(),),
                                          const SizedBox(width: 6,),
                                          Icon(
                                            data.show == true?Icons.visibility: Icons.visibility_off,
                                            color: Colors.blue.shade900,
                                            size: 19,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                  ),
                ],
              ),
            ))
        ],
      ),
    );
  }
}
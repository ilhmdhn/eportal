import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/substitution_response.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';

class SubstituteDialog{

  static void showAddLipengDialog(BuildContext ctx){
    DateTime date = DateTime.now();
    DateTime dateDest = DateTime.now();
    TextEditingController tfReason = TextEditingController();
    bool isOvertime = false;

    showDialog(
      context: ctx, 
      builder: (BuildContext ctx){
        return StatefulBuilder(
          builder: (BuildContext ctxStateful, StateSetter setState){
            return AlertDialog(
              iconPadding: const EdgeInsets.all(0),
              insetPadding: const EdgeInsets.all(0),
              titlePadding: const EdgeInsets.all(0),
              buttonPadding: const EdgeInsets.all(0),
              actionsPadding: const EdgeInsets.all(0),
              contentPadding: const EdgeInsets.all(0),
              content: Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                width: ScreenSize.setWidthPercent(ctx, 85),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.3, color: Colors.grey)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 24,),
                        Center(child: Text('Ajukan Libur Pengganti', style: CustomFont.headingTigaSemiBold(),)),
                        InkWell(
                          onTap: ()async{
                            NavigationService.back();
                          },
                          child: const SizedBox(width: 24, child: 
                          Icon(Icons.close),),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    AutoSizeText(
                      'Tanggal Libur',
                      style: CustomFont.headingEmpatSemiBold(),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          builder: (BuildContext context, Widget? child) {
                            return CustomDatePicker.primary(child!);
                          },
                          context: ctx,
                          initialDate: date,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            date = selectedDate;
                          });
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Text(CustomConverter.dateTimeToDay(date),
                            style: CustomFont.headingEmpat(),
                          )),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    AutoSizeText(
                      'Tanggal Libur Pengganti',
                      style: CustomFont.headingEmpatSemiBold(),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          builder: (BuildContext context, Widget? child) {
                            return CustomDatePicker.primary(child!);
                          },
                          context: ctx,
                          initialDate: dateDest,
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            date = selectedDate;
                          });
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Text(
                            CustomConverter.dateTimeToDay(date),
                            style: CustomFont.headingEmpat(),
                          )),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Alasan Izin',
                      style: CustomFont.headingEmpatSemiBold(),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    TextField(
                      minLines: 3,
                      maxLines: 5,
                      controller: tfReason,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(
                            color: Colors.grey, width: 2.0
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(
                            color: Colors.grey, width: 1.0
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 8, 
                          horizontal: 12
                        )
                      )
                    ),
                    const SizedBox(height: 12,),
                    Row(
                      children: [
                        SizedBox(
                          width: 21,
                          height: 21,
                          child: Transform.scale(
                            scale: 1,
                            child: Checkbox(
                              value: isOvertime,
                              activeColor: CustomColor.primary(),
                              checkColor: Colors.white,
                              onChanged: ((value) {
                                setState((){
                                  isOvertime = value??false;
                                });
                              }),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6,),
                        AutoSizeText('Lembur', style: CustomFont.headingEmpatSemiBold(),)
                      ],
                    ),
                    const SizedBox(height: 12,),
                    InkWell(
                      onTap: ()async{
                        if(date == dateDest){
                          ShowToast.warning('Tanggal tidak boleh sama');
                          return;
                        }
                        if(isNotNullOrEmpty(tfReason.text)){
                          ShowToast.warning('Tujuan tidak boleh kosong');
                          return;
                        }
                        final networkResponse = await NetworkRequest.postLipeng(date, dateDest, tfReason.text, isOvertime);
                        if(networkResponse.state != true){
                          if(ctx.mounted){
                            NotificationStyle.warning(ctx, 'Gagal', networkResponse.message);
                          }
                        }else{
                          if(ctx.mounted){
                            NotificationStyle.info(ctx, 'Berhasil', networkResponse.message);
                          }
                          return NavigationService.back();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 9),
                        decoration: CustomContainer.buttonGreen(),
                        child: Center(
                          child: Text(
                            'Ajukan Libur Pengganti',
                          style: CustomFont.headingDuaSemiBoldSecondary(),
                        )),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }

  static void showDetailLipengDialog(BuildContext ctx, SubstitutionModel data){
    showDialog(
      context: ctx, 
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          iconPadding: const EdgeInsets.all(0),
          insetPadding: const EdgeInsets.all(0),
          titlePadding: const EdgeInsets.all(0),
          buttonPadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.all(0),
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            width: ScreenSize.setWidthPercent(ctx, 85),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.3, color: Colors.grey)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      Center(
                        child: Text(
                          'Rincian Libur Pengganti',
                          style: CustomFont.headingTigaSemiBold(),
                        )
                      ),
                      InkWell(
                        onTap: () async {
                          NavigationService.back();
                        },
                        child: const SizedBox(
                          width: 24,
                          child: Icon(Icons.close),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Tanggal Libur',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(height: 2,),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey, width: 1.0)),
                    child: Text(
                      CustomConverter.dateTimeToDay(data.dateSource),
                      style: CustomFont.headingEmpat(),
                    ),
                  ),
                  const SizedBox(height: 12,),
                  AutoSizeText(
                    'Tanggal Pengganti',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    width: double.infinity,
                    padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.grey, width: 1.0)),
                    child: Text(
                      CustomConverter.dateTimeToDay(data.dateFurlough),
                      style: CustomFont.headingEmpat(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Lembur : ${data.overtime == 1? 'Ya': 'Tidak'}',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  
              ],
            ),
          ),
        );
      }
    );
  }

  static void showEditLipengDialog(BuildContext ctx, SubstitutionModel data) {

  }
}
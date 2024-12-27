import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/cuti_response.dart';
import 'package:eportal/page/dialog/confirmation_dialog.dart';
import 'package:eportal/provider/max_date.dart';
import 'package:eportal/style/custom_button.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
class CutiDialog {

  static int calculateDaysBetween(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    int difference = (end.difference(start).inDays) + 1;

    return difference;
  }

  static Future<bool> showAddCUtiDialog(BuildContext ctx, int cutiRemaining) async{
    
    DateTime startDateTemp = DateTime.now().add(const Duration(days: 30));
    DateTime startDate = DateTime(startDateTemp.year, startDateTemp.month, startDateTemp.day);
    DateTime endDate = DateTime.now().add(const Duration(days: 30));
    int pickedCount = 1;
    const List<String> listCutiType = <String>['Tahunan'];
    TextEditingController tfReason = TextEditingController();
    void updateMaxDate() {
      ctx.read<MaxDateProvider>().updateDate(startDate, '1');
    }
    
    updateMaxDate();
    
    final result = await showDialog(
      context: ctx,
      builder: (BuildContext ctxDialog) {
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
              constraints: BoxConstraints(
                maxHeight: ScreenSize.setHeightPercent(ctx, 70)
              ),
              width: ScreenSize.setWidthPercent(ctx, 85),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.3, color: Colors.grey)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 24,),
                      Center(child: Text('Ajukan Cuti', style: CustomFont.headingTigaSemiBold(),)),
                      InkWell(
                        onTap: ()async{
                          NavigationService.back();
                        },
                        child: const SizedBox(width: 24, child: 
                        Icon(Icons.close),),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Flexible(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tipe Cuti',
                              style: CustomFont.headingEmpatSemiBold(),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            DropdownMenu<String>(
                              menuStyle: const MenuStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                              ),
                              width: ScreenSize.setWidthPercent(ctx, 85) - 24,
                              initialSelection: listCutiType.first,
                              dropdownMenuEntries: listCutiType
                                .map<DropdownMenuEntry<String>>((String value) {
                                  return DropdownMenuEntry<String>(
                                    value: value, label: value
                                  );
                                }).toList(),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            AutoSizeText(
                              'Mulai Cuti',
                              style: CustomFont.headingEmpatSemiBold(),
                              maxLines: 1,
                            ),
                            InkWell(
                              onTap: ()async{
                                final selectedDate = await showDatePicker(
                                  builder: (BuildContext context, Widget? child) {
                                    return CustomDatePicker.primary(child!);
                                },
                                  context: ctx,
                                  initialDate: startDate,
                                  firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                  lastDate: DateTime.now().add(const Duration(days: 365)),
                                );
                            
                                if (selectedDate != null) {
                                  setState((){
                                    
                                    startDate = selectedDate;
                                    endDate = selectedDate;
                                    updateMaxDate();
                                    pickedCount = calculateDaysBetween(startDate.toString(), endDate.toString());
                                  });
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey
                                  )
                                ),
                                child: Text(CustomConverter.dateToDay(DateFormat('yyyy-MM-dd').format(startDate)), style: CustomFont.headingEmpat(),)),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            AutoSizeText(
                              'Selesai Cuti',
                              style: CustomFont.headingEmpatSemiBold(),
                              maxLines: 1,
                            ),
                            Consumer<MaxDateProvider>(
                              builder: (ctxMaxDate, maxDateProvider, child) {
                                return InkWell(
                                  onTap: () async {
                                    final selectedDate = await showDatePicker(
                                      builder: (BuildContext context, Widget? child) {
                                        return CustomDatePicker.primary(child!);
                                      },
                                        context: ctx,
                                        initialDate: endDate,
                                        firstDate: startDate,
                                        lastDate: maxDateProvider.date,
                                    );
                                    if (selectedDate != null) {
                                      setState(() {
                                        endDate = selectedDate;
                                        pickedCount = calculateDaysBetween(startDate.toString(), endDate.toString());
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      border: Border.all(width: 1, color: Colors.grey)
                                    ),
                                    child: maxDateProvider.isLoading
                                    ? Center(
                                        child: LoadingAnimationWidget.waveDots(
                                          color: CustomColor.primary(),
                                          size: 20,
                                        )
                                      ): 
                                    Text(
                                      CustomConverter.dateToDay(
                                        DateFormat('yyyy-MM-dd').format(maxDateProvider.date)
                                      ),
                                      style: CustomFont.headingEmpat(),
                                    )
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              'Alasan Cuti',
                              style: CustomFont.headingEmpatSemiBold(),
                            ),
                            TextField(
                              minLines: 3,
                              maxLines: 5,
                              controller: tfReason,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(
                                    color: Colors.grey, width: 1.0),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12
                                )
                              )
                            ),
                            
                            const SizedBox(
                              height: 3,
                            ),
                            
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text('Cuti diambil: $pickedCount', style: CustomFont.headingLimaSemiBold(),)),
                            const SizedBox(
                              height: 12,
                            ),
                            InkWell(
                              onTap: () async{
                                final confirm = await ConfirmationDialog.confirmation(ctx, 'Ajukan cuti');
                                if(confirm != true){
                                  return;
                                }
                                final response = await NetworkRequest.postCuti(DateFormat('yyyy-MM-dd').format(startDate), DateFormat('yyyy-MM-dd').format(endDate), tfReason.text);
                                if(response.state != true){
                                  if(ctx.mounted){
                                    NotificationStyle.warning(ctx, 'Gagal mengajukan cuti', response.message);
                                  }
                                  return;
                                }
                                if(ctx.mounted){
                                  NotificationStyle.info(ctx, 'Berhasil', response.message);
                                }  
                                NavigationService.backWithData(true);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                decoration: CustomContainer.buttonGreen(),
                                child: Center(child: Text('Ajukan Cuti', style: CustomFont.headingDuaSemiBoldSecondary(),)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            );
            },
        );
      }
    );

    return result ?? false;
  }

  static Future<bool> detailCutiDialog(BuildContext ctx, CutiListModel data)async{
    final result = await showDialog(
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
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12
            ),
            constraints: BoxConstraints(
              maxHeight: ScreenSize.setHeightPercent(ctx, 70)
            ),
            width: ScreenSize.setWidthPercent(ctx, 85),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.close, size: 26, color: Colors.white,),
                      Text('Rincian Cuti', style: CustomFont.headingTigaSemiBold(),),
                      InkWell(
                        onTap: ()async{
                          NavigationService.back();
                        },
                        child: const SizedBox(width: 24, child: 
                        Icon(Icons.close),),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 9,),
                Flexible(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Kode Cuti',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)
                              ),
                            child: Text(data.id,style: CustomFont.headingEmpat(),
                            )
                          ),
                          const SizedBox(
                          height: 12,
                          ),
                          AutoSizeText(
                            'Status',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)
                              ),
                            child: AutoSizeText(
                              data.state == 1 ? 'Menunggu' : data.state == 2 ? 'Disetujui' : 'Ditolak',
                              style: 
                                data.state == 1? CustomFont.headingEmpatWaiting():
                                data.state == 2? CustomFont.headingEmpatApprove():
                                CustomFont.headingEmpatReject(),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            )
                          ),
                          const SizedBox(
                          height: 12,
                          ),
                          AutoSizeText(
                            'Mulai Cuti',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)
                              ),
                            child: AutoSizeText( CustomConverter.dateTimeToDay(data.startCuti),
                              style: CustomFont.headingEmpat(),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            )
                          ),
                          const SizedBox(
                          height: 12,
                          ),
                          AutoSizeText(
                            'Selesai Cuti',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)
                              ),
                            child: AutoSizeText( CustomConverter.dateTimeToDay(data.endCuti),
                              style: CustomFont.headingEmpat(),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            )
                          ),
                          const SizedBox(
                          height: 12,
                          ),
                          AutoSizeText(
                            'Lama Cuti',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)
                              ),
                            child: AutoSizeText('${data.day} hari',
                              style: CustomFont.headingEmpat(),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            )
                          ),
                          const SizedBox(
                          height: 12,
                          ),
                          AutoSizeText(
                            'Tanggal Pengajuan',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)
                              ),
                            child: AutoSizeText(CustomConverter.dateTimeToDay(data.requestDate),
                              style: CustomFont.headingEmpat(),
                              maxLines: 2,
                              overflow: TextOverflow.clip,
                            )
                          ),
                          const SizedBox(
                          height: 12,
                          ),
                          SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  AutoSizeText(
                                    'Alasan Cuti',
                                    style: CustomFont.headingLimaSemiBold(),
                                    maxLines: 1,
                                  ),
                                  TextField(
                                      minLines: 3,
                                      maxLines: 5,
                                      readOnly: true,
                                      style: CustomFont.headingLima(),
                                      controller: TextEditingController(text: data.cutiReason),
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 1.3),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.9),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12))
                                      ),
                                ],
                              ),
                            ),
                          data.state == 3?
                          SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  AutoSizeText(
                                    'Alasan Penolakan:',
                                    style: CustomFont.headingLimaSemiBold(),
                                    maxLines: 1,
                                  ),
                                  TextField(
                                      minLines: 3,
                                      maxLines: 5,
                                      readOnly: true,
                                      style: CustomFont.headingLima(),
                                      controller: TextEditingController(text: data.rejectReason),
                                      decoration: InputDecoration(
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 1.3),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(6.0),
                                            borderSide: const BorderSide(
                                                color: Colors.grey, width: 0.9),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 12))
                                      ),
                                ],
                              ),
                            )
                          :const SizedBox(),
                          const SizedBox(height: 12,),
                          data.editable?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  NavigationService.backWithData(true);
                                },
                                child: CustomButton.edit()
                              ),
                            ],
                          ):
                          const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );

    return result??false;
  }

  static Future<bool> editCutiDialog(BuildContext ctx, CutiListModel data)async{

    DateTime startDate = data.startCuti;
    DateTime endDate = data.endCuti;
    int pickedCount = 1;
    final cutiPicked = data.day;
    TextEditingController tfReason = TextEditingController();
    tfReason.text = data.cutiReason;

    final result = await showDialog(
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
                constraints: BoxConstraints(
                  maxHeight: ScreenSize.setHeightPercent(ctx, 70)
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.3, color: Colors.grey)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.close, size: 26, color: Colors.white,),
                        Text('Ajukan Ulang Cuti', style: CustomFont.headingTigaSemiBold(),),
                        InkWell(
                          onTap: ()async{
                            NavigationService.back();
                          },
                          child: const SizedBox(width: 24, child: 
                            Icon(Icons.close),
                          ),
                        ),
                      ],
                     ),
                    const SizedBox(
                      height: 12,
                    ),
                    Flexible(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AutoSizeText(
                                      'Mulai Cuti',
                                      style: CustomFont.headingEmpatSemiBold(),
                                      maxLines: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      'Cuti sebelumnya: $cutiPicked',
                                      textAlign: TextAlign.end,
                                      style: CustomFont.headingEmpatSemiBold(),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                onTap: () async {
                                  final selectedDate = await showDatePicker(
                                    builder: (BuildContext context, Widget? child) {
                                      return CustomDatePicker.primary(child!);
                                    },
                                    context: ctx,
                                    initialDate: startDate,
                                    firstDate:
                                        DateTime.now().subtract(const Duration(days: 30)),
                                    lastDate:
                                        DateTime.now().add(const Duration(days: 365)),
                                  );
                              
                                  if (selectedDate != null) {
                                    setState(() {
                                      startDate = selectedDate;
                                      endDate = selectedDate;
                                      pickedCount = calculateDaysBetween(
                                          startDate.toString(), endDate.toString());
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
                                      CustomConverter.dateToDay(
                                          DateFormat('yyyy-MM-dd').format(startDate)),
                                      style: CustomFont.headingEmpat(),
                                    )),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              AutoSizeText(
                                'Selesai Cuti',
                                style: CustomFont.headingEmpatSemiBold(),
                                maxLines: 1,
                              ),
                              Consumer<MaxDateProvider>(
                                builder: (ctxMaxDate, maxDateProvider, child) {
                                  return InkWell(
                                    onTap: () async {
                                      final selectedDate = await showDatePicker(
                                        builder: (BuildContext context, Widget? child) {
                                          return CustomDatePicker.primary(child!);
                                        },
                                        context: ctx,
                                        initialDate: endDate,
                                        firstDate: startDate,
                                        lastDate: maxDateProvider.date,
                                      );
                                      if (selectedDate != null) {
                                        setState(() {
                                          endDate = selectedDate;
                                          pickedCount = calculateDaysBetween(
                                              startDate.toString(), endDate.toString());
                                        });
                                      }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 12),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            border:
                                                Border.all(width: 1, color: Colors.grey)),
                                        child: maxDateProvider.isLoading
                                            ? Center(
                                                child: LoadingAnimationWidget.waveDots(
                                                color: CustomColor.primary(),
                                                size: 20,
                                              ))
                                            : Text(
                                                CustomConverter.dateToDay(
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(maxDateProvider.date)),
                                                style: CustomFont.headingEmpat(),
                                              )),
                                  );
                                },
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Alasan Cuti',
                                style: CustomFont.headingEmpatSemiBold(),
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
                              const SizedBox(
                                height: 3,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Cuti diambil: $pickedCount',
                                  style: CustomFont.headingLimaSemiBold(),
                                )
                              ),
                              const SizedBox(height: 12,),
                              InkWell(
                                onTap: () async{
                                  final confirm = await ConfirmationDialog.confirmation(ctx, 'Ubah data cuti');
                                  if(confirm != true){
                                    return;
                                  }
                                  final response = await NetworkRequest.putCuti(data.id, DateFormat('yyyy-MM-dd').format(startDate), DateFormat('yyyy-MM-dd').format(endDate), tfReason.text);
                                  if (response.state != true) {
                                    if (ctx.mounted) {
                                      NotificationStyle.warning(ctx, 'Gagal mengajukan ulang cuti', response.message);
                                    }
                                    return;
                                  }
                                  if (ctx.mounted) {
                                    NotificationStyle.info(ctx, 'Berhasil', response.message);
                                  }
                                  NavigationService.backWithData(true);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 9),
                                  decoration: CustomContainer.buttonGreen(),
                                  child: Center(
                                    child: Text(
                                      'Ajukan Ulang',
                                      style: CustomFont.headingTigaSemiBoldSecondary(),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          });
      }
    );
    return result??false;
  }
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/overtime_response.dart';
import 'package:eportal/page/dialog/confirmation_dialog.dart';
import 'package:eportal/style/custom_button.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/style/custom_time_picker.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/dummy.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OvertimeDialog{
  static void showOvertimeDialog(BuildContext ctx){
    final listInstructor = DummyData.getInstructorOvertime();
    String instructorSelected = listInstructor.first;
    DateTime startDate = DateTime.now();
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now();
    TextEditingController tfReason = TextEditingController();
    
    showDialog(
      context: ctx, 
      builder: (BuildContext ctx){
        return StatefulBuilder(
          builder: (context, setState) {
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
                            'Ajukan Lembur',
                            style: CustomFont.headingTigaSemiBold(),
                          )),
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
                    Flexible(
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'Tanggal',
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
                                    initialDate: startDate,
                                    firstDate:
                                        DateTime.now().subtract(const Duration(days: 30)),
                                    lastDate:
                                        DateTime.now().add(const Duration(days: 365)),
                                  );
                              
                                  if (selectedDate != null) {
                                    setState(() {
                                      startDate = selectedDate;
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
                                'Jam mulai',
                                style: CustomFont.headingEmpatSemiBold(),
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              InkWell(
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    builder: (BuildContext context, Widget? child) {
                                      return CustomTimePicker.primary(child!);
                                    },
                                    initialTime: TimeOfDay.now(),
                                    context: ctx,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      startTime = selectedTime;
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
                                      CustomConverter.time(startTime),
                                      style: CustomFont.headingEmpat(),
                                    )),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              AutoSizeText(
                                'Jam selesai',
                                style: CustomFont.headingEmpatSemiBold(),
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              InkWell(
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    builder: (BuildContext context, Widget? child) {
                                      return CustomTimePicker.primary(child!);
                                    },
                                    initialTime: TimeOfDay.now(),
                                    context: ctx,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      endTime = selectedTime;
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
                                      CustomConverter.time(endTime),
                                      style: CustomFont.headingEmpat(),
                                    )),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Tujuan lembur',
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
                                      color: Colors.grey, width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(
                                      color: Colors.grey, width: 1.0),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12)
                                )
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Ditugaskan oleh',
                                style: CustomFont.headingEmpatSemiBold(),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              DropdownMenu<String>(
                                onSelected: (value){
                                  setState((){
                                    instructorSelected = value!;
                                  });
                                },
                                menuStyle: const MenuStyle(
                                backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
                                ),
                                width: ScreenSize.setWidthPercent(ctx, 85) - 24,
                                initialSelection: listInstructor.first,
                                dropdownMenuEntries: listInstructor.map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(
                                    value: value, label: value);
                              }).toList(),
                              ),
                              instructorSelected == 'Lainnya' || !listInstructor.contains(instructorSelected)?
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Penugas',
                                      style: CustomFont.headingEmpatSemiBold(),
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    TextField(
                                      minLines: 1,
                                      maxLines: 1,
                                      onChanged: (value){
                                        setState((){
                                          instructorSelected = value;
                                        });
                                      },
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
                                          color: Colors.grey, width: 1.0),
                                        ),
                                        contentPadding:const EdgeInsets.symmetric(vertical: 8, horizontal: 12))
                                    ),
                                  ],
                                ):
                              const SizedBox(),
                              const SizedBox(height: 12,),
                              InkWell(
                                  onTap: () async {
                                    if(instructorSelected == 'Pilih' || instructorSelected == 'Lainnya' || isNullOrEmpty(instructorSelected)){
                                      ShowToast.warning('Lengkapi data');
                                      return;
                                    }
                                    final confirm = await ConfirmationDialog.confirmation(ctx, 'Ajukan lembur?');
                                    if (confirm != true) {
                                      return;
                                    }
                              
                                    final networkResponse = await NetworkRequest.postLembur(startDate, startTime, endTime, tfReason.text, instructorSelected);
                              
                                    if(networkResponse.state != true){
                                      if(ctx.mounted){
                                        NotificationStyle.warning(ctx, "Gagal", networkResponse.message);
                                      }
                                      return;
                                    }else{
                                      if(ctx.mounted){
                                        NotificationStyle.info(ctx, "Berhasil", 'Lembur Diajukan');
                                      }
                                      NavigationService.back();
                                    }  
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: CustomContainer.buttonGreen(),
                                    child: Center(
                                      child: Text('Ajukan',style: CustomFont.buttonSecondary(),
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
          }
        );
      });
  }

  static void showOvertimeDetail(BuildContext ctx, OvertimeModel data){
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
            padding: const EdgeInsets.symmetric(
              vertical: 9,
              horizontal: 12
            ),
            constraints: BoxConstraints(
              maxHeight: ScreenSize.setHeightPercent(ctx, 70)
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
            ),
            width: ScreenSize.setWidthPercent(ctx, 85),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(child: SizedBox()),
                    AutoSizeText('Rincian Lembur',style: CustomFont.headingTigaSemiBold()),
                    Expanded(child: InkWell(
                      onTap: (){
                        NavigationService.back();
                      },
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.close, size: 21,)),
                    )),
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
                          AutoSizeText('Tanggal', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)
                            ),
                            child: Text( CustomConverter.dateToDay(DateFormat('yyyy-MM-dd').format(data.date)), style: CustomFont.headingEmpat(),)
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
                            'Jam Lembur',
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
                              border: Border.all(width: 1, color: Colors.grey)),
                            child: Text('${CustomConverter.time(data.startTime)} - ${CustomConverter.time(data.finishTime)}',
                              style: CustomFont.headingEmpat(),
                            )
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                              'Tujuan lembur',
                              style: CustomFont.headingEmpatSemiBold(),
                            ),
                          const SizedBox(
                              height: 2,
                            ),
                          TextField(
                            minLines: 2,
                            maxLines: 5,
                            readOnly: true,
                            controller: TextEditingController(text: data.reason),
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
                            height: 12,
                          ),
                          AutoSizeText(
                            'Penugas',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                            child: Text(data.assigner, style: CustomFont.headingEmpat(),)
                          ),
                          data.state == 1?
                          Column(
                            children: [
                             const SizedBox(
                               height: 12,
                             ),
                             Row(
                               mainAxisAlignment: MainAxisAlignment.end,
                               crossAxisAlignment: CrossAxisAlignment.end,
                               children: [
                                 InkWell(
                                   onTap: (){
                                     NavigationService.back();
                                     OvertimeDialog.editOvertimeDialog(ctx, data);
                                   },
                                   child: CustomButton.edit()
                                 )
                               ],
                             ),
                            ],
                          ):
                          data.state == 2?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             const SizedBox(
                              height: 12,
                              ),
                              AutoSizeText('Status', style: CustomFont.headingEmpatSemiBold(), maxLines: 1,),
                              Text( 'Disetujui', style: CustomFont.headingEmpatApprove(),
                                                 ),
                            ], 
                          ):
                          data.state == 3?
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12,),
                              AutoSizeText('Alasan Penolakan', style: CustomFont.headingEmpatReject(),maxLines: 1,),
                              const SizedBox(
                                height: 2,
                              ),
                              TextField(
                                minLines: 2,
                                maxLines: 5,
                                readOnly: true,
                                controller: TextEditingController(text: data.rejectReason),
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
                            ],
                          ):
                          const SizedBox(),
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

  static void editOvertimeDialog(BuildContext ctx, OvertimeModel data){
    DateTime date = data.date;
    TimeOfDay startTime = data.startTime;
    TimeOfDay endTime = data.finishTime;
    TextEditingController tfReason = TextEditingController(text: data.reason);
    final listInstructor = DummyData.getInstructorOvertime();
    String instructorSelected = data.assigner;
    final tfOtherAssigner = TextEditingController(text: data.assigner);
    int indexInitial = listInstructor.indexWhere((dataz) => dataz == data.assigner);
    
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
          content: StatefulBuilder(
            builder: (ctxStateful, setState) {
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                constraints: BoxConstraints(
                  maxHeight: ScreenSize.setHeightPercent(ctx, 70)
                ),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                width: ScreenSize.setWidthPercent(ctx, 85),            
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: AutoSizeText('Edit Pengajuan Lembur',style: CustomFont.headingTigaSemiBold())
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
                              AutoSizeText('Tanggal', style: CustomFont.headingEmpatSemiBold(), maxLines: 1, ),
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
                                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (selectedDate != null) {
                                    setState(() {
                                      date = selectedDate;
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
                                  child: Text(
                                    CustomConverter.dateToDay(DateFormat('yyyy-MM-dd').format(date)),
                                    style: CustomFont.headingEmpat(),
                                  )
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              AutoSizeText(
                                'Jam mulai',
                                style: CustomFont.headingEmpatSemiBold(),
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              InkWell(
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    builder: (BuildContext context, Widget? child) {
                                      return CustomTimePicker.primary(child!);
                                    },
                                    initialTime: TimeOfDay.now(),
                                    context: ctx,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      startTime = selectedTime;
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
                                      CustomConverter.time(startTime),
                                      style: CustomFont.headingEmpat(),
                                    )),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              AutoSizeText(
                                'Jam selesai',
                                style: CustomFont.headingEmpatSemiBold(),
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              InkWell(
                                onTap: () async {
                                  final selectedTime = await showTimePicker(
                                    builder: (BuildContext context, Widget? child) {
                                      return CustomTimePicker.primary(child!);
                                    },
                                    initialTime: TimeOfDay.now(),
                                    context: ctx,
                                  );
                                  if (selectedTime != null) {
                                    setState(() {
                                      endTime = selectedTime;
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
                                      CustomConverter.time(endTime),
                                      style: CustomFont.headingEmpat(),
                                    )),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Tujuan lembur',
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
                                            color: Colors.grey, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6.0),
                                        borderSide: const BorderSide(
                                            color: Colors.grey, width: 1.0),
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12))),
                              const SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Ditugaskan oleh',
                                style: CustomFont.headingEmpatSemiBold(),
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              DropdownMenu<String>(
                                onSelected: (value) {
                                  setState(() {
                                    instructorSelected = value!;
                                  });
                                },
                                menuStyle: const MenuStyle(
                                  backgroundColor:WidgetStatePropertyAll<Color>(Colors.white),
                                ),
                                width: ScreenSize.setWidthPercent(ctx, 85) - 24,
                                initialSelection: indexInitial > -1? listInstructor[indexInitial]: listInstructor[6] ,
                                dropdownMenuEntries: listInstructor
                                    .map<DropdownMenuEntry<String>>((String value) {
                                  return DropdownMenuEntry<String>(
                                      value: value, label: value);
                                }).toList(),
                              ),
                              instructorSelected == 'Lainnya' ||
                                      !listInstructor.contains(instructorSelected)
                                  ? Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Penugas',
                                          style: CustomFont.headingEmpatSemiBold(),
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        TextField(
                                          minLines: 1,
                                          maxLines: 1,
                                          controller: tfOtherAssigner,
                                          onChanged: (value) {
                                            setState(() {
                                              instructorSelected = value;
                                            });
                                          },
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(6.0),
                                              borderSide: const BorderSide(
                                                color: Colors.grey, width: 2.0),
                                            ),
                                          enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(6.0),
                                          borderSide: const BorderSide(
                                            color: Colors.grey, 
                                            width: 1.0),
                                          ),
                                          contentPadding: const EdgeInsets.symmetric( vertical: 8, horizontal: 12))
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              const SizedBox(
                                height: 12,
                              ),
                              InkWell(
                                onTap: () async {
                                  if (instructorSelected == 'Pilih' ||
                                      instructorSelected == 'Lainnya' ||
                                      isNullOrEmpty(instructorSelected)) {
                                    ShowToast.warning('Lengkapi data');
                                    return;
                                  }
                                  final confirm = await ConfirmationDialog.confirmation(
                                      ctx, 'Ubah data lembur?');
                                  if (confirm != true) {
                                    return;
                                  }
                              
                                  final networkResponse = await NetworkRequest.putLembur(
                                      data.id,
                                      date,
                                      startTime,
                                      endTime,
                                      tfReason.text,
                                      instructorSelected);
                              
                                  if (networkResponse.state != true) {
                                    if (ctx.mounted) {
                                      NotificationStyle.warning(
                                          ctx, "Gagal", networkResponse.message);
                                    }
                                    return;
                                  } else {
                                    if (ctx.mounted) {
                                      NotificationStyle.info(
                                          ctx, "Berhasil", 'Lembur Diajukan');
                                    }
                                    NavigationService.back();
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: CustomContainer.buttonGreen(),
                                  child: Center(
                                    child: Text(
                                      'Ajukan',
                                      style: CustomFont.buttonSecondary(),
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
              );
            }
          ),
        );
      });
  }
}
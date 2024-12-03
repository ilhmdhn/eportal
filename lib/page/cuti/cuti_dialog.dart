import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/data/network/response/cuti_response.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CutiDialog {

  static int calculateDaysBetween(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    int difference = (end.difference(start).inDays) + 1;

    return difference;
  }

  static DateTime limitToEndOfYear(DateTime startDate, int daysToAdd) {
    DateTime endOfYear = DateTime(startDate.year, 12, 31);

    DateTime newDate = startDate.add(Duration(days: daysToAdd - 1));

    if (newDate.isAfter(endOfYear)) {
      return endOfYear;
    }

    return newDate;
  }

  static void showAddCUtiDialog(BuildContext ctx, int cutiRemaining) {
    
    DateTime startDateTemp = DateTime.now().add(const Duration(days: 30));
    DateTime startDate = DateTime(startDateTemp.year, startDateTemp.month, startDateTemp.day);
    DateTime endDate = DateTime.now().add(const Duration(days: 30));
    int pickedCount = 1;
    const List<String> listCutiType = <String>['Tahunan'];


    showDialog(
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
              width: ScreenSize.setWidthPercent(ctx, 85),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.3, color: Colors.grey)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Pengajuan Cuti',
                        style: CustomFont.headingTigaSemiBold(),
                      )
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tipe Cuti',
                        style: CustomFont.headingEmpatSemiBold(),
                      ),
                      Text(
                        'Sisa cuti: $cutiRemaining',
                        style: CustomFont.headingEmpatSemiBold(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  DropdownMenu<String>(
                    width: double.infinity,
                    initialSelection: listCutiType.first,
                    dropdownMenuEntries: listCutiType
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
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
                  InkWell(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        builder: (BuildContext context, Widget? child) {
                          return CustomDatePicker.primary(child!);
                        },
                        context: ctx,
                        initialDate: startDate,
                        firstDate: startDate,
                        lastDate: limitToEndOfYear(startDate, cutiRemaining==0?1:cutiRemaining),
                      );

                      if (selectedDate != null) {
                        setState((){
                          endDate = selectedDate;
                          pickedCount = calculateDaysBetween(startDate.toString(), endDate.toString());
                        });
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Text(
                          CustomConverter.dateToDay(
                                  DateFormat('yyyy-MM-dd').format(endDate)),
                          style: CustomFont.headingEmpat(),
                        )),
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
                              vertical: 8, horizontal: 12))
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('Cuti diambil: $pickedCount', style: CustomFont.headingLimaSemiBold(),)),
                  const SizedBox(
                    height: 19,
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          NavigationService.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: CustomContainer.buttonCancel(),
                          child: Text(
                            'Batal',
                            style: CustomFont.buttonSecondary(),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          NavigationService.back();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: CustomContainer.buttonPrimary(),
                          child: Text(
                            'Ajukan',
                            style: CustomFont.buttonSecondary(),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            );
            },
          );
        });
  }

  static void detailCutiDialog(BuildContext ctx, CutiListModel data){

    bool isEditable = false;

    final cutiDate = data.startCuti;
    final today = DateTime.now();

    if(cutiDate.isAfter(today)){
      isEditable = true;
    }

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
              vertical: 12,
              horizontal: 6
            ),
            width: ScreenSize.setWidthPercent(ctx, 85),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.close, size: 26, color: Colors.white,),
                      Text('Rincian Cuti', style: CustomFont.headingTigaSemiBold(),),
                      InkWell(
                          onTap: () {
                            NavigationService.back();
                          },
                          child: const Icon(
                            Icons.close,
                            color: Colors.grey,
                            size: 26,
                          ),
                      )
                    ],
                  ),
                ),
                Column(
                  children: [
                    const SizedBox(height: 9,),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 1,
                                child: AutoSizeText(
                                  'Kode Cuti',
                                  style: CustomFont.headingLimaSemiBold(),
                                )),
                            Expanded(
                                flex: 2,
                                child: AutoSizeText(
                                  ': ${data.id}',
                                  style: CustomFont.headingLima(),
                                  maxLines: 2,
                                  overflow: TextOverflow.clip,
                                )),
                          ],
                        ),
                      ),
                    const SizedBox(
                        height: 6,
                      ),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 1,
                                child: AutoSizeText(
                                  'Status',
                                  style: CustomFont.headingLimaSemiBold(),
                                )),
                            Expanded(
                                flex: 2,
                                child: AutoSizeText(
                                  ': ${data.state == 1?'Menunggu' : data.state == 2? 'Disetujui': 'Ditolak'}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14, 
                                      fontWeight: FontWeight.w600,
                                      color: data.state == 1? Colors.amber : data.state == 2? Colors.green.shade600 : Colors.red),
                                  maxLines: 2,
                                  overflow: TextOverflow.clip,
                                )),
                          ],
                        ),
                      ),
                    const SizedBox(
                        height: 6,
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AutoSizeText('Mulai Cuti', style: CustomFont.headingLimaSemiBold(),)),
                          Expanded(
                            flex: 2, 
                            child: AutoSizeText(': ${CustomConverter.dateToDay(data.startCuti.toString())}', style: CustomFont.headingLima(), maxLines: 2, overflow: TextOverflow.clip,)
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6,),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(flex: 1, child: AutoSizeText('Selesai Cuti',
                                  style: CustomFont.headingLimaSemiBold(),
                                )),
                            Expanded(
                                flex: 2,
                                child: AutoSizeText(
                                  ': ${CustomConverter.dateToDay(data.endCuti.toString())}',
                                    style: CustomFont.headingLima(),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip
                                  )
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                        height: 6,
                      ),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(flex: 1, child: AutoSizeText('Lama Cuti',
                                  style: CustomFont.headingLimaSemiBold(),
                                  maxLines: 1,
                                )),
                            Expanded(
                              flex: 2,
                              child: AutoSizeText(
                                ': ${data.day} hari',
                                    style: CustomFont.headingLima(),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip
                              )
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(
                        height: 6,
                      ),
                    SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                                flex: 1,
                                child: AutoSizeText(
                                  'Pengajuan Cuti',
                                  style: CustomFont.headingLimaSemiBold(),
                                  maxLines: 1,
                                )),
                            Expanded(
                                flex: 2, child:  AutoSizeText(
                                    ': ${CustomConverter.dateToDay(data.requestDate.toString())}',
                                    style: CustomFont.headingLima(),
                                    maxLines: 2,
                                    overflow: TextOverflow.clip)),
                          ],
                        ),
                      ),
                    const SizedBox(
                        height: 6,
                      ),
                    SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            AutoSizeText(
                              'Alasan Cuti:',
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
                    isEditable?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(ctx);
                            Future.delayed(const Duration(milliseconds: 300), () {
                              if(ctx.mounted){
                                editCutiDialog(ctx, data);
                              }else{
                                ShowToast.error('Halaman tidak dapat ditampilkan');
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(top: 9),
                            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.yellow.shade700,
                              borderRadius: BorderRadius.circular(12)
                            ),
                            child: Row(
                              children: [
                                Text('Ubah', style: CustomFont.headingEmpatBoldSecondary(),),
                                const SizedBox(width: 3,),
                                const Icon(Icons.edit_note_sharp, color: Colors.white, size: 21,)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ):
                    const SizedBox()
                  ],
                ),
              ],
            ),
          ),
        );
      });
  }

  static void editCutiDialog(BuildContext ctx, CutiListModel data){

    DateTime startDate = data.startCuti;
    DateTime endDate = data.endCuti;
    int pickedCount = 1;
    final cutiPicked = data.day;
    TextEditingController tfReason = TextEditingController();
    tfReason.text = data.cutiReason;

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
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                width: ScreenSize.setWidthPercent(ctx, 85),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 0.3, color: Colors.grey)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Ajukan Ulang Cuti',
                          style: CustomFont.headingTigaSemiBold(),
                        )),
                    const SizedBox(
                      height: 12,
                    ),
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
                            'Cuti diambil: $cutiPicked',
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
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showDatePicker(
                          builder: (BuildContext context, Widget? child) {
                            return CustomDatePicker.primary(child!);
                          },
                          context: ctx,
                          initialDate: startDate,
                          firstDate: startDate,
                          lastDate: limitToEndOfYear(startDate,
                              cutiPicked == 0 ? 1 : cutiPicked),
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
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Text(
                            CustomConverter.dateToDay(
                                DateFormat('yyyy-MM-dd').format(endDate)),
                            style: CustomFont.headingEmpat(),
                          )),
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
                                vertical: 8, horizontal: 12))),
                    const SizedBox(
                      height: 3,
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Cuti diambil: $pickedCount',
                          style: CustomFont.headingLimaSemiBold(),
                        )),
                    const SizedBox(
                      height: 19,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            NavigationService.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: CustomContainer.buttonCancel(),
                            child: Text(
                              'Batal',
                              style: CustomFont.buttonSecondary(),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            NavigationService.back();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: CustomContainer.buttonPrimary(),
                            child: Text(
                              'Ajukan',
                              style: CustomFont.buttonSecondary(),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
          });
      });
  }
}
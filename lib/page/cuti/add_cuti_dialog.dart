import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CutiDialog {
  static void showAddCUtiDialog(BuildContext ctx, int cutiRemaining) {
    
    DateTime startDateTemp = DateTime.now().add(const Duration(days: 30));
    DateTime startDate = DateTime(startDateTemp.year, startDateTemp.month, startDateTemp.day);
    DateTime endDate = DateTime.now().add(const Duration(days: 30));
    int pickedCount = 1;
    const List<String> listCutiType = <String>['Tahunan'];
    
    int calculateDaysBetween(String startDate, String endDate) {
     
      DateTime start = DateTime.parse(startDate);
      DateTime end = DateTime.parse(endDate);
      int difference = (end.difference(start).inDays)+1;

      return difference;
    }

    DateTime limitToEndOfYear(DateTime startDate, int daysToAdd) {
      DateTime endOfYear = DateTime(startDate.year, 12, 31);

      DateTime newDate = startDate.add(Duration(days: daysToAdd - 1));

      if (newDate.isAfter(endOfYear)) {
        return endOfYear;
      }

      return newDate;
    }

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
                  Text(
                    'Mulai Cuti',
                    style: CustomFont.headingEmpatSemiBold(),
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
                  Text(
                    'Selesai Cuti',
                    style: CustomFont.headingEmpatSemiBold(),
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
                        lastDate: limitToEndOfYear(startDate, cutiRemaining),
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
}

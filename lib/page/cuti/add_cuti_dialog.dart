import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CutiDialog {
  static void showAddCUtiDialog(BuildContext ctx, int cutiRemaining) {
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    const List<String> listCutiType = <String>['Tahunan'];
    showDialog(
        context: ctx,
        builder: (BuildContext ctxDialog) {
          return AlertDialog(
            iconPadding: EdgeInsets.all(0),
            insetPadding: EdgeInsets.all(0),
            titlePadding: EdgeInsets.all(0),
            buttonPadding: EdgeInsets.all(0),
            actionsPadding: EdgeInsets.all(0),
            contentPadding: EdgeInsets.all(0),
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
                      )),
                  Text(
                    'Tipe Cuti',
                    style: CustomFont.headingEmpatSemiBold(),
                  ),
                  SizedBox(
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
                    // inputDecorationTheme: InputDecorationTheme(
                    //   contentPadding: EdgeInsets.all(12)
                    // ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Mulai Cuti',
                    style: CustomFont.headingEmpatSemiBold(),
                  ),
                  InkWell(
                    onTap: ()async{
                      DateTime today = DateTime.now();
                      DateTime oneYearFromNow = today.add(const Duration(days: 365));
                      final selectedDate = await showDatePicker(
                        builder: (BuildContext context, Widget? child) {
                          return CustomDatePicker.primary(child!);
                      },
                        context: ctx,
                        initialDate: today,
                        firstDate: today,
                        lastDate: oneYearFromNow,
                      );

                      if (selectedDate != null) {
                        date = 'aaa';
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey
                        )
                      ),
                      child: Text(date, style: CustomFont.headingEmpat(),)),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Selesai Cuti',
                    style: CustomFont.headingEmpatSemiBold(),
                  ),
                  InkWell(
                    onTap: () async {
                      DateTime today = DateTime.now();
                      DateTime oneYearFromNow =
                          today.add(const Duration(days: 365));
                      final selectedDate = await showDatePicker(
                        builder: (BuildContext context, Widget? child) {
                          return CustomDatePicker.primary(child!);
                        },
                        context: ctx,
                        initialDate: today,
                        firstDate: today,
                        lastDate: oneYearFromNow,
                      );

                      if (selectedDate != null) {
                        date = 'aaa';
                      }
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Text(
                          date,
                          style: CustomFont.headingEmpat(),
                        )),
                  ),

                  SizedBox(
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
                  
                  SizedBox(
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
  }
}

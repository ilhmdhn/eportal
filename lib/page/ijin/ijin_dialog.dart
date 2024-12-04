import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class IjinDialog{
  static void showIjinDialog(BuildContext ctx){

    String selectedType = 'Ijin Terlambat';

    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now();

    DateTime startDate = DateTime.now();

    List<String> tipeIjin = [
      'Ijin Terlambat',
      'Ijin Pulang Awal',
      'Ijin Keluar Kantor',
      'Ijin Tidak Masuk Kerja',
      'Ijin Sakit',
      'Ijin Menikah',
      'Ijin Melahirkan',
      'Ijin Lainnnya',
    ];

    TextEditingController tfReason = TextEditingController();
    showDialog(
      context: ctx,
      builder: (BuildContext ctx){
        return StatefulBuilder(
          builder: (BuildContext ctxStateful, StateSetter setState) {
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
                    Center(child: Text('Ajukan Izin', style: CustomFont.headingTigaSemiBold(),)),
                    const SizedBox(
                        height: 12,
                      ),
                      AutoSizeText(
                        'Tipe Izin',
                        style: CustomFont.headingEmpatSemiBold(),
                        maxLines: 1,
                      ),
                    DropdownMenu<String>(
                        onSelected: (value) {
                          selectedType = value!;  
                        },
                        menuStyle: const MenuStyle(
                          backgroundColor:
                              WidgetStatePropertyAll<Color>(Colors.white),
                        ),
                        width: ScreenSize.setWidthPercent(ctx, 85) - 24,
                        menuHeight: ScreenSize.setHeightPercent(ctx, 30),
                        initialSelection: tipeIjin.first,
                        dropdownMenuEntries: tipeIjin
                            .map<DropdownMenuEntry<String>>((String value) {
                          return DropdownMenuEntry<String>(
                              value: value, label: value);
                        }).toList(),
                    ),
                    const SizedBox(height: 12,),
                    AutoSizeText(
                        'Tanggal',
                        style: CustomFont.headingEmpatSemiBold(),
                        maxLines: 1,
                    ),
                    const SizedBox(height: 2,),
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
                          )
                      ),
                    ),
                    const SizedBox(height: 12,),
                    Text(
                      'Alasan Cuti',
                      style: CustomFont.headingEmpatSemiBold(),
                    ),
                    const SizedBox(height: 2,),
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
                                vertical: 8, horizontal: 12))
                    ),
                    AutoSizeText(
                      'Jam',
                      style: CustomFont.headingEmpatSemiBold(),
                      maxLines: 1,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        final selectedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: ctx,
                        );

                        if (selectedTime != null) {
                          startTime = selectedTime;
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Text('${startTime.hour}:${startTime.minute}' ,style: CustomFont.headingEmpat(),
                          )),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/page/dialog/confirmation_dialog.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/style/custom_time_picker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/dummy.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
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
                      instructorSelected == 'Lainya'?
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
                        SizedBox(),
                        const SizedBox(height: 12,),
                        InkWell(
                      onTap: () async {
                        final confirm = await ConfirmationDialog.confirmation(ctx, 'Ajukan lembur?');
                        if (confirm != true) {
                          return;
                        }
                        NavigationService.back();
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
                    )
                    ],
                  ),
                ),
            );
          }
        );
      });
  }
}
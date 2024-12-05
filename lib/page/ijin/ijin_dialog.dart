import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:camera/camera.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/page/dialog/confirmation_dialog.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/style/custom_time_picker.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/data/network/response/base_response.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/notification.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';


class IjinDialog{
  static void showIjinDialog(BuildContext ctx){

    String selectedType = 'Izin Terlambat';

    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now();
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    bool isDoctorLetterAvailable = false;
    File? selectedImage;
    FilePickerResult? file;

    final ImagePicker picker = ImagePicker();
    List<String> tipeIjin = [
      'Izin Terlambat',
      'Izin Pulang Awal',
      'Izin Keluar Kantor',
      'Izin Tidak Masuk Kerja',
      'Izin Sakit',
      'Izin Menikah',
      'Izin Melahirkan',
      'Izin Lainnnya',
    ];

    TextEditingController tfReason = TextEditingController();    

    int calculateMinutesDifference(TimeOfDay startTime, TimeOfDay endTime) {
      int startMinutes = startTime.hour * 60 + startTime.minute;
      int endMinutes = endTime.hour * 60 + endTime.minute;

      int difference = endMinutes - startMinutes;

      if (difference < 0) {
        difference += 24 * 60;
      }

      return difference;
    }

    showDialog(
      context: ctx,
      builder: (BuildContext ctx){
        return StatefulBuilder(
          builder: (BuildContext ctxStateful, StateSetter setState) {
            
            Future<void> pickImage(ImageSource source) async {
              final XFile? pickedFile = await picker.pickImage(source: source);
              if (pickedFile != null) {
                setState(() {
                  selectedImage = File(pickedFile.path);
                });
              }
            }

            Widget getImageWidget() {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 6, horizontal: 12),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        pickImage(ImageSource.camera);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(7)
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                        child: AutoSizeText('Camera', minFontSize: 1, maxLines: 1, style: CustomFont.headingLimaSecondary(),),
                                      ),
                                    ),
                                    const SizedBox(width: 6,),
                                    InkWell(
                                      onTap: (){
                                        pickImage(ImageSource.gallery);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey,
                                          borderRadius: BorderRadius.circular(7)
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 4),
                                        child: AutoSizeText('Gallery', minFontSize: 1, maxLines: 1, style: CustomFont.headingLimaSecondary(),),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              isNotNullOrEmpty(selectedImage?.path)
                                  ? Column(
                                      children: [
                                        AutoSizeText(
                                          'Gambar dipilih',
                                          style:CustomFont.headingLimaSemiBold(),
                                          maxLines: 1,
                                          minFontSize: 6,
                                        ),
                                        const SizedBox(
                                          height: 2,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          width: ScreenSize.setWidthPercent(ctx, 50),
                                          child:
                                              Image.file(File(selectedImage!.path), fit: BoxFit.cover,),
                                        ),
                                      ],
                                    )
                                  : const SizedBox(width: 0,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
            }
                      
            Widget radioLetterWidget() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Surat Dokter',
                    style: CustomFont.headingEmpatSemiBold(),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                    value: true,
                                    activeColor: CustomColor.primary(),
                                    groupValue: isDoctorLetterAvailable,
                                    onChanged: (state) {
                                      setState(() {
                                        isDoctorLetterAvailable = state!;
                                      });
                                    }),
                                AutoSizeText(
                                  'Ada',
                                  style: CustomFont.headingLima(),
                                )
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                    value: false,
                                    activeColor: CustomColor.primary(),
                                    groupValue: isDoctorLetterAvailable,
                                    onChanged: (state) {
                                      setState(() {
                                        isDoctorLetterAvailable = state!;
                                      });
                                    }),
                                AutoSizeText(
                                  'Tidak Ada',
                                  style: CustomFont.headingLima(),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget startTimeWidget() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        builder: (BuildContext context, Widget? child) {
                          return CustomTimePicker.primary(child!);
                        },
                        initialTime: TimeOfDay.now(),
                        context: ctx,
                      );
                      if (selectedTime != null) {
                        setState((){
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
                        child: Text(CustomConverter.time(startTime),
                          style: CustomFont.headingEmpat(),
                        )),
                  ),
                ],
              );
            }
            
            Widget reasonIzinWidget(){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                color: Colors.grey, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6.0),
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 1.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12))),
                ],
              );
            }
            Widget endTimeWidget() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Selesai Jam',
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
                        setState((){
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
                ],
              );
            }

            Widget endDateWidget(){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Tanggal Selesai Izin',
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
                        firstDate: DateTime.now().subtract(const Duration(days: 30)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          endDate = selectedDate;
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
                ],
              );
            }

            Widget formByType(String type){
              if(type == 'Izin Terlambat'){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12,),
                    reasonIzinWidget()
                  ],
                );
              }else if(type == 'Izin Pulang Awal'){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    startTimeWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              }else if(type == 'Izin Keluar Kantor'){
                 return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    startTimeWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    endTimeWidget(),
                    const SizedBox(
                      height: 2,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: AutoSizeText(
                        '${calculateMinutesDifference(startTime, endTime)} Menit',
                        textAlign: TextAlign.end,
                        style: CustomFont.headingLimaColor(),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              }else if(type == 'Izin Tidak Masuk Kerja'){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              }else if(type == 'Izin Sakit'){
                 return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    radioLetterWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              }else if(type == 'Izin Menikah'){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    endDateWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    AutoSizeText('File Undangan', style: CustomFont.headingEmpatSemiBold(),),
                    const SizedBox(
                      height: 2,
                    ),
                    getImageWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                );
              }else if(type == 'Izin Melahirkan'){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    endDateWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    AutoSizeText(
                      'Dokumen HPL',
                      style: CustomFont.headingEmpatSemiBold(),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Container(
                            width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 6, horizontal: 12
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: ()async{
                                  file = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf']
                                  );
                                  setState((){
                                    file;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.grey),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  child: Text('Pilih File', style: CustomFont.headingLimaSecondary(),),
                                ),
                              ),
                              (file?.count??0) > 0?
                              Row(
                                children: [
                                  const SizedBox(width: 6,),
                                  AutoSizeText((file?.names[0]??''), style: CustomFont.standartFont(),),
                                ],
                              ): const SizedBox()
                            ],
                          ),
                          const SizedBox(height: 2,),
                          AutoSizeText('*hanya menerima file PDF', style: GoogleFonts.poppins(color: Colors.red),)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),       
                  ],
                );
              }else if(type == 'Izin Lainnya'){
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    endTimeWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              }else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    endDateWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              }
            }

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              child: AlertDialog(
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
                          Center(child: Text('Ajukan Izin', style: CustomFont.headingTigaSemiBold(),)),
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
                          height: 12,
                        ),
                      Flexible(
                        child: SingleChildScrollView(
                          
                          scrollDirection: Axis.vertical,
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
                                'Tipe Izin',
                                style: CustomFont.headingEmpatSemiBold(),
                                maxLines: 1,
                              ),
                              DropdownMenu<String>(
                                  onSelected: (value) {
                                    setState((){
                                      selectedType = value!;  
                                    });
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
                              formByType(selectedType),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: ()async{
                          final confirmationDialog = await ConfirmationDialog.confirmation(ctx, '$selectedType?');
                          BaseResponse networkResponse = BaseResponse();
                          if(confirmationDialog != true){
                            return;
                          }

                          if(selectedType == 'Izin Terlambat'){
                            if(isNullOrEmpty(tfReason.text)){
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.postIzin('1',DateFormat('yyyy-MM-dd').format(startDate),DateFormat('yyyy-MM-dd').format(endDate), CustomConverter.time(startTime), CustomConverter.time(endTime), tfReason.text, '0');
                          } else if(selectedType == 'Izin Pulang Awal'){
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.postIzin('2',DateFormat('yyyy-MM-dd').format(startDate),DateFormat('yyyy-MM-dd').format(endDate), CustomConverter.time(startTime), CustomConverter.time(endTime), tfReason.text, '0');
                          } else if(selectedType == 'Izin Keluar Kantor'){
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.postIzin('3',DateFormat('yyyy-MM-dd').format(startDate),DateFormat('yyyy-MM-dd').format(endDate), CustomConverter.time(startTime), CustomConverter.time(endTime), tfReason.text, '0');
                          } else if(selectedType == 'Izin Tidak Masuk Kerja'){
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.postIzin('4',DateFormat('yyyy-MM-dd').format(startDate),DateFormat('yyyy-MM-dd').format(endDate), CustomConverter.time(startTime), CustomConverter.time(endTime), tfReason.text, '0');
                          } else if(selectedType == 'Izin Sakit'){
                            String doctorLetter = '0';
                            if(isDoctorLetterAvailable){
                              doctorLetter = '1';
                            }
                            networkResponse = await NetworkRequest.postIzin('5',DateFormat('yyyy-MM-dd').format(startDate),DateFormat('yyyy-MM-dd').format(endDate), CustomConverter.time(startTime), CustomConverter.time(endTime), tfReason.text, doctorLetter);
                          } else if(selectedType == 'Izin Menikah'){
                            networkResponse = await NetworkRequest.postIjinBukti('6', DateFormat('yyyy-MM-dd').format(startDate), DateFormat('yyyy-MM-dd').format(endDate), (selectedImage?.path??''));
                          } else if(selectedType == 'Izin Melahirkan'){
                            networkResponse = await NetworkRequest.postIjinBukti('7', DateFormat('yyyy-MM-dd').format(startDate), DateFormat('yyyy-MM-dd').format(endDate), (file?.paths[0]??''));                            
                          } else if(selectedType == 'Izin Lainnnya'){
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.postIzin('8',DateFormat('yyyy-MM-dd').format(startDate),DateFormat('yyyy-MM-dd').format(endDate), CustomConverter.time(startTime), CustomConverter.time(endTime), tfReason.text, '0');
                          }

                          if(ctx.mounted){

                            if (networkResponse.state != true) {
                              NotificationStyle.warning(ctx, 'Gagal', networkResponse.message);
                              return;
                            }
                            NotificationStyle.info(ctx, 'Berhasil', networkResponse.message);
                          }
                          NavigationService.back();
                          
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: CustomContainer.buttonGreen(),
                          child: Center(child: Text('Ajukan Izin', style: CustomFont.headingDuaSemiBoldSecondary(),)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        );
      }
    );
  }
}

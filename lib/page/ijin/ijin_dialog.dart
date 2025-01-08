import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/izin_response.dart';
import 'package:eportal/page/dialog/confirmation_dialog.dart';
import 'package:eportal/page/dialog/viewer_dialog.dart';
import 'package:eportal/page/ijin/ijin_page.dart';
import 'package:eportal/provider/max_date.dart';
import 'package:eportal/style/custom_button.dart';
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
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

class IjinDialog{
  static Future<bool> showIjinDialog(BuildContext ctx)async{

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
      'Izin Lainnya',
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

    final result = await showDialog<bool>(
      context: ctx,
      builder: (BuildContext ctx){
        return StatefulBuilder(
          builder: (BuildContext ctxStateful, StateSetter setState) {
            void updateMaxDate() {
              if (selectedType == 'Izin Menikah') {
                ctx.read<MaxDateProvider>().updateDate(startDate, '2');
              } else if (selectedType == 'Izin Melahirkan') {
                ctx.read<MaxDateProvider>().updateDate(startDate, '3');
              } else if (selectedType == 'Izin Lainnya') {
                ctx.read<MaxDateProvider>().hardCode(startDate.add(const Duration(days: 30)));
              }
            }
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
                                isNotNullOrEmpty(selectedImage?.path)
                                  ? Row(
                                    children: [
                                      const SizedBox(width: 12,),
                                      InkWell(
                                          onTap: () {
                                            CustomViewer.filePhoto(
                                                ctx, selectedImage!);
                                          },
                                          child: AutoSizeText(
                                            'image.jpg',
                                            style:
                                                CustomFont.headingLimaWarning(),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        InkWell(
                                          onTap: ()async{
                                            final deleteResponse = await ConfirmationDialog.confirmation(ctx, 'Hapus gambar dipilih?');
                                            if(deleteResponse){
                                              setState((){
                                                File(selectedImage!.path).delete();
                                                selectedImage = null;
                                              });
                                            }
                                          },
                                          child: const Icon(Icons.close, color: Colors.red, size: 24,),
                                        )
                                    ],
                                  )
                                  : const SizedBox(
                                      width: 0,
                                    )
                              ],
                            ),
                          ),
                        ],
                      ),
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
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)
                    ),
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
                                }
                              ),
                              AutoSizeText(
                                'Ada',
                                style: CustomFont.headingLima(),
                              )
                            ],
                          )
                        ),
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
                          )
                        ),
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
                        horizontal: 12)
                    )
                  ),
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
                  Consumer<MaxDateProvider>(
                    builder: (ctxMaxDate, maxDateProvider, child){
                      return InkWell(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            builder: (BuildContext context, Widget? child) {
                              return CustomDatePicker.primary(child!);
                            },
                            context: ctx,
                            initialDate: startDate,
                            firstDate: startDate,
                            lastDate: maxDateProvider.date,
                          );
                          if (selectedDate != null) {
                            setState(() {
                              endDate = selectedDate;
                            });
                          }
                        },
                        
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                          child: 
                          maxDateProvider.isLoading?
                          Center(
                            child: LoadingAnimationWidget.waveDots(
                              color: CustomColor.primary(),
                              size: 20,
                            )
                          )
                          :Text(CustomConverter.dateToDay(DateFormat('yyyy-MM-dd').format(endDate)),style: CustomFont.headingEmpat(),)
                        ),
                      );
                    },
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
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 0.3,
                                      color: Colors.black
                                    )
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                  child: Text('Pilih File', style: CustomFont.headingLima(),),
                                ),
                              ),
                              (file?.count??0) > 0?
                              Row(
                                children: [
                                  const SizedBox(width: 6,),
                                  SizedBox(
                                    width: 120,
                                    child: InkWell(
                                      onTap: (){
                                        CustomViewer.pdfFile(ctx, File(file!.paths[0]!));
                                      },
                                      child: AutoSizeText((file?.names[0]??''), style: GoogleFonts.poppins(color: Colors.red), softWrap: true, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                                  ),
                                  const SizedBox(width: 6,),
                                  InkWell(
                                    onTap: () async{
                                      final removeState = await ConfirmationDialog.confirmation(ctx, 'Hapus file dipilih?');
                                      if(removeState){
                                        setState(() {
                                          file = null;
                                        });
                                      }
                                    },
                                    child: const Icon(Icons.close, color: Colors.red, size: 21,),
                                  )
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
                    endDateWidget(),
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
                    AutoSizeText('Tipe Izin tidak diketahui', style: CustomFont.headingDuaSemiBold(),)
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
                  constraints: BoxConstraints(
                    maxHeight: ScreenSize.setHeightPercent(ctx, 70)
                  ),
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
                        child: Scrollbar(
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
                                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                                          
                                    if (selectedDate != null) {
                                      setState(() {
                                        startDate = selectedDate;
                                        updateMaxDate();
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
                                      updateMaxDate();
                                    },
                                    menuStyle: const MenuStyle(
                                      backgroundColor: WidgetStatePropertyAll<Color>(Colors.white),
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
                            if(isNullOrEmpty(selectedImage?.path)){
                              return ShowToast.error('Undangan tidak ada');
                            }
                            networkResponse = await NetworkRequest.postIjinBukti('7', DateFormat('yyyy-MM-dd').format(startDate), DateFormat('yyyy-MM-dd').format(endDate), selectedImage!.path);
                          } else if(selectedType == 'Izin Melahirkan'){
                            if (isNullOrEmpty(file?.paths[0])) {
                              return ShowToast.error('Dokumen hpl tidak ada');
                            }
                            networkResponse = await NetworkRequest.postIjinBukti('8', DateFormat('yyyy-MM-dd').format(startDate), DateFormat('yyyy-MM-dd').format(endDate), file!.paths[0]!);                            
                          } else if(selectedType == 'Izin Lainnya'){
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.postIzin('6',DateFormat('yyyy-MM-dd').format(startDate), DateFormat('yyyy-MM-dd').format(endDate), CustomConverter.time(startTime), CustomConverter.time(endTime), tfReason.text, '0');
                          }

                          if (networkResponse.state != true) {
                            if(ctx.mounted){
                              NotificationStyle.warning(ctx, 'Gagal', networkResponse.message);
                            }
                            return;
                          }

                          if(ctx.mounted){
                            NotificationStyle.info(ctx, 'Berhasil', networkResponse.message);
                          }
                          NavigationService.backWithData(true);
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

    return result??false;
  }

  static Future<bool> showIzinDetail(BuildContext ctx, IzinListModel data) async{
    final baseUrl = dotenv.env['SERVER_URL'];

    Widget reasonIzinWidget() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Alasan Izin', style: CustomFont.headingEmpatSemiBold(),
          ),
          const SizedBox(
            height: 2,
          ),
          TextField(
            minLines: 3,
            maxLines: 5,
            readOnly: true,
            controller: TextEditingController(text: data.reason),
            decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Colors.grey, width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6.0),
              borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12))),
        ],
      );
    }

    Widget hplPdf() {
      return SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dokumen bukti HPL',
              style: CustomFont.headingEmpatSemiBold(),
            ),
            const SizedBox(
              height: 2,
            ),
            InkWell(
              onTap: (){
                CustomViewer.detectImageOrPdf(ctx, Uri.parse('$baseUrl/${data.hlpUrl}').toString());
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: Colors.grey, width: 1.0
                  )
                ),
                child: Text('hpl', style: CustomFont.headingLimaColorUnderlined()),
              ),
            ),
          ],
        ),
      );
    }

    Widget invitationImage() {
      return SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dokumen bukti HPL',
              style: CustomFont.headingEmpatSemiBold(),
            ),
            const SizedBox(
              height: 2,
            ),
            InkWell(
              onTap: () {
                CustomViewer.detectImageOrPdf(
                    ctx, Uri.parse('$baseUrl/${data.invitationUrl}').toString());
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.grey, width: 1.0)),
                child: Text(
                  'invitation',
                  style: CustomFont.headingLimaColorUnderlined(),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget universalDescription(String title, String content){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CustomFont.headingEmpatSemiBold(),),
          const SizedBox(
            height: 2,
          ),
          TextField(
            readOnly: true,
            controller: TextEditingController(text: content),
            maxLines: 2,
            minLines: 1,
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(color: Colors.grey, width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(color: Colors.grey, width: 1.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12)
            )
          )
        ],
      );
    }

    Widget detailWidget(){ 
      if(data.type == 1){
        return Column(
          children: [
            reasonIzinWidget()
          ],
        );
      } else if(data.type == 2){
        return Column(
          children: [
            universalDescription('jam', CustomConverter.time(data.startTime!)),
            const SizedBox(
              height: 12,
            ),
            reasonIzinWidget()
          ],
        );
      } else if (data.type == 3) {
        return Column(
          children: [
            universalDescription('Jam', CustomConverter.time(data.startTime!)),
            const SizedBox(
              height: 12,
            ),
            universalDescription('Selesai jam', CustomConverter.time(data.finishTime!)),
            const SizedBox(
              height: 12,
            ),
            reasonIzinWidget()
          ],
        );
      } else if (data.type == 4) {
        return Column(
          children: [
            reasonIzinWidget()
          ],
        );
      } else if (data.type == 5) {
        return Column(
          children: [
            universalDescription('Surat Dokter', data.doctorLetter == '1'? 'Ada': 'Tidak Ada'),
            const SizedBox(
              height: 12,
            ),
            reasonIzinWidget()
          ],
        );
      } else if (data.type == 6) {
        return Column(
          children: [
            universalDescription('Sampai Tanggal', CustomConverter.dateToDay(data.finishDate.toString())),
            const SizedBox(
              height: 12,
            ),
            reasonIzinWidget()
          ],
        );
      } else if (data.type == 7) {
        return Column(
          children: [ 
            const SizedBox(
              height: 12,
            ),
            universalDescription('Sampai Tanggal', CustomConverter.dateToDay(data.finishDate.toString())),
            const SizedBox(
              height: 12,
            ),
            invitationImage()
          ],
        );
      } else if (data.type == 8) {
        return Column(
          children: [ 
            const SizedBox(
              height: 12,
            ),
            universalDescription('Sampai Tanggal', CustomConverter.dateToDay(data.finishDate.toString())),
            const SizedBox(
              height: 12,
            ),
            hplPdf()
          ],
        );
      } else{
        return const SizedBox();
      }
    }

    final result = await showDialog(
      context: ctx,
      builder: (BuildContext ctxDialog) {
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
              borderRadius: BorderRadius.circular(20)
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
                    AutoSizeText(
                      data.type == 1?
                      'Izin Terlambat':
                      data.type == 2?
                      'Izin Pulang Cepat':
                      data.type == 3?
                      'Izin Keluar Kantor':
                      data.type == 4?
                      'Izin Tidak Masuk Kerja':
                      data.type == 5?
                      'Izin Sakit':
                      data.type == 6?
                      'Izin Lain':
                      data.type == 7?
                      'Izin Menikah':
                      data.type == 8?
                      'Izin Melahirkan':
                      'Izin Tidak diketahui',
                      style: CustomFont.headingTigaSemiBold(),
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
                const SizedBox(height: 12,),
                Flexible(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          universalDescription('Tanggal', CustomConverter.dateToDay(data.startDate.toString())),
                          const SizedBox(height: 12,),
                          Text('Status', style: CustomFont.headingEmpatSemiBold(),),
                          const SizedBox(
                            height: 2,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: Colors.grey, width: 1.0
                              )
                            ),
                            child: 
                              data.state == 1? Text('Menunggu', style: CustomFont.headingEmpatWarning()):
                              data.state == 2? Text('Desetujui', style: CustomFont.headingEmpatApprove()):
                              data.state == 3? Text('Ditolak', style: CustomFont.headingEmpatReject()):
                              data.state == 4? Text('Dibatalkan', style: CustomFont.headingEmpatReject()):const SizedBox()
                          ),
                          const SizedBox(height: 12,),
                          detailWidget(),
                          data.state == 3?
                          Column(
                            children: [
                              const SizedBox(height: 12,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Alasan Ditolak', style: CustomFont.headingEmpatSemiBoldRed(),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  TextField(
                                    minLines: 3,
                                    maxLines: 5,
                                    readOnly: true,
                                    controller: TextEditingController(text: data.rejectReason??''),
                                    decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12))),
                                ],
                              ),
                            ],
                          ): const SizedBox(),
                          const SizedBox(height: 12,),
                          Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             data.editable == true?
                             InkWell(
                               onTap: (){
                                 NavigationService.back();
                                 IjinDialog.showEditIjinDialog(ctx, data);
                               },
                               child: CustomButton.edit()
                             ): const SizedBox(),
                             const SizedBox(width: 6,),
                             data.cancelable == true?
                             InkWell(
                               onTap: () async{
                                 final cancelState = await ConfirmationDialog.confirmation(ctx, 'Batalkan Izin?');
                                 if(cancelState){
                                   final cancelResponse = await NetworkRequest.cancelIzin(data.id??'');
                                   if(cancelResponse.state == true){
                                     if(ctx.mounted){
                                       NotificationStyle.info(ctx, 'Berhasil', 'Izin dibatalkan');
                                     }
                                     NavigationService.backWithData(true);
                                   }else{
                                     if (ctx.mounted) {
                                       NotificationStyle.info(ctx, 'Gagal', 'Gagal membatalkan izin');
                                     }
                                   }
                                 }
                               },
                               child: CustomButton.cancel()
                             ): const SizedBox()
                           ],
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

    return result??false;
  }

  static Future<bool> showEditIjinDialog(BuildContext ctx, IzinListModel data) async{
    
    final baseUrl = dotenv.env['SERVER_URL'];
    
    TimeOfDay startTime = data.startTime??TimeOfDay.now();
    TimeOfDay endTime = data.finishTime ?? TimeOfDay.now();
    DateTime startDate = data.startDate ?? DateTime.now();
    DateTime endDate = data.finishDate ?? DateTime.now();
    
    bool isDoctorLetterAvailable = data.doctorLetter == '1'? true: false;
    
    File? selectedImage;
    FilePickerResult? file;

    final ImagePicker picker = ImagePicker();

    TextEditingController tfReason = TextEditingController(text: data.reason);
    
    void updateMaxDate() {
      if (data.type == 7) {
        ctx.read<MaxDateProvider>().updateDate(startDate, '2');
      } else if (data.type == 8) {
        ctx.read<MaxDateProvider>().updateDate(startDate, '3');
      }else if(data.type == 6){
        ctx.read<MaxDateProvider>().hardCode(startDate.add(const Duration(days: 30)));
      }
    }

    updateMaxDate();

    int calculateMinutesDifference(TimeOfDay startTime, TimeOfDay endTime) {
      int startMinutes = startTime.hour * 60 + startTime.minute;
      int endMinutes = endTime.hour * 60 + endTime.minute;

      int difference = endMinutes - startMinutes;

      if (difference < 0) {
        difference += 24 * 60;
      }

      return difference;
    }

    final result = await showDialog(
        context: ctx,
        builder: (BuildContext ctx) {
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
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  pickImage(ImageSource.camera);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(7)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  child: AutoSizeText(
                                    'Camera',
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style:
                                        CustomFont.headingLimaSecondary(),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              InkWell(
                                onTap: () {
                                  pickImage(ImageSource.gallery);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius:
                                          BorderRadius.circular(7)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  child: AutoSizeText(
                                    'Gallery',
                                    minFontSize: 1,
                                    maxLines: 1,
                                    style:
                                        CustomFont.headingLimaSecondary(),
                                  ),
                                ),
                              ),
                              isNotNullOrEmpty(selectedImage?.path)
                                  ? Row(
                                      children: [
                                        const SizedBox(
                                          width: 12,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            CustomViewer.filePhoto(
                                                ctx, selectedImage!);
                                          },
                                          child: AutoSizeText(
                                            'image.jpg',
                                            style: CustomFont
                                                .headingLimaWarning(),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            final deleteResponse =
                                                await ConfirmationDialog
                                                    .confirmation(ctx,
                                                        'Hapus gambar dipilih?');
                                            if (deleteResponse) {
                                              setState(() {
                                                File(selectedImage!.path)
                                                    .delete();
                                                selectedImage = null;
                                              });
                                            }
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 24,
                                          ),
                                        )
                                      ],
                                    )
                                  : InkWell(
                                      onTap: (){
                                        CustomViewer.detectImageOrPdf(ctx, Uri.parse('$baseUrl/${data.invitationUrl}').toString());
                                      },
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 6,),
                                          AutoSizeText('uploaded', style: CustomFont.headingLimaColorUnderlined(),)
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ],
                    ),
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
                ],
              );
            }

            Widget reasonIzinWidget() {
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
                ],
              );
            }

            Widget endDateWidget() {
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
                            firstDate: DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: maxDateProvider.date,
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
                                            .format(endDate)),
                                    style: CustomFont.headingEmpat(),
                                  )),
                      );
                    },
                  ),
                  /*InkWell(
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        builder: (BuildContext context, Widget? child) {
                          return CustomDatePicker.primary(child!);
                        },
                        context: ctx,
                        initialDate: endDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 30)),
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
                */],
              );
            }

            Widget formByType() {
              if (data.type == 1) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    reasonIzinWidget()
                  ],
                );
              } else if (data.type == 2) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    startTimeWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              } else if (data.type == 3) {
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
              } else if (data.type == 4) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 12,
                    ),
                    reasonIzinWidget()
                  ],
                );
              } else if (data.type == 5) {
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
              } else if (data.type == 7) {
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
                      'File Undangan',
                      style: CustomFont.headingEmpatSemiBold(),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    getImageWidget(),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                );
              } else if (data.type == 8) {
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
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  file = await FilePicker.platform.pickFiles(
                                      type: FileType.custom,
                                      allowedExtensions: ['pdf']);
                                  setState(() {
                                    file;
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    color: Colors.white,
                                    border: Border.all(
                                      width: 0.3,
                                      color: Colors.black
                                    )
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 4),
                                  child: Text(
                                    'Pilih File',
                                    style: CustomFont.headingLima(),
                                  ),
                                ),
                              ),
                              (file?.count ?? 0) > 0
                                  ? Row(
                                      children: [
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: InkWell(
                                              onTap: () {
                                                CustomViewer.pdfFile(
                                                    ctx, File(file!.paths[0]!));
                                              },
                                              child: AutoSizeText(
                                                (file?.names[0] ?? ''),
                                                style: GoogleFonts.poppins(
                                                    color: Colors.red),
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            final removeState =
                                                await ConfirmationDialog
                                                    .confirmation(ctx,
                                                        'Hapus file dipilih?');
                                            if (removeState) {
                                              setState(() {
                                                file = null;
                                              });
                                            }
                                          },
                                          child: const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                            size: 21,
                                          ),
                                        )
                                      ],
                                    )
                                  : InkWell(
                                    onTap: (){
                                      CustomViewer.detectImageOrPdf(ctx, Uri.parse('$baseUrl/${data.hlpUrl}').toString());
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 6,),
                                        AutoSizeText('uploaded', style: CustomFont.headingLimaColorUnderlined(),),
                                      ],
                                    ),
                                  )
                            ],
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          AutoSizeText(
                            '*hanya menerima file PDF',
                            style: GoogleFonts.poppins(color: Colors.red),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                );
              } else if (data.type == 6) {
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
              } else {
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
                  constraints: BoxConstraints(maxHeight: ScreenSize.setHeightPercent(ctx, 70)),
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
                            child: AutoSizeText(
                              data.type == 1?
                              'Izin Terlambat':
                              data.type == 2?
                              'Izin Keluar Kantor':
                              data.type == 3?
                              'Izin Pulang Cepat':
                              data.type == 4?
                              'Izin Tidak Masuk Kerja':
                              data.type == 5?
                              'Izin Sakit':
                              data.type == 6?
                              'Izin Lain':
                              data.type == 7?
                              'Izin Menikah':
                              data.type == 8?
                              'Izin Melahirkan':
                              'Izin Tidak diketahui',
                              style: CustomFont.headingTigaSemiBold(),
                            ),
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
                      Flexible(
                        child: Scrollbar(
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
                                      builder:(BuildContext context, Widget? child) {
                                        return CustomDatePicker.primary(child!);
                                      },
                                      context: ctx,
                                      initialDate: startDate,
                                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                      lastDate: DateTime.now().add(const Duration(days: 365)),
                                    );
                          
                                    if (selectedDate != null) {
                                      setState(() {
                                        startDate = selectedDate;
                                        endDate =selectedDate;
                                        updateMaxDate();
                                      });
                                    }
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric( vertical: 6, horizontal: 12),
                                      width: double.infinity,
                                      decoration: BoxDecoration(border: Border.all( width: 1, color: Colors.grey)),
                                      child: Text(
                                        CustomConverter.dateToDay(
                                            DateFormat('yyyy-MM-dd').format(startDate)),
                                        style: CustomFont.headingEmpat(),
                                      )),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                formByType(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          final confirmationDialog = await ConfirmationDialog.confirmation(ctx, 'Ubah ${data.type == 1?
                              'Izin Terlambat':
                              data.type == 2?
                              'Izin Keluar Kantor':
                              data.type == 3?
                              'Izin Pulang Cepat':
                              data.type == 4?
                              'Izin Tidak Masuk Kerja':
                              data.type == 5?
                              'Izin Sakit':
                              data.type == 6?
                              'Izin Lain':
                              data.type == 7?
                              'Izin Menikah':
                              data.type == 8?
                              'Izin Melahirkan':
                              'Izin Tidak diketahui'}?');
                          BaseResponse networkResponse = BaseResponse();
                          if (confirmationDialog != true) {
                            return;
                          }

                          if (data.type == 1) {
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.editIzin(
                                data.id??'',
                                data.type.toString(),
                                DateFormat('yyyy-MM-dd').format(startDate),
                                DateFormat('yyyy-MM-dd').format(endDate),
                                CustomConverter.time(startTime),
                                CustomConverter.time(endTime),
                                tfReason.text,
                                '0');
                          } else if (data.type == 2) {
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.editIzin(
                                data.id??'',
                                data.type.toString(),
                                DateFormat('yyyy-MM-dd').format(startDate),
                                DateFormat('yyyy-MM-dd').format(endDate),
                                CustomConverter.time(startTime),
                                CustomConverter.time(endTime),
                                tfReason.text,
                                '0');
                          } else if ( data.type == 3) {
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.editIzin(
                                data.id??'',
                                data.type.toString(),
                                DateFormat('yyyy-MM-dd').format(startDate),
                                DateFormat('yyyy-MM-dd').format(endDate),
                                CustomConverter.time(startTime),
                                CustomConverter.time(endTime),
                                tfReason.text,
                                '0');
                          } else if (data.type == 4) {
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.editIzin(
                                data.id??'',
                                data.type.toString(),
                                DateFormat('yyyy-MM-dd').format(startDate),
                                DateFormat('yyyy-MM-dd').format(endDate),
                                CustomConverter.time(startTime),
                                CustomConverter.time(endTime),
                                tfReason.text,
                                '0');
                          } else if (data.type == 5) {
                            String doctorLetter = '0';
                            if (isDoctorLetterAvailable) {
                              doctorLetter = '1';
                            }
                            networkResponse = await NetworkRequest.editIzin(
                                data.id??'',
                                data.type.toString(),
                                DateFormat('yyyy-MM-dd').format(startDate),
                                DateFormat('yyyy-MM-dd').format(endDate),
                                CustomConverter.time(startTime),
                                CustomConverter.time(endTime),
                                tfReason.text,
                                doctorLetter);
                          } else if (data.type == 7) {

                            networkResponse = await NetworkRequest.putIjinBukti(
                                    data.id!,
                                    data.type.toString(),
                                    DateFormat('yyyy-MM-dd').format(startDate),
                                    DateFormat('yyyy-MM-dd').format(endDate),
                                    selectedImage?.path);
                          } else if (data.type == 8) {
                            networkResponse = await NetworkRequest.putIjinBukti(
                                    data.id!,
                                    data.type.toString(),
                                    DateFormat('yyyy-MM-dd').format(startDate),
                                    DateFormat('yyyy-MM-dd').format(endDate),
                                    file?.paths[0]);
                          } else if (data.type == 6) {
                            if (isNullOrEmpty(tfReason.text)) {
                              return ShowToast.error('Alasan kosong');
                            }
                            networkResponse = await NetworkRequest.editIzin(
                                data.id??'',
                                data.type.toString(),
                                DateFormat('yyyy-MM-dd').format(startDate),
                                DateFormat('yyyy-MM-dd').format(endDate),
                                CustomConverter.time(startTime),
                                CustomConverter.time(endTime),
                                tfReason.text,
                                '0');
                          }

                          if (ctx.mounted) {
                            if (networkResponse.state != true) {
                              NotificationStyle.warning(ctx, 'Gagal', networkResponse.message);
                              return;
                            }
                            NotificationStyle.info(ctx, 'Berhasil', networkResponse.message);
                          }
                          NavigationService.back();
                          NavigationService.replacePage(IjinPage.nameRoute);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 12),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                          decoration: CustomContainer.buttonGreen(),
                          child: Center(
                              child: Text(
                            'Ajukan Ulang Izin',
                            style: CustomFont.headingDuaSemiBoldSecondary(),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
      }
    );

    return result ?? false;
  }
}
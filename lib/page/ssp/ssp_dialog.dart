import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/base_response.dart';
import 'package:eportal/data/network/response/ssp_response.dart';
import 'package:eportal/page/dialog/confirmation_dialog.dart';
import 'package:eportal/page/dialog/viewer_dialog.dart';
import 'package:eportal/style/custom_button.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_date_picker.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/dummy.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SspDialog{

  static List<String> sspType = DummyData.typeSsp();

  static Future<bool> addSsp(BuildContext ctx, SspValue? value)async{
    String selectedType = sspType.first;
    TextEditingController tfNote = TextEditingController();

    TextEditingController tfPartnerName = TextEditingController();
    TextEditingController tfBabyName = TextEditingController();
    TextEditingController tfNumberBaby = TextEditingController(text: '1');
    TextEditingController tfFamilyHubName = TextEditingController();
    TextEditingController tfTheLateName = TextEditingController();
    DateTime dieDate = DateTime.now();
    String marriageBookPath = '';
    String birthCertificatePath = '';
    String deathCertificatePath = '';
    String familyCardPath = '';
    num sspValue = 0;
    String babyGender = 'Laki-Laki';

    final ImagePicker picker = ImagePicker();

    final result = await showDialog(
      barrierDismissible: false,
      context: ctx,
      builder: (BuildContext ctx){
        return StatefulBuilder(
          builder: (BuildContext ctxStateful, StateSetter setState){
            if(selectedType == 'Pernikahan'){
              sspValue = value?.typeSatu??0;
            }else if(selectedType == 'Kelahiran'){
              sspValue = value?.typeDua??0;
            }else if(selectedType == 'Kematian Keluarga'){
              sspValue = value?.typeTiga??0;
            }else if(selectedType == 'Kematian Orang Tua'){
              sspValue = value?.typeEmpat??0;
            }
            Widget marriageBookUpload(){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Buku nikah',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async{
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                                if(pickedFile != null){
                                  if (isNotNullOrEmpty(marriageBookPath)) {
                                    File(marriageBookPath).delete();
                                  }
                                  setState(() {
                                    marriageBookPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(
                                    width: 0.5,
                                    color: Colors.black
                                  ),
                                  borderRadius:BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric( horizontal: 6, vertical: 4),
                                child: AutoSizeText('Camera', minFontSize: 1, maxLines: 1, style:CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async{
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                if(pickedFile != null){
                                  if (isNotNullOrEmpty(marriageBookPath)) {
                                    File(marriageBookPath).delete();
                                  }
                                  setState(() {
                                    marriageBookPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  border: Border.all(width: 0.5, color: Colors.black),
                                  borderRadius: BorderRadius.circular(7)
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(marriageBookPath)? 
                        Expanded(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 6,
                              ),
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    CustomViewer.filePhoto(ctx, File(marriageBookPath));
                                  },
                                  child: AutoSizeText(
                                      'buku nikah.jpg',
                                      minFontSize: 14,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomFont.headingLimaWarning(),
                                    ),
                                ),
                              ),
                              InkWell(
                                  onTap: () async {
                                    final deleteResponse = await ConfirmationDialog.confirmation(ctx, 'Hapus gambar dipilih?');
                                    if (deleteResponse) {
                                      setState(() {
                                        File(marriageBookPath).delete();
                                        marriageBookPath = '';
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 19,
                                  ),
                                ),
                              ],
                          ),
                        )
                        : const SizedBox()
                      ],
                    ),
                  ),                  
                ],
              );
            }

            Widget bornCertificateUpload() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Akta Lahir',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(birthCertificatePath)) {
                                    File(birthCertificatePath).delete();
                                  }
                                  setState(() {
                                    birthCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Camera',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(birthCertificatePath)) {
                                    File(birthCertificatePath).delete();
                                  }
                                  setState(() {
                                    birthCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(birthCertificatePath)
                            ? Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          CustomViewer.filePhoto(
                                              ctx, File(birthCertificatePath));
                                        },
                                        child: AutoSizeText(
                                          'Akta kelahiran.jpg',
                                          minFontSize: 14,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              CustomFont.headingLimaWarning(),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final deleteResponse =
                                            await ConfirmationDialog
                                                .confirmation(ctx,
                                                    'Hapus gambar dipilih?');
                                        if (deleteResponse) {
                                          setState(() {
                                            File(birthCertificatePath).delete();
                                            birthCertificatePath = '';
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 19,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget familyCardUpload() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Kartu Keluarga',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(familyCardPath)) {
                                    File(familyCardPath).delete();
                                  }
                                  setState(() {
                                    familyCardPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Camera',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(familyCardPath)) {
                                    File(familyCardPath).delete();
                                  }
                                  setState(() {
                                    familyCardPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(familyCardPath)
                            ? Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          CustomViewer.filePhoto(
                                              ctx, File(familyCardPath));
                                        },
                                        child: AutoSizeText(
                                          'kk.jpg',
                                          minFontSize: 14,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              CustomFont.headingLimaWarning(),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final deleteResponse =
                                            await ConfirmationDialog.confirmation(ctx, 'Hapus gambar dipilih?');
                                        if (deleteResponse) {
                                          setState(() {
                                            File(familyCardPath).delete();
                                            familyCardPath = '';
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 19,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget dieCertificateUpload() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Surat keterangan meninggal',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(deathCertificatePath)) {
                                    File(deathCertificatePath).delete();
                                  }
                                  setState(() {
                                    deathCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Camera',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(deathCertificatePath)) {
                                    File(deathCertificatePath).delete();
                                  }
                                  setState(() {
                                    deathCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(deathCertificatePath)
                            ? Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          CustomViewer.filePhoto(
                                              ctx, File(deathCertificatePath));
                                        },
                                        child: AutoSizeText(
                                          'skm.jpg',
                                          minFontSize: 14,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              CustomFont.headingLimaWarning(),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final deleteResponse =
                                            await ConfirmationDialog
                                                .confirmation(ctx,
                                                    'Hapus gambar dipilih?');
                                        if (deleteResponse) {
                                          setState(() {
                                            File(deathCertificatePath).delete();
                                            familyCardPath = '';
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 19,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget note() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Catatan Tambahan',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfNote,
                    maxLines: 5,
                    minLines: 3,
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
                        vertical: 4,
                        horizontal: 6
                      ), 
                    ),
                    style: CustomFont.headingLima(),
                  ),
                ],
              );
            }

            Widget marriage(){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Nama Pasangan',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfPartnerName,
                    maxLines: 1,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6)
                    ),
                    style: CustomFont.headingLima(),
                    
                  ),
                  const SizedBox(height: 12,),
                  marriageBookUpload(),
                  const SizedBox(height: 12,),
                  note()
                ],
              );
            }

            Widget born(){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Nama Anak',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfBabyName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(height: 12,),
                  Text(
                    'Jenis Kelamin',
                    style: CustomFont.headingEmpatSemiBold(),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
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
                                value: 'Laki-Laki',
                                activeColor: CustomColor.primary(),
                                groupValue: babyGender,
                                onChanged: (state) {
                                  setState(() {
                                    babyGender = state.toString();
                                  });
                                }
                              ),
                              AutoSizeText(
                                'Laki - Laki',
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
                                value: 'Perempuan',
                                activeColor: CustomColor.primary(),
                                groupValue: babyGender,
                                onChanged: (state) {
                                  setState(() {
                                    babyGender = state.toString();
                                  });
                                }),
                                AutoSizeText(
                                  'Perempuan',
                                  style: CustomFont.headingLima(),
                                )
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AutoSizeText(
                    'Anak ke',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfNumberBaby,
                    maxLines: 2,
                    minLines: 1,
                    maxLength: 1,
                    keyboardType: TextInputType.number,
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
                  ),
                  bornCertificateUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  marriageBookUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  note()
                ],
              );
            }

            Widget familyDie(){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Hubungan Keluarga',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfFamilyHubName,
                    maxLines: 1,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Nama Almarhum',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfTheLateName,
                    maxLines: 1,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Tanggal Meninggal',
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
                        initialDate: dieDate,
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          dieDate = selectedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)
                      ),
                      child: Text(CustomConverter.dateTimeToDay(dieDate),
                      style: CustomFont.headingEmpat())
                    ),
                  ),
                  const SizedBox(height: 12,),
                  marriageBookUpload(),
                  const SizedBox(height: 12,),
                  dieCertificateUpload(),
                  const SizedBox(height: 12,),
                  familyCardUpload(),
                  const SizedBox(height: 12,),
                  note()
                ],
              );
            }
            
            Widget parentDie(){
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Hubungan Keluarga',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfFamilyHubName,
                    maxLines: 1,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Nama Almarhum',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfTheLateName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Tanggal Meninggal',
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
                        initialDate: dieDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          dieDate = selectedDate;
                        });
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Text(CustomConverter.dateTimeToDay(dieDate),
                            style: CustomFont.headingEmpat())),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  dieCertificateUpload()
                ],
              );
            }
            
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
                  maxHeight: ScreenSize.setHeightPercent(ctx, 70),
                  minHeight: 0
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.3, color: Colors.grey)
                ),
                child: Column(
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
                          'Ajukan SSP',
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
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            
                            AutoSizeText(
                              'Tipe SSP',
                              style: CustomFont.headingEmpatSemiBold(),
                              maxLines: 1,
                            ),
                            DropdownMenu<String>(
                              onSelected: (value) {
                                setState(() {
                                  selectedType = value!;
                                });
                              },
                              menuStyle: const MenuStyle(
                                backgroundColor:WidgetStatePropertyAll<Color>(Colors.white),
                              ),
                              width: ScreenSize.setWidthPercent(ctx, 85) - 24,
                              menuHeight: ScreenSize.setHeightPercent(ctx, 30),
                              initialSelection: sspType.first,
                              dropdownMenuEntries: sspType.map<DropdownMenuEntry<String>>((String value) {
                                return DropdownMenuEntry<String>(
                                  value: value, label: value
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 12,),
                            AutoSizeText(
                              'Jumlah Sumbangan',
                              style: CustomFont.headingEmpatSemiBold(),
                              maxLines: 1,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              width: double.infinity,
                              decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.grey), borderRadius: BorderRadius.circular(6)),
                              child: Text(CustomConverter.numToRp(sspValue) ,style: CustomFont.headingEmpat()
                              )
                            ),
                            const SizedBox(height: 12,),
                            selectedType == 'Pernikahan'?
                            marriage():
                            selectedType == 'Kelahiran'?
                            born():
                            selectedType == 'Kematian Keluarga'?
                            familyDie():
                            selectedType == 'Kematian Orang Tua'?
                            parentDie():
                            const SizedBox(),
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () async {
                                final isConfirmed = await ConfirmationDialog.confirmation(ctx, 'Ajukan SSP');
                                if(!isConfirmed){
                                  return;
                                }
                                
                                int type = 0;
                                if(selectedType == 'Pernikahan'){
                                  type = 1;
                                }else if(selectedType == 'Kelahiran'){
                                  type = 2;
                                } else if (selectedType == 'Kematian Keluarga') {
                                  type = 3;
                                } else if (selectedType == 'Kematian Orang Tua') {
                                  type = 4;
                                }
                                
                                BaseResponse response;
                                
                                if(type == 1){
                                  if(isNullOrEmpty(tfPartnerName.text)){
                                    ShowToast.warning('Nama Pasangan Kosong');
                                    return;
                                  }
                                  if (!isFileExist(marriageBookPath)) {
                                    ShowToast.warning('Buku nikah tidak ada');
                                    return;
                                  }
                                  response = await NetworkRequest.postSsp(type, marriageBookPath, birthCertificatePath, deathCertificatePath, familyCardPath, tfPartnerName.text, tfBabyName.text, '1', tfNumberBaby.text, tfFamilyHubName.text, tfTheLateName.text, dieDate, tfNote.text);
                                }else if(type ==2){
                                  String jkCode = '1';
                                  if(babyGender == 'Laki-Laki'){
                                    jkCode = '1';
                                  }else if(babyGender == 'Perempuan'){
                                    jkCode = '2';
                                  }

                                  if (isNullOrEmpty(tfBabyName.text)) {
                                    ShowToast.warning('Nama Anak Kosong');
                                    return;
                                  }

                                  if (isNullOrEmpty(tfNumberBaby.text) || tfNumberBaby.text == '0') {
                                    ShowToast.warning('Urutan anak tidak valid');
                                    return;
                                  }

                                  if(!isFileExist(birthCertificatePath)){
                                    ShowToast.warning('Akta lahir tidak ada');
                                    return;
                                  }

                                  if (!isFileExist(marriageBookPath)) {
                                    ShowToast.warning('Buku Nikah tidak ada');
                                    return;
                                  }

                                  response = await NetworkRequest.postSsp(type, marriageBookPath, birthCertificatePath, deathCertificatePath, familyCardPath, tfPartnerName.text, tfBabyName.text, jkCode, tfNumberBaby.text, tfFamilyHubName.text, tfTheLateName.text, dieDate, tfNote.text);
                                }else if(type == 3){
                                  if (isNullOrEmpty(tfFamilyHubName.text)) {
                                    ShowToast.warning('Hubungan Keluarga belum diisi');
                                    return;
                                  }

                                  if (isNullOrEmpty(tfTheLateName.text)) {
                                    ShowToast.warning('Nama Almarhum belum diisi');
                                    return;
                                  }

                                  if (!isFileExist(marriageBookPath)) {
                                    ShowToast.warning('Buku Nikah tidak ada');
                                    return;
                                  }

                                  if (!isFileExist(deathCertificatePath)) {
                                    ShowToast.warning('Surat Keratangan Meninggal tidak ada');
                                    return;
                                  }

                                  if (!isFileExist(familyCardPath)) {
                                    ShowToast.warning('Kartu Keluarga tidak ada');
                                    return;
                                  }

                                  response = await NetworkRequest.postSsp(type, marriageBookPath, birthCertificatePath, deathCertificatePath, familyCardPath, tfPartnerName.text, tfBabyName.text, '1', tfNumberBaby.text, tfFamilyHubName.text, tfTheLateName.text, dieDate, tfNote.text);
                                }else if(type == 4 ){
                                  if (isNullOrEmpty(tfFamilyHubName.text)) {
                                    ShowToast.warning('Hubungan Keluarga belum diisi');
                                    return;
                                  }

                                  if (isNullOrEmpty(tfTheLateName.text)) {
                                    ShowToast.warning('Nama Almarhum belum diisi');
                                    return;
                                  }

                                  if (!isFileExist(deathCertificatePath)) {
                                    ShowToast.warning('Surat Keratangan Meninggal tidak ada');
                                    return;
                                  }
                                  response = await NetworkRequest.postSsp(type, marriageBookPath, birthCertificatePath, deathCertificatePath, familyCardPath, tfPartnerName.text, tfBabyName.text, '1', tfNumberBaby.text, tfFamilyHubName.text, tfTheLateName.text, dieDate, tfNote.text);
                                }else{
                                  response = BaseResponse(
                                    state: false,
                                    message: 'Tipe tidak ditemukan'
                                  );
                                  ShowToast.warning('Tipe tidak ditemukan');
                                  return;
                                }

                                if(response.state != true){
                                  ShowToast.error(response.message??'Gagal');
                                }else{
                                  NavigationService.backWithData(true);
                                }
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: CustomContainer.buttonGreen(),
                                child: Center(
                                  child: Text(
                                    'Ajukan',
                                    style: CustomFont.buttonSecondary(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      }
    );

    return result??false;
  }

  static Future<bool> detailSsp(BuildContext ctx, SspModel data)async{
    
    Widget wedding(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Nama Pasangan',
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
            child: Text(
              data.namaPasangan,
              style: CustomFont.headingEmpat(),
            )),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Buku Nikah',
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
            child: InkWell(
              onTap: (){
                CustomViewer.detectImageOrPdf(ctx, CustomConverter.generateLink(data.bukuNikah));
              },
              child: Text('buku nikah',style: CustomFont.headingLimaColorUnderlined(),))
          ),
          const SizedBox(
            height: 12,
          ),
        ],
      );
    }

    Widget birth(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Nama Anak',
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
            child: Text(
              data.namaAnak,
              style: CustomFont.headingEmpat(),
            )
          ),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Jenis Kelamin',
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
              border: Border.all(
                width: 1, 
                color: Colors.grey
              )
            ),
            child: Text(data.genderAnak == 1?'Laki - Laki': 'Perempuan',
              style: CustomFont.headingEmpatSemiBold(),
            )
          ),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Anak ke',
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
              border: Border.all(
                width: 1, 
                color: Colors.grey
              )
            ),
            child: Text(data.urutanAnak.toString(),style: CustomFont.headingEmpatSemiBold(),)
          ),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Akta Lahir',
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
            child: InkWell(
              onTap: () {
                CustomViewer.detectImageOrPdf(ctx, CustomConverter.generateLink(data.aktaAnak));
              },
              child: Text(
                'akta lahir',
                style: CustomFont.headingLimaColorUnderlined(),
              )
            )
          ),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Buku Nikah',
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
              child: InkWell(
                  onTap: () {
                    CustomViewer.detectImageOrPdf(
                        ctx, CustomConverter.generateLink(data.bukuNikah));
                  },
                  child: Text(
                    'buku nikah',
                    style: CustomFont.headingLimaColorUnderlined(),
                  ))),
          const SizedBox(
            height: 12,
          ),
        ],
      );
    }

    Widget familyDie(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Hubungan Keluarga',
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
            child: Text(
              data.hubunganKeluarga,
              style: CustomFont.headingEmpat(),
            )
          ),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Nama Almarhum',
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
            child: Text(
              data.namaAlmarhum,
              style: CustomFont.headingEmpat(),
            )
          ),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Tanggal Meninggal',
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
            child: Text(CustomConverter.dateTimeToDay(data.tanggalMeninggal),
              style: CustomFont.headingEmpat(),
            )
          ),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Buku Nikah',
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
              child: InkWell(
                onTap: (){
                  CustomViewer.detectImageOrPdf(ctx, CustomConverter.generateLink(data.bukuNikah));
                },
                child: Text(
                  'buku nikah',
                  style: CustomFont.headingLimaColorUnderlined(),
                ),
              )),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Surat Keterangan Meninggal',
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
              child: InkWell(
                onTap: () {
                  CustomViewer.detectImageOrPdf(
                      ctx, CustomConverter.generateLink(data.suratKemation));
                },
                child: Text(
                  'surat keterangan meninggal',
                  style: CustomFont.headingLimaColorUnderlined(),
                ),
              )),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Kartu Keluarga',
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
              child: InkWell(
                onTap: () {
                  CustomViewer.detectImageOrPdf(
                      ctx, CustomConverter.generateLink(data.kartuKeluarga));
                },
                child: Text(
                  'Kartu keluarga',
                  style: CustomFont.headingLimaColorUnderlined(),
                ),
              )),
          const SizedBox(
            height: 12,
          ),
        ],
      );
    }
    
    Widget parentDie(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Hubungan Keluarga',
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
              child: Text(
                data.hubunganKeluarga,
                style: CustomFont.headingEmpat(),
              )),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Nama Almarhum',
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
              child: Text(
                data.namaAlmarhum,
                style: CustomFont.headingEmpat(),
              )),
          const SizedBox(
            height: 12,
          ),
          AutoSizeText(
            'Tanggal meninggal',
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
              child: Text(
                CustomConverter.dateTimeToDay(data.tanggalMeninggal),
                style: CustomFont.headingEmpat(),
              )),
          const SizedBox(
            height: 12,
          ),
           AutoSizeText(
            'Surat Keterangan Meninggal',
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
              child: InkWell(
                onTap: () {
                  CustomViewer.detectImageOrPdf(
                      ctx, CustomConverter.generateLink(data.suratKemation));
                },
                child: Text(
                  'surat keterangan meninggal',
                  style: CustomFont.headingLimaColorUnderlined(),
                ),
              )),
          const SizedBox(
            height: 12,
          ),
        ],
      );
    }
    
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            width: ScreenSize.setWidthPercent(ctx, 85),
            constraints: BoxConstraints(maxHeight: ScreenSize.setHeightPercent(ctx, 70), minHeight: 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(width: 0.3, color: Colors.grey)
            ),
            child: Column(
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
                        data.type == 1? 'Pernikahan':
                        data.type == 2? 'Kelahiran':
                        data.type == 3? 'Kematian Keluarga':
                        data.type == 4? 'Kematian Orang Tua':'',
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
                Flexible(
                  child: Scrollbar(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            'Kode SSP',
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
                              border: Border.all(
                                width: 1, 
                                color: Colors.grey
                              )
                            ),
                          child: Text(data.id, style: CustomFont.headingEmpat(),)),
                          const SizedBox(
                            height: 12,
                          ),
                          AutoSizeText(
                            'Jumlah Sumbangan',
                            style: CustomFont.headingEmpatSemiBold(),
                            maxLines: 1,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 6, horizontal: 12),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(CustomConverter.numToRp(data.sumbangan), style: CustomFont.headingEmpat())
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
                            padding: const EdgeInsets.symmetric(
                              vertical: 6, 
                              horizontal: 12
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1, 
                                color: Colors.grey
                              )
                            ),
                            child: 
                            data.state == 2 ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AutoSizeText('Disetujui', style: CustomFont.headingEmpatApprove(),),
                                Row(
                                  children: [
                                    AutoSizeText('lihat', style: CustomFont.headingLima()),
                                    const SizedBox(width: 3,),
                                    InkWell(
                                      onTap: (){
                                        CustomViewer.detectImageOrPdf(ctx, Uri.parse(data.pdf).toString());
                                      },
                                      child: AutoSizeText('ssp', style: CustomFont.headingLimaColorUnderlined())),
                                  ],
                                )
                              ],
                            ):
                            AutoSizeText(
                              data.state == 1? 'Menunggu': 'Ditolak',
                              style: data.state == 1
                                ? CustomFont.headingEmpatWaiting(): CustomFont.headingEmpatReject(),
                                maxLines: 2,
                                overflow: TextOverflow.clip,
                            )
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          data.type == 1?
                          wedding():
                          data.type == 2?
                          birth(): 
                          const SizedBox(),
                          data.type == 3?
                          familyDie():
                          data.type == 4?
                          parentDie()
                          :const SizedBox(
                            height: 12,
                          ),
                          isNotNullOrEmpty(data.note)?
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                'Catatan Tambahan',
                                style: CustomFont.headingEmpatSemiBold(),
                                maxLines: 1,
                              ),
                              const SizedBox(
                                height: 2,
                              ),
                              TextField(
                                minLines: 3,
                                maxLines: 5,
                                readOnly: true,
                                style: CustomFont.headingLima(),
                                controller: TextEditingController(text: data.note),
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: const BorderSide(color: Colors.grey, width: 1.3),
                                  ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: const BorderSide(color: Colors.grey, width: 0.9),
                                ),
                                contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12))
                              ),
                              const SizedBox(height: 12,)
                            ],
                          ): const SizedBox(),
                          data.editable?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: (){
                                  NavigationService.backWithData(true);
                                },
                                child: CustomButton.edit(),
                              ),
                            ],
                          ): const SizedBox()
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

    return result ?? false;
  }

  static Future<bool> editSsp(BuildContext ctx, SspModel data)async{
    TextEditingController tfNote = TextEditingController(
      text: data.note
    );

    TextEditingController tfPartnerName = TextEditingController(
      text: data.namaPasangan
    );

    TextEditingController tfBabyName = TextEditingController(
      text: data.namaAnak
    );

    TextEditingController tfNumberBaby = TextEditingController(
      text: data.urutanAnak.toString()  
    );
    
    TextEditingController tfFamilyHubName = TextEditingController(
      text: data.hubunganKeluarga
    );
    
    TextEditingController tfTheLateName = TextEditingController(
      text: data.namaAlmarhum
    );

    DateTime dieDate = data.tanggalMeninggal;

    String marriageBookPath = '';
    String birthCertificatePath = '';
    String deathCertificatePath = '';
    String familyCardPath = '';

    String babyGender = 'Laki-Laki';

    final ImagePicker picker = ImagePicker();

    final result = await showDialog(
      context: ctx,
      builder: (BuildContext ctxDialog){
        return StatefulBuilder(
          builder: (BuildContext ctxStatefull, StateSetter setState) {

            Widget marriageBookUpload() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Buku nikah',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(marriageBookPath)) {
                                    File(marriageBookPath).delete();
                                  }
                                  setState(() {
                                    marriageBookPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Camera',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(marriageBookPath)) {
                                    File(marriageBookPath).delete();
                                  }
                                  setState(() {
                                    marriageBookPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(marriageBookPath)
                        ? Expanded(
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 6,
                                ),
                                Flexible(
                                  child: InkWell(
                                    onTap: () {
                                      CustomViewer.filePhoto(
                                          ctx, File(marriageBookPath));
                                    },
                                    child: AutoSizeText(
                                      'buku nikah',
                                      minFontSize: 14,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomFont.headingLimaColorUnderlined(),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final deleteResponse =
                                        await ConfirmationDialog
                                            .confirmation(ctx,
                                                'Hapus gambar dipilih?');
                                    if (deleteResponse) {
                                      setState(() {
                                        File(marriageBookPath).delete();
                                        marriageBookPath = '';
                                      });
                                    }
                                  },
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                    size: 19,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Expanded(
                          child: InkWell(
                            onTap: (){
                              CustomViewer.detectImageOrPdf(ctx, CustomConverter.generateLink(data.bukuNikah));
                            },
                            child: Row(
                              children: [
                                const SizedBox(width: 4,),
                                Flexible(
                                  child: AutoSizeText(
                                    'buku nikah terupload',
                                    minFontSize: 9,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomFont.headingLimaColorUnderlined(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget bornCertificateUpload() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Akta Lahir',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(birthCertificatePath)) {
                                    File(birthCertificatePath).delete();
                                  }
                                  setState(() {
                                    birthCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Camera',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(birthCertificatePath)) {
                                    File(birthCertificatePath).delete();
                                  }
                                  setState(() {
                                    birthCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(birthCertificatePath)
                            ? Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          CustomViewer.filePhoto(
                                              ctx, File(birthCertificatePath));
                                        },
                                        child: AutoSizeText(
                                          'Akta kelahiran.jpg',
                                          minFontSize: 14,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                              CustomFont.headingLimaWarning(),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final deleteResponse =
                                            await ConfirmationDialog
                                                .confirmation(ctx,
                                                    'Hapus gambar dipilih?');
                                        if (deleteResponse) {
                                          setState(() {
                                            File(birthCertificatePath).delete();
                                            birthCertificatePath = '';
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 19,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                              child: InkWell(
                                onTap: (){
                                  CustomViewer.detectImageOrPdf(ctx, CustomConverter.generateLink(data.aktaAnak));
                                },
                                child: Row(
                                  children: [
                                    const SizedBox(width: 4,),
                                    Flexible(
                                      child: AutoSizeText(
                                        'Akta Lahir terupload',
                                        minFontSize: 9,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: CustomFont.headingLimaColorUnderlined(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget familyCardUpload() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Kartu Keluarga',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(familyCardPath)) {
                                    File(familyCardPath).delete();
                                  }
                                  setState(() {
                                    familyCardPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Camera',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(familyCardPath)) {
                                    File(familyCardPath).delete();
                                  }
                                  setState(() {
                                    familyCardPath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(familyCardPath)? 
                        Expanded(
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 6,
                              ),
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    CustomViewer.filePhoto(
                                        ctx, File(familyCardPath));
                                  },
                                  child: AutoSizeText(
                                    'kk.jpg',
                                    minFontSize: 14,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        CustomFont.headingLimaWarning(),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  final deleteResponse =
                                      await ConfirmationDialog
                                          .confirmation(ctx,
                                              'Hapus gambar dipilih?');
                                  if (deleteResponse) {
                                    setState(() {
                                      File(familyCardPath).delete();
                                      familyCardPath = '';
                                    });
                                  }
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 19,
                                ),
                              ),
                            ],
                          ),
                        ): 
                        Expanded(
                            child: InkWell(
                              onTap: () {
                                CustomViewer.detectImageOrPdf(
                                    ctx,
                                    CustomConverter.generateLink(
                                        data.kartuKeluarga));
                              },
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Flexible(
                                    child: AutoSizeText(
                                      'Kartu keluarga terupload',
                                      minFontSize: 9,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: CustomFont
                                          .headingLimaColorUnderlined(),
                                    ),
                                  ),
                                ],
                              ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget dieCertificateUpload() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Surat keterangan meninggal',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 3),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.camera);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(deathCertificatePath)) {
                                    File(deathCertificatePath).delete();
                                  }
                                  setState(() {
                                    deathCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Camera',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            InkWell(
                              onTap: () async {
                                final XFile? pickedFile = await picker
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  if (isNotNullOrEmpty(deathCertificatePath)) {
                                    File(deathCertificatePath).delete();
                                  }
                                  setState(() {
                                    deathCertificatePath = pickedFile.path;
                                  });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black),
                                    borderRadius: BorderRadius.circular(7)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 4),
                                child: AutoSizeText(
                                  'Gallery',
                                  minFontSize: 1,
                                  maxLines: 1,
                                  style: CustomFont.headingLima(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isNotNullOrEmpty(deathCertificatePath)
                            ? Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Flexible(
                                      child: InkWell(
                                        onTap: () {
                                          CustomViewer.filePhoto(
                                              ctx, File(deathCertificatePath));
                                        },
                                        child: AutoSizeText(
                                          'surat kematian',
                                          minFontSize: 14,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomFont.headingLimaColorUnderlined(),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        final deleteResponse =
                                            await ConfirmationDialog
                                                .confirmation(ctx,
                                                    'Hapus gambar dipilih?');
                                        if (deleteResponse) {
                                          setState(() {
                                            File(deathCertificatePath).delete();
                                            familyCardPath = '';
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 19,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Expanded(
                                child: InkWell(
                                  onTap: () {
                                    CustomViewer.detectImageOrPdf(ctx, CustomConverter.generateLink(data.kartuKeluarga));
                                  },
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Flexible(
                                        child: AutoSizeText(
                                          'Surat Kematian terupload',
                                          minFontSize: 9,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: CustomFont
                                              .headingLimaColorUnderlined(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              );
            }

            Widget note() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Catatan Tambahan',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfNote,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 6),
                    ),
                    style: CustomFont.headingLima(),
                  ),
                ],
              );
            }

            Widget marriage() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Nama Pasangan',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfPartnerName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  marriageBookUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  note()
                ],
              );
            }

            Widget born() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Nama Anak',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfBabyName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Text(
                    'Jenis Kelamin',
                    style: CustomFont.headingEmpatSemiBold(),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Container(
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
                                    value: 'Laki-Laki',
                                    activeColor: CustomColor.primary(),
                                    groupValue: babyGender,
                                    onChanged: (state) {
                                      setState(() {
                                        babyGender = state.toString();
                                      });
                                    }),
                                AutoSizeText(
                                  'Laki - Laki',
                                  style: CustomFont.headingLima(),
                                )
                              ],
                            )),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Radio(
                                    value: 'Perempuan',
                                    activeColor: CustomColor.primary(),
                                    groupValue: babyGender,
                                    onChanged: (state) {
                                      setState(() {
                                        babyGender = state.toString();
                                      });
                                    }),
                                AutoSizeText(
                                  'Perempuan',
                                  style: CustomFont.headingLima(),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  AutoSizeText(
                    'Anak ke',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                      controller: tfNumberBaby,
                      maxLines: 2,
                      minLines: 1,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
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
                  bornCertificateUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  marriageBookUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  note()
                ],
              );
            }

            Widget familyDie() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Hubungan Keluarga',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfFamilyHubName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Nama Almarhum',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfTheLateName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Tanggal Meninggal',
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
                        initialDate: dieDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          dieDate = selectedDate;
                        });
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Text(CustomConverter.dateTimeToDay(dieDate),
                            style: CustomFont.headingEmpat())),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  marriageBookUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  dieCertificateUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  familyCardUpload(),
                  const SizedBox(
                    height: 12,
                  ),
                  note()
                ],
              );
            }

            Widget parentDie() {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    'Hubungan Keluarga',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfFamilyHubName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Nama Almarhum',
                    style: CustomFont.headingEmpatSemiBold(),
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  TextField(
                    controller: tfTheLateName,
                    maxLines: 1,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6.0),
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 6)),
                    style: CustomFont.headingLima(),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  AutoSizeText(
                    'Tanggal Meninggal',
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
                        initialDate: dieDate,
                        firstDate:
                            DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now(),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          dieDate = selectedDate;
                        });
                      }
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 12),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey)),
                        child: Text(CustomConverter.dateTimeToDay(dieDate),
                            style: CustomFont.headingEmpat())),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  dieCertificateUpload()
                ],
              );
            }

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
                constraints: BoxConstraints(maxHeight: ScreenSize.setHeightPercent(ctx, 70), minHeight: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 0.3, color: Colors.grey)
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Flexible(
                          child: Center(
                            child: AutoSizeText(
                            data.type == 1? 'Ubah Pengajuan Pernikahan': 
                            data.type == 2? 'Ubah Pengajuan Kelahiran': 
                            data.type == 3? 'Ubah Pengajuan Kematian Keluarga': 
                            data.type == 4? 'Ubah Pengajuan Kematian Orang Tua': '',
                            maxLines: 2,
                            minFontSize: 1,
                            textAlign: TextAlign.center,
                            style: CustomFont.headingTigaSemiBold(),
                          )),
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
                          child: Column(
                            children: [
                              data.type == 1?
                              marriage():
                              data.type == 2?
                              born():
                              data.type == 3?
                              familyDie():
                              data.type == 4?
                              parentDie(): const SizedBox(),
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () async {
                                  NavigationService.backWithData(true);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: CustomContainer.buttonGreen(),
                                  child: Center(
                                    child: Text(
                                      'Perbarui',
                                      style: CustomFont.buttonSecondary(),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      )
                    )
                  ],
                ),
              ),
            );
          }
        );
      }
    );

    return result ?? false;
  }
}
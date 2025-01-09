import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/data/model/profile.dart';
import 'package:eportal/page/dialog/viewer_dialog.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const nameRoute = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static final baseUrl = dotenv.env['SERVER_URL'];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    const SizedBox(height: 12,),
                    SizedBox(
                      width: ScreenSize.setWidthPercent(context, 40),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipOval(
                          child: InkWell(
                            onTap: (){
                              CustomViewer.networkPhoto(context, CustomConverter.generateLink('$baseUrl/uploads/ProfilePicture/${Profile.getProfile().nip}.jpg',));
                            },
                            child: CachedNetworkImage(
                              imageUrl: CustomConverter.generateLink('$baseUrl/uploads/ProfilePicture/${Profile.getProfile().nip}.jpg',),
                              fit:BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6,),
                    AutoSizeText(Profile.getProfile().name, style: CustomFont.headingDuaSemiBold()),
                    AutoSizeText(Profile.getProfile().nip, style: CustomFont.headingTiga()),
                    const SizedBox(height: 6,),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AutoSizeText(
                            'Outlet',
                            style: CustomFont.headingEmpat(),
                          ),
                        ),
                        AutoSizeText(' : ', style: CustomFont.headingEmpat(),),
                        Expanded(
                          flex: 2,
                          child: AutoSizeText(
                            Profile.getProfile().outlet,
                            style: CustomFont.headingEmpat(),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AutoSizeText('Email', style: CustomFont.headingEmpat(),)),
                        AutoSizeText(
                          ' : ',
                          style: CustomFont.headingEmpat(),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoSizeText(
                            Profile.getProfile().email,
                            style: CustomFont.headingEmpat(),
                            minFontSize: 1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AutoSizeText('Jabatan', style: CustomFont.headingEmpat(),)
                        ),
                        AutoSizeText(
                          ' : ',
                          style: CustomFont.headingEmpat(),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoSizeText(
                            Profile.getProfile().jabatan,
                            style: CustomFont.headingEmpat(),
                            minFontSize: 1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AutoSizeText(
                            'Department',
                            style: CustomFont.headingEmpat(),
                          ),
                        ),
                        AutoSizeText(
                          ' : ',
                          style: CustomFont.headingEmpat(),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoSizeText(
                            Profile.getProfile().department,
                            style: CustomFont.headingEmpat(),
                            minFontSize: 1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: AutoSizeText(
                            'Masuk',
                            style: CustomFont.headingEmpat(),
                          ),
                        ),
                        AutoSizeText(
                          ' : ',
                          style: CustomFont.headingEmpat(),
                        ),
                        Expanded(
                          flex: 2,
                          child: AutoSizeText(
                            CustomConverter.dateToDay(Profile.getProfile().employee),
                            style: CustomFont.headingEmpat(),
                            minFontSize: 1,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3,),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: (){
                          CustomViewer.networkPhoto(context, CustomConverter.generateLink(Profile.getProfile().signature));
                        },
                        child: AutoSizeText('Digital Signature', style: CustomFont.headingLimaColorUnderlined())))
                  ],
                ),
              ),
            )),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/joe.png'),
            ))
        ],
      ),
    );
  }
}
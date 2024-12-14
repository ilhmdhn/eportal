import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/dashboard/dashboard_page.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  static const nameRoute = '/error';
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: ScreenSize.setWidthPercent(context, 50),
              child: Image.asset('assets/image/error.png')),
            const SizedBox(height: 31,),
            Text('Oops!', style: CustomFont.headingDuaBold(),),
            const SizedBox(height: 4,),
            Text('Seems like the page is not working', style: CustomFont.headingEmpatSemiBold(),),
            const SizedBox(height: 6,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    NavigationService.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: CustomColor.primary(),
                      ),
                      borderRadius: BorderRadius.circular(20)
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6
                    ),
                    child: Text('Retry', style: CustomFont.headingLima()),
                  ),
                ),
                const SizedBox(width: 6,),
                InkWell(
                  onTap: (){
                    NavigationService.moveRemoveUntil(DashboardPage.nameRoute);
                  },
                  child: Container(
                    decoration: CustomContainer.buttonGreen(),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text('Back to dashboard', style: CustomFont.headingLimaSecondary(),),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 6,
            ),
            AutoSizeText('Report this error', style: CustomFont.headingEmpatWarning(),)
          ],
        ),
      ),
    );
  }
}
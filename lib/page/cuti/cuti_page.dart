import 'package:calendar_slider/calendar_slider.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/page/add_on/animation.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

class CutiPage extends StatefulWidget {
  static const nameRoute = '/cuti';
  const CutiPage({super.key});

  @override
  State<CutiPage> createState() => _CutiPageState();
}

class _CutiPageState extends State<CutiPage> {
  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final int _startYear = 2000;
  final int _endYear = 2050;
  late List<String> _monthYearList;

  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _monthYearList = _generateMonthYearList();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.4, // Item tengah lebih besar, sisi lebih kecil
    );
  }

  List<String> _generateMonthYearList() {
    List<String> monthYearList = [];
    for (int year = _startYear; year <= _endYear; year++) {
      for (String month in _months) {
        monthYearList.add("$month $year");
      }
    }
    return monthYearList;
  }

    @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.background(),
      body: Column(
        children: [
          CustomAnimation.loading()
         /* Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: ScreenSize.setHeightPercent(context, 25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
                    color: CustomColor.primary()
                  ),
                ),
             SizedBox(
                  height: ScreenSize.setHeightPercent(context, 10),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _monthYearList.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      final isCurrent = index == _currentIndex;
                      return Center(
                        child: AnimatedOpacity(
                          opacity:
                              isCurrent ? 1.0 : 0.5, // Transparansi untuk efek fokus
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            _monthYearList[index],
                            style: TextStyle(
                              fontSize: isCurrent ? 24 : 18, // Ukuran teks berubah
                              fontWeight:
                                  isCurrent ? FontWeight.bold : FontWeight.normal,
                              color: isCurrent ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Selected: ${_monthYearList[_currentIndex]}",
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          ,SizedBox(
            width: ScreenSize.setWidthPercent(context, 50),
            child: Image.asset('assets/image/joe.png'),
          )*/
        ],
      ),
    );
  }
}

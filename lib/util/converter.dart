import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomConverter{

  static String dateToMonth(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate);
    
    List<String> months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];

    String monthName = months[dateTime.month - 1];

    return "${dateTime.day} $monthName ${dateTime.year}";
  }

  static String dateToDay(String inputDate){
    DateTime dateTime = DateTime.parse(inputDate);

    List<String> days = [
      "Minggu",
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu"
    ];

    List<String> months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];

    String dayName = days[dateTime.weekday % 7];
    String monthName = months[dateTime.month - 1];

    return "$dayName, ${dateTime.day} $monthName ${dateTime.year}";    
  }

  static String dateTimeToDay(DateTime dateTime) {

    List<String> days = [
      "Minggu",
      "Senin",
      "Selasa",
      "Rabu",
      "Kamis",
      "Jumat",
      "Sabtu"
    ];

    List<String> months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];

    String dayName = days[dateTime.weekday % 7];
    String monthName = months[dateTime.month - 1];

    return "$dayName, ${dateTime.day} $monthName ${dateTime.year}";
  }

  static String monthCheck(String inputDate) {
    DateTime dateTime = DateFormat('MM-yyyy').parse(inputDate);

    List<String> months = [
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember"
    ];

    String monthName = months[dateTime.month - 1];

    return "$monthName ${dateTime.year}";
  }

  static String time(TimeOfDay time) {
    final now = DateTime.now();
    final dateTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dateTime);
  }
  
  static TimeOfDay stringToTime(String timeSource) {
    List<String> timeParts = timeSource.split(":");

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    TimeOfDay time = TimeOfDay(hour: hour, minute: minute);

    return time;
  }
}
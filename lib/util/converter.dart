import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
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

  static String timeToString(TimeOfDay time){
    final String hour = time.hour.toString().padLeft(2, '0');
    final String minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String generateLink(String link){
    return Uri.parse(link).toString();
  }

  static String numToRp(num value) {
    final formatter = NumberFormat.currency(locale: 'id_ID', symbol: '', decimalDigits: 0);
    return formatter.format(value);
  }

  static String ago(DateTime dateTime) {
    DateTime now = DateTime.now();

    final timeFormatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('dd/MM');
    final yearFormatter = DateFormat('yyyy');

    DateTime startOfToday = DateTime(now.year, now.month, now.day);

    int weekDayOffset = now.weekday - DateTime.monday;
    DateTime startOfWeek = startOfToday.subtract(Duration(days: weekDayOffset));

    if (dateTime.isAfter(startOfToday)) {
      return timeFormatter.format(dateTime);
    }

    if (dateTime.isAfter(startOfWeek)) {
      return DateFormat.EEEE()
          .format(dateTime);
    }

    if (dateTime.year == now.year) {
      return dateFormatter.format(dateTime);    }

    return yearFormatter.format(dateTime);
  }
}
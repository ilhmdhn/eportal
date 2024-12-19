class TimeDiff{
  static bool dateSameOrAfterNow(DateTime dateTemp){
    final date = DateTime(dateTemp.year, dateTemp.month, dateTemp.day);
    DateTime today = DateTime.now();
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    return date.isAfter(todayWithoutTime) || date == todayWithoutTime;
  }
  static bool dateSameOrBeforeNow(DateTime dateTemp){
    final date = DateTime(dateTemp.year, dateTemp.month, dateTemp.day);
    DateTime today = DateTime.now();
    DateTime todayWithoutTime = DateTime(today.year, today.month, today.day);
    return date.isBefore(todayWithoutTime) || date == todayWithoutTime;
  }
}
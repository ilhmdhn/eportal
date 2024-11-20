class Calculate{
  static String meterToUp(double meter) {
    if(meter > 999){
    return '${(meter/1000).toStringAsFixed(2)}km';
    }
    return '${meter.toStringAsFixed(0)}m';
  }
}
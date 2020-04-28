class Helper {
  static String formatPrice({double rateMin, double rateMax, String rateType}) {
    return '\$$rateMin - \$$rateMax \/$rateType';
  }
}

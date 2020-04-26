class Helper {
  static String formatPrice({double rateMin, double ratemax, String rateType}) {
    return '\$$rateMin - \$$rateMin \/$rateType';
  }
}

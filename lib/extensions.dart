
extension E on String {
  String takeLast(int n) {
    int from = length - n;
    return (from.isNegative) ? "" : substring(from);
  }
}
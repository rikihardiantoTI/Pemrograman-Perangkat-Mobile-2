/// Format angka menjadi Rupiah gaya Indonesia, sama seperti
/// `number.toLocaleString('id-ID')` pada `Image 2.html`.
String formatRupiah(num value) {
  final bool negative = value < 0;
  final String digits = value.abs().round().toString();
  final StringBuffer out = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) out.write('.');
    out.write(digits[i]);
  }
  return '${negative ? '-' : ''}Rp $out';
}

String formatRupiahShort(num value) {
  if (value >= 1000000) {
    final double v = value / 1000000;
    return 'Rp ${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1)} jt';
  }
  if (value >= 1000) {
    final double v = value / 1000;
    return 'Rp ${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 0)} rb';
  }
  return formatRupiah(value);
}

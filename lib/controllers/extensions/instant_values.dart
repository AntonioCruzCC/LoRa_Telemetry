// ignore_for_file: non_constant_identifier_names
class InstantValues {
  late double VA;
  late double VB;
  late double VC;

  late double IA;
  late double IB;
  late double IC;

  late double WA;
  late double WB;
  late double WC;

  late double temp;
  late double freq;

  InstantValues(Map<String, Object?> json) {
    VA = (json['VA'] ?? 0.0) as double;
    VB = (json['VB'] ?? 0.0) as double;
    VC = (json['VC'] ?? 0.0) as double;

    IA = (json['IA'] ?? 0.0) as double;
    IB = (json['IB'] ?? 0.0) as double;
    IC = (json['IC'] ?? 0.0) as double;

    WA = (json['WA'] ?? 0.0) as double;
    WB = (json['WB'] ?? 0.0) as double;
    WC = (json['WC'] ?? 0.0) as double;

    temp = (json['Temp'] ?? 0.0) as double;
    freq = (json['Freq'] ?? 0.0) as double;
  }

  Map<String, Object?> toJson() {
    return {
      'VA': VA,
      'VB': VB,
      'VC': VC,
      'IA': IA,
      'IB': IB,
      'IC': IC,
      'WA': WA,
      'WB': WB,
      'WC': WC,
      'temp': temp,
      'freq': freq,
    };
  }
}

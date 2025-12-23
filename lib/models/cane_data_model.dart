class CaneData {
  final String carId;
  final String descr;
  final double itemQty;
  final double ccs;
  final double ccsPriceTon;
  final double priceItem;
  final String dayOutS;

  CaneData({
    required this.carId,
    required this.descr,
    required this.itemQty,
    required this.ccs,
    required this.ccsPriceTon,
    required this.priceItem,
    required this.dayOutS,
  });

  factory CaneData.fromJson(Map<String, dynamic> json) {
    return CaneData(
      carId: json['CarID'] ?? '',
      descr: json['Descr'] ?? '',
      itemQty: (json['ItemQty'] as num?)?.toDouble() ?? 0.0,
      ccs: (json['CCS'] as num?)?.toDouble() ?? 0.0,
      ccsPriceTon: (json['CCSPriceTon'] as num?)?.toDouble() ?? 0.0,
      priceItem: (json['PriceItem'] as num?)?.toDouble() ?? 0.0,
      dayOutS: json['DayOutS'] ?? '',
    );
  }
}
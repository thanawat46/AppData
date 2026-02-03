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

class PromotionData {
  final DateTime? dateEff;
  final String itemType;
  final String itemName;
  final double amount;
  final String yearNum;
  final String noYear;

  PromotionData({
    required this.dateEff,
    required this.itemType,
    required this.itemName,
    required this.amount,
    required this.yearNum,
    required this.noYear,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) {
    return PromotionData(
      dateEff: json['DateEff'] != null ? DateTime.tryParse(json['DateEff']) : null,
      itemType: json['ItemType']?.toString() ?? '',
      itemName: json['ItemName']?.toString() ?? 'ไม่พบชื่อรายการ',
      amount: (json['Amount'] as num?)?.toDouble() ?? 0.0,
      yearNum: json['YearNum']?.toString() ?? '',
      noYear: json['NoYear']?.toString() ?? '',
    );
  }
}

class CaneYear {
  final String noYear;
  final String yearNum;

  CaneYear({required this.noYear, required this.yearNum});

  factory CaneYear.fromJson(Map<String, dynamic> json) {
    return CaneYear(
      noYear: json['NoYear']?.toString() ?? '',
      yearNum: json['YearNum']?.toString() ?? '',
    );
  }
}

class RobshowData {
  final int robCarType;
  final String carTypeName;
  final int robNum;
  final int robStartQ;
  final int robEndQ;
  final DateTime? robDat;
  final String robTime;

  RobshowData({
    required this.robCarType,
    required this.carTypeName,
    required this.robNum,
    required this.robStartQ,
    required this.robEndQ,
    this.robDat,
    required this.robTime,
  });

  factory RobshowData.fromJson(Map<String, dynamic> json) {
    String rawDat = json['RobDat']?.toString() ?? '';
    String extractedTime = '';
    if (rawDat.contains('T')) {
      extractedTime = rawDat.split('T').last;
    }

    return RobshowData(
      robCarType: json['RobCarType'] ?? 0,
      carTypeName: json['CartypeName'] ?? '',
      robNum: json['RobNum'] ?? 0,
      robStartQ: json['RobStartQ'] ?? 0,
      robEndQ: json['RobEndQ'] ?? 0,
      robDat: DateTime.tryParse(rawDat),
      robTime: extractedTime,
    );
  }
}
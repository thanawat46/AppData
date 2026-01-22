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

/*class QueueData {
  final String title;
  final int round;
  final int queue;
  final int currentQueue;
  final int totalQueue;
  final int missedQueue;
  final int missedUntil;
  final String timeAgo;

  const QueueData({
    required this.title,
    required this.round,
    required this.queue,
    required this.currentQueue,
    required this.totalQueue,
    required this.missedQueue,
    required this.missedUntil,
    required this.timeAgo,
  });

  factory QueueData.fromJson(Map<String, dynamic> json) {
    return QueueData(
      title: json['Title'] ?? '',
      round: (json['Round'] as num?)?.toInt() ?? 0,
      queue: (json['Queue'] as num?)?.toInt() ?? 0,
      currentQueue: (json['CurrentQueue'] as num?)?.toInt() ?? 0,
      totalQueue: (json['totalQueue'] as num?)?.toInt() ?? 0,
      missedQueue: (json['missedQueue'] as num?)?.toInt() ?? 0,
      missedUntil: (json['missedUntil'] as num?)?.toInt() ?? 0,
      timeAgo: json['time_value'] ?? '0:00',
    );
  }
}*/

/*class UserProfileData {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String address;
  final String registerDate;
  final String profileImageUrl;

  const UserProfileData({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.registerDate,
    this.profileImageUrl = "",
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      fullName: json['ชาวไร่']?.toString() ?? 'ไม่ระบุชื่อ',
      email: json['email'] ?.toString() ?? 'ไม่มีข้อมูล',
      phoneNumber: json['เบอร์โทร'] ?.toString() ?? 'ไม่พบเบอร์โทร',
      address: json['ที่อยู่'] ?.toString() ?? 'ไม่มีข้อมูล',
      registerDate: json['วันที่ลงทะเบียน'] ?.toString() ?? 'ไม่มีข้อมูล',
      profileImageUrl: json['image_url'] ?.toString() ?? '-',
    );
  }
}*/

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
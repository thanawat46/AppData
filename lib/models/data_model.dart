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

class QueueData {
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
}

class UserProfileData {
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
}

class PromotionData {
  final String date;
  final String item;
  final int quantity;
  final double price;
  final double total;
  final String type;

  PromotionData({
    required this.date,
    required this.item,
    required this.quantity,
    required this.price,
    required this.total,
    required this.type,
  });

  factory PromotionData.fromJson(Map<String, dynamic> json) {
    return PromotionData(
      date: json['วันที่'] ?.toString() ?? 'ไม่ระบุวันที่',
      item: json['รายการ'] ?.toString() ?? 'ไม่พบรายการ',
      quantity: (json['จำนวน'] as num?)?.toInt() ?? 0,
      price: (json['ราคา'] as num?)?.toDouble() ?? 0.0,
      total: (json['รวม'] as num?)?.toDouble() ?? 0.0,
      type: json['ประเภท'] ?.toString() ?? 'ไม่ระบุประเภท',
    );
  }
}
import 'package:hive_ce_flutter/hive_flutter.dart';

class HiveService {
  static const String profileBoxName = 'profileBox';

  static final Box box = Hive.box(profileBoxName);

  static Future<void> init() async {
    await Hive.openBox(profileBoxName);
  }

  static Future<void> savePhone(String phone) async {
    await box.put('phone', phone);
  }

  static String getPhone() {
    return box.get('phone', defaultValue: '');
  }
}

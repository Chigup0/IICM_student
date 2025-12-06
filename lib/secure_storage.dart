import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  // Keys
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _userGenderKey = 'user_gender';
  static const String _userRollNoKey = 'user_rollno';
  static const String _userEventKey = 'user_event';
  static const String _userTeamKey = 'user_team';
  static const String _userHallKey = 'user_hall';
  static const String _userMealKey = 'user_meal';
  static const String _userCodeKey = 'user_code';
  static const String _userImageKey = 'user_image';
  static const String _qrCodePathKey = 'qr_code_path';

  // Save all participant data
  static Future<void> saveParticipantData(
    Map<String, dynamic> participant,
  ) async {
    await _storage.write(
      key: _userIdKey,
      value: (participant['id'] ?? '').toString(),
    );
    await _storage.write(
      key: _userNameKey,
      value: (participant['name'] ?? '').toString(),
    );
    await _storage.write(
      key: _userEmailKey,
      value: (participant['email'] ?? '').toString(),
    );
    await _storage.write(
      key: _userGenderKey,
      value: (participant['gender'] ?? '').toString(),
    );
    await _storage.write(
      key: _userRollNoKey,
      value: (participant['rollNo'] ?? '').toString(),
    );
    await _storage.write(
      key: _userEventKey,
      value: (participant['eventN'] ?? '').toString(),
    );
    await _storage.write(
      key: _userTeamKey,
      value: (participant['team'] ?? '').toString(),
    );
    await _storage.write(
      key: _userHallKey,
      value: (participant['hall_name'] ?? '').toString(),
    );
    await _storage.write(
      key: _userMealKey,
      value: (participant['last_meal'] ?? '').toString(),
    );
    await _storage.write(
      key: _userCodeKey,
      value: (participant['uniqueCode'] ?? '').toString(),
    );
    await _storage.write(
      key: _userImageKey,
      value: (participant['image'] ?? '').toString(),
    );
  }

  // Get methods
  static Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  static Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  static Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }

  static Future<String?> getUserGender() async {
    return await _storage.read(key: _userGenderKey);
  }

  static Future<String?> getUserRollNo() async {
    return await _storage.read(key: _userRollNoKey);
  }

  static Future<String?> getUserEvent() async {
    return await _storage.read(key: _userEventKey);
  }

  static Future<String?> getUserTeam() async {
    return await _storage.read(key: _userTeamKey);
  }

  static Future<String?> getUserHall() async {
    return await _storage.read(key: _userHallKey);
  }

  static Future<String?> getUserMeal() async {
    return await _storage.read(key: _userMealKey);
  }

  static Future<String?> getUserCode() async {
    return await _storage.read(key: _userCodeKey);
  }

  static Future<String?> getUserImage() async {
    return await _storage.read(key: _userImageKey);
  }

  // QR Code methods
  static Future<void> saveQrCodePath(String qrData) async {
    print('=== Saving QR Code Data ===');
    print('Data length: ${qrData.length}');
    try {
      await _storage.write(key: _qrCodePathKey, value: qrData);
      print('QR data saved successfully');

      // Verify it was saved
      final retrieved = await _storage.read(key: _qrCodePathKey);
      print('Verification - Retrieved data length: ${retrieved?.length}');
    } catch (e) {
      print('Error saving QR data: $e');
    }
  }

  static Future<String?> getQrCodePath() async {
    print('=== Getting QR Code Data ===');
    final data = await _storage.read(key: _qrCodePathKey);
    print('Retrieved QR data length: ${data?.length}');
    return data;
  }

  static Future<bool> qrCodeExists() async {
    final data = await getQrCodePath();
    final exists = data != null && data.isNotEmpty;
    print('QR Code exists: $exists');
    return exists;
  }

  // Delete all user data
  static Future<void> deleteUserData() async {
    await _storage.delete(key: _userIdKey);
    await _storage.delete(key: _userEmailKey);
    await _storage.delete(key: _userNameKey);
    await _storage.delete(key: _userGenderKey);
    await _storage.delete(key: _userRollNoKey);
    await _storage.delete(key: _userEventKey);
    await _storage.delete(key: _userTeamKey);
    await _storage.delete(key: _userHallKey);
    await _storage.delete(key: _userMealKey);
    await _storage.delete(key: _userCodeKey);
    await _storage.delete(key: _userImageKey);
    await _storage.delete(key: _qrCodePathKey);
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final email = await getUserEmail();
    return email != null && email.isNotEmpty;
  }
}

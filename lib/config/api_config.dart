class ApiConfig {
  static const String baseUrl = 'http://34.131.232.205:3005/api';

  // Auth endpoints
  static String get requestOtpUrl => '$baseUrl/auth/requestotp';
  static String get verifyOtpUrl => '$baseUrl/auth/register';

  // Other endpoints
  static String get eventsUrl => '$baseUrl/events';
}

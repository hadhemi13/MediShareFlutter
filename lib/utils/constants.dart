/// API Endpoints
class Constants {
  static const String baseUrl = 'http://192.168.1.94:3000/';


  static const String signup = 'auth/signup';
  static const String login = 'auth/login';
  static const String confirmEmail = 'auth/confirm-email';
  static const String refreshTokens = 'auth/refresh';
  static const String changePassword = 'auth/change-password';
  static const String forgotPassword = 'auth/forgot-password';
  static const String verifyOtp = 'auth/verify-otp';
  static const String resetPassword = 'auth/reset-password';
  static const String googleLogin = 'auth/google';
  static const String updateUser = 'auth/update-user';
  static const String getAllUsers = 'auth/users';
}

class ResponseMessage {
  static const String forgotPassword =
      'Un OTP a été envoyé à votre adresse email.!!! most change this message later in ***utils/constants/ResponseMessage***';
}

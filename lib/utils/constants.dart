/// API Endpoints
class Constants {
  static const String baseUrl = 'http://172.18.2.14:3000/';
  static const String loginEndpoint = 'user/login';
  static const String addCommercial = 'user/create-commercial';
  static const String getCommercials = 'user/commercials';
  static const String upadteProfile = 'user/update-profile';
  static const String changePassword = 'user/change-password';
  static const String forgotPassword = 'user/forgot-password';
  static const String verfiyOtp = 'user/verify-otp';
  static const String fetchCimenterie='cimenterie';
  static const String fetchProducts='produit';


}

class ResponseMessage{
  static const String forgotPassword = 'Un OTP a été envoyé à votre adresse email.!!! most change this message later in ***utils/constants/ResponseMessage***';

}
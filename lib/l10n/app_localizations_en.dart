// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FA Game';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get networkError => 'Network error, please try again';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get invalidCredentials => 'Invalid username or password';

  @override
  String get username => 'Username';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get registerSuccess => 'Registration successful, please login';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get resetPasswordInstructions => 'We\'ll send a verification code to your email for password reset.';

  @override
  String get sendVerificationCode => 'Send Verification Code';

  @override
  String get verifyAndResetPassword => 'Verify & Reset Password';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get newPassword => 'New Password';

  @override
  String get verificationCodeRequired => 'Verification code is required';

  @override
  String get verificationCodeSent => 'Verification code has been sent to your email';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get resetPasswordFailed => 'Failed to reset password';

  @override
  String get verificationCodeInvalid => 'Invalid verification code';

  @override
  String get passwordResetSuccess => 'Password has been reset successfully';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get chinese => 'Chinese';
}

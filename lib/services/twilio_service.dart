import 'package:twilio_flutter/twilio_flutter.dart';

class TwilioService {
  static final TwilioFlutter twilioFlutter = TwilioFlutter(
    accountSid: 'AC52fbcd9c650ce50cc12e46769edb59f4',  // Replace with your Twilio Account SID
    authToken: '1462b011f8fc404fa9aed4aaf8fa75cb',    // Replace with your Twilio Auth Token
    twilioNumber: '+14155238886',  // Example: +14155238886
  );

  static String generateOTP() {
    return (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
  }

  static Future<void> sendOTP(String userNumber) async {
    String otp = generateOTP();
    await twilioFlutter.sendSMS(
      toNumber: 'whatsapp:$userNumber', // Must include 'whatsapp:' before the number
      messageBody: 'Your KaamDekho verification code is: $otp',
    );
  }
}

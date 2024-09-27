import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  String _verificationId = '';
  bool _isOtpSent = false;
  bool _isPinSetup = false;

  // Send OTP to the phone number
  Future<void> _sendOtp() async {
    final String phone = _phoneController.text.trim();

    if (phone.isNotEmpty) {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+88$phone', // Assuming Bangladesh's country code
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (this may vary depending on regions)
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Verification failed: ${e.message}')),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _verificationId = verificationId;
            _isOtpSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid phone number')),
      );
    }
  }

  // Verify OTP and allow PIN setup
  Future<void> _verifyOtp() async {
    final String otp = _otpController.text.trim();
    if (_verificationId.isNotEmpty && otp.isNotEmpty) {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: otp,
      );
      try {
        await _auth.signInWithCredential(credential);
        setState(() {
          _isPinSetup = true; // Allow user to set PIN after verification
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter the OTP')),
      );
    }
  }

  // Set and store the PIN securely
  Future<void> _setPin() async {
    final String pin = _pinController.text.trim();
    final String confirmPin = _confirmPinController.text.trim();

    if (pin.length == 4 && pin == confirmPin) {
      // Store the PIN securely
      await _storage.write(key: 'user_pin', value: pin);
      await _storage.write(key: 'user_phone', value: _phoneController.text.trim());
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PIN does not match or is not 4 digits')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login / Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isOtpSent) ...[
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
              ),
              ElevatedButton(
                onPressed: _sendOtp,
                child: Text('Send OTP'),
              ),
            ] else if (!_isPinSetup) ...[
              TextField(
                controller: _otpController,
                decoration: InputDecoration(labelText: 'Enter OTP'),
                keyboardType: TextInputType.number,
              ),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: Text('Verify OTP'),
              ),
            ] else ...[
              TextField(
                controller: _pinController,
                decoration: InputDecoration(labelText: 'Set 4-Digit PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              TextField(
                controller: _confirmPinController,
                decoration: InputDecoration(labelText: 'Confirm 4-Digit PIN'),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: _setPin,
                child: Text('Set PIN'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Function to request OTP
  Future<void> requestOTP(String phoneNumber,
      Function(String, int?) codeSentCallback,
      Function(FirebaseAuthException) verificationFailedCallback) async {
    // await _firebaseAuth.setSettings(appVerificationDisabledForTesting: true); // <-- here is the magic
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 0),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification completed
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle the error
        print('Verification failed error ${e}');
        print('Verification failed error vefymethod ${e}');

        verificationFailedCallback(e);
      },
      codeSent: (String verificationId, int? resendToken) {
        // SMS code sent, now we notify the caller about this event
        codeSentCallback(verificationId, resendToken);
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval time out
      },
    );
  }
  // Function to resend OTP
  Future<void> resendOTP(String phoneNumber, int resendToken) async {
    await _firebaseAuth.setSettings(
        appVerificationDisabledForTesting: true); // <-- here is the magic
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 0),
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-retrieval or instant verification completed
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        // Handle the error
        print('Verification failed error ${e}');
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        // SMS code resent
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        // Auto-retrieval time out
      },
    );
  }

  Future<UserCredential> verifyOTP(String verificationId, String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    return await _firebaseAuth.signInWithCredential(credential);
  }

  // Function to get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
     print('Error signing out: $e');
    } finally {}
  }
}
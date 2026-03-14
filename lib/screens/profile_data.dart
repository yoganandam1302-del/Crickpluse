import 'dart:io';

/// A global singleton to hold the user's profile data across screens.
/// Any screen can read and write to this to share state without a state management library.
class ProfileData {
  ProfileData._();
  static final ProfileData instance = ProfileData._();

  File? profileImage;
  String name = 'Yoganandam DK';
  String username = '@yogi_cricket';
  String location = 'Tamil Nadu, India';
}

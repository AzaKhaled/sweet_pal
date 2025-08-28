import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/errors/exceptions.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;

 Future<String> uploadProfileImage(File imageFile) async {
  final user = _client.auth.currentUser;
  if (user == null) throw CustomException(message: 'User not logged in.');

  final fileName = 'avatar_${user.id}.jpg';
  final filePath = fileName;
  final bytes = await imageFile.readAsBytes();

  try {
    // Upload the image to Supabase storage
    await _client.storage
        .from('avatars')
        .uploadBinary(filePath, bytes, fileOptions: const FileOptions(upsert: true));

    // Get the public URL
    final imageUrl = _client.storage.from('avatars').getPublicUrl(filePath);
    final imageUrlWithBypass = '$imageUrl?ts=${DateTime.now().millisecondsSinceEpoch}';

    print('Image uploaded successfully. URL: $imageUrlWithBypass');
    return imageUrlWithBypass;
  } catch (e) {
    print('Error uploading image: $e');
    rethrow;
  }
}
}

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/errors/exceptions.dart';

class StorageService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String> uploadProfileImage(File imageFile) async {
    final user = _client.auth.currentUser;
    if (user == null) throw CustomException(message: 'User not logged in.');

    final fileName = 'avatar_${user.id}.jpg';
    final filePath = 'public/$fileName';

    final bytes = await imageFile.readAsBytes();

    await _client.storage
        .from('avatars')
        .uploadBinary(filePath, bytes, fileOptions: const FileOptions(upsert: true));

    final publicUrl = _client.storage
        .from('avatars')
        .getPublicUrl(filePath);

    return publicUrl;
  }
}

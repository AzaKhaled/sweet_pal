import 'package:supabase_flutter/supabase_flutter.dart';

class LocationService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> saveLocation(double lat, double lng) async {
    final user = supabase.auth.currentUser;
    
    if (user == null) {
      throw Exception('User not authenticated. Please sign in first.');
    }

    await supabase.from('users').update({
      'latitude': lat,
      'longitude': lng,
    }).eq('auth_id', user.id);
  }
}

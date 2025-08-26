import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sweet_pal/core/utils/app_colors.dart';
import 'package:sweet_pal/core/utils/localization_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:sweet_pal/auth/presentation/views/sigin_view.dart';
import 'package:sweet_pal/features/map/presentation/cubits/location_cubit.dart';
import 'package:sweet_pal/features/map/service/location.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;
    final user = supabase.auth.currentUser;

    // إذا لم يكن المستخدم مسجل الدخول، عرض شاشة تسجيل غ
    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              LocalizationHelper.translate('Map', 'الخريطة'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                LocalizationHelper.translate(
                  'must log in first to access the map',
                  'يجب تسجيل الدخول أولاً للوصول إلى الخريطة'
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                LocalizationHelper.translate(
                  'must log in to see your location on the map',
                  'يجب تسجيل الدخول لرؤية موقعك على الخريطة'
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const SiginView()),
                  );
                },
                child: Text(LocalizationHelper.translate('Sign In', 'تسجيل الدخول')),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (context) => LocationCubit(LocationService()),
      child: Scaffold(
        appBar:  AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              LocalizationHelper.translate('Map', 'الخريطة'),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
        body: BlocConsumer<LocationCubit, LocationState>(
          listener: (context, state) {
            if (state is LocationError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is LocationSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.green,
                  content: Center(
                    child: Text(
                      LocalizationHelper.translate(
                        'Location saved successfully',
                        'تم حفظ الموقع بنجاح'
                      )
                    ),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is LocationLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is LocationSaved) {
              return _buildMapWithLocation(state.lat, state.lng);
            }

            return _buildInitialMap();
          },
        ),
        floatingActionButton: BlocBuilder<LocationCubit, LocationState>(
          builder: (context, state) {
            return FloatingActionButton(
              backgroundColor: Colors.black.withOpacity(0.6),
              child: const Icon(Icons.my_location, color: Colors.white),
              onPressed: () {
                context.read<LocationCubit>().getAndSaveLocation();
              },
              heroTag: 'map_fab', // Unique hero tag
            );
          },
        ),
      ),
    );
  }

Widget _buildInitialMap() {
  return FlutterMap(
    options: const MapOptions(
      initialCenter: LatLng(26.5595, 31.6957), 
      initialZoom: 10,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.example.sweet_pal',
      ),
      RichAttributionWidget(
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () => launchUrl(
              Uri.parse('https://openstreetmap.org/copyright'),
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildMapWithLocation(double lat, double lng) {
    return FlutterMap(
      options: MapOptions(initialCenter: LatLng(lat, lng), initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.sweet_pal',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(lat, lng),
              width: 80,
              height: 80,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 40,
              ),
            ),
          ],
        ),
        RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
              onTap: () =>
                  launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
            ),
          ],
        ),
      ],
    );
  }
}

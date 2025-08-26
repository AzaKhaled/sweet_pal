import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sweet_pal/features/map/service/location.dart';

part 'location_state.dart';


class LocationCubit extends Cubit<LocationState> {
  final LocationService locationService;

  LocationCubit(this.locationService) : super(LocationInitial());

  Future<void> getAndSaveLocation() async {
    emit(LocationLoading());
    try {
      bool serviceEnabled;
      LocationPermission permission;

      // تأكد من إن الـ GPS شغال
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        emit(const LocationError('GPS is disabled'));
        return;
      }

      // تحقق من الصلاحيات
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          emit(const LocationError('permission denied'));
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        emit(const LocationError('permission denied permanently'));
        return;
      }

      // جيب الموقع الحالي
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // حفظ في Supabase
      await locationService.saveLocation(position.latitude, position.longitude);

      emit(LocationSaved(position.latitude, position.longitude));
    } catch (e) {
      if (e.toString().contains('User not authenticated')) {
        emit(const LocationError('must log in first'));
      } else {
        emit(const LocationError('error tracing'));
      }
    }
  }
}

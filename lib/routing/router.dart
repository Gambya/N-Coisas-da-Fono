import 'package:go_router/go_router.dart';
import 'package:ncoisasdafono/routing/routes.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_register_view.dart';
import 'package:ncoisasdafono/ui/doctor/views/doctor_register_view.dart';
import 'package:ncoisasdafono/ui/home/views/home_view.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_register_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  late final GoRouter router;
  bool _isDoctorRegisteredCache = false;

  AppRouter() {
    router = GoRouter(
      initialLocation: Routes.home,
      debugLogDiagnostics: true,
      redirect: (context, state) async {
        final isDoctorRegistered = await _isDoctorRegistered();
        if (!isDoctorRegistered &&
            state.uri.toString() != Routes.doctorRegister) {
          return Routes.doctorRegister;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => HomeView(
            viewModel: context.read(),
          ),
        ),
        GoRoute(
          path: Routes.doctorRegister,
          builder: (context, state) => DoctorRegisterView(
            viewModel: context.read(),
            onDoctorRegistered: () async {
              await _setDoctorRegistered(true);
              _isDoctorRegisteredCache = true; // Atualiza o cache
            },
          ),
        ),
        GoRoute(
          path: Routes.patientRegister,
          builder: (context, state) => PatientRegisterView(
            viewModel: context.read(),
          ),
        ),
        GoRoute(
          path: Routes.consultationRegister,
          builder: (context, state) => ConsultationRegisterView(
            viewModel: context.read(),
          ),
        ),
      ],
    );
  }

  Future<bool> _isDoctorRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('doctorRegistered') ?? false;
  }

  Future<void> _setDoctorRegistered(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('doctorRegistered', value);
  }
}

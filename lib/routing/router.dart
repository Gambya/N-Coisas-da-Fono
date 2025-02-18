import 'package:go_router/go_router.dart';
import 'package:ncoisasdafono/routing/routes.dart';
import 'package:ncoisasdafono/ui/consultation/views/consultation_register_view.dart';
import 'package:ncoisasdafono/ui/doctor/views/doctor_register_view.dart';
import 'package:ncoisasdafono/ui/home/views/home_view.dart';
import 'package:ncoisasdafono/ui/patient/views/patient_register_view.dart';
import 'package:provider/provider.dart';

GoRouter router() => GoRouter(
      initialLocation: Routes.patientRegister,
      debugLogDiagnostics: true,
      routes: [
        GoRoute(
          path: Routes.home,
          builder: (context, state) => HomeView(),
        ),
        GoRoute(
          path: Routes.doctorRegister,
          builder: (context, state) => DoctorRegisterView(
            viewModel: context.read(),
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

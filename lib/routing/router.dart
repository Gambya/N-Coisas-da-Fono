import 'package:go_router/go_router.dart';
import 'package:ncoisasdafono/routing/routes.dart';
import 'package:ncoisasdafono/ui/doctor/views/doctor_register_view.dart';
import 'package:ncoisasdafono/ui/home/views/home_view.dart';
import 'package:provider/provider.dart';

GoRouter router() => GoRouter(
      initialLocation: Routes.doctorRegister,
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
      ],
    );

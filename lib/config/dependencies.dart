import 'package:ncoisasdafono/config/app_settings.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/local_doctor_repository.dart';
import 'package:ncoisasdafono/data/services/doctor/local_doctor_storage.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_register_view_model.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> get providers {
  return [
    ChangeNotifierProvider(create: (_) => AppSettings()),
    Provider<LocalDoctorStorage>(create: (_) => LocalDoctorStorage()),
    Provider<DoctorRepository>(
      create: (context) =>
          LocalDoctorRepository(context.read<LocalDoctorStorage>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          DoctorRegisterViewModel(context.read<DoctorRepository>()),
    ),
    ChangeNotifierProvider(
      create: (context) {
        final storage = context.read<LocalDoctorStorage>();
        final repository = LocalDoctorRepository(storage);
        return DoctorRegisterViewModel(repository);
      },
    ),
  ];
}

import 'package:ncoisasdafono/config/object_box_database.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/data/repositories/consultation/local_consultation_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/local_doctor_repository.dart';
import 'package:ncoisasdafono/data/repositories/patient/local_patient_repository.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/data/services/consultation/local_consultation_storage.dart';
import 'package:ncoisasdafono/data/services/doctor/local_doctor_storage.dart';
import 'package:ncoisasdafono/data/services/patient/local_patient_storage.dart';
import 'package:ncoisasdafono/domain/usecases/consultation/get_consultations_with_doctor_and_patient.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_detail_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_register_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/widgets/viewmodels/drop_down_buttom_from_field_patients_view_model.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_register_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_view_model.dart';
import 'package:ncoisasdafono/ui/home/viewmodels/home_view_model.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_register_view_model.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> get providers {
  return [
    Provider<ObjectBoxDatabase>(create: (_) => ObjectBoxDatabase()),
    Provider<LocalDoctorStorage>(
      create: (context) => LocalDoctorStorage(
        context.read(),
      ),
    ),
    Provider<LocalPatientStorage>(
      create: (context) => LocalPatientStorage(
        context.read(),
      ),
    ),
    Provider<LocalConsultationStorage>(
      create: (context) => LocalConsultationStorage(
        context.read(),
      ),
    ),
    Provider<DoctorRepository>(
      create: (context) =>
          LocalDoctorRepository(context.read<LocalDoctorStorage>()),
    ),
    Provider<PatientRepository>(
      create: (context) =>
          LocalPatientRepository(context.read<LocalPatientStorage>()),
    ),
    Provider<ConsultationRepository>(
      create: (context) =>
          LocalConsultationRepository(context.read<LocalConsultationStorage>()),
    ),
    Provider<GetConsultationsWithDoctorAndPatient>(
      create: (context) => GetConsultationsWithDoctorAndPatient(
        context.read<ConsultationRepository>(),
        context.read<DoctorRepository>(),
        context.read<PatientRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          DoctorRegisterViewModel(context.read<DoctorRepository>()),
    ),
    ChangeNotifierProvider(
      create: (context) => PatientRegisterViewModel(
        context.read<PatientRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => ConsultationRegisterViewModel(
        context.read<ConsultationRepository>(),
        context.read<PatientRepository>(),
        context.read<DoctorRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => HomeViewModel(
        context.read<ConsultationRepository>(),
        context.read<DoctorRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => ConsultationDetailViewModel(
        context.read<ConsultationRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => ConsultationViewModel(
        context.read<ConsultationRepository>(),
        context.read<GetConsultationsWithDoctorAndPatient>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => DropDownButtomFromFieldPatientsViewModel(
        context.read<PatientRepository>(),
      ),
    )
  ];
}

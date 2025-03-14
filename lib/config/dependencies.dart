import 'package:ncoisasdafono/data/repositories/annotation/annotation_repository.dart';
import 'package:ncoisasdafono/data/repositories/annotation/local_annotation_repository.dart';
import 'package:ncoisasdafono/data/repositories/consultation/consultation_repository.dart';
import 'package:ncoisasdafono/data/repositories/consultation/local_consultation_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/doctor_repository.dart';
import 'package:ncoisasdafono/data/repositories/doctor/local_doctor_repository.dart';
import 'package:ncoisasdafono/data/repositories/document/document_repository.dart';
import 'package:ncoisasdafono/data/repositories/document/local_document_repository.dart';
import 'package:ncoisasdafono/data/repositories/patient/local_patient_repository.dart';
import 'package:ncoisasdafono/data/repositories/patient/patient_repository.dart';
import 'package:ncoisasdafono/data/services/annotation/local_annotation_storage.dart';
import 'package:ncoisasdafono/data/services/consultation/local_consultation_storage.dart';
import 'package:ncoisasdafono/data/services/doctor/local_doctor_storage.dart';
import 'package:ncoisasdafono/data/services/document/local_document_storage.dart';
import 'package:ncoisasdafono/data/services/patient/local_patient_storage.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_detail_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_register_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/widgets/viewmodels/drop_down_buttom_from_field_patients_view_model.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_register_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_view_model.dart';
import 'package:ncoisasdafono/ui/doctor/viewmodels/doctor_view_model.dart';
import 'package:ncoisasdafono/ui/home/viewmodels/home_view_model.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/annotation_view_model.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_details_view_model.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_register_view_model.dart';
import 'package:ncoisasdafono/ui/patient/viewmodels/patient_view_model.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> get providers {
  return [
    Provider<LocalDoctorStorage>(
      create: (_) => LocalDoctorStorage(),
    ),
    Provider<LocalPatientStorage>(
      create: (_) => LocalPatientStorage(),
    ),
    Provider<LocalConsultationStorage>(
      create: (_) => LocalConsultationStorage(),
    ),
    Provider(
      create: (_) => LocalAnnotationStorage(),
    ),
    Provider(
      create: (_) => LocalDocumentStorage(),
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
    Provider<AnnotationRepository>(
      create: (context) => LocalAnnotationRepository(
        context.read<LocalAnnotationStorage>(),
      ),
    ),
    Provider<DocumentRepository>(
      create: (context) => LocalDocumentRepository(
        context.read<LocalDocumentStorage>(),
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
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => DropDownButtomFromFieldPatientsViewModel(
        context.read<PatientRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => PatientViewModel(
        context.read<PatientRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => PatientDetailsViewModel(
        context.read<PatientRepository>(),
        context.read<AnnotationRepository>(),
        context.read<DocumentRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => DoctorViewModel(
        context.read<DoctorRepository>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => AnnotationViewModel(
        context.read<AnnotationRepository>(),
      ),
    )
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_with_doctor_and_patient_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/domain/validators/consultation_with_doctor_and_patient_validator.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_detail_view_model.dart';
import 'package:ncoisasdafono/ui/consultation/widgets/drop_down_buttom_from_field_patients.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

class ConsultationDetailView extends StatefulWidget {
  final ConsultationWithDoctorAndPatientDto consultation;
  const ConsultationDetailView({super.key, required this.consultation});

  @override
  State<ConsultationDetailView> createState() => _ConsultationDetailViewState();
}

class _ConsultationDetailViewState extends State<ConsultationDetailView> {
  late ConsultationDetailViewModel _viewModel;
  final ConsultationWithDoctorAndPatientValidator _validator =
      ConsultationWithDoctorAndPatientValidator();
  ConsultationStatus _statusSelectioned = ConsultationStatus.agendada;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<ConsultationDetailViewModel>();
    _viewModel.setConsultation(widget.consultation);
    _statusSelectioned = _viewModel.consultation!.status;
    _viewModel.registerConsultationCommand
        .addListener(_onRegisterConsultationCommandChanged);
    _viewModel.onSaveConsultationCommand.addListener(_onSave);
  }

  void _onRegisterConsultationCommandChanged() {
    if (_viewModel.registerConsultationCommand.isSuccess) {
      Navigator.of(context).pop();
    } else if (_viewModel.registerConsultationCommand.isFailure) {
      final failure =
          _viewModel.registerConsultationCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  void _onSave() {
    if (_viewModel.onSaveConsultationCommand.isSuccess) {
      Navigator.of(context).pop();
    } else if (_viewModel.onSaveConsultationCommand.isFailure) {
      final failure =
          _viewModel.onSaveConsultationCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  IconData _getStatus() {
    switch (_viewModel.consultation!.status) {
      case ConsultationStatus.agendada:
        return Icons.pending;
      case ConsultationStatus.confirmada:
        return Icons.check_circle;
      case ConsultationStatus.cancelada:
        return Icons.cancel;
      case ConsultationStatus.realizada:
        return Icons.task_alt;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 215, 186, 232),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          _viewModel.consultation!.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              // Ação a ser executada ao clicar no ícone de menu
            },
          ),
          IconButton(
            icon: Icon(
              _getStatus(),
              color: Colors.white,
            ),
            onPressed: () =>
                _showEditBottomSheetStatus(context, _viewModel.consultation!),
          ),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () =>
                _showEditBottomSheet(context, _viewModel.consultation!),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(
                  Icons.payments,
                  color: Colors.white,
                  size: 13,
                ),
                const SizedBox(width: 8),
                Text(
                  'R\$ ${_viewModel.consultation!.value}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Center(
              child: Stack(
                children: [
                  if (_viewModel.consultation!.patient.photoUrl != null &&
                      _viewModel.consultation!.patient.photoUrl!.isNotEmpty)
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          _viewModel.consultation!.patient.photoUrl!),
                    )
                  else
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Color.fromARGB(255, 193, 214, 255),
                      child: Text(
                        _viewModel.consultation!.patient.name
                            .substring(0, 2)
                            .toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 193, 214, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd/MM/yyyy')
                            .format(_viewModel.consultation!.dateTime),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('hh:mm:ss')
                            .format(_viewModel.consultation!.dateTime),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timelapse,
                        color: Colors.white,
                        size: 13,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${_viewModel.consultation!.duration} minutos',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Nome',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(_viewModel.consultation!.patient.name),
              titleTextStyle: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 13.0,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white),
            Row(
              children: [
                Icon(
                  Icons.phone_iphone,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Telefone/Celular',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(
                _viewModel.consultation!.patient.phone,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.white),
            Row(
              children: [
                Icon(
                  Icons.mail,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Email',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(
                _viewModel.consultation!.patient.email,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
            ),
            const Divider(color: Colors.white),
            Row(
              children: [
                Icon(
                  Icons.description,
                  color: Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  'Observações',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            ListTile(
              title: Text(
                _viewModel.consultation!.description,
                textAlign: TextAlign.justify,
                maxLines: 5,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditBottomSheetStatus(
      BuildContext context, ConsultationWithDoctorAndPatientDto obj) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                    child: DropdownButton<ConsultationStatus>(
                      isExpanded: true,
                      isDense: true,
                      focusColor: Colors.white,
                      value: _statusSelectioned,
                      onChanged: (ConsultationStatus? newValue) {
                        setStateBottomSheet(() {
                          _statusSelectioned = newValue!;
                          _viewModel.consultation!.status = newValue;
                        });
                      },
                      items: ConsultationStatus.values
                          .map((ConsultationStatus status) {
                        return DropdownMenuItem<ConsultationStatus>(
                          value: status,
                          child: Text(status
                              .toString()
                              .toUpperCase()
                              .split('.')
                              .last), // Exibe o nome do Enum
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _viewModel.onSaveConsultationCommand.execute();
                      Navigator.pop(context);
                      setState(() {});
                    },
                    child: const Text('Salvar'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditBottomSheet(
      BuildContext context, ConsultationWithDoctorAndPatientDto obj) {
    showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateBottomSheet) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: obj.title,
                        onChanged: (value) {
                          _viewModel.consultation!.title = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validator.byField(
                            _viewModel.consultation!, 'title'),
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: obj.description,
                        onChanged: (value) {
                          _viewModel.consultation!.description = value;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validator.byField(
                            _viewModel.consultation!, 'description'),
                        minLines: 3,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Descrição',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              initialValue: DateFormat('dd/MM/yyyy hh:mm')
                                  .format(obj.dateTime),
                              readOnly: true,
                              onTap: () async {
                                DateTime? pickedDate =
                                    await showOmniDateTimePicker(
                                        context: context);

                                if (pickedDate != null) {
                                  setState(() {
                                    _viewModel.consultation!.dateTime =
                                        pickedDate;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Data da Consulta',
                                border: OutlineInputBorder(),
                                errorStyle: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              DateTime? pickedDate =
                                  await showOmniDateTimePicker(
                                      context: context);

                              if (pickedDate != null) {
                                setState(() {
                                  _viewModel.consultation!.dateTime =
                                      pickedDate;
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Color.fromARGB(255, 193, 214, 255),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: obj.duration,
                        onChanged: (value) {
                          _viewModel.consultation!.duration = value;
                        },
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: _validator.byField(
                            _viewModel.consultation!, 'duration'),
                        decoration: InputDecoration(
                          labelText: 'Duração da Consulta (minutos)',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        initialValue: obj.value,
                        onChanged: (value) {
                          _viewModel.consultation!.value = value;
                        },
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*[\.,]?\d{0,2}$'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: 'Valor da consulta',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Status',
                          border: OutlineInputBorder(),
                          errorStyle: TextStyle(color: Colors.red),
                        ),
                        child: DropdownButton<ConsultationStatus>(
                          isExpanded: true,
                          isDense: true,
                          focusColor: Colors.white,
                          value: _statusSelectioned, // Valor selecionado
                          onChanged: (ConsultationStatus? newValue) {
                            setState(() {
                              _statusSelectioned = newValue!;
                              _viewModel.consultation!.status =
                                  _statusSelectioned;
                            });
                          },
                          items: ConsultationStatus.values
                              .map((ConsultationStatus status) {
                            return DropdownMenuItem<ConsultationStatus>(
                              value: status,
                              child: Text(status
                                  .toString()
                                  .toUpperCase()
                                  .split('.')
                                  .last),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropDownButtomFromFieldPatients(
                        onChanged: (Patient? value) {
                          if (value != null) {
                            _viewModel.consultation!.patient = value;
                          }
                        },
                        initialPatient: _viewModel.consultation!.patient,
                      ),
                      const SizedBox(height: 40),
                      ListenableBuilder(
                        listenable: _viewModel.registerConsultationCommand,
                        builder: (context, _) {
                          return ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                Color.fromARGB(255, 193, 214, 255),
                              ),
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.white,
                              ),
                              shape: WidgetStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onPressed:
                                _viewModel.registerConsultationCommand.isRunning
                                    ? null
                                    : () {
                                        if (_validator
                                            .validate(_viewModel.consultation!)
                                            .isValid) {
                                          _viewModel.registerConsultationCommand
                                              .execute();
                                          Navigator.pop(context);
                                          setState(() {});
                                        }
                                      },
                            child: const Text('Salvar'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

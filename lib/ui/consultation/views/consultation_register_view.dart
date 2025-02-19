import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/domain/validators/consultation_validator.dart';
import 'package:ncoisasdafono/routing/routes.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_register_view_model.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:result_command/result_command.dart';

class ConsultationRegisterView extends StatefulWidget {
  final ConsultationRegisterViewModel viewModel;
  const ConsultationRegisterView({super.key, required this.viewModel});

  @override
  State<ConsultationRegisterView> createState() =>
      _ConsultationRegisterViewState();
}

class _ConsultationRegisterViewState extends State<ConsultationRegisterView> {
  late ConsultationRegisterViewModel _viewModel;
  final ConsultationValidator _validator = ConsultationValidator();
  final ConsultationDto _consultation = ConsultationDto();

  final TextEditingController _dateController = TextEditingController();
  ConsultationStatus _statusSelecionado = ConsultationStatus.agendada;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
    _viewModel.registerConsultationCommand
        .addListener(_onRegisterConsultationCommandChanged);

    _dateController.text =
        DateFormat('dd/MM/yyyy hh:mm').format(_consultation.dateTime);

    _viewModel.loadPatients();
    _loadDoctor();
  }

  void _loadDoctor() async {
    _consultation.doctorId = await _viewModel.loadDoctor();
  }

  void _onRegisterConsultationCommandChanged() {
    if (_viewModel.registerConsultationCommand.isSuccess) {
      context.go(Routes.home);
      // Navigator.of(context).pop();
    } else if (_viewModel.registerConsultationCommand.isFailure) {
      final failure =
          _viewModel.registerConsultationCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.registerConsultationCommand
        .removeListener(_onRegisterConsultationCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              TextFormField(
                onChanged: (value) {
                  _consultation.title = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_consultation, 'title'),
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
                onChanged: (value) {
                  _consultation.description = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_consultation, 'description'),
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
                      controller: _dateController,
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate =
                            await showOmniDateTimePicker(context: context);

                        if (pickedDate != null) {
                          setState(() {
                            _consultation.dateTime = pickedDate;
                            _dateController.text =
                                DateFormat('dd/MM/yyyy hh:mm')
                                    .format(pickedDate);
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
                          await showOmniDateTimePicker(context: context);

                      if (pickedDate != null) {
                        setState(() {
                          _consultation.dateTime = pickedDate;
                          _dateController.text =
                              DateFormat('dd/MM/yyyy hh:mm').format(pickedDate);
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
                onChanged: (value) {
                  _consultation.duration = value;
                },
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_consultation, 'duration'),
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
                onChanged: (value) {
                  _consultation.value = value;
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
                  value: _statusSelecionado, // Valor selecionado
                  onChanged: (ConsultationStatus? newValue) {
                    setState(() {
                      _statusSelecionado = newValue!;
                      _consultation.status = _statusSelecionado;
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
              const SizedBox(height: 20),
              StreamBuilder<List<Patient>>(
                stream: _viewModel.patientsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Ou outro indicador de carregamento
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return DropdownButtonFormField<Patient>(
                      decoration: InputDecoration(
                        labelText: 'Paciente',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (Patient? newValue) {
                        setState(() {
                          _consultation.patientId = newValue!.id;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'É necessário selecionar um paciente';
                        }
                        return null;
                      },
                      items: snapshot.data!
                          .map<DropdownMenuItem<Patient>>((Patient patient) {
                        return DropdownMenuItem<Patient>(
                          value: patient,
                          child: Text(patient.name),
                        );
                      }).toList(),
                    );
                  } else {
                    return const Text(
                        "No data available"); // Lidar com o caso em que não há dados
                  }
                },
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
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: _viewModel.registerConsultationCommand.isRunning
                        ? null
                        : () {
                            if (_validator.validate(_consultation).isValid) {
                              _viewModel.registerConsultationCommand
                                  .execute(_consultation);
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
  }
}

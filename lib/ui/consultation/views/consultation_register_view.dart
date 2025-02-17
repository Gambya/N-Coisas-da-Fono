import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ncoisasdafono/domain/dtos/consultation_dto.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';
import 'package:ncoisasdafono/domain/validators/consultation_validator.dart';
import 'package:ncoisasdafono/ui/consultation/viewmodels/consultation_register_view_model.dart';

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
        DateFormat('dd/MM/yyyy').format(_consultation.dateTime);
  }

  void _onRegisterConsultationCommandChanged() {}

  @override
  void dispose() {
    _viewModel.registerConsultationCommand
        .removeListener(_onRegisterConsultationCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Text('Consulta'),
              const SizedBox(height: 40),
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
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _consultation.description = value;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_consultation, 'description'),
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    // Use Expanded para o TextFormField ocupar o espaço disponível
                    child: TextFormField(
                      controller: _dateController, // Use o controlador aqui
                      readOnly: true, // Impede a edição direta no TextFormField
                      onTap: () async {
                        // Abre o DatePicker ao tocar no TextFormField
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );

                        if (pickedDate != null) {
                          setState(() {
                            _consultation.dateTime = pickedDate;
                            _dateController.text = DateFormat('dd/MM/yyyy')
                                .format(pickedDate); // Atualiza o TextFormField
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
                    // Um ícone de calendário para facilitar a interação
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );

                      if (pickedDate != null) {
                        setState(() {
                          _consultation.dateTime = pickedDate;
                          _dateController.text = DateFormat('dd/MM/yyyy')
                              .format(pickedDate); // Atualiza o TextFormField
                        });
                      }
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  _consultation.duration = int.parse(value);
                },
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validator.byField(_consultation, 'duration'),
                decoration: InputDecoration(
                  labelText: 'Duração da Consulta (minutos)',
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  Decimal? decimalValue = Decimal.tryParse(value);
                  if (decimalValue != null) {
                    _consultation.value = decimalValue;
                  }
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
            ],
          ),
        ),
      ),
    );
  }
}

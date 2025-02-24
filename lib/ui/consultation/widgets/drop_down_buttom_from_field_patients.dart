import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/entities/patient.dart';
import 'package:ncoisasdafono/ui/consultation/widgets/viewmodels/drop_down_buttom_from_field_patients_view_model.dart';
import 'package:provider/provider.dart';
import 'package:result_command/result_command.dart';

class DropDownButtomFromFieldPatients extends StatefulWidget {
  final Patient? initialPatient;
  final Function(Patient?)? onChanged;
  const DropDownButtomFromFieldPatients(
      {super.key, this.initialPatient, this.onChanged});

  @override
  State<DropDownButtomFromFieldPatients> createState() =>
      _DropDownButtomFromFieldPatientsState();
}

class _DropDownButtomFromFieldPatientsState
    extends State<DropDownButtomFromFieldPatients> {
  late DropDownButtomFromFieldPatientsViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = context.read<DropDownButtomFromFieldPatientsViewModel>();
    _viewModel.onLoadPatientsCommand.addListener(_onLoadPatientsCommandChanged);
    _viewModel.onLoadPatientsCommand.execute();
  }

  void _onLoadPatientsCommandChanged() {
    if (_viewModel.onLoadPatientsCommand.isFailure) {
      final failure = _viewModel.onLoadPatientsCommand.value as FailureCommand;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(failure.error.toString()),
      ));
    }
  }

  @override
  void dispose() {
    _viewModel.onLoadPatientsCommand
        .removeListener(_onLoadPatientsCommandChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Patient>>(
      stream: _viewModel.patientsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erro: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<Patient> patients = snapshot.data!;
          Patient? selectedPatient = patients.contains(widget.initialPatient)
              ? widget.initialPatient
              : patients.isNotEmpty
                  ? patients.first
                  : null;
          return DropdownButtonFormField<Patient>(
            value: selectedPatient,
            decoration: InputDecoration(
              labelText: 'Paciente',
              border: OutlineInputBorder(),
            ),
            onChanged: (Patient? newValue) {
              setState(() {
                widget.onChanged!(newValue);
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
                child: SizedBox(
                  width: 200,
                  child: Text(
                    patient.name,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              );
            }).toList(),
          );
        } else {
          return const Text(
              "No data available"); // Lidar com o caso em que não há dados
        }
      },
    );
  }
}

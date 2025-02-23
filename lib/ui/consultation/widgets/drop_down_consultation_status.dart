import 'package:flutter/material.dart';
import 'package:ncoisasdafono/domain/entities/consultation.dart';

class DropDownConsultationStatus extends StatefulWidget {
  final ConsultationStatus? initialStatus;
  final Function(ConsultationStatus?)? onChanged;
  const DropDownConsultationStatus(
      {super.key, this.initialStatus, this.onChanged});

  @override
  State<DropDownConsultationStatus> createState() =>
      _DropDownConsultationStatusState();
}

class _DropDownConsultationStatusState
    extends State<DropDownConsultationStatus> {
  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Status',
        border: OutlineInputBorder(),
        errorStyle: TextStyle(color: Colors.red),
      ),
      child: DropdownButton<ConsultationStatus>(
        isExpanded: true,
        isDense: true,
        focusColor: Colors.white,
        value: widget.initialStatus,
        onChanged: (ConsultationStatus? newValue) {
          setState(() {
            widget.onChanged!(newValue);
          });
        },
        items: ConsultationStatus.values.map((ConsultationStatus status) {
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
    );
  }
}

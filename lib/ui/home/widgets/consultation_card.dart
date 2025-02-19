import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ConsultationCard extends StatelessWidget {
  final String patientName;
  final String? photoUrl;
  final DateTime consultationDate;
  final TimeOfDay consultationTime;
  final int consultationDuration;

  const ConsultationCard({
    super.key,
    required this.patientName,
    this.photoUrl,
    required this.consultationDate,
    required this.consultationTime,
    required this.consultationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        color: Color.fromARGB(
            255, 215, 186, 232), //Color.fromARGB(255, 193, 214, 255),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Foto do paciente ou iniciais
                  if (photoUrl != null && photoUrl!.isNotEmpty)
                    CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl!),
                    )
                  else
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Text(
                        patientName.substring(0, 2).toUpperCase(),
                        style: TextStyle(
                          color: Color.fromARGB(255, 215, 186, 232),
                        ),
                      ),
                    ),
                  const SizedBox(width: 16),
                  Text(
                    patientName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('dd/MM/yyyy').format(consultationDate),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('hh:mm:ss').format(consultationDate),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${consultationDuration} minutos',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

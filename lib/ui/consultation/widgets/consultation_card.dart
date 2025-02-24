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
      padding: const EdgeInsets.all(0.5),
      child: Card(
        color: Color.fromARGB(255, 215, 186, 232),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
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
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: Center(
                          child: Text(
                            patientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  DateFormat('dd/MM/yyyy')
                                      .format(consultationDate),
                                  style: const TextStyle(
                                    fontSize: 10,
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
                                  size: 10,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatTimeOfDay(consultationTime),
                                  style: const TextStyle(
                                    fontSize: 10,
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
                                  Icons.timer,
                                  color: Colors.white,
                                  size: 10,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '$consultationDuration minutos',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    const second =
        '00'; // Como TimeOfDay não tem segundos, você pode definir como '00' ou algum valor fixo

    return '$hour:$minute:$second';
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingConsultationView extends StatelessWidget {
  final int itemCount;

  const ShimmerLoadingConsultationView({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Cor base da animação
      highlightColor: Colors.grey[100]!, // Destaque da animação
      period: const Duration(milliseconds: 1000), // Duração da animação
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                  top: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Lado esquerdo: CircleAvatar + textos
                    Row(
                      children: [
                        // Simula o CircleAvatar
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        // Simula o nome, data e hora
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Simula o nome do paciente
                            Container(
                              width: 200.0, // Mesma largura do texto real
                              height: 16.0, // Altura aproximada do texto
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8.0),
                            // Simula data e hora
                            Row(
                              children: [
                                // Data
                                Row(
                                  children: [
                                    // Simula o ícone de calendário
                                    Container(
                                      width: 10.0,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8.0),
                                    // Simula o texto da data
                                    Container(
                                      width: 60.0,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10.0),
                                // Hora
                                Row(
                                  children: [
                                    // Simula o ícone de relógio
                                    Container(
                                      width: 10.0,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 8.0),
                                    // Simula o texto da hora
                                    Container(
                                      width: 40.0,
                                      height: 10.0,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Lado direito: simula o ícone de seta
                    Container(
                      width: 24.0,
                      height: 24.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              Divider(
                color: Colors.grey[200],
                thickness: 1.0,
                height: 0.0,
              ),
            ],
          );
        },
      ),
    );
  }
}

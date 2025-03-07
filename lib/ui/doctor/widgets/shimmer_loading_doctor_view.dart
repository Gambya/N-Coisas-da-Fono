import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingDoctorView extends StatelessWidget {
  const ShimmerLoadingDoctorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!, // Cor base da animação
      highlightColor: Colors.grey[100]!, // Destaque da animação
      period: const Duration(milliseconds: 1000), // Duração da animação
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Mesmo padding da DoctorView
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Simula o CircleAvatar centralizado
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 100.0, // 2 * raio do CircleAvatar (50)
                    height: 100.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  // Simula o ícone de edição
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 30.0,
                      height: 30.0,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            // Simula o nome, e-mail e especialidade
            Column(
              children: [
                // Nome
                Center(
                  child: Container(
                    width: 150.0, // Largura aproximada para o nome
                    height: 16.0, // Altura de uma linha de texto
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                // E-mail
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.0, // Simula o ícone de e-mail
                      height: 20.0,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5.0),
                    Container(
                      width: 200.0, // Largura aproximada para o e-mail
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                // Especialidade
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.0, // Simula o ícone de especialidade
                      height: 20.0,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5.0),
                    Container(
                      width: 150.0, // Largura aproximada para a especialidade
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Simula o Divider
            Container(
              height: 1.0,
              color: Colors.white,
            ),
            const SizedBox(height: 16.0),
            // Simula Telefone e CRFa
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Telefone
                Row(
                  children: [
                    Container(
                      width: 20.0, // Simula o ícone de telefone
                      height: 20.0,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5.0),
                    Container(
                      width: 120.0, // Largura aproximada para o telefone
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(width: 16.0),
                // CRFa
                Row(
                  children: [
                    Container(
                      width: 20.0, // Simula o ícone de CRFa
                      height: 20.0,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 5.0),
                    Container(
                      width: 80.0, // Largura aproximada para o CRFa
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Simula Endereço
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20.0, // Simula o ícone de endereço
                      height: 20.0,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 5.0),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.6, // Mesma largura do texto real
                      height: 16.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            // Simula o segundo Divider
            Container(
              height: 1.0,
              color: Colors.white,
            ),
            const SizedBox(height: 16.0),
            // Simula os botões "Compartilhar" e "Editar"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Botão "Compartilhar"
                Container(
                  height: 48.0, // Altura padrão de um ElevatedButton
                  width: 140.0, // Largura para acomodar ícone e texto
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                // Botão "Editar"
                Container(
                  height: 48.0,
                  width: 140.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

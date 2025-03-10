import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingConsultationRegister extends StatelessWidget {
  const ShimmerLoadingConsultationRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1000),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShimmerTextField(),
            const SizedBox(height: 16.0),
            _buildShimmerTextArea(),
            const SizedBox(height: 24.0),
            _buildShimmerTextFieldAndIcon(),
            const SizedBox(height: 24.0),
            _buildShimmerTextField(),
            const SizedBox(height: 16.0),
            _buildShimmerTextField(),
            const SizedBox(height: 16.0),
            _buildShimmerTextField(),
            const SizedBox(height: 16.0),
            _buildShimmerTextField(),
            const SizedBox(height: 16.0),
            Center(child: _buildShimmerButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerTextField() {
    return Container(
      height: 60.0, // Altura aproximada de um TextFormField com label
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(8.0), // Bordas arredondadas como no Material
      ),
    );
  }

  Widget _buildShimmerTextFieldAndIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 60.0,
          width: 250.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ],
    );
  }

  Widget _buildShimmerTextArea() {
    return Container(
      height: 120.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  Widget _buildShimmerButton() {
    return Container(
      height: 48.0,
      width: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.2) as int),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

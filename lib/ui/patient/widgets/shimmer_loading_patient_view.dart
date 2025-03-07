import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoadingPatientView extends StatelessWidget {
  final int itemCount;

  const ShimmerLoadingPatientView({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      period: const Duration(milliseconds: 1000),
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
                    Row(
                      children: [
                        Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200.0,
                              height: 16.0,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 8.0),
                            Container(
                              width: 230.0,
                              height: 14.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
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

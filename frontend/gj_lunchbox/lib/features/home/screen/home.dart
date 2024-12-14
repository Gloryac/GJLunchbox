import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class HomeScreen  extends StatelessWidget {
  const HomeScreen ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: AppColors.lightGreen,
              padding: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  CircularContainer()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CircularContainer extends StatelessWidget {
  const CircularContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 400,
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(400),
        color: AppColors.white.withOpacity(0.1),
      ),
    );
  }
}

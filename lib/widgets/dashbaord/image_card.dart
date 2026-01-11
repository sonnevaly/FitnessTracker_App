import 'package:flutter/material.dart';

class HeroImageCard extends StatelessWidget {
  final VoidCallback onStart;

  const HeroImageCard({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onStart,
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/run_banner.jpg',
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.45),
              ),

              /// TEXT CONTENT
              Center(
                child: Text(
                  'Start your run tracking today',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

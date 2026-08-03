import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'logos/site_flow_logo.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(
              width: 180,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.all(Radius.circular(2.0)),
                color: Color(0xFFDC9728),
                backgroundColor: Color(0xFFF3E7D3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

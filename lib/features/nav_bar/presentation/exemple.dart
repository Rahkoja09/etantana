import 'package:e_tantana/shared/widget/app_refresh_indicator.dart';
import 'package:flutter/material.dart';

class Exemple extends StatelessWidget {
  const Exemple({super.key});

  @override
  Widget build(BuildContext context) {
    return AppRefreshIndicator(
      onRefresh: () async {
        print("koja");
        await Future.delayed(
          const Duration(seconds: 2),
        ); // Pour simuler l'attente
      },
      child: SingleChildScrollView(
        // On garde ça, c'est indispensable
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          // On force le contenu à prendre toute la hauteur de l'écran
          height: MediaQuery.of(context).size.height,
          child: const Center(child: Text("Comming soon")),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../modules/calc/screens/calc.dart';
import '../modules/forms/screens/formulario.dart';
import '../modules/home/screens/home.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<StatefulWidget> createState() {
    return BottomBarState();
  }
}

class BottomBarState extends State<BottomBar> {
  int abaSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nav bar"),
          centerTitle: true,
          leading: const Icon(Icons.anchor_outlined),
          backgroundColor: Color.fromARGB(255, 2, 113, 17),
        ),
        bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.white,
            selectedIndex: abaSelecionada,
            // Evento ativado quando uma aba for selecionada
            // index representa o índice da aba (0 a n-1)
            onDestinationSelected: (index) {
              setState(() {
                abaSelecionada = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home,
                    color: Colors
                        .yellow), // Substitua "Colors.blue" pela cor desejada
                label: "Início",
              ),
              NavigationDestination(
                icon: Icon(Icons.calculate_sharp, color: Colors.blue),
                label: "Calculadora",
              ),
              NavigationDestination(
                icon: Icon(Icons.person, color: Colors.black),
                label: "Perfil",
              ),
            ]),
        body: [
          const Home(),
          const Calc(),
          const Formulario(),
        ][abaSelecionada]);
  }
}

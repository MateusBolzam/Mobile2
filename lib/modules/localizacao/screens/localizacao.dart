import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../models/localizacao.dart';

class Localizacao extends StatefulWidget {
  const Localizacao({super.key});

  @override
  State<StatefulWidget> createState() {
    return LocalizacaoState();
  }
}

class LocalizacaoState extends State<Localizacao> {
  late Future<dynamic>? futureData;
  final cepController = TextEditingController();
  bool buttonDisabled = true;

  @override
  void dispose() {
    cepController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    futureData = procuraCEP();
    cepController.addListener(() {
      setState(() {
        buttonDisabled = cepController.text.length < 8;
      });
      if (cepController.text.length < 8) {
        setState(() {
          futureData = null;
        });
      }
    });
  }

  Future<void> pegarLocalizacao() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    } catch (e) {
      print('Erro ao obter a localização: $e');
    }
  }

  Future<void> UsarGoogleMaps(String query) async {
    await pegarLocalizacao();
    final Uri googleMapsUrl = Uri.parse(
        "https://google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}");

    try {
      await launchUrl(googleMapsUrl, mode: LaunchMode.inAppWebView);
    } catch (e) {
      throw 'O Google Maps não abriu seu erro e esse: $e';
    }
  }

  Future<dynamic> procuraCEP() async {
    final String cep = cepController.text;

    if (cep.isNotEmpty) {
      final Uri url = Uri.parse("https://viacep.com.br/ws/$cep/json/");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return LocalizacaoModel.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw Exception('Failed to load Localização');
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Localização"),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 2, 113, 17),
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  TextField(
                    controller: cepController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Coloque Um CEP',
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 8,
                  ),
                  ElevatedButton(
                    onPressed: buttonDisabled
                        ? null
                        : () async {
                            if (cepController.text.isNotEmpty) {
                              setState(() {
                                futureData = procuraCEP();
                              });
                            }
                          },
                    child: const Text("Procurar"),
                  ),
                  if (!buttonDisabled)
                    FutureBuilder(
                        future: futureData,
                        builder: ((context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Text(
                                  "Erro",
                                ));
                          }
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Column(
                                    children: [
                                      ListView(
                                        itemExtent: 25,
                                        shrinkWrap: true,
                                        children: [
                                          ListTile(
                                            title: Text(
                                              "CEP: ${snapshot.data!.cep}",
                                            ),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "Rua: ${snapshot.data!.rua}"),
                                          ),
                                          ListTile(
                                            title: snapshot.data?.complemento !=
                                                        null &&
                                                    snapshot.data!.complemento
                                                        .isNotEmpty
                                                ? Text(
                                                    "Complemento: ${snapshot.data!.complemento}")
                                                : Text(
                                                    "Complemento: Não há complemento nesse CEP"),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "Bairro: ${snapshot.data!.bairro}"),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "Localidade: ${snapshot.data!.localidade}"),
                                          ),
                                          ListTile(
                                            title: Text(
                                                "Estado: ${snapshot.data!.uf}"),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await UsarGoogleMaps(
                                                  snapshot.data!.rua);
                                            },
                                            child:
                                                const Text('Usar Google Maps')),
                                      )
                                    ],
                                  )),
                            );
                          }

                          return Container();
                        }))
                ],
              )),
        ));
  }
}

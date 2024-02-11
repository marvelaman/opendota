import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HeroEntity {
  final String name;
  final String mainAttribute;

  const HeroEntity({
    required this.name,
    required this.mainAttribute
  });

  factory HeroEntity.fromJson(Map<String, dynamic> json) {
    return HeroEntity(name: json['localized_name'], mainAttribute: json['primary_attr']);
  }
}

class Controller {
  List<HeroEntity> heroes = [];

  Future<void>? getHeroes() async {
    final response = await http.get(Uri.https('opendota.com', 'api/heroes'));
    final List<dynamic> data = jsonDecode(response.body);
    heroes = data.map((e) => HeroEntity.fromJson(e)).toList();
  }
}

void main() async {
  final Controller controller = Controller();
  await controller.getHeroes();
  runApp(
    MyApp(
      data: controller,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.data, super.key});

  final Controller data;

  @override
  Widget build(BuildContext context) {
    final heroes = data.heroes;
    return MaterialApp(
      home: Scaffold(
          body: ListView.builder(
            itemCount: data.heroes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Image.asset('assets/images/heroes/abaddon.png'),
                title: Text(heroes[index].name),
                trailing: Text(heroes[index].mainAttribute),
              );
            },
          )),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GardenPage extends StatelessWidget {
  const GardenPage({Key? key, required this.username}) : super(key: key);

  final String username;
  static const route = '/garden';
  static const routename = 'GardenPage';
  
  @override
  Widget build(BuildContext context) {
    print('${GardenPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(GardenPage.routename),
      ),
      body: Center(
        child: Text('Here you will find your vegetable garden progress'),
      ),
    );
  } //build

} //Page
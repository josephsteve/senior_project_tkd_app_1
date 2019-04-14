import 'package:flutter/material.dart';
import 'blocs/belt_techniques_bloc_provider.dart';
import 'ui/belt_add.dart';
import 'ui/belts_list.dart';
import 'blocs/belts_bloc_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BeltsBlocProvider(
      child: BeltTechniquesBlocProvider(
        child: new MaterialApp(
            home: new HomeScreen()),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Belts"),
      ),
      body: BeltListScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBelt())),
        child: Icon(Icons.add),
      ),
    );
  }
}

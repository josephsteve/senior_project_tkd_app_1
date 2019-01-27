import 'package:flutter/material.dart';
import 'ui/belts_list.dart';
import 'blocs/belts_bloc_provider.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BeltsBlocProvider(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("Belts"),
          ),
          body: BeltListScreen(),
        ),
      ),
    );
  }
}

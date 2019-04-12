import 'package:flutter/material.dart';
import 'belt_techniques_bloc.dart';
export 'belt_techniques_bloc.dart';
export '../models/belt_model.dart';

class BeltTechniquesBlocProvider extends InheritedWidget {
  final bloc = BeltTechniquesBloc();
  BeltTechniquesBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BeltTechniquesBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BeltTechniquesBlocProvider) as BeltTechniquesBlocProvider).bloc;
  }
}
import 'package:flutter/material.dart';
import 'belts_bloc.dart';
export 'belts_bloc.dart';
export '../models/belt_model.dart';

class BeltsBlocProvider extends InheritedWidget {
  final bloc = BeltsBloc();
  BeltsBlocProvider({Key key, Widget child}) : super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static BeltsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BeltsBlocProvider) as BeltsBlocProvider).bloc;
  }
}
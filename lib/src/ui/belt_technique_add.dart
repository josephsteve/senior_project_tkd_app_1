import 'package:flutter/material.dart';
import 'belt_technique_list.dart';
import '../blocs/belt_techniques_bloc_provider.dart';
import '../blocs/belt_techniques_bloc.dart';

class AddBeltTechnique extends StatelessWidget {

  final String beltId;
  final String beltName;

  const AddBeltTechnique({Key key, this.beltId, this.beltName}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Technique for " + beltName),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: BeltTechniqueAddScreen(beltId: beltId, beltName: beltName)
    );
  }
}

class BeltTechniqueAddScreen extends StatefulWidget {

  final String beltId;
  final String beltName;
  const BeltTechniqueAddScreen({Key key, this.beltId, this.beltName}): super(key: key);

  @override
  _BeltTechniqueAddScreenState createState() => _BeltTechniqueAddScreenState();
}

class _BeltTechniqueAddScreenState extends State<BeltTechniqueAddScreen> {
  BeltTechniquesBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BeltTechniquesBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget techniqueNameField() {
    return StreamBuilder(
      stream: _bloc.techniqueName,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: _bloc.changeTechniqueName,
          decoration: InputDecoration(
            hintText: 'Enter Technique Name', errorText: snapshot.error),
        );
      },
    );
  }

  Widget difficultyField() {
    return StreamBuilder(
      stream: _bloc.difficulty,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: _bloc.changeDifficulty,
          decoration: InputDecoration(
            hintText: 'Enter Difficulty', errorText: snapshot.error),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: techniqueNameField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: difficultyField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(8.0)),
                color: Colors.blue,
                child: Text('Save'),
                onPressed: () {
                  _bloc.submit(widget.beltId);
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(8.0)),
                color: Colors.grey,
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        )
      ],
    );
  }
}


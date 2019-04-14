import 'package:flutter/material.dart';
import '../app.dart';
import '../blocs/belts_bloc_provider.dart';
import '../blocs/belts_bloc.dart';

class AddBelt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Belt"),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: BeltAddScreen(),
    );
  }
}

class BeltAddScreen extends StatefulWidget {
  @override
  _BeltAddScreenState createState() => _BeltAddScreenState();
}

class _BeltAddScreenState extends State<BeltAddScreen> {
  BeltsBloc _bloc;

  final _beltNameController = new TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BeltsBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  Widget beltNameField() {
    return StreamBuilder(
      stream: _bloc.beltname,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: _bloc.changeBeltName,
          decoration: InputDecoration(
            hintText: 'Enter Belt Name', errorText: snapshot.error),
        );
      },
    );
  }

  Widget levelField() {
    return StreamBuilder(
      stream: _bloc.level,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onChanged: _bloc.changeLevel,
          decoration: InputDecoration(
              hintText: 'Enter Belt Level', errorText: snapshot.error),
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
          child: beltNameField(),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: levelField(),
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
                  _bloc.submit();
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                shape: RoundedRectangleBorder(side: BorderSide(style: BorderStyle.none), borderRadius: BorderRadius.circular(8.0)),
                color: Colors.grey,
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context)
              ),
            ],
          ),
        )
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../blocs/belts_bloc_provider.dart';
import '../blocs/belts_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_colorpicker/material_picker.dart';
import 'package:flutter_colorpicker/block_picker.dart';
import 'package:flutter_colorpicker/utils.dart';

class AddBelt extends StatelessWidget {

  final String beltID;

  AddBelt({this.beltID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((beltID != null && beltID.isNotEmpty ? "Edit" : "Add") + " Belt"),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: BeltAddScreen(beltID: beltID,),
    );
  }
}

class BeltAddScreen extends StatefulWidget {
  final String beltID;

  BeltAddScreen({this.beltID});
  @override
  _BeltAddScreenState createState() => _BeltAddScreenState();
}

class _BeltAddScreenState extends State<BeltAddScreen> {
  BeltsBloc _bloc;
  final TextEditingController beltNameController = new TextEditingController();
  final TextEditingController levelController = new TextEditingController();
  int currentColorValue = 0xff443a49;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BeltsBlocProvider.of(context);
    if (widget.beltID != null && widget.beltID.isNotEmpty) {
      _bloc.getBelt(widget.beltID).listen((data) {
        if (data != null) {
          Belt _belt = Belt.fromMap(data.data);
          setState(() {
            beltNameController.text = _belt.beltname;
            _bloc.setBeltName(_belt.beltname);
            levelController.text = _belt.level.toString();
            _bloc.setLevel(_belt.level.toString());
            currentColorValue = _belt.color;
            _bloc.setColor(_belt.color);
          });
        }
      });
    }
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
          controller: beltNameController,
          onChanged: _bloc.changeBeltName,
          decoration: InputDecoration(
            labelText: 'Enter Belt Name',
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
          controller: levelController,
          onChanged: _bloc.changeLevel,
          decoration: InputDecoration(
            labelText: 'Enter Belt Level',
              hintText: 'Enter Belt Level', errorText: snapshot.error),
        );
      },
    );
  }

  void changeColor(Color color) => setState(() {
    currentColorValue = color.value;
    _bloc.setColor(currentColorValue);
  });

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
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50.0,
                height: 50.0,
                child: Text(""),
                color: Color(currentColorValue),
              ),
              IconButton(icon: Icon(Icons.edit), onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      titlePadding: const EdgeInsets.all(0.0),
                      contentPadding: const EdgeInsets.all(0.0),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: Color(currentColorValue),
                          onColorChanged: changeColor,
                          colorPickerWidth: 1000.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: true,
                        ),
                      ),
                    );
                  },
                );
              },)
            ],
          ),
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
                  _bloc.submit(widget.beltID);
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

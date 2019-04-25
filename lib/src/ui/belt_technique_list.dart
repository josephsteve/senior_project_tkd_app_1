import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/belt_technique_model.dart';
import 'belt_technique_add.dart';
import 'slide_menu.dart';
import '../blocs/belt_techniques_bloc_provider.dart';
import 'belt_technique_view.dart';

class ListBeltTechnique extends StatelessWidget {

  final String beltId;
  final String beltName;

  const ListBeltTechnique({Key key, this.beltId, this.beltName}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(beltName),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: BeltTechniqueListScreen(beltId: beltId, beltName: beltName,),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBeltTechnique(beltId: beltId, beltName: beltName))),
        child: Icon(Icons.add),
      ),
    );
  }
}


class BeltTechniqueListScreen extends StatefulWidget {

  final String beltId;
  final String beltName;

  const BeltTechniqueListScreen({Key key, this.beltId, this.beltName}): super(key: key);

  @override
  _BeltTechniqueListScreenState createState() => _BeltTechniqueListScreenState();
}

class _BeltTechniqueListScreenState extends State<BeltTechniqueListScreen> {
  BeltTechniquesBloc _bloc;
  final closeMenuNotifier = new StreamController.broadcast();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BeltTechniquesBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    closeMenuNotifier.close();
    super.dispose();
  }

  getBeltTechniqueInfo(documentID) {
    print(documentID);
    print(widget.beltName);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
      AddBeltTechnique(beltId: widget.beltId, beltName: widget.beltName, techniqueID: documentID,)));
    closeMenuNotifier.sink.add(null);
  }

  deleteBelt(String documentID, String techniqueName) {
    closeMenuNotifier.sink.add(null);
    _showDialog(documentID, techniqueName);
  }

  void _showDialog(String techniqueID, String techniqueName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Technique?"),
          content: Text("Are you sure you want to delete $techniqueName?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                _bloc.delete(techniqueID);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot doc) {
    BeltTechniqueTemp _belttechnique = BeltTechniqueTemp.fromMap(doc.data);
    return SlideMenu(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ViewBeltTechnique(techniqueID: doc.documentID, techniqueName: _belttechnique.techniqueName)));
        },
        key: ValueKey(doc.documentID),
        title: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF957343)),
            borderRadius: BorderRadius.circular(5.0)
          ),
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: <Widget>[
              Text(_belttechnique.techniqueName)
            ],
          ),
        ),
      ),
      menuItems: <Widget>[
        new Container(
          child: new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: () => deleteBelt(doc.documentID, _belttechnique.techniqueName),
          ),
        ),
        new Container(
          child: new IconButton(
            icon: new Icon(Icons.info),
            onPressed: () => getBeltTechniqueInfo(doc.documentID),
          ),
        ),
      ],
      triggerCloseMenu: closeMenuNotifier.stream,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: _bloc.getBeltTechniques(widget.beltId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              padding: const EdgeInsets.all(10.0),
              itemExtent: 60.0,
              itemBuilder: (context, index) =>
                _buildListItem(context, snapshot.data.documents[index]));
          } else {
            return Text("No Technique");
          }
        })
    );
  }
}

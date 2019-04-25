import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'belt_add.dart';
import 'slide_menu.dart';
import 'belt_technique_list.dart';
import '../blocs/belts_bloc_provider.dart';

class BeltListScreen extends StatefulWidget {
  @override
  _BeltListScreenState createState() => _BeltListScreenState();
}

class _BeltListScreenState extends State<BeltListScreen> {
  BeltsBloc _bloc;
  final closeMenuNotifier = new StreamController.broadcast();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BeltsBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    closeMenuNotifier.close();
    super.dispose();
  }

  getBeltInfo(documentID) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBelt(beltID: documentID,)));
    closeMenuNotifier.sink.add(null);
  }

  deleteBelt(String documentID, String beltName) {
    closeMenuNotifier.sink.add(null);
    _showDialog(documentID, beltName);
  }

  void _showDialog(String beltID, String beltName) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Delete Belt?"),
          content: Text("Are you sure you want to delete $beltName?"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () {
                _bloc.delete(beltID);
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot doc) {
    Belt _belt = Belt.fromMap(doc.data);
    return SlideMenu(
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListBeltTechnique(beltId: doc.documentID, beltName: _belt.beltname,)));
        },
        key: ValueKey(doc.documentID),
        title: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: [const Color(0xFFFFFFFF), Color(_belt.color == null ? 0xFFFFFFFF : _belt.color)],
              tileMode: TileMode.clamp,
            ),
            border: Border.all(color: const Color(0xFF957343)),
            borderRadius: BorderRadius.circular(5.0)
          ),
          padding: const EdgeInsets.all(18.0),
          child: Row(
            children: <Widget>[
              Text(_belt.beltname, style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
      menuItems: <Widget>[
        new Container(
          child: new IconButton(
            icon: new Icon(Icons.delete),
            onPressed: () => deleteBelt(doc.documentID, _belt.beltname),
          ),
        ),
        new Container(
          child: new IconButton(
            icon: new Icon(Icons.info),
            onPressed: () => getBeltInfo(doc.documentID),
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
          stream: _bloc.getAllBelts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  padding: const EdgeInsets.all(10.0),
                  itemExtent: 60.0,
                  itemBuilder: (context, index) =>
                      _buildListItem(context, snapshot.data.documents[index]));
            } else {
              return Text("No Belt");
            }
          })
    );
  }
}

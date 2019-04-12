import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'belt_technique_list.dart';
import '../blocs/belts_bloc_provider.dart';

class BeltListScreen extends StatefulWidget {
  @override
  _BeltListScreenState createState() => _BeltListScreenState();
}

class _BeltListScreenState extends State<BeltListScreen> {
  BeltsBloc _bloc;

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

  Widget _buildListItem(BuildContext context, DocumentSnapshot doc) {
    Belt _belt = Belt.fromMap(doc.data);
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => ListBeltTechnique(beltId: doc.documentID,)));
      },
      key: ValueKey(doc.documentID),
      title: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF957343)),
          borderRadius: BorderRadius.circular(5.0)
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(_belt.beltname)
          ],
        ),
      ),
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

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/belt_technique_model.dart';
import 'belt_technique_add.dart';
import '../blocs/belt_techniques_bloc_provider.dart';

class ListBeltTechnique extends StatelessWidget {

  final String beltId;
  final String beltName;

  const ListBeltTechnique({Key key, this.beltId, this.beltName}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return BeltTechniquesBlocProvider(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text(beltName),
            leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
          ),
          body: BeltTechniqueListScreen(beltId: beltId),
          floatingActionButton: FloatingActionButton(
            onPressed: () =>
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddBeltTechnique(beltId: beltId, beltName: beltName))),
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}


class BeltTechniqueListScreen extends StatefulWidget {

  final String beltId;

  const BeltTechniqueListScreen({Key key, this.beltId}): super(key: key);

  @override
  _BeltTechniqueListScreenState createState() => _BeltTechniqueListScreenState();
}

class _BeltTechniqueListScreenState extends State<BeltTechniqueListScreen> {
  BeltTechniquesBloc _bloc;

  @override
  void initState() {
    super.initState();
  }

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

  Widget _buildListItem(BuildContext context, DocumentSnapshot doc) {
    BeltTechniqueTemp _belttechnique = BeltTechniqueTemp.fromMap(doc.data);
    return ListTile(
      onTap: () {},
      key: ValueKey(doc.documentID),
      title: Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF957343)),
          borderRadius: BorderRadius.circular(5.0)
        ),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Text(_belttechnique.techniqueName)
          ],
        ),
      ),
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

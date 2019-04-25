import 'dart:io';

import 'package:flutter/material.dart';
import '../blocs/belt_techniques_bloc_provider.dart';
import '../blocs/belt_techniques_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ViewBeltTechnique extends StatelessWidget {

  final String techniqueID;
  final String techniqueName;

  const ViewBeltTechnique({Key key, this.techniqueID, this.techniqueName}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(techniqueName),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: ViewBeltTechniqueScreen(techniqueID: techniqueID),
    );
  }
}

class ViewBeltTechniqueScreen extends StatefulWidget {

  final String techniqueID;

  const ViewBeltTechniqueScreen({Key key, this.techniqueID}): super(key: key);

  @override
  _ViewBeltTechniqueScreenState createState() => _ViewBeltTechniqueScreenState();
}

class _ViewBeltTechniqueScreenState extends State<ViewBeltTechniqueScreen> {
  BeltTechniquesBloc _bloc;
  List<String> imgList;
  List child;
  String description;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BeltTechniquesBlocProvider.of(context);
    if (widget.techniqueID != null && widget.techniqueID.isNotEmpty) {
      _bloc.getBeltTechnique(widget.techniqueID).listen((data) {
        if (data != null) {
          BeltTechniqueTemp _beltTechnique = BeltTechniqueTemp.fromMap(data.data);
          setState(() {
            description = _beltTechnique.description;
          });
          if (_beltTechnique.images != null && _beltTechnique.images.isNotEmpty) {
           imgList = _beltTechnique.images.cast<String>().toList();
           setState(() {
             child = map<Widget>(
               imgList,
                 (index, i) {
                 return Container(
                   margin: EdgeInsets.all(5.0),
                   child: ClipRRect(
                     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                     child: Stack(children: <Widget>[
                       Image.network(i, fit: BoxFit.fitHeight, height: 300.0),
                       Positioned(
                         bottom: 0.0,
                         left: 0.0,
                         right: 0.0,
                         child: Container(
                           decoration: BoxDecoration(
                             gradient: LinearGradient(
                               colors: [Color.fromARGB(200, 0, 0, 0), Color.fromARGB(0, 0, 0, 0)],
                               begin: Alignment.bottomCenter,
                               end: Alignment.topCenter,
                             ),
                           ),
                           padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                           child: Text(
                             '',
                             style: TextStyle(
                               color: Colors.white,
                               fontSize: 20.0,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                         ),
                       ),
                     ]),
                   ),
                 );
               },
             ).toList();
           });
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _bloc.dispose();
    imgList = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CarouselWithIndicator(imgList: imgList, child: child),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                child: Text(description == null ? "" : description.trim(), style: TextStyle(fontSize: 20.0),),
              ),
            ),
          ])),
      ],
    );
  }
}

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}

class CarouselWithIndicator extends StatefulWidget {

  final List<String> imgList;
  final List child;

  const CarouselWithIndicator({Key key, this.imgList, this.child}): super(key: key);

  @override
  _CarouselWithIndicatorState createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.imgList != null && widget.imgList.isNotEmpty) {
      return Column(children: [
      CarouselSlider(
        items: widget.child,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 1.0,
        onPageChanged: (index) {
          setState(() {
            _current = index;
          });
        },
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: map<Widget>(
          widget.imgList,
            (index, url) {
            return Container(
              width: 8.0,
              height: 8.0,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _current == index
                  ? Color.fromRGBO(0, 0, 0, 0.9)
                  : Color.fromRGBO(0, 0, 0, 0.4)),
            );
          },
        ),
      ),
    ]);
    } else {
      return Container();
    }
  }
}


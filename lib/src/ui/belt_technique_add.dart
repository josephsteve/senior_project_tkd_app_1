import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../blocs/belt_techniques_bloc_provider.dart';
import '../blocs/belt_techniques_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;
import 'package:image/image.dart' as Im;

class AddBeltTechnique extends StatelessWidget {

  final String beltId;
  final String beltName;
  final String techniqueID;

  const AddBeltTechnique({Key key, this.beltId, this.beltName, this.techniqueID}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Technique for " + beltName),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: BeltTechniqueAddScreen(beltId: beltId, beltName: beltName, techniqueID: techniqueID,),
    );
  }
}

class BeltTechniqueAddScreen extends StatefulWidget {

  final String beltId;
  final String beltName;
  final String techniqueID;

  const BeltTechniqueAddScreen({Key key, this.beltId, this.beltName, this.techniqueID}): super(key: key);

  @override
  _BeltTechniqueAddScreenState createState() => _BeltTechniqueAddScreenState();
}

class _BeltTechniqueAddScreenState extends State<BeltTechniqueAddScreen> {
  BeltTechniquesBloc _bloc;
  final TextEditingController techniqueNameController = new TextEditingController();
  final TextEditingController difficultyController = new TextEditingController();
  List<String> imgList;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = BeltTechniquesBlocProvider.of(context);
    if (widget.techniqueID != null && widget.techniqueID.isNotEmpty) {
      _bloc.getBeltTechnique(widget.techniqueID).listen((data) {
        if (data != null) {
          BeltTechniqueTemp _beltTechnique = BeltTechniqueTemp.fromMap(data.data);
          print(_beltTechnique.toMap());
          setState(() {
            techniqueNameController.text = _beltTechnique.techniqueName;
            _bloc.setTechniqueName(_beltTechnique.techniqueName);
            difficultyController.text = _beltTechnique.difficulty.toString();
            _bloc.setDifficulty(_beltTechnique.difficulty.toString());
            if (_beltTechnique.images != null) {
              imgList = _beltTechnique.images.cast<String>().toList();
              _bloc.setImages(_beltTechnique.images.cast<String>().toList());
            }
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

  Widget techniqueNameField() {
    return StreamBuilder(
      stream: _bloc.techniqueName,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        return TextField(
          controller: techniqueNameController,
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
          controller: difficultyController,
          onChanged: _bloc.changeDifficulty,
          decoration: InputDecoration(
            hintText: 'Enter Difficulty', errorText: snapshot.error),
        );
      },
    );
  }

  Future<void> getImageFromGallery() async {
    var image = await takeCompressedPicture();  // await ImagePicker.pickImage(source: ImageSource.gallery);
    String imageurl = await _bloc.uploadImage(image);
    setState(() {
      if (imgList == null || imgList.isEmpty) {
        imgList = new List<String>();
      }
      imgList.add(imageurl);
      _bloc.setImages(imgList);
    });
  }

  Future<File> takeCompressedPicture() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image == null) {
      return null;
    }
    final tempDir = await getTemporaryDirectory();
    final String fn = DateTime.now().millisecondsSinceEpoch.toString();
    _CompressObject compressObject = _CompressObject(_image, tempDir.path, fn);
    String filePath = await _compressImage(compressObject);
    File file = File(filePath);

    return file;
  }

  Future<String> _compressImage(_CompressObject object) async {
    return compute(_decodeImage, object);
  }

  static String _decodeImage(_CompressObject object) {
    Im.Image image = Im.decodeImage(object.imageFile.readAsBytesSync());
    Im.Image smallerImage = Im.copyResize(image, 1024);
    final String _imageFileName = "${object.fileName}.jpg";
    var decodedImageFile = File(object.path + _imageFileName);
    decodedImageFile.writeAsBytesSync(Im.encodeJpg(smallerImage, quality: 85));
    return decodedImageFile.path;
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
        (imgList != null && imgList.isNotEmpty) ?
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TechniqueImages(imgList: imgList,),
            ],
          ),
        ) : Container(),
//        Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: Container(
//            child: _image == null ? Container() : Image.file(_image, fit: BoxFit.cover, width: 250.0,),
//          ),
//        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
//          child: ButtonBar(
//            alignment: MainAxisAlignment.center,
//            children: <Widget>[
//              IconButton(icon: Icon(Icons.add_a_photo), onPressed: getImageFromGallery)
//            ],
//          ),
          child: RaisedButton(
            child: Text("Add Photo"),
            onPressed: getImageFromGallery,
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
                  _bloc.submit(widget.beltId, widget.techniqueID);
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

class TechniqueImages extends StatefulWidget {

  final List<String> imgList;

  const TechniqueImages({Key key, this.imgList}): super(key: key);

  @override
  _TechniqueImagesState createState() => _TechniqueImagesState();
}

class _TechniqueImagesState extends State<TechniqueImages> {

  Widget _buildImageItem(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Image.network(widget.imgList[index], width: 90.0, height: 90.0),
//        Text("delete")
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.imgList.length,
      itemBuilder: _buildImageItem,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
    );
  }
}

class _CompressObject {
  File imageFile;
  String path;
  String fileName;

  _CompressObject(this.imageFile, this.path, this.fileName);
}
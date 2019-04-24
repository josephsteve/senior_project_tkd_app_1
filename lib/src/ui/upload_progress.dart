import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UploadProgressWidget extends StatelessWidget {
  final StorageUploadTask task;
  const UploadProgressWidget({Key key, this.task})
    : super(key: key);

  Future<String> get status async {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        String url = await task.lastSnapshot.ref.getDownloadURL();
        result = 'Complete' + task.lastSnapshot.ref.toString();
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
        AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        print('$status:uploading');
        return Dismissible(
          key: Key(task.hashCode.toString()),
          child: new Row(
            children: <Widget>[new CircularProgressIndicator()],
          ),
        );
      },
    );
  }
}
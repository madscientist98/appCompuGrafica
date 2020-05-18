import 'dart:io';

import 'package:flutter/material.dart';
import 'package:grafica/dialogs/dialogThresholding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_core/core.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

import 'package:grafica/algorithms/operExponencial.dart';
import 'package:grafica/algorithms/operLogaritmo.dart';
import 'package:grafica/algorithms/thresholding.dart';
import 'package:grafica/algorithms/operRaiz.dart';
import 'package:grafica/dialogs/dialogRaiz.dart';
import 'package:grafica/dialogs/dialogExp.dart';
import 'package:grafica/dialogs/dialogLog.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File _imageFile;
  List<PointHist> histogram = List(255);

  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    //updateHistogram();

    setState(() {
      _imageFile = selected;
    });
  }

  Future<void> updateImage(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    setState(() {
      _imageFile = File('${directory.path}/$name.jpg');
    });
  }

  updateHistogram() {
    if (_imageFile != null) {
      img.Image ori = img.decodeImage(_imageFile.readAsBytesSync());
      int wi = ori.width;
      int he = ori.height;
      List<int> histoTemp = [];

      for (int x = 0; x < wi; x++) {
        for (int y = 0; y < he; y++) {
          int temp = img.getRed(ori[x * wi + y]);
          if(histogram[temp] == null){
            histogram[temp] = PointHist(temp,0);
          }
          histogram[temp].cant++;
        }
      }
      for (int x = 0; x < histogram.length; x++) {
        if(histogram[x] == null){
            histogram[x] = PointHist(x,0);
          }
        print('${histogram[x].cant}   ${histogram[x].pixel}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Algoritmos de Computacion Grafica'),
        actions: [
          IconButton(
            icon: Icon(Icons.assessment),
            onPressed: () {
              updateHistogram();
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.photo),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              buttonExp(context),
              buttonLog(context),
              buttonRaiz(context),
              buttonThresholding(context),
            ],
          ),
        ),
      ),
      body: ListView(
        children: [
          if (_imageFile != null) ...[
            Image.file(_imageFile),
            //chart(histogram),
          ],
        ],
      ),
    );
  }

  MaterialButton buttonLog(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Logaritmo '),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogLog(context).then(
          (value) {
            operLogaritmo(
              c: value[0].toInt(),
              imageFile: _imageFile,
              name: now,
            );
            updateImage(now);
          },
        );
      },
    );
  }

  MaterialButton buttonExp(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Exponencial'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogExp(context).then(
          (value) {
            operExponencial(
              c: value[0],
              b: value[1],
              imageFile: _imageFile,
              name: now,
            );
            updateImage(now);
          },
        );
      },
    );
  }

  MaterialButton buttonRaiz(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Raiz'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogRaiz(context).then(
          (value) {
            operRaiz(
              c: value[0].toInt(),
              imageFile: _imageFile,
              name: now,
            );
            updateImage(now);
          },
        );
      },
    );
  }

  MaterialButton buttonThresholding(BuildContext context) {
    return MaterialButton(
      elevation: 5,
      child: Text('Thresholding'),
      onPressed: () {
        String now = DateTime.now().toString();
        dialogThre(context).then(
          (value) {
            thresholding(
              umbral: value[0].toInt(),
              imageFile: _imageFile,
              name: now,
            );
            updateImage(now);
          },
        );
      },
    );
  }
}

Widget chart(List<PointHist> data) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    //title: ChartTitle(Text('prueba')),
    legend: Legend(isVisible: true),
    series: <ChartSeries>[
      LineSeries<PointHist, int>(
        dataSource: data,
        xValueMapper: (PointHist dat, _) => dat.pixel,
        yValueMapper: (PointHist dat, _) => dat.cant,
      )
    ],
  );
}

class PointHist {
  int cant;
  int pixel;
  PointHist(this.pixel, this.cant);
}
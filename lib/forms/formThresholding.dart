import 'package:flutter/material.dart';

class FormValidateThre extends StatefulWidget {
  final _formKey;
  final cController;
  final bController;

  FormValidateThre(this._formKey, this.cController, this.bController);
  @override
  _FormValidateStateThre createState() =>
      _FormValidateStateThre(_formKey, cController, bController);
}

class _FormValidateStateThre extends State<FormValidateThre> {
  final _formKey;
  final cController;
  final bController;

  _FormValidateStateThre(this._formKey, this.cController, this.bController);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            TextFormField(
              controller: cController,
              validator: (String value) {
                if (value.isEmpty) {
                  return "Ingrese un valor";
                }
                double temp = double.parse(value);
                if (temp > 255 || temp < 0) {
                  return 'Tiene que ingresar un valor';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Umbral',
                hintText: 'Example 100',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400], width: 2.5),
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.assessment),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFormField(
              controller: bController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Umbral (Opcional)',
                hintText: 'Example 120',
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue[400], width: 2.5),
                    borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.assessment),
                fillColor: Colors.white,
                filled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}

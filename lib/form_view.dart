import 'package:flutter/material.dart';

class FormView extends StatefulWidget {
  const FormView({super.key});

  @override
  State<FormView> createState() => _FormViewState();
}

class _FormViewState extends State<FormView> {
  String myVariable = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text("Navigator.push"),
      ),
      body:
      //ejemplo de textfiel
      Column(
        children: [
          SizedBox(
            width: 250,
            child: TextField(
              // obscureText: true,
              onChanged: (value) {
                setState(() {
                  myVariable = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Texto',
              ),
            ),
          ),
          Text(style: TextStyle(fontSize: 25), "Texto Capturado"),
          Text(myVariable),
        ],
      ),
    );
  }
}

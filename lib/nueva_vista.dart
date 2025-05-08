import 'package:flutter/material.dart';

class NuevaVista extends StatefulWidget {
  const NuevaVista({super.key});

  @override
  State<NuevaVista> createState() => _NuevaVistaState();
}

class _NuevaVistaState extends State<NuevaVista> {
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

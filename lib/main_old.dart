// import 'package:hola_mundo/form_view.dart';
// import 'package:hola_mundo/nueva_vista.dart';
// import 'package:flutter/material.dart';

// //punto de entrada en la aplicacion
// void main() {
//   runApp(const MyApp());
// }

// //StatelessWidget - widget sin estado (no cambia)
// //StatefulWidget  - widget dinamico.

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       //define la estructura de la app
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       // home - define la pantalla inicial
//       home: const MyHomePage(title: 'Hola Mundo  - Flutter'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   String myVariable = "";

//   void _incrementCounter() {
//     setState(() {
//       _counter++;
//     });
//   }
// //
//   // void _decrementCounter() {
//   //   setState(() {
//   //     _counter--;
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,

//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             // seccion #1
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.add),
//                   tooltip: 'Aumentar',
//                   onPressed: _incrementCounter,
//                 ),
//                 Column(
//                   children: [
//                     const Text('Contador:'),
//                     Text(
//                       '$_counter',
//                       style: Theme.of(context).textTheme.headlineMedium,
//                     ),
//                   ],
//                 ),

//                 IconButton(
//                   icon: const Icon(Icons.minimize),
//                   tooltip: 'disminuir',
//                   onPressed: () {
//                     setState(() {
//                       _counter--;
//                     });
//                   },
//                 ),
//               ],
//             ),
//             IconButton(
//               icon: const Icon(Icons.minimize),
//               tooltip: 'disminuir',
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => FormView()),
//                 );
//               },
//             ),

//             //TEXT FIELD
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => NuevaVista()),
//           );
//         },
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

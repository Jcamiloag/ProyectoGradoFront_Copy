import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hola_mundo/models/clase.dart';
import 'package:hola_mundo/models/horario_clase.dart';
import 'package:hola_mundo/services/clase_service.dart';
import 'package:hola_mundo/services/reserva_service.dart';
import 'package:hola_mundo/views/asistencias/asistencia_page.dart';


class AllClassesPage extends StatefulWidget {

  const AllClassesPage({super.key});

  @override
  State<AllClassesPage> createState() => _AllClassesPageState();

}


class _AllClassesPageState extends State<AllClassesPage> {


  final ClaseService claseService = ClaseService();
  final ReservaService reservaService = ReservaService();


  List<Clase> clases = [];

  bool isLoading = true;

  bool isAdmin = false;



  final List<Color> colores = [

    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.cyan,
    Colors.redAccent,

  ];




  @override
  void initState() {

    super.initState();

    cargarUsuarioYClases();

  }




  Future<void> cargarUsuarioYClases() async {


    final prefs = await SharedPreferences.getInstance();

    final role = prefs.getString('role');


    setState(() {

      isAdmin = role == "ADMIN";

    });


    await cargarClases();

  }





  Future<void> cargarClases() async {


    try {


      final data = await claseService.getClases();


      setState(() {

        clases = data;

        isLoading = false;

      });


    } catch(e) {


      print("Error cargando clases: $e");


      setState(() {

        isLoading = false;

      });


    }


  }






  Future<void> seleccionarFecha(
      BuildContext context,
      TextEditingController controller
  ) async {


    final fecha = await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime.now(),

      lastDate: DateTime(2035),

    );



    if(fecha != null){


      controller.text =
          DateFormat("yyyy-MM-dd").format(fecha);


    }


  }






  void mostrarFormularioClase({Clase? clase}) {


    final nombreController =
        TextEditingController(
          text: clase?.nombre ?? ""
        );


    final descripcionController =
        TextEditingController(
          text: clase?.descripcion ?? ""
        );


    final categoriaController =
        TextEditingController(
          text: clase?.categoria ?? ""
        );



    List<TextEditingController> fechaControllers =
        (clase?.horarios ?? [])
            .map(
              (h) => TextEditingController(
                text: h.fecha ?? ""
              )
            )
            .toList();



    List<TextEditingController> horaControllers =
        (clase?.horarios ?? [])
            .map(
              (h) => TextEditingController(
                text: h.hora ?? ""
              )
            )
            .toList();



    List<TextEditingController> cuposControllers =
        (clase?.horarios ?? [])
            .map(
              (h) => TextEditingController(
                text: h.cupos?.toString() ?? ""
              )
            )
            .toList();



    List<int?> horarioIds =
        (clase?.horarios ?? [])
            .map((h)=>h.id)
            .toList();




    if(horaControllers.isEmpty){

      fechaControllers.add(
          TextEditingController()
      );

      horaControllers.add(
          TextEditingController()
      );

      cuposControllers.add(
          TextEditingController()
      );

      horarioIds.add(null);

    }






    showDialog(

      context: context,

      builder: (context){


        return Dialog(

          shape: RoundedRectangleBorder(

            borderRadius:
            BorderRadius.circular(25),

          ),



          child: Padding(

            padding:
            const EdgeInsets.all(20),


            child: StatefulBuilder(

              builder:(context,setStateDialog){


                return SingleChildScrollView(


                  child: Column(

                    mainAxisSize:
                    MainAxisSize.min,


                    children:[



                      Text(

                        clase == null
                            ? "Crear clase"
                            : "Editar clase",

                        style:
                        const TextStyle(

                          fontSize:22,

                          fontWeight:
                          FontWeight.bold,

                        ),

                      ),



                      const SizedBox(height:20),




                      TextField(

                        controller:
                        nombreController,

                        decoration:
                        const InputDecoration(

                          labelText:
                          "Nombre",

                          border:
                          OutlineInputBorder(),

                        ),

                      ),



                      const SizedBox(height:12),




                      TextField(

                        controller:
                        descripcionController,

                        decoration:
                        const InputDecoration(

                          labelText:
                          "Descripción",

                          border:
                          OutlineInputBorder(),

                        ),

                      ),



                      const SizedBox(height:12),




                      TextField(

                        controller:
                        categoriaController,

                        decoration:
                        const InputDecoration(

                          labelText:
                          "Categoría",

                          border:
                          OutlineInputBorder(),

                        ),

                      ),



                      const SizedBox(height:20),



                      const Align(

                        alignment:
                        Alignment.centerLeft,

                        child:
                        Text(

                          "Horarios",

                          style:
                          TextStyle(

                            fontSize:18,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),

                      ),



                      const SizedBox(height:10),



                      ...List.generate(
                        horaControllers.length,
                        (index){

                          return Card(

                            margin:
                            const EdgeInsets.only(
                              bottom:12
                            ),


                            child:
                            Padding(

                              padding:
                              const EdgeInsets.all(12),


                              child:
                              Column(

                                children:[


                                  TextField(

                                    controller:
                                    fechaControllers[index],

                                    readOnly:true,

                                    onTap:(){

                                      seleccionarFecha(
                                        context,
                                        fechaControllers[index]
                                      );

                                    },


                                    decoration:
                                    const InputDecoration(

                                      labelText:
                                      "Fecha (opcional)",

                                      suffixIcon:
                                      Icon(
                                        Icons.calendar_month
                                      ),

                                    ),

                                  ),


                                  const SizedBox(height:10),


                                  TextField(

                                    controller:
                                    horaControllers[index],

                                    decoration:
                                    const InputDecoration(

                                      labelText:
                                      "Hora",

                                    ),

                                  ),


                                  const SizedBox(height:10),


                                  TextField(

                                    controller:
                                    cuposControllers[index],

                                    keyboardType:
                                    TextInputType.number,


                                    decoration:
                                    const InputDecoration(

                                      labelText:
                                      "Cupos",

                                    ),

                                  ),


                                  Align(

                                    alignment:
                                    Alignment.centerRight,

                                    child:
                                    IconButton(

                                      icon:
                                      const Icon(
                                        Icons.delete,
                                        color:Colors.red
                                      ),

                                      onPressed:(){

                                        setStateDialog((){

                                          fechaControllers.removeAt(index);

                                          horaControllers.removeAt(index);

                                          cuposControllers.removeAt(index);

                                          horarioIds.removeAt(index);

                                        });

                                      },

                                    ),

                                  )


                                ],

                              ),

                            ),

                          );


                        }

                      ),
                                            const SizedBox(height:10),


                      TextButton.icon(

                        onPressed:(){

                          setStateDialog((){


                            fechaControllers.add(
                                TextEditingController()
                            );


                            horaControllers.add(
                                TextEditingController()
                            );


                            cuposControllers.add(
                                TextEditingController()
                            );


                            horarioIds.add(null);


                          });


                        },


                        icon:
                        const Icon(Icons.add_circle),


                        label:
                        const Text(
                          "Agregar horario"
                        ),


                      ),



                      const SizedBox(height:20),



                      Row(

                        mainAxisAlignment:
                        MainAxisAlignment.end,


                        children:[



                          TextButton(

                            onPressed:(){

                              Navigator.pop(context);

                            },


                            child:
                            const Text(
                              "Cancelar"
                            ),

                          ),



                          const SizedBox(width:10),



                          ElevatedButton(

                            style:
                            ElevatedButton.styleFrom(

                              backgroundColor:
                              Colors.redAccent,

                              shape:
                              RoundedRectangleBorder(

                                borderRadius:
                                BorderRadius.circular(15),

                              ),

                            ),


                            onPressed:() async {



                              final nuevaClase = Clase(

                                id:
                                clase?.id,


                                nombre:
                                nombreController.text.trim(),


                                descripcion:
                                descripcionController.text.trim(),


                                categoria:
                                categoriaController.text.trim(),


                                activa:
                                true,


                                horarios:
                                [],

                              );




                              try {



                                Clase claseGuardada;



                                if(clase == null){


                                  claseGuardada =
                                  await claseService.addClase(
                                      nuevaClase
                                  );


                                }else{


                                  await claseService.updateClase(
                                      nuevaClase
                                  );


                                  claseGuardada =
                                      nuevaClase;


                                }




                                for(int i = 0;
                                i < horaControllers.length;
                                i++){



                                  if(
                                  horaControllers[i]
                                      .text
                                      .trim()
                                      .isEmpty
                                  ){

                                    continue;

                                  }




                                  final horario = HorarioClase(


                                    id:
                                    horarioIds[i],


                                    fecha:
                                    fechaControllers[i]
                                        .text
                                        .trim()
                                        .isEmpty
                                        ? null
                                        : fechaControllers[i]
                                        .text
                                        .trim(),



                                    hora:
                                    horaControllers[i]
                                        .text
                                        .trim(),



                                    cupos:
                                    int.tryParse(
                                        cuposControllers[i]
                                            .text
                                            .trim()
                                    ),


                                  );






                                  if(horario.id != null){


                                    await claseService.actualizarHorario(
                                        horario
                                    );


                                  }else{


                                    await claseService.agregarHorario(
                                      claseGuardada.id!,
                                      horario,
                                    );


                                  }


                                }





                                await cargarClases();



                                Navigator.pop(context);



                              }catch(e){


                                ScaffoldMessenger.of(context)
                                    .showSnackBar(

                                  SnackBar(

                                    content:
                                    Text(
                                      "Error: $e"
                                    ),

                                  ),

                                );


                              }



                            },


                            child:
                            const Text(
                              "Guardar"
                            ),


                          )


                        ],


                      )


                    ],


                  ),


                );


              },


            ),


          ),


        );


      },


    );


  }







  Future<void> eliminarClase(int id) async {


    try{


      await claseService.deleteClase(id);


      await cargarClases();


    }catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
              "Error al eliminar: $e"
          ),

        ),

      );


    }


  }







  Future<void> reservarClase(
      HorarioClase horario
      ) async {



    final prefs =
    await SharedPreferences.getInstance();



    final userId =
    prefs.getInt("userId");



    if(userId == null){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Usuario no encontrado"
          ),

        ),

      );


      return;


    }




    try{


      await reservaService.crearReserva(

        userId,

        horario.id!,

      );



      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
            "Reserva realizada correctamente"
          ),

        ),

      );



      await cargarClases();



    }catch(e){


      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
          Text(
              e.toString()
          ),

        ),

      );


    }


  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      Colors.white,


      appBar: AppBar(

        backgroundColor:
        Colors.white,

        elevation:
        0,

        centerTitle:
        true,


        title:
        const Text(

          "Todas las clases",

          style:
          TextStyle(

            color:
            Colors.black87,

            fontWeight:
            FontWeight.bold,

            fontSize:
            20,

          ),

        ),


        iconTheme:
        const IconThemeData(

          color:
          Colors.black87,

        ),

      ),



      body:

      isLoading

          ?

      const Center(

        child:
        CircularProgressIndicator(),

      )


          :

      ListView.builder(


        padding:
        const EdgeInsets.all(20),


        itemCount:
        clases.length,


        itemBuilder:
            (context,index){



          final clase =
          clases[index];


          final color =
          colores[index % colores.length];


          final horarios =
          clase.horarios ?? [];



          return Container(


            margin:
            const EdgeInsets.only(
                bottom:20
            ),



            decoration:
            BoxDecoration(


              color:
              color.withOpacity(0.08),


              borderRadius:
              BorderRadius.circular(25),



              border:
              Border.all(

                color:
                color.withOpacity(0.25),

              ),


            ),



            child:
            Padding(

              padding:
              const EdgeInsets.all(20),


              child:
              Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,


                children:[



                  Row(

                    children:[



                      CircleAvatar(

                        radius:
                        28,

                        backgroundColor:
                        color,


                        child:
                        const Icon(

                          Icons
                              .fitness_center,

                          color:
                          Colors.white,

                        ),

                      ),




                      const SizedBox(
                          width:15
                      ),




                      Expanded(

                        child:
                        Text(

                          clase.nombre,

                          style:
                          const TextStyle(

                            fontSize:
                            19,

                            fontWeight:
                            FontWeight.bold,

                          ),

                        ),

                      ),





                      if(isAdmin)...[


                        IconButton(

                          icon:
                          const Icon(
                              Icons.edit
                          ),


                          onPressed:(){

                            mostrarFormularioClase(
                                clase: clase
                            );

                          },


                        ),



                        IconButton(

                          icon:
                          const Icon(
                            Icons.delete,
                            color:Colors.red,
                          ),


                          onPressed:() async {



                            final confirmar =
                            await showDialog<bool>(

                              context:
                              context,


                              builder:
                                  (context){


                                return AlertDialog(

                                  title:
                                  const Text(
                                      "Eliminar clase"
                                  ),


                                  content:
                                  const Text(
                                      "¿Deseas eliminar esta clase?"
                                  ),


                                  actions:[


                                    TextButton(

                                      onPressed:(){

                                        Navigator.pop(
                                            context,
                                            false
                                        );

                                      },


                                      child:
                                      const Text(
                                          "Cancelar"
                                      ),

                                    ),



                                    TextButton(

                                      onPressed:(){

                                        Navigator.pop(
                                            context,
                                            true
                                        );

                                      },


                                      child:
                                      const Text(
                                          "Eliminar"
                                      ),

                                    )


                                  ],

                                );


                              },


                            );



                            if(confirmar == true){

                              eliminarClase(
                                  clase.id!
                              );

                            }



                          },


                        )


                      ]


                    ],


                  ),





                  const SizedBox(
                      height:20
                  ),






                  if(horarios.isEmpty)

                    const Text(
                      "Sin horarios disponibles"
                    )


                  else


                    Wrap(

                      spacing:
                      12,


                      runSpacing:
                      12,



                      children:
                      horarios.map((h){



                        final sinCupos =
                            h.cuposDisponibles != null &&
                                h.cuposDisponibles == 0;




                        return GestureDetector(


                          onTap:

                          sinCupos

                              ?

                          null

                              :

                              (){


                            if(!isAdmin){

                              reservarClase(h);

                            }


                          },



                          child:
                          Container(


                            width:
                            150,


                            padding:
                            const EdgeInsets.all(14),



                            decoration:
                            BoxDecoration(


                              color:

                              sinCupos

                                  ?

                              Colors.grey.shade300

                                  :

                              Colors.white,



                              borderRadius:
                              BorderRadius.circular(18),



                              boxShadow:[


                                BoxShadow(

                                  blurRadius:
                                  5,

                                  color:
                                  Colors.black.withOpacity(
                                      0.08
                                  ),

                                )

                              ],


                            ),



                            child:
                            Column(

                              crossAxisAlignment:
                              CrossAxisAlignment.start,


                              children:[



                                Row(

                                  children:[

                                    const Icon(

                                      Icons.access_time,

                                      size:
                                      18,

                                      color:
                                      Colors.redAccent,

                                    ),


                                    const SizedBox(
                                        width:5
                                    ),


                                    Text(

                                      h.hora ??
                                          "Sin hora",

                                      style:
                                      const TextStyle(

                                        fontWeight:
                                        FontWeight.bold,

                                      ),

                                    ),

                                  ],


                                ),





                                if(h.fecha != null &&
                                    h.fecha!.isNotEmpty)

                                  Padding(

                                    padding:
                                    const EdgeInsets.only(
                                        top:8
                                    ),

                                    child:
                                    Row(

                                      children:[


                                        const Icon(

                                          Icons.calendar_month,

                                          size:
                                          16,

                                        ),



                                        const SizedBox(
                                            width:5
                                        ),



                                        Text(

                                          h.fecha!,

                                          style:
                                          const TextStyle(

                                            fontSize:
                                            12,

                                          ),

                                        )


                                      ],


                                    ),

                                  ),






                                const SizedBox(
                                    height:8
                                ),




                                if (h.cupos != null)
  Row(
                                                children: [
                                                  const Icon(
                                                    Icons.people,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    sinCupos
                                                        ? "Sin cupos"
                                                        : "${h.cuposDisponibles ?? 0}/${h.cupos}",
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            if (isAdmin) ...[
                                              const SizedBox(height: 12),

                                              SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton.icon(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                        backgroundColor:
                                                            Colors.indigo,
                                                      ),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder:
                                                            (_) =>
                                                                AsistenciaPage(
                                                                  horarioId:
                                                                      h.id!,
                                                                ),
                                                      ),
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.people,
                                                    color: Colors.white,
                                                  ),
                                                  label: const Text(
                                                    "Ver inscritos",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],



                              ],


                            ),


                          ),


                        );


                      }).toList(),


                    )




                ],


              ),


            ),


          );


        },


      ),




      floatingActionButton:

      isAdmin

          ?

      FloatingActionButton(

        backgroundColor:
        Colors.redAccent,


        onPressed:(){

          mostrarFormularioClase();

        },


        child:
        const Icon(
            Icons.add
        ),


      )


          :

      null,


    );


  }

}
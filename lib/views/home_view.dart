import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hola_mundo/views/base_view.dart';
import 'package:hola_mundo/views/clases/all_classes_page.dart';

import 'package:hola_mundo/services/plan_service.dart';
import 'package:hola_mundo/services/reserva_service.dart';

import 'package:hola_mundo/models/plan.dart';
import 'package:hola_mundo/models/reserva.dart';



class HomeView extends StatefulWidget {

  const HomeView({
    super.key,
  });


  @override
  State<HomeView> createState() => _HomeViewState();

}




class _HomeViewState extends State<HomeView> {



  String username = "Usuario";


  List<Plan> planes = [];


  List<Reserva> reservas = [];


  bool cargando = true;



  final PlanService planService =
      PlanService();



  final ReservaService reservaService =
      ReservaService();





  @override
  void initState() {

    super.initState();

    cargarDatos();

  }







  Future<void> cargarDatos() async {


    setState(() {

      cargando = true;

    });



    final prefs =
        await SharedPreferences.getInstance();



    final userId =
        prefs.getInt("userId");



    username =
        prefs.getString("username") ?? "Usuario";



    if(userId != null){


      planes =
          await planService.obtenerPlanesUsuario(
            userId,
          );



      reservas =
          await reservaService.obtenerReservasUsuario(
            userId,
          );


    }



    if(mounted){


      setState(() {

        cargando = false;

      });


    }


  }








  int obtenerClasesRestantes(){


    int total = 0;



    for(final plan in planes){


      if(plan.estado == "ACTIVO"){


        total += plan.clasesRestantes;


      }


    }


    return total;


  }








  Future<void> cancelarReserva(
      int id
      ) async {



    await reservaService.cancelarReserva(
      id,
    );



    await cargarDatos();



  }








  Future<void> irAClases() async {


    await Navigator.push(


      context,


      MaterialPageRoute(


        builder:(context)=>


        const AllClassesPage(),


      ),


    );



    await cargarDatos();


  }









  @override
  Widget build(BuildContext context) {


    return BaseView(


      title:
      "ACADEMIA FARFALA",


      initialIndex:1,


      length:2,



      body:


      cargando


          ? const Center(

        child:CircularProgressIndicator(),

      )



          : RefreshIndicator(


        onRefresh:
        cargarDatos,



        child:SingleChildScrollView(


          physics:
          const AlwaysScrollableScrollPhysics(),



          padding:
          const EdgeInsets.all(20),



          child:Column(


            crossAxisAlignment:
            CrossAxisAlignment.start,



            children:[



              // ===========================
              // HEADER
              // ===========================



              Container(


                width:
                double.infinity,



                padding:
                const EdgeInsets.all(25),



                decoration:
                BoxDecoration(


                  color:
                  Colors.white,



                  borderRadius:
                  BorderRadius.circular(28),



                  boxShadow:[


                    BoxShadow(

                      color:
                      Colors.black.withOpacity(.07),

                      blurRadius:
                      15,

                    )


                  ],


                ),



                child:Row(


                  children:[



                    Container(


                      width:
                      80,


                      height:
                      80,



                      decoration:
                      BoxDecoration(


                        color:
                        Colors.red,


                        borderRadius:
                        BorderRadius.circular(24),


                      ),



                      child:
                      const Icon(

                        Icons.person,

                        color:
                        Colors.white,

                        size:
                        42,

                      ),



                    ),



                    const SizedBox(width:18),



                    Expanded(


                      child:Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,



                        children:[


                          const Text(

                            "Bienvenido",

                            style:
                            TextStyle(

                              color:
                              Colors.grey,

                              fontSize:
                              15,

                            ),

                          ),



                          const SizedBox(height:5),



                          Text(

                            username,


                            style:
                            const TextStyle(

                              fontSize:
                              26,

                              fontWeight:
                              FontWeight.bold,

                            ),


                          ),



                          const SizedBox(height:10),



                          const Text(

                            "Es un excelente día para entrenar 💪",

                          ),


                        ],


                      ),


                    ),



                  ],


                ),



              ),



              const SizedBox(height:35),



              // ===========================
              // PROGRESO
              // ===========================



              const Text(

                "Tu progreso",

                style:
                TextStyle(

                  fontSize:
                  22,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(height:15),



              Row(


                children:[


                  Expanded(


                    child:StatCard(

                      icon:
                      Icons.school,

                      title:
                      "Clases restantes",

                      value:
                      obtenerClasesRestantes()
                          .toString(),

                      color:
                      Colors.red,

                    ),


                  ),



                  const SizedBox(width:15),



                  Expanded(


                    child:StatCard(

                      icon:
                      Icons.calendar_month,

                      title:
                      "Reservas",

                      value:
                      reservas
                          .where((r)=>
                      r.estado=="ACTIVA")
                          .length
                          .toString(),

                      color:
                      Colors.deepPurple,

                    ),


                  ),



                ],


              ),



              const SizedBox(height:35),
              // ===========================
              // MIS PLANES
              // ===========================


              const Text(

                "Mis Planes",

                style:
                TextStyle(

                  fontSize:
                  22,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(height:15),




              if(planes.isEmpty)


                const Text(

                  "No tienes planes asignados",

                )



              else


                Column(


                  children:


                  planes.map((plan){



                    return Container(


                      margin:
                      const EdgeInsets.only(bottom:15),



                      padding:
                      const EdgeInsets.all(20),



                      decoration:
                      BoxDecoration(


                        color:
                        Colors.white,



                        borderRadius:
                        BorderRadius.circular(25),



                        boxShadow:[


                          BoxShadow(

                            color:
                            Colors.black.withOpacity(.06),

                            blurRadius:
                            12,

                          )


                        ],


                      ),



                      child:Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,



                        children:[



                          Row(


                            children:[



                              const Icon(

                                Icons.workspace_premium,

                                color:
                                Colors.red,

                                size:
                                32,

                              ),



                              const SizedBox(width:12),



                              Expanded(


                                child:Text(


                                  plan.planCatalogo?.nombre ??
                                      "Plan",

                                  style:
                                  const TextStyle(

                                    fontSize:
                                    20,

                                    fontWeight:
                                    FontWeight.bold,

                                  ),


                                ),


                              ),



                            ],


                          ),




                          const SizedBox(height:18),




                          Text(

                            "Categoría: ${plan.planCatalogo?.categoria ?? ""}",


                          ),



                          const SizedBox(height:8),



                          Text(

                            "Clases totales: ${plan.cantidadClases}",

                          ),



                          const SizedBox(height:8),



                          Text(

                            "Clases restantes: ${plan.clasesRestantes}",

                            style:
                            const TextStyle(

                              fontWeight:
                              FontWeight.bold,

                              color:
                              Colors.red,

                            ),


                          ),



                          const SizedBox(height:8),



                          Text(

                            "Valor: \$${plan.valor}",

                          ),



                          const SizedBox(height:8),



                          Text(

                            "Estado: ${plan.estado}",

                          ),



                        ],


                      ),


                    );



                  }).toList(),


                ),






              const SizedBox(height:35),






              // ===========================
              // MIS RESERVAS
              // ===========================



              const Text(

                "Mis Reservas",

                style:
                TextStyle(

                  fontSize:
                  22,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),




              const SizedBox(height:15),





              if(reservas.isEmpty)


                const Text(

                  "No tienes reservas",

                )



              else



                Column(


                  children:


                  reservas.map((reserva){



                    if(reserva.estado != "ACTIVA"){


                      return const SizedBox();


                    }



                    return Container(


                      margin:
                      const EdgeInsets.only(bottom:15),



                      padding:
                      const EdgeInsets.all(18),



                      decoration:
                      BoxDecoration(


                        color:
                        Colors.white,



                        borderRadius:
                        BorderRadius.circular(22),



                        boxShadow:[


                          BoxShadow(

                            color:
                            Colors.black.withOpacity(.06),

                            blurRadius:
                            12,

                          )


                        ],


                      ),



                      child:Column(


                        crossAxisAlignment:
                        CrossAxisAlignment.start,



                        children:[



                          Row(


                            children:[



                              const Icon(

                                Icons.calendar_month,

                                color:
                                Colors.red,

                              ),



                              const SizedBox(width:10),



                              Expanded(


                                child:Text(


                                  "Reserva realizada",

                                  style:
                                  const TextStyle(

                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize:
                                    18,

                                  ),


                                ),


                              ),



                            ],


                          ),




                          const SizedBox(height:15),





                                      Text("Clase: ${reserva.nombreClase}"),

                                      const SizedBox(height: 8),

                                      Text("Categoría: ${reserva.categoria}"),

                                      const SizedBox(height: 8),

                                      Text("Hora: ${reserva.hora}"),

                                      const SizedBox(height: 8),

                                      Text("Fecha: ${reserva.fecha ?? ""}"),

                           




                          const SizedBox(height:15),




                          SizedBox(


                            width:
                            double.infinity,



                            child:ElevatedButton(


                              style:
                              ElevatedButton.styleFrom(


                                backgroundColor:
                                Colors.red,


                              ),



                              onPressed:(){


                                cancelarReserva(

                                  reserva.id,

                                );


                              },



                              child:
                              const Text(

                                "Cancelar reserva",

                                style:
                                TextStyle(

                                  color:
                                  Colors.white,

                                ),

                              ),



                            ),


                          )




                        ],


                      ),



                    );



                  }).toList(),


                ),






              const SizedBox(height:35),






              // ===========================
              // BOTON CLASES
              // ===========================



              SizedBox(


                width:
                double.infinity,



                height:
                55,



                child:ElevatedButton.icon(


                  style:
                  ElevatedButton.styleFrom(


                    backgroundColor:
                    Colors.red,



                    shape:
                    RoundedRectangleBorder(


                      borderRadius:
                      BorderRadius.circular(18),


                    ),


                  ),



                  icon:
                  const Icon(

                    Icons.school,

                    color:
                    Colors.white,

                  ),



                  label:
                  const Text(

                    "Ver clases disponibles",

                    style:
                    TextStyle(

                      color:
                      Colors.white,

                      fontSize:
                      16,

                    ),

                  ),



                  onPressed:
                  irAClases,



                ),


              ),



              const SizedBox(height:35),
                            // ===========================
              // DISCIPLINAS
              // ===========================


              const Text(

                "Disciplinas",

                style:
                TextStyle(

                  fontSize:
                  22,

                  fontWeight:
                  FontWeight.bold,

                ),

              ),



              const SizedBox(height:18),



              GridView.count(

                shrinkWrap:true,

                physics:
                const NeverScrollableScrollPhysics(),


                crossAxisCount:2,


                crossAxisSpacing:15,


                mainAxisSpacing:15,



                children: const [



                  CategoryCard(

                    icon:
                    Icons.sports_gymnastics,

                    title:
                    "Pole Dance",

                    subtitle:
                    "Arte y expresión",

                    color:
                    Colors.red,

                  ),



                  CategoryCard(

                    icon:
                    Icons.fitness_center,

                    title:
                    "Pole Sport",

                    subtitle:
                    "Fuerza y técnica",

                    color:
                    Colors.purple,

                  ),



                  CategoryCard(

                    icon:
                    Icons.music_note,

                    title:
                    "Twerk",

                    subtitle:
                    "Ritmo y energía",

                    color:
                    Colors.orange,

                  ),



                  CategoryCard(

                    icon:
                    Icons.emoji_people,

                    title:
                    "Baile en silla",

                    subtitle:
                    "Elegancia y control",

                    color:
                    Colors.teal,

                  ),



                ],


              ),





              const SizedBox(height:35),





              Container(


                width:
                double.infinity,


                padding:
                const EdgeInsets.all(22),



                decoration:
                BoxDecoration(


                  gradient:
                  const LinearGradient(


                    colors:[


                      Color(0xff212121),


                      Color(0xff424242),


                    ],


                  ),



                  borderRadius:
                  BorderRadius.circular(25),


                ),



                child:const Column(


                  crossAxisAlignment:
                  CrossAxisAlignment.start,



                  children:[



                    Text(

                      "Academia Farfala",

                      style:
                      TextStyle(

                        color:
                        Colors.white,

                        fontSize:
                        22,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                    SizedBox(height:10),



                    Text(

                      "Donde el movimiento se convierte en arte",

                      style:
                      TextStyle(

                        color:
                        Colors.white70,

                      ),

                    ),



                  ],


                ),


              ),



              const SizedBox(height:30),



            ],


          ),


        ),


      ),


    );


  }


}






// ===================================
// WIDGET TARJETA ESTADISTICA
// ===================================



class StatCard extends StatelessWidget {


  final IconData icon;

  final String title;

  final String value;

  final Color color;




  const StatCard({

    super.key,

    required this.icon,

    required this.title,

    required this.value,

    required this.color,

  });





  @override
  Widget build(BuildContext context) {


    return Container(


      padding:
      const EdgeInsets.all(18),



      decoration:
      BoxDecoration(


        color:
        Colors.white,



        borderRadius:
        BorderRadius.circular(22),



        boxShadow:[


          BoxShadow(

            color:
            Colors.black.withOpacity(.06),

            blurRadius:
            12,

          )


        ],


      ),



      child:Column(


        children:[



          Icon(

            icon,

            color:
            color,

            size:
            32,

          ),



          const SizedBox(height:10),



          Text(

            value,

            style:
            const TextStyle(

              fontSize:
              22,

              fontWeight:
              FontWeight.bold,

            ),

          ),



          Text(

            title,

            style:
            const TextStyle(

              color:
              Colors.grey,

            ),

          ),



        ],


      ),


    );


  }


}








// ===================================
// WIDGET CATEGORIA
// ===================================



class CategoryCard extends StatelessWidget {


  final IconData icon;

  final String title;

  final String subtitle;

  final Color color;




  const CategoryCard({

    super.key,

    required this.icon,

    required this.title,

    required this.subtitle,

    required this.color,

  });






  @override
  Widget build(BuildContext context) {


    return Container(


      padding:
      const EdgeInsets.all(15),



      decoration:
      BoxDecoration(


        color:
        Colors.white,



        borderRadius:
        BorderRadius.circular(22),



        boxShadow:[


          BoxShadow(

            color:
            Colors.black.withOpacity(.05),

            blurRadius:
            10,

          )


        ],


      ),



      child:Column(


        mainAxisAlignment:
        MainAxisAlignment.center,



        children:[



          Icon(

            icon,

            color:
            color,

            size:
            35,

          ),



          const SizedBox(height:10),



          Text(

            title,

            textAlign:
            TextAlign.center,


            style:
            const TextStyle(

              fontWeight:
              FontWeight.bold,

              fontSize:
              15,

            ),


          ),



          const SizedBox(height:5),



          Text(

            subtitle,

            textAlign:
            TextAlign.center,


            style:
            const TextStyle(

              color:
              Colors.grey,

              fontSize:
              12,

            ),


          ),



        ],


      ),


    );


  }


}
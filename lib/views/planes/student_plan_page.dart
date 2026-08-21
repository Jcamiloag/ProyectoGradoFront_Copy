import 'package:flutter/material.dart';

import 'package:hola_mundo/models/user.dart';
import 'package:hola_mundo/models/plan.dart';

import 'package:hola_mundo/services/plan_service.dart';



class StudentPlanPage extends StatefulWidget {


  final User usuario;



  const StudentPlanPage({

    super.key,

    required this.usuario,

  });



  @override
  State<StudentPlanPage> createState() =>
      _StudentPlanPageState();

}






class _StudentPlanPageState extends State<StudentPlanPage> {



  final PlanService _planService =
  PlanService();



  List<Plan> planes = [];



  bool loading = true;





  @override
  void initState() {

    super.initState();

    cargarPlanes();

  }







  Future<void> cargarPlanes() async {


    try {



      final data =

      await _planService.obtenerPlanesUsuario(

        widget.usuario.id,

      );



      if(!mounted) return;



      setState(() {


        planes = data;


        loading = false;


      });



    }catch(e){



      debugPrint(
        "ERROR CARGANDO PLANES: $e",
      );



      if(!mounted) return;



      setState(() {


        loading = false;


      });



      ScaffoldMessenger.of(context)
          .showSnackBar(



        const SnackBar(

          content:

          Text(

            "Error cargando planes",

          ),

        ),


      );



    }


  }









  // ==========================================
  // MOSTRAR CATALOGO Y ASIGNAR PLAN
  // ==========================================


  Future<void> mostrarCatalogo() async {


    try {



      final catalogo =

      await _planService.obtenerPlanesCatalogo();



      if(!mounted) return;





      showModalBottomSheet(



        context: context,



        isScrollControlled: true,



        backgroundColor:

        Colors.white,



        shape:

        const RoundedRectangleBorder(



          borderRadius:

          BorderRadius.vertical(

            top:

            Radius.circular(25),

          ),



        ),




        builder:(modalContext){



          return SizedBox(



            height:

            MediaQuery.of(context)
                .size
                .height * 0.65,



            child:


            Padding(



              padding:

              const EdgeInsets.all(20),




              child:


              Column(



                children:[





                  const Text(



                    "Seleccionar plan",



                    style:

                    TextStyle(



                      fontSize:

                      22,



                      fontWeight:

                      FontWeight.bold,



                    ),



                  ),






                  const SizedBox(

                    height:

                    20,

                  ),






                  Expanded(



                    child:


                    ListView.builder(



                      itemCount:

                      catalogo.length,




                      itemBuilder:(context,index){



                        final plan =

                        catalogo[index];






                        return Card(




                          shape:

                          RoundedRectangleBorder(



                            borderRadius:

                            BorderRadius.circular(18),



                          ),





                          child:


                          ListTile(




                            title:

                            Text(



                              plan.nombre,



                              style:

                              const TextStyle(



                                fontWeight:

                                FontWeight.bold,



                              ),



                            ),






                            subtitle:


                            Text(



                              "${plan.cantidadClases} clases - \$${plan.valor}",



                            ),







                            trailing:


                            ElevatedButton(



                              style:

                              ElevatedButton.styleFrom(



                                backgroundColor:

                                Colors.redAccent,



                                foregroundColor:

                                Colors.white,



                              ),




                              child:

                              const Text(

                                "Asignar",

                              ),





                              onPressed:() async {




                                final resultado =

                                await _planService.asignarPlan(



                                  widget.usuario.id,



                                  plan.id,



                                );





                                if(!mounted) return;






                                if(resultado){



                                  Navigator.pop(
                                    modalContext,
                                  );





                                  await cargarPlanes();





                                  if(!mounted) return;





                                  ScaffoldMessenger
                                  .of(context)
                                      .showSnackBar(



                                    const SnackBar(



                                      content:

                                      Text(



                                        "Plan asignado correctamente",



                                      ),



                                    ),



                                  );



                                }else{



                                  ScaffoldMessenger
                                  .of(context)
                                      .showSnackBar(



                                    const SnackBar(



                                      content:

                                      Text(



                                        "Error asignando plan",



                                      ),



                                    ),



                                  );



                                }




                              },



                            ),





                          ),




                        );



                      },



                    ),



                  ),




                ],



              ),




            ),



          );



        },



      );





    }catch(e){



      debugPrint(

        "ERROR CATALOGO: $e",

      );



      ScaffoldMessenger.of(context)
          .showSnackBar(



        const SnackBar(



          content:

          Text(

            "Error cargando catálogo",

          ),



        ),



      );



    }


  }
    // ==========================================
  // CAMBIAR ESTADO DEL PLAN
  // ==========================================


  Future<void> editarEstadoPlan(

      Plan plan

      ) async {



    String estado = plan.estado;




    final guardar =

    await showDialog<bool>(



      context: context,



      builder:(context){



        return AlertDialog(



          shape:

          RoundedRectangleBorder(



            borderRadius:

            BorderRadius.circular(20),



          ),





          title:

          const Text(



            "Cambiar estado",



            style:

            TextStyle(

              fontWeight:

              FontWeight.bold,

            ),



          ),





          content:



          DropdownButtonFormField<String>(



            value:

            estado,



            decoration:

            InputDecoration(



              border:

              OutlineInputBorder(



                borderRadius:

                BorderRadius.circular(15),



              ),



            ),





            items:

            const [



              DropdownMenuItem(

                value:

                "ACTIVO",

                child:

                Text(

                  "ACTIVO",

                ),

              ),





              DropdownMenuItem(

                value:

                "FINALIZADO",

                child:

                Text(

                  "FINALIZADO",

                ),

              ),





              DropdownMenuItem(

                value:

                "VENCIDO",

                child:

                Text(

                  "VENCIDO",

                ),

              ),



            ],




            onChanged:(value){


              estado = value!;


            },



          ),






          actions:[





            TextButton(



              onPressed:(){


                Navigator.pop(

                  context,

                  false,

                );


              },



              child:

              const Text(

                "Cancelar",

              ),



            ),





            FilledButton(



              onPressed:(){


                Navigator.pop(

                  context,

                  true,

                );


              },



              child:

              const Text(

                "Guardar",

              ),



            ),





          ],




        );



      },



    );






    if(guardar == true){



      final resultado =

      await _planService.actualizarEstadoPlan(



        plan.id,



        estado,



      );






      if(resultado){



        await cargarPlanes();





        if(!mounted) return;



        ScaffoldMessenger.of(context)
            .showSnackBar(



          const SnackBar(



            content:

            Text(

              "Estado actualizado",

            ),



          ),



        );



      }



    }



  }









  // ==========================================
  // ELIMINAR PLAN
  // ==========================================


  Future<void> eliminarPlan(

      Plan plan

      ) async {



    final confirmar =

    await showDialog<bool>(



      context: context,



      builder:(context)=>AlertDialog(




        shape:

        RoundedRectangleBorder(



          borderRadius:

          BorderRadius.circular(20),



        ),





        title:

        const Text(



          "Eliminar plan",



          style:

          TextStyle(

            fontWeight:

            FontWeight.bold,

          ),



        ),






        content:



        Text(



          "¿Deseas eliminar ${plan.planCatalogo?.nombre ?? "este plan"}?",



        ),







        actions:[





          TextButton(



            onPressed:(){


              Navigator.pop(

                context,

                false,

              );


            },



            child:

            const Text(

              "Cancelar",

            ),



          ),





          FilledButton(



            style:

            FilledButton.styleFrom(



              backgroundColor:

              Colors.red,



            ),



            onPressed:(){



              Navigator.pop(

                context,

                true,

              );



            },



            child:

            const Text(

              "Eliminar",

            ),



          ),





        ],





      ),



    );






    if(confirmar == true){



      final eliminado =

      await _planService.eliminarPlanAsignado(



        plan.id,



      );






      if(eliminado){



        await cargarPlanes();





        if(!mounted) return;




        ScaffoldMessenger.of(context)
            .showSnackBar(



          const SnackBar(



            content:

            Text(

              "Plan eliminado correctamente",

            ),



          ),



        );



      }



    }



  }









  Color estadoColor(String estado){



    switch(estado){



      case "ACTIVO":

        return Colors.green;



      case "FINALIZADO":

        return Colors.red;



      case "VENCIDO":

        return Colors.orange;



      default:

        return Colors.grey;



    }



  }
    @override
  Widget build(BuildContext context) {


    return Scaffold(



      backgroundColor:

      Colors.grey[100],





      appBar:

      AppBar(



        title:

        Text(

          "Planes - ${widget.usuario.name}",

        ),



        backgroundColor:

        Colors.redAccent,



        foregroundColor:

        Colors.white,



      ),





      body:



      loading



          ?



      const Center(



        child:

        CircularProgressIndicator(),



      )



          :



      Padding(



        padding:

        const EdgeInsets.all(16),





        child:

        Column(



          children:[





            // ==========================
            // INFORMACION ESTUDIANTE
            // ==========================


            Container(



              width:

              double.infinity,



              padding:

              const EdgeInsets.all(18),




              decoration:

              BoxDecoration(



                color:

                Colors.white,



                borderRadius:

                BorderRadius.circular(25),




                boxShadow:[



                  BoxShadow(



                    color:

                    Colors.black.withOpacity(.08),



                    blurRadius:

                    10,



                    offset:

                    const Offset(0,4),



                  )



                ],



              ),





              child:



              Row(



                children:[



                  CircleAvatar(



                    radius:

                    30,



                    backgroundColor:

                    Colors.redAccent
                        .withOpacity(.15),




                    child:

                    Text(



                      widget.usuario.firstname[0]
                          .toUpperCase(),



                      style:

                      const TextStyle(



                        fontSize:

                        24,



                        fontWeight:

                        FontWeight.bold,



                        color:

                        Colors.redAccent,



                      ),



                    ),



                  ),






                  const SizedBox(

                    width:

                    15,

                  ),





                  Column(



                    crossAxisAlignment:

                    CrossAxisAlignment.start,



                    children:[



                      Text(



                        widget.usuario.name,



                        style:

                        const TextStyle(



                          fontSize:

                          20,



                          fontWeight:

                          FontWeight.bold,



                        ),



                      ),




                      const SizedBox(

                        height:

                        5,

                      ),




                      Text(



                        "${planes.length} plan(es) asignado(s)",



                        style:

                        const TextStyle(



                          color:

                          Colors.grey,



                        ),



                      ),



                    ],



                  ),



                ],



              ),



            ),






            const SizedBox(

              height:

              15,

            ),






            // ==========================
            // BOTON ASIGNAR ARRIBA
            // ==========================


            SizedBox(



              width:

              double.infinity,



              child:

              ElevatedButton.icon(



                icon:

                const Icon(

                  Icons.add,

                ),





                label:

                const Text(

                  "Asignar nuevo plan",

                  style:

                  TextStyle(

                    fontSize:

                    16,

                  ),

                ),




                style:

                ElevatedButton.styleFrom(



                  backgroundColor:

                  Colors.redAccent,



                  foregroundColor:

                  Colors.white,



                  padding:

                  const EdgeInsets.symmetric(

                    vertical:

                    16,

                  ),



                  shape:

                  RoundedRectangleBorder(



                    borderRadius:

                    BorderRadius.circular(25),



                  ),



                ),




                onPressed:(){



                  mostrarCatalogo();



                },



              ),



            ),






            const SizedBox(

              height:

              20,

            ),







            Expanded(



              child:





              planes.isEmpty



                  ?



              const Center(



                child:

                Text(



                  "No tiene planes asignados",



                  style:

                  TextStyle(



                    color:

                    Colors.grey,



                    fontSize:

                    16,



                  ),



                ),



              )



                  :





              ListView.builder(



                itemCount:

                planes.length,



                itemBuilder:(context,index){



                  final plan =

                  planes[index];







                  return Container(



                    margin:

                    const EdgeInsets.only(

                      bottom:

                      15,

                    ),





                    decoration:

                    BoxDecoration(



                      color:

                      Colors.white,



                      borderRadius:

                      BorderRadius.circular(24),




                      boxShadow:[



                        BoxShadow(



                          color:

                          Colors.black.withOpacity(.08),



                          blurRadius:

                          12,



                          offset:

                          const Offset(0,5),



                        )



                      ],



                    ),







                    child:

                    Padding(



                      padding:

                      const EdgeInsets.all(18),





                      child:

                      Column(



                        crossAxisAlignment:

                        CrossAxisAlignment.start,



                        children:[





                          Row(



                            mainAxisAlignment:

                            MainAxisAlignment.spaceBetween,



                            children:[





                              Expanded(



                                child:

                                Text(



                                  plan.planCatalogo?.nombre ??
                                      "Plan",




                                  style:

                                  const TextStyle(



                                    fontSize:

                                    22,



                                    fontWeight:

                                    FontWeight.bold,



                                  ),



                                ),



                              ),





                              Container(



                                padding:

                                const EdgeInsets.symmetric(



                                  horizontal:

                                  12,



                                  vertical:

                                  6,



                                ),



                                decoration:

                                BoxDecoration(



                                  color:

                                  estadoColor(plan.estado)
                                      .withOpacity(.15),



                                  borderRadius:

                                  BorderRadius.circular(20),



                                ),




                                child:

                                Text(



                                  plan.estado,



                                  style:

                                  TextStyle(



                                    color:

                                    estadoColor(plan.estado),



                                    fontWeight:

                                    FontWeight.bold,



                                  ),



                                ),



                              ),




                            ],



                          ),






                          const SizedBox(

                            height:

                            15,

                          ),






                          Text(

                            "Clases totales: ${plan.cantidadClases}",

                          ),




                          Text(

                            "Clases disponibles: ${plan.clasesRestantes}",

                          ),




                          Text(

                            "Valor: \$${plan.valor.toStringAsFixed(0)}",

                          ),





                          Text(

                            "Inicio: ${plan.fechaInicio}",

                          ),




                          Text(

                            "Finaliza: ${plan.fechaFinalizacion}",

                          ),






                          const SizedBox(

                            height:

                            15,

                          ),





                          Row(



                            mainAxisAlignment:

                            MainAxisAlignment.end,



                            children:[




                              OutlinedButton.icon(



                                icon:

                                const Icon(

                                  Icons.edit,

                                ),



                                label:

                                const Text(

                                  "Estado",

                                ),




                                onPressed:(){



                                  editarEstadoPlan(plan);



                                },



                              ),






                              const SizedBox(

                                width:

                                10,

                              ),





                              FilledButton.icon(



                                style:

                                FilledButton.styleFrom(



                                  backgroundColor:

                                  Colors.red,



                                ),




                                icon:

                                const Icon(

                                  Icons.delete,

                                ),




                                label:

                                const Text(

                                  "Eliminar",

                                ),




                                onPressed:(){



                                  eliminarPlan(plan);



                                },



                              ),





                            ],



                          ),




                        ],



                      ),



                    ),



                  );




                },



              ),



            ),





          ],



        ),



      ),



    );

  }

}
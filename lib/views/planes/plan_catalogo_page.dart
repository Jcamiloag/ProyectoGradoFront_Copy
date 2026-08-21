import 'package:flutter/material.dart';

import 'package:hola_mundo/models/plan_catalogo.dart';
import 'package:hola_mundo/services/plan_service.dart';
import 'package:hola_mundo/views/custom_drawer.dart';



class PlanCatalogoPage extends StatefulWidget {

  const PlanCatalogoPage({
    super.key,
  });


  @override
  State<PlanCatalogoPage> createState() =>
      _PlanCatalogoPageState();

}






class _PlanCatalogoPageState extends State<PlanCatalogoPage> {


  final PlanService _planService =
      PlanService();


  List<PlanCatalogo> planes = [];


  bool loading = true;


  bool guardando = false;







  @override
  void initState() {

    super.initState();

    cargarPlanes();

  }








  Future<void> cargarPlanes() async {

    try {

      final data =
      await _planService.obtenerPlanesCatalogo();


      if(!mounted) return;


      setState(() {

        planes = data;

        loading = false;

      });


    } catch(e) {


      if(!mounted) return;


      setState(() {

        loading = false;

      });


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








  Future<void> cambiarEstado(
      PlanCatalogo plan
      ) async {


    final resultado =
    await _planService.cambiarEstadoCatalogo(
      plan.id,
    );


    if(resultado){

      await cargarPlanes();

    }


  }








  Future<void> eliminarPlan(
      PlanCatalogo plan
      ) async {


    final confirmar =
    await showDialog<bool>(

      context: context,

      builder:(context)=>AlertDialog(

        shape: RoundedRectangleBorder(
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
          "¿Deseas eliminar ${plan.nombre}?",
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



    if(confirmar != true) return;



    final eliminado =
    await _planService.eliminarPlanCatalogo(
      plan.id,
    );



    if(eliminado){


      await cargarPlanes();


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









  void abrirFormulario({
    PlanCatalogo? plan,
  }) {


    final categoriaController =
    TextEditingController(
      text:
      plan?.categoria ?? "",
    );


    final nombreController =
    TextEditingController(
      text:
      plan?.nombre ?? "",
    );


    final clasesController =
    TextEditingController(
      text:
      plan?.cantidadClases?.toString() ?? "",
    );


    final valorController =
    TextEditingController(
      text:
      plan?.valor.toString() ?? "",
    );


    final duracionController =
    TextEditingController(
      text:
      plan?.duracion?.toString() ?? "",
    );




    bool activo =
        plan?.activo ?? true;




    showModalBottomSheet(

      context: context,

      isScrollControlled: true,

      backgroundColor:
      Colors.transparent,


      builder:(context){


        return StatefulBuilder(


          builder:(context,setModalState){


            return Container(

              padding:

              EdgeInsets.only(

                left:20,

                right:20,

                top:25,

                bottom:

                MediaQuery.of(context)
                    .viewInsets
                    .bottom + 20,

              ),


              decoration:

              const BoxDecoration(

                color:
                Colors.white,

                borderRadius:

                BorderRadius.vertical(

                  top:
                  Radius.circular(30),

                ),

              ),


              child:

              SingleChildScrollView(

                child:

                Column(

                  mainAxisSize:
                  MainAxisSize.min,


                  children:[


                    Container(

                      width:50,

                      height:5,

                      decoration:

                      BoxDecoration(

                        color:
                        Colors.grey.shade300,

                        borderRadius:
                        BorderRadius.circular(20),

                      ),

                    ),



                    const SizedBox(
                      height:20,
                    ),



                    Text(

                      plan == null
                          ?
                      "Crear plan"
                          :
                      "Editar plan",


                      style:

                      const TextStyle(

                        fontSize:24,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),



                    const SizedBox(
                      height:20,
                    ),


                    _campo(
                      categoriaController,
                      "Categoría",
                      Icons.category,
                    ),


                    const SizedBox(height:12),


                    _campo(
                      nombreController,
                      "Nombre del plan",
                      Icons.card_membership,
                    ),


                    const SizedBox(height:12),


                    _campo(
                      clasesController,
                      "Cantidad de clases",
                      Icons.fitness_center,
                      numero:true,
                    ),


                    const SizedBox(height:12),


                    _campo(
                      valorController,
                      "Valor",
                      Icons.attach_money,
                      numero:true,
                    ),


                    const SizedBox(height:12),


                    _campo(
                      duracionController,
                      "Duración meses",
                      Icons.calendar_month,
                      numero:true,
                    ),


                    SwitchListTile(

                      title:

                      const Text(
                        "Activo",
                      ),


                      value:
                      activo,


                      onChanged:(value){

                        setModalState((){

                          activo=value;

                        });

                      },

                    ),



                    const SizedBox(height:20),



                    SizedBox(

                      width:
                      double.infinity,


                      child:

                      FilledButton(

                        style:

                        FilledButton.styleFrom(

                          backgroundColor:
                          Colors.redAccent,

                          padding:
                          const EdgeInsets.all(16),

                        ),



                        onPressed:

                        guardando

                            ?

                        null

                            :

                        () async {


                          setModalState((){

                            guardando=true;

                          });


                          final nuevoPlan =
                          PlanCatalogo(

                            id:
                            plan?.id ?? 0,

                            categoria:
                            categoriaController.text.trim(),

                            nombre:
                            nombreController.text.trim(),

                            cantidadClases:
                            int.tryParse(
                              clasesController.text,
                            ),

                            valor:
                            double.tryParse(
                              valorController.text,
                            ) ?? 0,


                            duracion:
                            int.tryParse(
                              duracionController.text,
                            ),


                            activo:
                            activo,

                          );



                          bool resultado;



                          if(plan == null){


                            resultado =
                            await _planService
                                .crearPlanCatalogo(
                              nuevoPlan,
                            );


                          }else{


                            resultado =
                            await _planService
                                .actualizarPlanCatalogo(
                              nuevoPlan,
                            );


                          }



                          if(!mounted) return;



                          Navigator.pop(context);



                          await cargarPlanes();



                          ScaffoldMessenger.of(context)
                              .showSnackBar(

                            SnackBar(

                              content:

                              Text(

                                resultado

                                    ?

                                "Plan guardado correctamente"

                                    :

                                "Error guardando plan",

                              ),

                            ),

                          );


                        },


                        child:

                        guardando

                            ?

                        const CircularProgressIndicator(
                          color: Colors.white,
                        )

                            :

                        const Text(
                          "Guardar",
                        ),

                      ),

                    ),


                  ],

                ),

              ),

            );


          },


        );


      },


    );

  }
    Widget _campo(
      TextEditingController controller,
      String label,
      IconData icon, {
        bool numero = false,
      }) {


    return TextField(


      controller:
      controller,


      keyboardType:

      numero

          ?

      TextInputType.number

          :

      TextInputType.text,


      decoration:

      InputDecoration(


        labelText:
        label,


        prefixIcon:

        Icon(
          icon,
          color:
          Colors.redAccent,
        ),


        filled:
        true,


        fillColor:
        Colors.grey.shade100,


        border:

        OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(16),

          borderSide:
          BorderSide.none,

        ),


      ),


    );


  }







  Color estadoColor(bool activo){


    return activo

        ?

    Colors.green

        :

    Colors.grey;


  }









  @override
  Widget build(BuildContext context) {


  return Scaffold(

  backgroundColor:
  Colors.grey[100],

  drawer:
  const CustomDrawer(),

  appBar:

  AppBar(

    title:

    const Text(

      "Catálogo de planes",

    ),

    backgroundColor:

    Colors.redAccent,

    foregroundColor:

    Colors.white,

    centerTitle:

    true,

  ),



  floatingActionButton:

  FloatingActionButton.extended(


    backgroundColor:

    Colors.redAccent,


    foregroundColor:

    Colors.white,


    icon:

    const Icon(
      Icons.add,
    ),


    label:

    const Text(
      "Nuevo plan",
    ),


    onPressed:(){

      abrirFormulario();

    },


  ),



  body:


  loading


      ?


  const Center(

    child:

    CircularProgressIndicator(),

  )



      :



  planes.isEmpty



      ?



  const Center(

    child:

    Text(

      "No hay planes creados",

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

    padding:

    const EdgeInsets.all(16),

    itemCount:

    planes.length,

    itemBuilder:(context,index){

      final plan =
      planes[index];


      return Container(

        margin:

        const EdgeInsets.only(

          bottom:
          16,

        ),


        padding:

        const EdgeInsets.all(18),


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

              const Offset(
                0,
                5,
              ),

            ),

          ],

        ),


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

                    plan.nombre,


                    style:

                    const TextStyle(

                      fontSize:
                      22,

                      fontWeight:
                      FontWeight.bold,

                    ),

                  ),

                ),


                InkWell(

                  borderRadius:

                  BorderRadius.circular(20),


                  onTap:(){

                    cambiarEstado(plan);

                  },


                  child:

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

                      estadoColor(plan.activo)
                          .withOpacity(.15),


                      borderRadius:

                      BorderRadius.circular(20),

                    ),


                    child:

                    Text(

                      plan.activo
                          ?
                      "ACTIVO"
                          :
                      "INACTIVO",


                      style:

                      TextStyle(

                        color:

                        estadoColor(plan.activo),


                        fontWeight:

                        FontWeight.bold,


                        fontSize:
                        12,

                      ),

                    ),

                  ),

                ),

              ],

            ),


            const SizedBox(
              height:18,
            ),


            _dato(
              Icons.category_outlined,
              "Categoría",
              plan.categoria,
            ),


            _dato(
              Icons.fitness_center,
              "Clases",
              "${plan.cantidadClases ?? 0}",
            ),


            _dato(
              Icons.calendar_month,
              "Duración",
              "${plan.duracion ?? 0} meses",
            ),


            _dato(
              Icons.attach_money,
              "Valor",
              "\$${plan.valor.toStringAsFixed(0)}",
            ),


            const SizedBox(
              height:18,
            ),


            Row(

              mainAxisAlignment:

              MainAxisAlignment.end,


              children:[


                OutlinedButton.icon(

                  icon:

                  const Icon(
                    Icons.edit_outlined,
                  ),


                  label:

                  const Text(
                    "Editar",
                  ),


                  onPressed:(){

                    abrirFormulario(
                      plan:
                      plan,
                    );

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
                    Icons.delete_outline,
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

      );

    },

  ),

);


  }






  Widget _dato(
      IconData icon,
      String titulo,
      String valor,
      ){


    return Padding(

      padding:

      const EdgeInsets.only(
        bottom:8,
      ),


      child:

      Row(

        children:[


          Icon(

            icon,

            size:
            20,

            color:
            Colors.redAccent,

          ),



          const SizedBox(
            width:10,
          ),



          Text(

            "$titulo: ",

            style:

            const TextStyle(

              fontWeight:
              FontWeight.bold,

            ),

          ),



          Expanded(

            child:

            Text(
              valor,
            ),

          ),



        ],


      ),


    );


  }


}
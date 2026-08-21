import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';
import 'package:hola_mundo/models/user.dart';
import 'package:hola_mundo/services/user_service.dart';
import 'package:go_router/go_router.dart';
import 'package:hola_mundo/views/planes/student_plan_page.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {

  final UserService _userService = UserService();

  List<User> _usuarios = [];
  List<User> _usuariosFiltrados = [];

  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    obtenerDatos();
  }


  Future<void> obtenerDatos() async {

    try {

      final datos = await _userService.fetchAllUsers();

      if (!mounted) return;

      setState(() {

        _usuarios = datos;

        _usuariosFiltrados = datos
            .where((u) => u.role != "ADMIN")
            .toList();

        _isLoading = false;

      });


    } catch(e){

      print("ERROR: $e");

      setState(() {
        _isLoading = false;
      });

    }

  }



  void buscarUsuario(String texto){

    final busqueda = texto.toLowerCase();


    setState(() {

      _usuariosFiltrados = _usuarios.where((usuario){

        if(usuario.role == "ADMIN"){
          return false;
        }


        return usuario.name
                .toLowerCase()
                .contains(busqueda) ||

            usuario.email
                .toLowerCase()
                .contains(busqueda);


      }).toList();


    });


  }



  Future<void> eliminarUsuario(User usuario) async {


    final confirmar = await showDialog<bool>(

      context: context,

      builder:(context)=>AlertDialog(

        title: const Text(
          "Eliminar estudiante"
        ),

        content: Text(
          "¿Deseas eliminar a ${usuario.name}?"
        ),


        actions:[


          TextButton(

            onPressed:()=>Navigator.pop(context,false),

            child:const Text(
              "Cancelar"
            ),

          ),


          FilledButton(

            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),

            onPressed:()=>Navigator.pop(context,true),

            child:const Text(
              "Eliminar"
            ),

          )

        ],

      )

    );


    if(confirmar == true){

      final eliminado =
      await _userService.deleteUser(usuario.id);


      if(eliminado){

        await obtenerDatos();


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(
              content:
              Text("Estudiante eliminado")
          ),

        );

      }

    }

  }



  Future<void> editarUsuario(User usuario) async {

    final nombreController = TextEditingController(
      text: usuario.firstname,
    );

    final apellidoController = TextEditingController(
      text: usuario.lastname,
    );

    final emailController = TextEditingController(
      text: usuario.email,
    );

    final telefonoController = TextEditingController(
      text: usuario.phonenumber,
    );


    final guardar = await showDialog(

      context: context,

      builder: (context) {

        return AlertDialog(

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),

          title: const Row(
            children: [

              Icon(
                Icons.edit,
                color: Colors.redAccent,
              ),

              SizedBox(width:10),

              Text(
                "Editar estudiante",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )

            ],
          ),


          content: SizedBox(

            width: double.maxFinite,

            child: SingleChildScrollView(

              child: Column(

                mainAxisSize: MainAxisSize.min,

                children: [

                  TextField(
                    controller: nombreController,

                    decoration: InputDecoration(

                      labelText:"Nombre",

                      prefixIcon:
                      const Icon(Icons.person_outline),

                      filled:true,

                      fillColor:Colors.grey[100],

                      border:OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide:
                        BorderSide.none,

                      ),

                    ),

                  ),

                  const SizedBox(height:16),


                  TextField(

                    controller: apellidoController,

                    decoration: InputDecoration(

                      labelText:"Apellido",

                      prefixIcon:
                      const Icon(Icons.person),

                      filled:true,

                      fillColor:Colors.grey[100],

                      border:OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide:
                        BorderSide.none,

                      ),

                    ),

                  ),


                  const SizedBox(height:16),


                  TextField(

                    controller: emailController,

                    decoration: InputDecoration(

                      labelText:"Correo",

                      prefixIcon:
                      const Icon(Icons.email_outlined),

                      filled:true,

                      fillColor:Colors.grey[100],

                      border:OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide:
                        BorderSide.none,

                      ),

                    ),

                  ),


                  const SizedBox(height:16),


                  TextField(

                    controller: telefonoController,

                    keyboardType:
                    TextInputType.phone,

                    decoration: InputDecoration(

                      labelText:"Teléfono",

                      prefixIcon:
                      const Icon(Icons.phone_outlined),

                      filled:true,

                      fillColor:Colors.grey[100],

                      border:OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(14),

                        borderSide:
                        BorderSide.none,

                      ),

                    ),

                  ),

                ],

              ),

            ),

          ),
                    actionsPadding:
          const EdgeInsets.symmetric(
            horizontal:20,
            vertical:12,
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


            ElevatedButton.icon(

              icon:
              const Icon(Icons.save),


              style:
              ElevatedButton.styleFrom(

                backgroundColor:
                Colors.redAccent,

                foregroundColor:
                Colors.white,

                shape:
                RoundedRectangleBorder(

                  borderRadius:
                  BorderRadius.circular(20),

                ),

              ),


              onPressed:(){

                Navigator.pop(
                  context,
                  true,
                );

              },


              label:
              const Text(
                "Guardar",
              ),

            ),


          ],

        );

      },

    );


    if(guardar == true){


      final updatedUser = User(

        id:
        usuario.id,

        username:
        usuario.username,

        firstname:
        nombreController.text,

        lastname:
        apellidoController.text,

        email:
        emailController.text,

        phonenumber:
        telefonoController.text,

        role:
        usuario.role,

      );


      final actualizado =
      await _userService.updateUser(
        updatedUser,
      );


      if(actualizado){

        await obtenerDatos();


        ScaffoldMessenger.of(context)
            .showSnackBar(

          const SnackBar(

            content:
            Text(
              "Usuario actualizado correctamente",
            ),

          ),

        );

      }

    }

  }



  @override
  Widget build(BuildContext context) {

    return BaseView(

      title:
      "Lista de Estudiantes",

      initialIndex:
      0,

      length:
      _usuariosFiltrados.length,


      body:

      _isLoading

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


            Container(

              decoration:
              BoxDecoration(

                color:
                Colors.white,

                borderRadius:
                BorderRadius.circular(18),

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

              TextField(

                onChanged:
                buscarUsuario,


                decoration:
                InputDecoration(

                  hintText:
                  "Buscar estudiante...",


                  prefixIcon:
                  const Icon(

                    Icons.search,

                    color:
                    Colors.redAccent,

                  ),


                  border:
                  InputBorder.none,


                  contentPadding:
                  const EdgeInsets.symmetric(

                    vertical:16,

                  ),

                ),

              ),

            ),



            const SizedBox(
              height:20,
            ),



            Expanded(

              child:

              _usuariosFiltrados.isEmpty

                  ?

              const Center(

                child:

                Text(

                  "No hay estudiantes registrados",

                  style:
                  TextStyle(

                    color:
                    Colors.grey,

                    fontSize:16,

                  ),

                ),

              )


                  :

              ListView.builder(

                itemCount:
                _usuariosFiltrados.length,


                itemBuilder:
                    (context,index){


                  final usuario =
                  _usuariosFiltrados[index];



                  return Container(

                    margin:
                    const EdgeInsets.only(
                      bottom:14,
                    ),


                    decoration:
                    BoxDecoration(

                      color:
                      Theme.of(context)
                          .cardColor,


                      borderRadius:
                      BorderRadius.circular(22),


                      boxShadow:[

                        BoxShadow(

                          color:
                          Colors.black.withOpacity(.07),

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
                      const EdgeInsets.all(16),


                      child:

                      Column(

                        children:[


                          Row(

                            children:[


                              CircleAvatar(

                                radius:28,

                                backgroundColor:
                                Colors.redAccent
                                    .withOpacity(.15),


                                child:

                                Text(

                                  usuario.firstname.isNotEmpty

                                      ?

                                  usuario.firstname[0]
                                      .toUpperCase()

                                      :

                                  "U",


                                  style:
                                  const TextStyle(

                                    fontSize:22,

                                    fontWeight:
                                    FontWeight.bold,

                                    color:
                                    Colors.redAccent,

                                  ),

                                ),

                              ),



                              const SizedBox(
                                width:14,
                              ),



                              Expanded(

                                child:

                                Column(

                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,


                                  children:[


                                    Text(

                                      usuario.name,

                                      style:
                                      const TextStyle(

                                        fontSize:18,

                                        fontWeight:
                                        FontWeight.bold,

                                      ),

                                    ),


                                    const SizedBox(
                                      height:5,
                                    ),


                                    Text(
                                      usuario.email,
                                      style:
                                      TextStyle(
                                        color:
                                        Colors.grey[600],
                                      ),
                                    ),


                                    Text(
                                      usuario.phonenumber,
                                      style:
                                      TextStyle(
                                        color:
                                        Colors.grey[600],
                                      ),
                                    ),

                                  ],

                                ),

                              ),



                              Container(

                                padding:
                                const EdgeInsets.symmetric(

                                  horizontal:10,

                                  vertical:5,

                                ),


                                decoration:
                                BoxDecoration(

                                  color:
                                  Colors.green
                                      .withOpacity(.15),


                                  borderRadius:
                                  BorderRadius.circular(20),

                                ),


                                child:

                                Text(

                                  "Activo",

                                  style:
                                  TextStyle(

                                    color:
                                    Colors.green[700],

                                    fontWeight:
                                    FontWeight.bold,

                                    fontSize:12,

                                  ),

                                ),

                              )


                            ],

                          ),



                          const SizedBox(
                            height:16,
                          ),



                          Row(

                            mainAxisAlignment:
                            MainAxisAlignment.end,


                            children:[


                              // EVALUACIÓN

                              IconButton(

                                tooltip:
                                "Evaluación",


                                icon:
                                const Icon(

                                  Icons.assignment_outlined,

                                  color:
                                  Colors.blue,

                                ),


                                onPressed:(){

                                  context.pushNamed(

                                    "evaluacion",

                                    extra:
                                    usuario,

                                  );

                                },

                              ),



                              // PLANES CONECTADO

                              IconButton(

                                tooltip:
                                "Planes",


                                icon:
                                const Icon(

                                  Icons.card_membership_outlined,

                                  color:
                                  Colors.deepPurple,

                                ),


                                onPressed:(){

                                  context.pushNamed(

                                    "planes",

                                    extra:
                                    usuario,

                                  );

                                },

                              ),



                              // EDITAR

                              IconButton(

                                tooltip:
                                "Editar",


                                icon:
                                const Icon(

                                  Icons.edit_outlined,

                                ),


                                onPressed:(){

                                  editarUsuario(
                                    usuario,
                                  );

                                },

                              ),



                              // ELIMINAR

                              IconButton(

                                tooltip:
                                "Eliminar",


                                icon:
                                const Icon(

                                  Icons.delete_outline,

                                  color:
                                  Colors.red,

                                ),


                                onPressed:(){

                                  eliminarUsuario(
                                    usuario,
                                  );

                                },

                              ),


                            ],

                          )


                        ],

                      ),

                    ),

                  );


                },

              ),

            )


          ],

        ),

      ),


    );

  }


}
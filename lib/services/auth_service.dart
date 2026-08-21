import 'dart:convert';

import 'package:hola_mundo/constants/api_constants.dart';
import 'package:hola_mundo/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = AppConstants.baseUrl;


  Future<Map<String, dynamic>> login(
      String email, String password) async {

    try {

      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );


      final data = jsonDecode(response.body);


      if (response.statusCode == 200) {


        final prefs = await SharedPreferences.getInstance();


        await prefs.setString(
          'token',
          data['token'],
        );


        // GUARDAR ID DEL USUARIO PARA RESERVAS
        await prefs.setInt(
          'userId',
          data['id'],
        );



        final user = User(

          id: data['id'],

          username: data['username'],

          firstname: data['firstname'],

          lastname: data['lastname'],

          email: data['email'],

          phonenumber: data['phonenumber'] ?? '',

          role: data['role'],

        );



        await prefs.setString(
          'user',
          jsonEncode(user.toJson()),
        );



        await prefs.setString(
          'username',
          user.name,
        );



        await prefs.setString(
          'role',
          user.role,
        );



        return {

          'success': true,

          'token': data['token'],

          'user': user,

        };


      }



      return {

        'success': false,

        'message': data['error'] ?? 'Error en login',

      };



    } catch(e) {


      return {

        'success': false,

        'message': 'Error de conexión: $e',

      };


    }

  }






  Future<Map<String, dynamic>> register({

    required String name,

    required String last_Name,

    required String username,

    required String phone,

    required String email,

    required String password,

  }) async {


    try {


      final body = jsonEncode({

        'username': username,

        'password': password,

        'firstname': name,

        'lastname': last_Name,

        'email': email,

        'phonenumber': phone,

        'role': 'USER',

      });



      final response = await http.post(

        Uri.parse('$baseUrl/auth/register'),

        headers: {

          'Content-Type': 'application/json'

        },

        body: body,

      );



      final data = jsonDecode(response.body);



      if(response.statusCode == 200){


        final prefs = await SharedPreferences.getInstance();



        await prefs.setString(

          'token',

          data['token'],

        );



        // GUARDAR ID DEL USUARIO REGISTRADO

        await prefs.setInt(

          'userId',

          data['id'],

        );




        final user = User(

          id: data['id'],

          username: data['username'],

          firstname: data['firstname'],

          lastname: data['lastname'],

          email: data['email'],

          phonenumber: data['phonenumber'] ?? '',

          role: data['role'],

        );




        await prefs.setString(

          'user',

          jsonEncode(user.toJson()),

        );



        await prefs.setString(

          'username',

          user.name,

        );



        await prefs.setString(

          'role',

          user.role,

        );



        return {

          'success': true,

          'user': user,

        };


      }




      return {

        'success': false,

        'message': data['error'] ??

            'Error en registro (${response.statusCode})',

      };



    } catch(e){


      return {

        'success': false,

        'message': 'Error de conexión: $e',

      };


    }


  }





  Future<String?> getToken() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('token');

  }




  Future<String?> getUsername() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('username');

  }





  Future<String?> getRole() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getString('role');

  }




  Future<int?> getUserId() async {

    final prefs = await SharedPreferences.getInstance();

    return prefs.getInt('userId');

  }





  Future<User?> getUser() async {

    final prefs = await SharedPreferences.getInstance();


    final userStr = prefs.getString('user');


    if(userStr == null) return null;



    return User.fromJson(

      jsonDecode(userStr),

    );

  }





  Future<bool> logout() async {


    final prefs = await SharedPreferences.getInstance();



    await prefs.remove('token');

    await prefs.remove('user');

    await prefs.remove('username');

    await prefs.remove('role');

    await prefs.remove('userId');



    return true;

  }


}
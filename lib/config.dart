import 'package:flutter/foundation.dart';

/// Dirección IP de tu servidor local
const String localIp = '192.168.0.11'; // reemplázala con tu IP 

/// Puerto del backend
const int port = 8080;

/// Base URL según el entorno
final String baseUrl = kIsWeb
    ? 'http://localhost:$port/api'         // Para entorno web
    : 'http://$localIp:$port/api';         // Para dispositivos móviles
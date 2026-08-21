import 'package:hola_mundo/models/plan.dart';
import 'package:hola_mundo/models/reserva.dart';
import 'package:hola_mundo/services/plan_service.dart';
import 'package:hola_mundo/services/reserva_service.dart';


class HomeService {


  final PlanService planService =
      PlanService();


  final ReservaService reservaService =
      ReservaService();




  Future<List<Plan>> obtenerPlanesUsuario(
      int userId
  ) async {

    return await planService
        .obtenerPlanesUsuario(userId);

  }




  Future<List<Reserva>> obtenerReservasUsuario(
      int userId
  ) async {

    final reservas =
        await reservaService
            .obtenerReservasUsuario(userId);


    return reservas
        .where(
          (r)=> r.estado == "ACTIVA"
        )
        .toList();

  }





  Future<void> cancelarReserva(
      int reservaId
  ) async {


    await reservaService
        .cancelarReserva(reservaId);


  }


}
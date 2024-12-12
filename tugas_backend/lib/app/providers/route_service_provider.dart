import 'package:vania/vania.dart';
import 'package:tugas_backend/route/api_route.dart';
import 'package:tugas_backend/route/web.dart';
import 'package:tugas_backend/route/web_socket.dart';

class RouteServiceProvider extends ServiceProvider {
  @override
  Future<void> boot() async {}

  @override
  Future<void> register() async {
    WebRoute().register();
    ApiRoute().register();
    WebSocketRoute().register();
  }
}

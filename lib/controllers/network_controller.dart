import 'package:conduit/conduit.dart';
import 'package:gladiators/p2p.dart';


class NetworkController extends ResourceController {
  P2P p2p;
  NetworkController(this.p2p);
  @Operation.get() 
  Future<Response> peers() async {
    return Response.ok(p2p.sockets);
  }  
}
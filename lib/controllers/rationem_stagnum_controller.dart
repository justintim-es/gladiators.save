import 'package:conduit/conduit.dart';
import 'package:gladiators/p2p.dart';


class RationemStagnumController extends ResourceController {
  P2P p2p;
  RationemStagnumController(this.p2p);
  @Operation.get('rationem-stagnum') 
  Future<Response> rationemStagnum() async {
      return Response.ok(p2p.propters);
  }
}
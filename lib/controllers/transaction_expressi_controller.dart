import 'package:conduit/conduit.dart';
import 'package:gladiators/p2p.dart';

class TransactionExpressiController extends ResourceController {
  P2P p2p;
  TransactionExpressiController(this.p2p);
  
  @Operation.get('expressi-stagnum') 
  Response expressiStagnum() {
     return Response.ok(p2p.expressieTxs.map((e) => e.toJson()).toList());
  }
  
}
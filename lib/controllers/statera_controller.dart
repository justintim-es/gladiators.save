import 'package:conduit/conduit.dart';
import 'package:gladiators/gladiators.dart';
import 'package:gladiators/models/pera.dart';

class StateraController extends ResourceController {  
  Directory directory;
  StateraController(this.directory);
  @Operation.get('liber', 'publica')
  Future<Response> liber() async {
    BigInt statera = await Pera.statera(request!.path.variables['liber']! == 'true', request!.path.variables['publica']!, directory);
    return Response.ok({
        "statera": statera.toString()
    });
  }
}
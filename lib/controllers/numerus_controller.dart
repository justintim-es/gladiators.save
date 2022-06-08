import 'dart:io';

import 'package:conduit/conduit.dart';
import 'package:gladiators/models/obstructionum.dart';
import 'package:gladiators/models/utils.dart';

class NumerusController extends ResourceController {
  Directory directory;
  NumerusController(this.directory);
  
  @Operation.get()
  Future<Response> numerus() async {
    Obstructionum obs = await Utils.priorObstructionum(directory);
    return Response.ok({ "numerus": obs.interioreObstructionum.obstructionumNumerus });
  }
}
import 'package:conduit/conduit.dart';
import 'package:gladiators/gladiators.dart';
import 'package:gladiators/models/obstructionum.dart';
import 'package:gladiators/models/utils.dart';
import 'package:collection/collection.dart';
import 'package:gladiators/p2p.dart';
import '../models/exampla.dart';
import 'dart:convert';

class ObstructionumController extends ResourceController {
    Directory directory;
    P2P p2p;
    ObstructionumController(this.directory, this.p2p);
   
    @Operation.post()
    Future<Response> obstructionum() async {
      try {
        final ObstructionumNumerus obstructionumNumerus = ObstructionumNumerus.fromJson(await request!.body.decode());
        File file = File(directory.path + '/caudices_' + (obstructionumNumerus.numerus.length-1).toString() + '.txt');
        return Response.ok(json.decode(await Utils.fileAmnis(file).elementAt(obstructionumNumerus.numerus[obstructionumNumerus.numerus.length-1])));          
      } catch (err) {
        return Response.notFound(body: {
          "code": 0,
          "message": "angustos non inveni",
          "english": "block not found"
        });
      }
    }
    @Operation.post('probationem')
    Future<Response> probationem() async {
      final Probationems prop = Probationems.fromJson(await request!.body.decode());
      List<Obstructionum> obs = await Utils.getObstructionums(directory);
      if (obs.length == 1) return Response.ok([obs.first.probationem]);
      int start = 0;
      int end = 0;
      for (int i = 0; i < obs.length; i++) {
        if (ListEquality().equals(obs[i].interioreObstructionum.obstructionumNumerus, prop.firstIndex)) {
          start = i;
        }
        if (ListEquality().equals(obs[i].interioreObstructionum.obstructionumNumerus, prop.lastIndex)) {
          end = i;
        }
      }
      return Response.ok(obs.map((o) => o.probationem).toList().getRange(start, end).toList());
    }
    @Operation.get() 
    Future<Response> prior() async {
      Obstructionum obs = await Utils.priorObstructionum(directory);
      return Response.ok(obs.toJson());
    }

    @Operation.get('probationem')
    Future<Response> probationemGenerare(@Bind.path('probationem') String probationem) async {
      Obstructionum obs = await Utils.accipereObstructionumProbationem(probationem, directory);
      return Response.ok({
        "generare": obs.interioreObstructionum.generare.name.toString()
      });
    } 
    @Operation.delete() 
    Future<Response> furcaUnumRetro() async {
      Obstructionum obs = await Utils.priorObstructionum(directory);
      await Utils.removeObstructionumsUntilProbationem(directory);
      p2p!.liberTxs = [];
      p2p!.fixumTxs= [];
      return Response.ok(json.encode({
        "message": "removed",
        "obstructionum": obs.toJson()
      }));
    }
    @override
    Map<String, APIResponse> documentOperationResponses(APIDocumentContext context, Operation operation) {
    // if(operation.method == "POST") {
      return {
        "200": APIResponse.schema("Fetched block by number", APISchemaObject.object({
          "probationem": APISchemaObject.string(),
          "interioreObstructionum": APISchemaObject.object({
                'generare': APISchemaObject.string(),
                'obstructionumDifficultas': APISchemaObject.integer(),
                'divisa': APISchemaObject.number(),
                'propterDifficultas': APISchemaObject.integer(),
                'liberDifficultas': APISchemaObject.integer(),
                'fixumDifficultas': APISchemaObject.integer(),
                'indicatione': APISchemaObject.number(),
                'nonce': APISchemaObject.integer(),
                'summaObstructionumDifficultas': APISchemaObject.integer(),
                'forumCap': APISchemaObject.integer(),
                'liberForumCap': APISchemaObject.integer(),
                'fixumForumCap': APISchemaObject.integer(),
                'obstructionumNumerus': APISchemaObject.array(ofSchema: APISchemaObject.integer()),
                'defensio': APISchemaObject.string(),
                'producentis': APISchemaObject.string(),
                'priorProbationem': APISchemaObject.string(),
                'gladiator': APISchemaObject.object({
                    'input': APISchemaObject.object({
                      'index': APISchemaObject.integer(),
                      'signature': APISchemaObject.string(),
                      'gladiatorId': APISchemaObject.string()                      
                    }),
                    'outputs': APISchemaObject.object({
                      'index': APISchemaObject.integer(),
                      'signature': APISchemaObject.string(),
                      'gladiatorId': APISchemaObject.string(),
                    }), 
                    'random': APISchemaObject.string(),
                    'id': APISchemaObject.string()
                }),
                'liberTransactions': APISchemaObject.array(ofSchema: APISchemaObject.object({
                   "probationem": APISchemaObject.string(),
                   "interioreTransaction": APISchemaObject.object({
                      'liber': APISchemaObject.boolean(),
                      'inputs': APISchemaObject.array(ofSchema: APISchemaObject.object({
                        'index': APISchemaObject.integer(),
                        'signature': APISchemaObject.string(),
                        'transactionId': APISchemaObject.string() 
                      })),
                      'outputs': APISchemaObject.object({
                        'publicKey': APISchemaObject.string(),
                        'gla': APISchemaObject.string()
                      }),
                      'random': APISchemaObject.string(),
                      'id': APISchemaObject.integer(),
                      'nonce': APISchemaObject.string(),
                      'expressi': APISchemaObject.string()
                   })
                })),
                'fixumTransactions': APISchemaObject.array(ofSchema: APISchemaObject.object({
                  "probationem": APISchemaObject.string(),
                  "interioreTransaction": APISchemaObject.object({
                    'liber': APISchemaObject.boolean(),
                    "interioreTransaction": APISchemaObject.object({
                      'liber': APISchemaObject.boolean(),
                      'inputs': APISchemaObject.array(ofSchema: APISchemaObject.object({
                        'index': APISchemaObject.integer(),
                        'signature': APISchemaObject.string(),
                        'transactionId': APISchemaObject.string() 
                      })),
                      'outputs': APISchemaObject.object({
                        'publicKey': APISchemaObject.string(),
                        'gla': APISchemaObject.string()
                      }),
                      'random': APISchemaObject.string(),
                      'id': APISchemaObject.integer(),
                      'nonce': APISchemaObject.string(),
                   })
                  })
                })),
                'expressiTransactions': APISchemaObject.array(ofSchema: APISchemaObject.object({
                  "probationem": APISchemaObject.string(),
                  "interioreTransaction": APISchemaObject.object({
                    'liber': APISchemaObject.boolean(),
                    "interioreTransaction": APISchemaObject.object({
                      'liber': APISchemaObject.boolean(),
                      'inputs': APISchemaObject.array(ofSchema: APISchemaObject.object({
                        'index': APISchemaObject.integer(),
                        'signature': APISchemaObject.string(),
                        'transactionId': APISchemaObject.string() 
                      })),
                      'outputs': APISchemaObject.object({
                        'publicKey': APISchemaObject.string(),
                        'gla': APISchemaObject.string()
                      }),
                      'random': APISchemaObject.string(),
                      'id': APISchemaObject.integer(),
                      'nonce': APISchemaObject.string(),
                   }) 
          }),
        }))
          })
        })) 
    // else if (operation.pathVariables.contains("probationem")) {
    //   return { "200":  APIResponse.schema("Fetch the amount of efectus threads", APISchemaObject.object({
    //       "threads": APISchemaObject.integer(),
    //     }))
    //   };
    // } else {
    //   return {
    //     "200": APIResponse.schema("Stop the efectus miner", APISchemaObject.object({
    //       "message": APISchemaObject.string(),
    //       "english": APISchemaObject.string(),
    //     }))
    //   };
    // }
      };
    // }
  }

  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    final personSchema = Confussus().documentSchema(context);
    context.schema.register(
      "Person",
      personSchema,
      representation: Confussus);          
  }
}
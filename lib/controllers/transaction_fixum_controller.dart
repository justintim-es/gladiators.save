import 'dart:io';
import 'dart:isolate';
import 'package:conduit/conduit.dart';
import 'package:elliptic/elliptic.dart';
import 'package:gladiators/models/exampla.dart';
import 'package:gladiators/models/pera.dart';
import 'package:gladiators/models/transaction.dart';
import 'package:gladiators/models/unitas.dart';
import 'package:gladiators/p2p.dart';
import 'package:gladiators/models/errors.dart';
import 'package:conduit_open_api/v3.dart';
import 'package:conduit_common/conduit_common.dart';

class TransactionFixumController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> fixumTxIsolates;

  TransactionFixumController(this.directory, this.p2p, this.fixumTxIsolates);
  @Operation.post()
  Future<Response> submittereFixumTransaction(@Bind.body() SubmittereTransaction unCalcTx) async {
    try {
        if(unCalcTx.gla == BigInt.zero) {
          return Response.badRequest(body: {
            "code": 0,
            "message": "non potest mittere 0",
            "english": "can not send 0"
          });
        }
        BigInt glascha = BigInt.zero;
        switch(unCalcTx.unit) {
          case UnitasClavis.GLA: {
              glascha = Unitas.GLA! * unCalcTx.gla!;
              break;
          };
          case UnitasClavis.GLAD: {
              glascha = Unitas.GLAD! * unCalcTx.gla!;
              break;
          } case UnitasClavis.GLADI: {
              glascha = Unitas.GLADI! * unCalcTx.gla!;
              break;
          } case UnitasClavis.GLADIA: {
              glascha = Unitas.GLADIA! * unCalcTx.gla!;
              break;
          } case UnitasClavis.GLADIAT: {
            glascha = Unitas.GLADIAT! * unCalcTx.gla!;
            break;
          } case UnitasClavis.GLADIATO: {
            glascha = Unitas.GLADIATOR! * unCalcTx.gla!;
            break;
          } case UnitasClavis.GLADIATORS: {
            glascha = Unitas.GLADIATORS! * unCalcTx.gla!;
            break;
          } case UnitasClavis.GLADIATODOTRS: {
            glascha = Unitas.GLADIATORS! * unCalcTx.gla!;
            break;
          } default: {
            glascha = unCalcTx.gla!;
          }
        };
        PrivateKey pk = PrivateKey.fromHex(Pera.curve(), unCalcTx.from!);
        if (pk.publicKey.toHex() == unCalcTx.to) {
          return Response.ok({
            "message": "potest mittere pecuniam publicam clavem",
            "english": "can not send money to the same public key"
          });
        }
        final InterioreTransaction tx = await Pera.novamRem(false, false, unCalcTx.from!, glascha, unCalcTx.to!, p2p.fixumTxs, directory, null);
        ReceivePort acciperePortus = ReceivePort();
        fixumTxIsolates[tx.id] = await Isolate.spawn(Transaction.quaestum, List<dynamic>.from([tx, acciperePortus.sendPort]));
        acciperePortus.listen((transaction) {
            p2p.syncFixumTx(transaction as Transaction);
        });
        return Response.ok({
          "transactionIdentitatis": tx.id
        });
      } on Error catch (err) {
          return Response.badRequest(body: err.toJson());
      }
  }
  @Operation.get()
  Future<Response> fixumTransactionStagnum() async {
    return Response.ok(p2p.fixumTxs.map((e) => e.toJson()).toList());
  }
  @override
  Map<String, APIResponse> documentOperationResponses(APIDocumentContext context, Operation operation) {
    if(operation.method == "POST") {
      return {
        "200": APIResponse.schema("Fetched transaction to stuck transaction pool", APISchemaObject.object({
          "transactionIdentitatis": APISchemaObject.string(),
        })),
        "400": APIResponse.schema("Failed to fetch fixum transaction", APISchemaObject.object({
          "code": APISchemaObject.integer(),
          "message": APISchemaObject.string(),
          "english": APISchemaObject.string()
        }))
      };
    } else {
      return {
        "200": APIResponse.schema("Fetched fixum transaction pool", APISchemaObject.array(ofSchema: APISchemaObject.array(ofSchema: APISchemaObject.object({
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
        }))))
      };
    }
  }
  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    final submittereTransactionSchema = SubmittereTransaction().documentSchema(context);
    context.schema.register(
      "SubmittereTransaction",
      submittereTransactionSchema,
      representation: SubmittereTransaction);          
  }
}
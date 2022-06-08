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
class TransactionFixumController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> fixumTxIsolates;

  TransactionFixumController(this.directory, this.p2p, this.fixumTxIsolates);
  @Operation.post()
  Future<Response> submittereFixumTransaction() async {
    try {
        final SubmittereTransaction unCalcTx = SubmittereTransaction.fromJson(await request!.body.decode());
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
              glascha = Unitas.GLA! * unCalcTx.gla;
              break;
          };
          case UnitasClavis.GLAD: {
              glascha = Unitas.GLAD! * unCalcTx.gla;
              break;
          } case UnitasClavis.GLADI: {
              glascha = Unitas.GLADI! * unCalcTx.gla;
              break;
          } case UnitasClavis.GLADIA: {
              glascha = Unitas.GLADIA! * unCalcTx.gla;
              break;
          } case UnitasClavis.GLADIAT: {
            glascha = Unitas.GLADIAT! * unCalcTx.gla;
            break;
          } case UnitasClavis.GLADIATO: {
            glascha = Unitas.GLADIATOR! * unCalcTx.gla;
            break;
          } case UnitasClavis.GLADIATORS: {
            glascha = Unitas.GLADIATORS! * unCalcTx.gla;
            break;
          } case UnitasClavis.GLADIATODOTRS: {
            glascha = Unitas.GLADIATORS! * unCalcTx.gla;
            break;
          } default: {
            glascha = unCalcTx.gla;
          }
        };
        PrivateKey pk = PrivateKey.fromHex(Pera.curve(), unCalcTx.from);
        if (pk.publicKey.toHex() == unCalcTx.to) {
          return Response.ok({
            "message": "potest mittere pecuniam publicam clavem",
            "english": "can not send money to the same public key"
          });
        }
        final InterioreTransaction tx = await Pera.novamRem(false, false, unCalcTx.from, glascha, unCalcTx.to, p2p.fixumTxs, directory, null);
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
}
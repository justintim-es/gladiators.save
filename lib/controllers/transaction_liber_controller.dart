import 'package:conduit/conduit.dart';
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

class TransactionLiberController extends ResourceController {
  Directory directory;
  P2P p2p;
  Map<String, Isolate> liberTxIsolates;
  TransactionLiberController(this.directory, this.p2p, this.liberTxIsolates);
  
  @Operation.post()
  Future<Response> submittereLiberTransaction() async {
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
            return Response.badRequest(body: Error(code: 2, message: "potest mittere pecuniam publicam clavem", english: "can not send money to the same public key").toJson());
          }
          if (!await Pera.isPublicaClavisDefended(unCalcTx.to, directory) && !await Pera.isProbationum(unCalcTx.to, directory)) {
              return Response.badRequest(body: Error(
                  code: 0,
                  message: "accipientis non defenditur",
                  english: "public key is not defended"
              ).toJson());
          }
          final InterioreTransaction tx =
          await Pera.novamRem(true, true, unCalcTx.from, glascha, unCalcTx.to, p2p.liberTxs, directory, null);
          p2p.liberTxs.add(Transaction.expressi(tx));
          p2p.expressieTxs.add(Transaction.expressi(await Pera.novamRem(true, false, unCalcTx.from, glascha, unCalcTx.to, p2p.liberTxs, directory, tx.id)));
          ReceivePort acciperePortus = ReceivePort();
          liberTxIsolates[tx.id] = await Isolate.spawn(Transaction.quaestum, List<dynamic>.from([tx, acciperePortus.sendPort]));
          acciperePortus.listen((transaction) {
              p2p.syncLiberTx(transaction as Transaction);
          });
          return Response.ok({
            "transactionIdentitatis": tx.id
          });
        } on Error catch (err) {
          return Response.badRequest(body: err.toJson());
        }
  }  

  @Operation.get()
  Future<Response> liberTransactionStagnum() async {
    return Response.ok(p2p.liberTxs.map((e) => e.toJson()).toList());
  }
}
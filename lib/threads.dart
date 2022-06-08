
import 'package:gladiators/p2p.dart';

abstract class Thread {
  final P2P p2p;
  Thread(this.p2p);
  p2p.efectusRp.listen((data) async {
        Obstructionum priorObstructionum = await Utils.priorObstructionum(principalisDirectory);
        List<Propter> propters = [];
        propters.addAll(Gladiator.grab(priorObstructionum.interioreObstructionum.propterDifficultas, p2p.propters));
        List<Transaction> liberTxs = [];
        liberTxs.add(Transaction(Constantes.txObstructionumPraemium, InterioreTransaction(true, [], [TransactionOutput(publicaClavis, Constantes.obstructionumPraemium)], Utils.randomHex(32))));
        liberTxs.addAll(Transaction.grab(priorObstructionum.interioreObstructionum.liberDifficultas, p2p.liberTxs));
        List<Transaction> fixumTxs = [];
        fixumTxs.addAll(Transaction.grab(priorObstructionum.interioreObstructionum.fixumDifficultas, p2p.fixumTxs));
        final obstructionumDifficultas = await Obstructionum.utDifficultas(principalisDirectory);
        List<Isolate> newThreads = [];
        int idx = 0;
        BigInt numerus = BigInt.zero; 
        for (int nuschum in await Obstructionum.utObstructionumNumerus(principalisDirectory)) {
          numerus += BigInt.parse(nuschum.toString());
        }
        ReceivePort acciperePortus = ReceivePort();
        for (int i = 0; i < efectusThreads.length; i++) {
          efectusThreads[i].kill();
          efectusThreads.remove(efectusThreads[i]);
          InterioreObstructionum interiore = InterioreObstructionum.efectus(
              obstructionumDifficultas: obstructionumDifficultas.length,
              divisa: (numerus / await Obstructionum.utSummaDifficultas(principalisDirectory)),
              forumCap: await Obstructionum.accipereForumCap(principalisDirectory),
              liberForumCap: await Obstructionum.accipereForumCapLiberFixum(true, principalisDirectory),
              fixumForumCap: await Obstructionum.accipereForumCapLiberFixum(false, principalisDirectory),
              propterDifficultas: Obstructionum.acciperePropterDifficultas(priorObstructionum),
              liberDifficultas: Obstructionum.accipereLiberDifficultas(priorObstructionum),
              fixumDifficultas: Obstructionum.accipereFixumDifficultas(priorObstructionum),
              summaObstructionumDifficultas: await Obstructionum.utSummaDifficultas(principalisDirectory),
              obstructionumNumerus: await Obstructionum.utObstructionumNumerus(principalisDirectory),
              producentis: publicaClavis,
              priorProbationem: priorObstructionum.probationem,
              gladiator: Gladiator(null, [GladiatorOutput(propters.take((propters.length / 2).round()).toList()), GladiatorOutput(propters.skip((propters.length / 2).round()).toList())], Utils.randomHex(32)),
              liberTransactions: liberTxs,
              fixumTransactions: fixumTxs,
              expressiTransactions: p2p.expressieTxs.where((tx) => liberTxs.any((l) => l.interioreTransaction.id == tx.interioreTransaction.expressi)).toList()
          );
          newThreads.add(await Isolate.spawn(Obstructionum.efectus, List<dynamic>.from([interiore, acciperePortus.sendPort, idx])));
        }
        newThreads.forEach(efectusThreads.add);

        acciperePortus.listen((nuntius) async {
            while (isSalutaris) {
              await Future.delayed(Duration(seconds: 1));

            }
            isSalutaris = true;
            Obstructionum obstructionum = nuntius;
            Obstructionum priorObs = await Utils.priorObstructionum(principalisDirectory);
            if(ListEquality().equals(obstructionum.interioreObstructionum.obstructionumNumerus, priorObs.interioreObstructionum.obstructionumNumerus)) {
              print('invalid blocknumber retrying');
              isSalutaris = false;
              p2p.efectusRp.sendPort.send("update miner");
              return;
            }
            if (priorObs.probationem != obstructionum.interioreObstructionum.priorProbationem) {
              print('invalid probationem');
              isSalutaris = false;
              p2p.efectusRp.sendPort.send("update miner");
              return;
            }
            List<GladiatorOutput> outputs = [];
            for (GladiatorOutput output in obstructionum.interioreObstructionum.gladiator.outputs) {
              output.rationem.map((r) => r.interioreRationem.id).forEach((id) => propterIsolates[id]?.kill(priority: Isolate.immediate));
              outputs.add(output);
            }
            obstructionum.interioreObstructionum.liberTransactions.map((e) => e.interioreTransaction.id).forEach((id) => liberTxIsolates[id]?.kill(priority: Isolate.immediate));
            obstructionum.interioreObstructionum.fixumTransactions.map((e) => e.interioreTransaction.id).forEach((id) => fixumTxIsolates[id]?.kill(priority: Isolate.immediate));
            List<String> gladiatorIds = [];
            for (GladiatorOutput output in outputs) {
              gladiatorIds.addAll(output.rationem.map((r) => r.interioreRationem.id).toList());
            }
            p2p.removePropters(gladiatorIds);
            p2p.removeLiberTxs(obstructionum.interioreObstructionum.liberTransactions.map((l) => l.interioreTransaction.id).toList());
            p2p.removeFixumTxs(obstructionum.interioreObstructionum.fixumTransactions.map((f) => f.interioreTransaction.id).toList());
            p2p.syncBlocks.forEach((element) => element.kill(priority: Isolate.immediate));
            p2p.syncBlocks.add(await Isolate.spawn(P2P.syncBlock, List<dynamic>.from([obstructionum, p2p.sockets, principalisDirectory, '$internum_ip:$p2pPortus'])));
            await obstructionum.salvare(principalisDirectory);
            p2p.expressieTxs = [];
            p2p.efectusRp.sendPort.send("update miner");
            if(p2p.isExpressiActive) {
              p2p.expressiRp.sendPort.send("update miner");
            }
            isSalutaris = false;
        });
    });
}
import 'dart:convert';
import 'package:ecdsa/ecdsa.dart';
import 'package:elliptic/elliptic.dart';
import 'package:gladiators/gladiators.dart';
import 'package:gladiators/models/gladiator.dart';
class ObstructionumNumerus extends Serializable {
  List<int>? numerus;
  Map<String, dynamic> asMap() => {
    'numerus': numerus
  };
  void readFromMap(Map<String, dynamic> map) {
    numerus = List<int>.from(map['numerus'] as List<dynamic>);
  }
}
class KeyPair {
  late String private;
  late String public;
  KeyPair() {
    final ec = getP256();
    final key = ec.generatePrivateKey();
    private = key.toHex();
    public = key.publicKey.toHex();
  }
}
class SubmittereRationem extends Serializable {
  String? publicaClavis;
  Map<String, dynamic> asMap() => {
    'publicaClavis': publicaClavis
  };
  void readFromMap(Map<String, dynamic> map) {
    publicaClavis = map['publicaClavis'].toString();
  }
  // SubmittereRationem.fromJson(Map<String, dynamic> jsoschon):
  // publicaClavis = jsoschon['publicaClavis'].toString();

  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      "publicaClavis": APISchemaObject.string()
    });
  }
}
class SubmittereTransaction {
  final String from;
  final String to;
  final BigInt gla;
  final String? unit;
  SubmittereTransaction(this.from, this.to, this.gla, this.unit);
  SubmittereTransaction.fromJson(Map<String, dynamic> jsoschon):
      to = jsoschon['to'].toString(),
      from = jsoschon['from'].toString(),
      gla = BigInt.parse(jsoschon['gla'].toString()),
      unit = (jsoschon['unit']).toString();
}
class RemoveTransaction {
  final bool liber;
  final String transactionId;
  final String publicaClavis;
  RemoveTransaction(this.liber, this.transactionId, this.publicaClavis);
  RemoveTransaction.fromJson(Map<String, dynamic> jsoschon):
      liber = jsoschon['liber'] as bool,
      transactionId = jsoschon['transactionId'].toString(),
      publicaClavis = jsoschon['publicaClavis'].toString();
}
class Confussus extends Serializable {
  int? index;
  String? gladiatorId;
  String? privateKey;
  Map<String, dynamic> asMap() => {
    'index': index,
    'gladiatorId': gladiatorId,
    'privateKey': privateKey
  };
  void readFromMap(Map<String, dynamic> map) {
    index = int.parse(map['index'].toString());
    gladiatorId = map['gladiatorId'].toString();
    privateKey = map['privateKey'].toString();
  }
  APISchemaObject documentSchema(APIDocumentContext context) {
    return APISchemaObject.object({
      "index": APISchemaObject.string(),
      "gladiatorId": APISchemaObject.string(),
      "privateKey": APISchemaObject.string()
    });
  }
  // Confussus.fromJson(Map<String, dynamic> jsoschon):
  // index = int.parse(jsoschon['index'].toString()),
  // gladiatorId = jsoschon['gladiatorId'].toString(),
  // privateKey = jsoschon['privateKey'].toString();
}
// class FurcaConfussus extends Confussus {
//   List<int> numerus;
//   FurcaConfussus.fromJson(Map<String, dynamic> jsoschon):
//     numerus = List<int>.from(jsoschon['numerus'] as List<int>), super.fromJson(jsoschon);
// }
class TransactionInfo {
  final bool includi;
  final List<String> priorTxIds;
  final int? indicatione;
  final List<int>? obstructionumNumerus;
  final BigInt? confirmationes;
  TransactionInfo(this.includi, this.priorTxIds, this.indicatione, this.obstructionumNumerus, this.confirmationes);

  Map<String, dynamic> toJson() => {
    'includi': includi,
    'confirmationes': confirmationes.toString(),
    'priorTxIds': priorTxIds,
    'indicatione': indicatione,
    'obstructionumNumerus': obstructionumNumerus,
  };
}
class PropterInfo {
  final bool includi;
  final int index;
  final int? indicatione;
  final List<int>? obstructionumNumerus;
  final String? defensio;
  PropterInfo(this.includi, this.index, this.indicatione, this.obstructionumNumerus, this.defensio);

  Map<String, dynamic> toJson() => {
    'includi': includi,
    'index': index,
    'indicatione': indicatione,
    'obstructionumNumerus': obstructionumNumerus,
    'defensio': defensio,
  };
}
class Probationems {
  final List<int> firstIndex;
  final List<int> lastIndex;
  Probationems(this.firstIndex, this.lastIndex);

  Map<String, dynamic> asMap() => {
    'firstIndex': firstIndex,
    'lastIndex': lastIndex
  };
  Probationems.fromJson(Map<String, dynamic> jsoschon):
    firstIndex = List<int>.from(jsoschon['firstIndex'] as List<dynamic>),
    lastIndex = List<int>.from(jsoschon['lastIndex'] as List<dynamic>);
}
class InvictosGladiator {
  String id;
  GladiatorOutput output;
  int index;
  InvictosGladiator(this.id, this.output, this.index);

  Map<String, dynamic> toJson() => {
    'id': id,
    'output': output.toJson(),
    'index': index
  };
}
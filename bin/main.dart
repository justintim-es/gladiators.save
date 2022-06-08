import 'package:gladiators/gladiators.dart';
import 'package:args/args.dart';
Future main() async {
    // var parser = ArgParser();
    // parser.addOption('publica-clavis');
    // parser.addOption('bootnode');
    // parser.addOption('max-pares', defaultsTo: '50');
    // parser.addOption('p2p-portus', defaultsTo: '5151');
    // parser.addOption('rpc-portus', defaultsTo: '1515');
    // parser.addOption('internum-ip', mandatory: true);
    // parser.addOption('external-ip', mandatory: true);
    // parser.addOption('novus', help: 'Do you want to start a new chain?', mandatory: true);
    // parser.addOption('directory', help: 'where should we save the blocks', mandatory: true);

  final app = Application<GladiatorsChannel>()
    ..options.configurationFilePath = "config.yaml"
    ..options.port = 8888;

  await app.startOnCurrentIsolate();

  print("Application started on port: ${app.options.port}.");
  print("Use Ctrl-C (SIGINT) to stop running the application.");
}

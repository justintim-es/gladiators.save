export 'package:conduit_open_api/v3.dart';
export 'package:conduit_common/conduit_common.dart';

import 'package:gladiators/gladiators.dart';

class Repository implements APIComponentDocumenter {
  @override
  void documentComponents(APIDocumentContext context) {
    super.documentComponents(context);

    context.schema.register("ObstructionumRespository",
        APISchemaObject.object({
          "id": APISchemaObject.integer(),
          "name": APISchemaObject.string()
        }));          
  }
}
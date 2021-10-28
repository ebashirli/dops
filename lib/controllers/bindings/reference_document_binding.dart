import 'package:get/get.dart';
import '../reference_document_controller.dart';

class ReferenceDocumentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferenceDocumentController>(
      () => ReferenceDocumentController(),
    );
  }
}

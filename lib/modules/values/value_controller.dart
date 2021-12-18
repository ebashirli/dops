import 'package:dops/modules/values/value_model.dart';
import 'package:dops/modules/values/values_repository.dart';
import 'package:get/get.dart';
import '../../components/custom_widgets.dart';

class ValueController extends GetxService {
  final _repository = Get.find<ValueRepository>();
  static ValueController instance = Get.find();

  RxList<ValueModel?> _documents = RxList<ValueModel?>([]);
  List<ValueModel?> get documents => _documents;

  addNew({required ValueModel model}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.add(model);
    CustomFullScreenDialog.cancelDialog();
  }

  addValues({required Map<String, dynamic> map, required String id}) async {
    CustomFullScreenDialog.showDialog();
    await _repository.addFields(map, id);
    CustomFullScreenDialog.cancelDialog();
  }

  @override
  void onInit() {
    super.onInit();
    _documents.bindStream(_repository.getAllDocumentsAsStream());
  }

  @override
  void onReady() {
    super.onReady();
  }

  List<Map<String, dynamic>> get getDataForTableView {
    return documents.map((refDoc) {
      String assignedTasks = '';

      if (documents.isNotEmpty) {
        taskController.documents.forEach((task) {
          List<DrawingModel> drawing = drawingController.documents
              .where((drawing) => drawing.id == task!.parentId)
              .toList();
          if (drawing.isNotEmpty) {
            final String drawingNumber = drawing[0].drawingNumber;

            if (task!.designDrawings.contains(refDoc.documentNumber))
              assignedTasks += '|${drawingNumber};${task.id}';
          }
        });
      }

      Map<String, dynamic> map = {
        'id': refDoc.id,
        'project': !refDoc.actionRequiredOrNext ? 'Action required' : 'Next',
        'referenceType': refDoc.referenceType,
        'moduleName': refDoc.moduleName,
        'documentNumber': refDoc.documentNumber,
        'title': refDoc.title,
        'transmittalNumber': refDoc.transmittalNumber,
        'receivedDate': refDoc.receivedDate,
        'actionRequiredOrNext': refDoc.actionRequiredOrNext,
        'assignedTasks': assignedTasks,
      };

      return map;
    }).toList();
  }

}

import 'package:get/get.dart';

abstract class BaseViewController<T> extends GetxService {
  @override
  void onInit() => super.onInit();
  bool get loading;
  List<Map<String, dynamic>?> get tableData;
  List<T> get documents;
  void buildUpdateForm({required String id});
  void buildAddForm({String? parentId});
}

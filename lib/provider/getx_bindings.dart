import 'package:bachelor_room/provider/application_provider.dart';
import 'package:bachelor_room/provider/firestore_provider.dart';
import 'package:bachelor_room/provider/auth_provider.dart';
import 'package:get/get.dart';

class GetxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AuthProvider());
    Get.lazyPut(() => FirestoreProvider());
    Get.lazyPut(() => AppProvider(), fenix: true);
  }
}

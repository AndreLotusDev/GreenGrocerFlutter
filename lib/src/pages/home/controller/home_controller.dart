import 'package:get/get.dart';
import 'package:loja_virtual/src/models/category_model.dart';
import 'package:loja_virtual/src/pages/home/repository/home_repository.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    getAllCategories();
  }

  final homeRepository = HomeRepository();

  final utilServices = UtilsServices();

  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory = null;

  bool isLoading = false;

  void setLoading(bool value) {
    isLoading = value;

    update();
  }

  void selectCategory(CategoryModel toBeSelected) {
    currentCategory = toBeSelected;

    update();
  }

  Future<void> getAllCategories() async {
    setLoading(true);

    var homeResult = await homeRepository.getAllCategories();

    setLoading(false);

    homeResult.when(
      success: (categories) {
        allCategories.assignAll(categories);

        if (allCategories.isEmpty) {
          return;
        }

        selectCategory(allCategories.first);
      },
      error: (message) {
        utilServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }
}

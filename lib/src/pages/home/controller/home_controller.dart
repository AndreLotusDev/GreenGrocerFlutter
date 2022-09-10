import 'package:get/get.dart';
import 'package:loja_virtual/src/models/category_model.dart';
import 'package:loja_virtual/src/models/item_model.dart';
import 'package:loja_virtual/src/pages/home/repository/home_repository.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

const int itemsPerPage = 6;

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    getAllCategories();
  }

  final homeRepository = HomeRepository();

  final utilServices = UtilsServices();

  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;

  List<ItemModel> get allProducts => currentCategory?.items ?? [];

  bool isLoadingCategory = false;
  bool isLoadingProducts = true;

  void setLoadingCategory(bool value) {
    isLoadingCategory = value;

    update();
  }

  void setLoadingProduct(bool value) {
    isLoadingProducts = value;

    update();
  }

  void selectCategory(CategoryModel toBeSelected) {
    currentCategory = toBeSelected;

    update();

    if (currentCategory!.items.isNotEmpty) {
      return;
    }

    getAllProducts();
  }

  Future<void> getAllCategories() async {
    setLoadingCategory(true);

    var homeResult = await homeRepository.getAllCategories();

    setLoadingCategory(false);

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

  Future<void> getAllProducts() async {
    setLoadingProduct(true);

    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      "itemPerPage": itemsPerPage
    };

    var result = await homeRepository.getAllProducts(body);

    setLoadingProduct(false);

    result.when(
      success: (products) {
        currentCategory!.items = products;
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

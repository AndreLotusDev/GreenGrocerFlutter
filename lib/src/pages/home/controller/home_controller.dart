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

    debounce(
      searchTitle,
      (_) => filterByTitle(),
      time: const Duration(milliseconds: 600),
    );

    getAllCategories();
  }

  final homeRepository = HomeRepository();

  final utilServices = UtilsServices();

  List<CategoryModel> allCategories = [];
  CategoryModel? currentCategory;

  List<ItemModel> get allProducts => currentCategory?.items ?? [];
  bool get isLastPage {
    if (currentCategory!.items.length > itemsPerPage) {
      return true;
    }

    return currentCategory!.pagination * itemsPerPage > allProducts.length;
  }

  bool isLoadingCategory = false;
  bool isLoadingProducts = true;

  RxString searchTitle = ''.obs;

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

  Future<void> getAllProducts({bool shouldLoad = true}) async {
    if (shouldLoad) setLoadingProduct(true);

    Map<String, dynamic> body = {
      'page': currentCategory!.pagination,
      'categoryId': currentCategory!.id,
      "itemPerPage": itemsPerPage
    };

    if (searchTitle.value.isNotEmpty) {
      body['title'] = searchTitle.value;

      if (currentCategory!.id == '') {
        body.remove('categoryId');
      }
    }

    var result = await homeRepository.getAllProducts(body);

    if (shouldLoad) setLoadingProduct(false);

    result.when(
      success: (products) {
        currentCategory!.items.addAll(products);
      },
      error: (message) {
        utilServices.showToast(
          message: message,
          isError: true,
        );
      },
    );
  }

  void filterByTitle() {
    for (var category in allCategories) {
      category.items.clear();

      category.pagination = 0;
    }

    if (searchTitle.value.isEmpty) {
      allCategories.removeAt(0);
    } else {
      CategoryModel? c = allCategories.firstWhereOrNull((cat) => cat.id == '');

      if (c == null) {
        final allProductsCategory = CategoryModel(
          title: 'Todos',
          id: '',
          items: [],
          pagination: 0,
        );

        allCategories.insert(0, allProductsCategory);
      } else {
        c.items.clear();
        c.pagination = 0;
      }
    }

    currentCategory = allCategories.first;

    update();

    getAllProducts();
  }

  void loadMoreProducts() {
    currentCategory!.pagination++;

    getAllProducts();
  }
}

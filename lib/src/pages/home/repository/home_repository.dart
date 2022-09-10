import 'package:loja_virtual/src/constants/endpoints.dart';
import 'package:loja_virtual/src/models/category_model.dart';
import 'package:loja_virtual/src/pages/home/result/home_result.dart';
import 'package:loja_virtual/src/services/http_manager.dart';

class HomeRepository {
  final HttpManager _httpManager = HttpManager();

  Future<HomeResult<CategoryModel>> getAllCategories() async {
    var result = await _httpManager.restRequest(
      url: Endpoints.getAllCategories,
      method: HttpMethods.post,
    );

    if (result['result'] != null) {
      List<CategoryModel> data =
          (List<Map<String, dynamic>>.from(result['result']))
              .map(CategoryModel.fromJson)
              .toList();

      return HomeResult<CategoryModel>.success(data);
    } else {
      return HomeResult.error(
          'Ocorreu um erro inesperado ao recuperar as categorias');
    }
  }
}

import 'dart:async';

import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/pages/common_widgets/custom_shimmer.dart';
import 'package:loja_virtual/src/pages/home/view/component/item_tile.dart';
import 'package:loja_virtual/src/services/utils_services.dart';
import '../../common_widgets/app_name.dart';
import 'package:loja_virtual/src/config/app_data.dart' as app_data;

import '../controller/home_controller.dart';
import 'component/category_tile.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final searchController = TextEditingController();

  GlobalKey<CartIconKey> globalKeyCartItens = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  void itemSelectedCartAnimation(GlobalKey gkImage) {
    runAddToCartAnimation(gkImage);
  }

  final UtilsServices utilsServices = UtilsServices();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(190),
      //APP BAR
      appBar: AppBar(
        backgroundColor: Colors.white.withAlpha(190),
        elevation: 0,
        centerTitle: true,
        title: AppName(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 15, right: 15),
            child: GestureDetector(
              onTap: () {},
              child: Badge(
                badgeColor: CustomColors.customContrastColor,
                badgeContent: const Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: AddToCartIcon(
                  key: globalKeyCartItens,
                  icon: Icon(
                    Icons.shopping_cart,
                    color: CustomColors.customSwatchColor,
                  ),
                ),
              ),
            ),
          )
        ],
      ),

      //LISTA DE PRODUTOS
      body: AddToCartAnimation(
        gkCart: globalKeyCartItens,
        previewDuration: const Duration(milliseconds: 100),
        previewCurve: Curves.ease,
        receiveCreateAddToCardAnimationMethod: (addToCartAnimationMethod) {
          runAddToCartAnimation = addToCartAnimationMethod;
        },
        child: Column(
          children: [
            //CAMPO DE PESQUISA
            GetBuilder<HomeController>(builder: (controller) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (value) {
                    controller.searchTitle.value = value;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Pesquise aqui...',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    prefixIcon: Icon(
                      Icons.search,
                      color: CustomColors.customContrastColor,
                      size: 21,
                    ),
                    suffixIcon: controller.searchTitle.value.isEmpty
                        ? null
                        : IconButton(
                            icon: Icon(
                              Icons.close,
                              color: CustomColors.customContrastColor,
                              size: 21,
                            ),
                            onPressed: () {
                              searchController.clear();
                              controller.searchTitle.value = '';
                              Focus.of(context).unfocus();
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(60),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                ),
              );
            }),

            //LISTA DE OPCOES DE PRODUTOS
            GetBuilder<HomeController>(
              builder: (controller) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  height: 40,
                  child: !controller.isLoadingCategory
                      ? ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (_, index) {
                            return CategoryTile(
                              externalCall: () {
                                controller.selectCategory(
                                    controller.allCategories[index]);
                              },
                              category: controller.allCategories[index].title,
                              isSelected: controller.allCategories[index] ==
                                  controller.currentCategory,
                            );
                          },
                          separatorBuilder: (_, index) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: controller.allCategories.length,
                        )
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                            10,
                            (index) => CustomShimmer(
                              height: 20,
                              width: 80,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                );
              },
            ),

            //GRID VIEW
            GetBuilder<HomeController>(
              builder: (controller) {
                return Expanded(
                  child: !controller.isLoadingCategory
                      ? Visibility(
                          visible: (controller.currentCategory?.items ?? [])
                              .isNotEmpty,
                          replacement: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 40,
                                color: CustomColors.customSwatchColor,
                              ),
                              const Text('Não há itens para apresentar')
                            ],
                          ),
                          child: GridView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 30, 16, 16),
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 9 / 11.5),
                              itemCount: controller.allProducts.length,
                              itemBuilder: (_, index) {
                                var isNotTheLastItem = (index + 1) ==
                                    controller.allCategories.length;
                                if (isNotTheLastItem &&
                                    !controller.isLastPage) {
                                  controller.loadMoreProducts();
                                }

                                return ItemTile(
                                  item: controller.allProducts[index],
                                  cartAnimationMethod:
                                      itemSelectedCartAnimation,
                                );
                              }),
                        )
                      : GridView.count(
                          padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                          physics: const BouncingScrollPhysics(),
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 9 / 11.5,
                          children: List.generate(
                            10,
                            (index) => CustomShimmer(
                              height: double.infinity,
                              width: double.infinity,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

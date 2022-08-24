import 'package:add_to_cart_animation/add_to_cart_animation.dart';
import 'package:add_to_cart_animation/add_to_cart_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/src/config/custom_colors.dart';
import 'package:loja_virtual/src/pages/common_widgets/custom_shimmer.dart';
import 'package:loja_virtual/src/pages/home/component/item_tile.dart';
import 'package:loja_virtual/src/services/utils_services.dart';
import 'package:shimmer/shimmer.dart';
import '../common_widgets/app_name.dart';
import 'component/category_tile.dart';
import 'package:loja_virtual/src/config/app_data.dart' as app_data;

class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String selectedCategory = 'Frutas';

  GlobalKey<CartIconKey> globalKeyCartItens = GlobalKey<CartIconKey>();
  late Function(GlobalKey) runAddToCartAnimation;

  void itemSelectedCartAnimation(GlobalKey gkImage) {
    runAddToCartAnimation(gkImage);
  }

  bool isLoading = false;

  final UtilsServices utilsServices = UtilsServices();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        isLoading = true;
      });
    });
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextFormField(
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(60),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none))),
              ),
            ),

            //LISTA DE OPCOES DE PRODUTOS
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                height: 40,
                child: isLoading
                    ? ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (_, index) {
                          return CategoryTile(
                            category: app_data.categories[index],
                            isSelected:
                                app_data.categories[index] == selectedCategory,
                            externalCall: () {
                              setState(() {
                                selectedCategory = app_data.categories[index];
                              });
                            },
                          );
                        },
                        separatorBuilder: (_, index) => const SizedBox(
                          width: 10,
                        ),
                        itemCount: app_data.categories.length,
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
                      )),

            //GRIDVIEW
            Expanded(
              child: isLoading
                  ? GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 9 / 11.5),
                      itemCount: app_data.items.length,
                      itemBuilder: (_, index) {
                        return ItemTile(
                          item: app_data.items[index],
                          cartAnimationMethod: itemSelectedCartAnimation,
                        );
                      })
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
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yehlo_User/features/cart/controllers/cart_controller.dart';
import 'package:yehlo_User/features/item/controllers/item_controller.dart';
import 'package:yehlo_User/features/item/domain/models/item_model.dart';
import 'package:yehlo_User/util/dimensions.dart';
import 'package:yehlo_User/util/styles.dart';

class CartCountView extends StatelessWidget {
  final Item item;
  final Widget? child;
  const CartCountView({super.key, required this.item, this.child});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(builder: (cartController) {
      int cartQty = cartController.cartQuantity(item.id!);
      int cartIndex = cartController.isExistInCart(
          item.id, cartController.cartVariant(item.id!), false, null);
      return cartQty != 0
          ? Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius:
                      BorderRadius.circular(Dimensions.radiusExtraLarge),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: cartController.isLoading
                            ? null
                            : () {
                                if (cartController
                                        .cartList[cartIndex].quantity! >
                                    1) {
                                  cartController.setQuantity(
                                      false,
                                      cartIndex,
                                      cartController.cartList[cartIndex].stock,
                                      cartController.cartList[cartIndex].item!
                                          .quantityLimit);
                                } else {
                                  cartController.removeFromCart(cartIndex);
                                }
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Icon(
                            Icons.remove,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Dimensions.paddingSizeSmall),
                        child: !cartController.isLoading
                            ? Text(
                                cartQty.toString(),
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeSmall,
                                    color: Theme.of(context).cardColor),
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                    color: Theme.of(context).cardColor)),
                      ),
                      InkWell(
                        onTap: cartController.isLoading
                            ? null
                            : () {
                                cartController.setQuantity(
                                    true,
                                    cartIndex,
                                    cartController.cartList[cartIndex].stock,
                                    cartController
                                        .cartList[cartIndex].quantityLimit);
                              },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                          ),
                          padding: const EdgeInsets.all(
                              Dimensions.paddingSizeExtraSmall),
                          child: Icon(
                            Icons.add,
                            size: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ]),
              ),
            )
          : InkWell(
              onTap: () {
                Get.find<ItemController>().itemDirectlyAddToCart(item, context);
              },
              child: child ?? 
                  Container(
                      height: 35,
                      width: 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(
                            Radius.circular(Dimensions.radiusSmall)),
                      ),
                      child: Center(
                          child: Text(
                        'Add to Cart',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ))

                      // Icon(
                      //   isPopularItemCart ? Icons.add_shopping_cart : Icons.add,
                      //   color: Theme.of(context).cardColor, size: 20),
                      ),
            );
    });
  }
}

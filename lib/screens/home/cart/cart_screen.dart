import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lion_sales/blocs/bloc.dart';
import 'package:lion_sales/reusable_widgets/app_button.dart';
import 'package:lion_sales/reusable_widgets/app_text_field.dart';
import 'package:lion_sales/screens/home/cart/cart_bloc.dart';
import 'package:lion_sales/screens/home/cart/cart_dl.dart';
import 'package:lion_sales/utils/constant_colors.dart';
import 'package:lion_sales/utils/constant_strings.dart';
import 'package:lion_sales/utils/constant_variables.dart';
import 'package:lion_sales/utils/extensions.dart';
import 'package:lion_sales/utils/utils.dart';

import '../../../reusable_widgets/appBar/custom_appbar.dart';
import '../../../reusable_widgets/app_loading_widget.dart';
import '../../../reusable_widgets/app_loading_widget_two.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.currentIndex});
  final int? currentIndex;
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBloc? bloc;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      if (widget.currentIndex == 3) {
        bloc = CartBloc(context, this)
          ..onGetCartList()
          ..checkIfUserExist();
      }
    }
  }

  @override
  void dispose() {
    if (bloc != null) {
      bloc!.dispose();
    }
    super.dispose();
  }

  CartUser? selectedValue;

  @override
  Widget build(BuildContext context) {
    return bloc == null
        ? Container()
        : SafeArea(
            child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(
                kToolbarHeight,
              ),
              child: CustomAppBar(
                title: ConstantStrings.CART,
                showBackButton: false,
                onTap: () {},
              ),
            ),
            body: GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus!.unfocus();
              },
              child: KeyboardVisibilityBuilder(
                builder: (
                  a,
                  isKeyBoardVisible,
                ) =>
                    GestureDetector(
                  onTap: () {
                    bloc!.closeKeyBoard(isKeyBoardVisible);
                  },
                  child: Center(
                    child: StreamBuilder<ApiResponse<CartListModel>>(
                        stream: bloc!.cartSubject,
                        initialData: ApiResponse.loading(),
                        builder: (context, snapshot) {
                          bool isLoading = false;
                          if (!snapshot.hasError) {
                            isLoading = snapshot.hasData &&
                                snapshot.data?.status == Status.loading;
                          }
                          return snapshot.data!.status == Status.error
                              ? Center(child: Text(snapshot.data!.message!))
                              : isLoading
                                  ? const Center(
                                      child: AppLoadingWidget(),
                                    )
                                  : snapshot.data!.data!.cartList.isEmpty
                                      ? const Center(
                                          child: Text("Cart is Empty"),
                                        )
                                      : snapshot.data!.data!.cartList.first
                                              .products.isEmpty
                                          ? const Center(
                                              child: Text("Cart is Empty"),
                                            )
                                          : StreamBuilder<ApiResponse>(
                                              stream: bloc!.addOrRemoveSubject,
                                              initialData:
                                                  ApiResponse.completed(),
                                              builder:
                                                  (context, loadingSnapshot) {
                                                bool isLoadingTwo =
                                                    loadingSnapshot.hasData &&
                                                        loadingSnapshot
                                                                .data!.status ==
                                                            Status.loading;
                                                return Stack(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  children: [
                                                    SizedBox(
                                                      height:
                                                          context.height / 0.68,
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                              height: context
                                                                      .height /
                                                                  90,
                                                            ),
                                                            SearchUserWidget(
                                                                cartBloc:
                                                                    bloc!),
                                                            Padding(
                                                              padding: EdgeInsets.only(
                                                                  right: context
                                                                          .width /
                                                                      20),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  StreamBuilder<
                                                                          ApiResponse>(
                                                                      stream: bloc!
                                                                          .clearCartSubject,
                                                                      builder:
                                                                          (context,
                                                                              snapshot) {
                                                                        var isLoading =
                                                                            snapshot.hasData &&
                                                                                snapshot.data?.status == Status.loading;
                                                                        return isLoading
                                                                            ? Padding(
                                                                                padding: EdgeInsets.symmetric(horizontal: context.width / 40, vertical: context.height / 80),
                                                                                child: const AppLoadingWidget(),
                                                                              )
                                                                            : TextButton(
                                                                                // onPressed: () => bloc!.clearCart(),
                                                                                onPressed: () {
                                                                                  showClearCartDialog(context);
                                                                                },
                                                                                child: Text(
                                                                                  "Clear Cart",
                                                                                  style: poppinsTextStyle(fontWeight: FontWeight.w500, textColor: ConstantColors.appPrimaryColor),
                                                                                ));
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                            ...List.generate(
                                                                snapshot
                                                                    .data!
                                                                    .data!
                                                                    .cartList
                                                                    .first
                                                                    .products
                                                                    .length,
                                                                (index) =>
                                                                    Slidable(
                                                                      endActionPane: ActionPane(
                                                                          extentRatio:
                                                                              0.2,
                                                                          motion:
                                                                              const DrawerMotion(),
                                                                          dragDismissible:
                                                                              true,
                                                                          children: [
                                                                            SlidableAction(
                                                                              borderRadius: BorderRadius.circular(20),
                                                                              spacing: 0,
                                                                              autoClose: true,
                                                                              flex: 5,
                                                                              onPressed: (value) {
                                                                                bloc!.removeProductFromCart(productId: snapshot.data!.data!.cartList.first.products[index].productId);
                                                                              },
                                                                              backgroundColor: Colors.red,
                                                                              foregroundColor: Colors.white,
                                                                              icon: Icons.delete,
                                                                              label: 'Delete',
                                                                            ),
                                                                          ]),
                                                                      child:
                                                                          CartTile(
                                                                        bloc:
                                                                            bloc!,
                                                                        cartProduct: snapshot
                                                                            .data!
                                                                            .data!
                                                                            .cartList
                                                                            .first
                                                                            .products[index],
                                                                      ),
                                                                    )),
                                                            SizedBox(
                                                              height: context
                                                                      .height /
                                                                  40,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: context
                                                                        .width /
                                                                    25,
                                                                right: context
                                                                        .width /
                                                                    25,
                                                              ),
                                                              child: Form(
                                                                key: bloc!
                                                                    .formKey,
                                                                child:
                                                                    MyTextField(
                                                                  onFieldSubmitted:
                                                                      (v) {},
                                                                  maxLength:
                                                                      300,
                                                                  maxLines: 3,
                                                                  validate:
                                                                      (v) {
                                                                    return v!
                                                                            .isEmpty
                                                                        ? "Please provide description"
                                                                        : null;
                                                                  },
                                                                  textColor:
                                                                      false,
                                                                  labelText:
                                                                      "Note",
                                                                  controller: bloc!
                                                                      .descriptionTextController,
                                                                  hintText:
                                                                      "Note",
                                                                  action:
                                                                      TextInputAction
                                                                          .done,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                                height: context
                                                                        .height /
                                                                    20),
                                                            StreamBuilder<
                                                                    ApiResponse>(
                                                                stream: bloc!
                                                                    .sendOrderSubject,
                                                                initialData:
                                                                    ApiResponse
                                                                        .completed(),
                                                                builder: (context,
                                                                    snapshotThree) {
                                                                  bool isLoadingThree = snapshotThree
                                                                          .hasData &&
                                                                      snapshotThree
                                                                              .data!
                                                                              .status ==
                                                                          Status
                                                                              .loading;
                                                                  return isLoadingThree
                                                                      ? const Center(
                                                                          child:
                                                                              AppLoadingWidget())
                                                                      : Padding(
                                                                          padding:
                                                                              EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                context.width / 10,
                                                                          ),
                                                                          child: AppButtonTwo(
                                                                              height: context.height / 17,
                                                                              width: context.width / 2,
                                                                              onTap: () {
                                                                                bloc!.sendOrder();
                                                                              },
                                                                              text: ConstantStrings.SEND_ORDER),
                                                                        );
                                                                }),
                                                            isKeyBoardVisible
                                                                ? SizedBox(
                                                                    height:
                                                                        context.height /
                                                                            2.7)
                                                                : SizedBox(
                                                                    height:
                                                                        context.height /
                                                                            15),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                        child: isLoadingTwo
                                                            ? const AppLoadingWidgetTwo()
                                                            : const SizedBox
                                                                .shrink()),
                                                  ],
                                                );
                                              });
                        }),
                  ),
                ),
              ),
            ),
          ));
  }

  Future<dynamic> showClearCartDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (c) => StreamBuilder<ApiResponse>(
            stream: bloc!.clearCartSubject,
            builder: (context, snapshot) {
              bool isLoading =
                  snapshot.hasData && snapshot.data!.status == Status.loading;
              return Stack(
                alignment: AlignmentDirectional.center,
                children: [
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    actionsPadding: EdgeInsets.symmetric(
                        horizontal: context.width / 20,
                        vertical: context.height / 40),
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: context.width / 20,
                        vertical: context.height / 40),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ConstantStrings.CONFIRMATION,
                          maxLines: 3,
                          style: poppinsTextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              textColor: ConstantColors.appPrimaryColor),
                        ),
                      ],
                    ),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: context.width / 1.5,
                          child: Text(
                            ConstantStrings.CLEAR_CART_MESSAGE,
                            style: poppinsTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                textColor: ConstantColors.appBlackColor),
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                    actionsAlignment: MainAxisAlignment.spaceAround,
                    actions: [
                      GestureDetector(
                        onTap: isLoading
                            ? () {}
                            : () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                              },
                        child: Text(ConstantStrings.NO,
                            style: poppinsTextStyle(
                                fontSize: 15,
                                textColor: ConstantColors.appBlackColor)),
                      ),
                      SizedBox(
                        width: context.width / 45,
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? () {}
                            : () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                bloc!.clearCart();
                              },
                        child: Text(ConstantStrings.YES,
                            style: poppinsTextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.normal,
                                textColor: ConstantColors.appPrimaryColor)),
                      ),
                    ],
                  ),
                ],
              );
            }));
  }
}

class CartTile extends StatelessWidget {
  const CartTile(
      {super.key, required CartProduct cartProduct, required CartBloc bloc})
      : _cartProduct = cartProduct,
        _bloc = bloc;
  final CartProduct _cartProduct;
  final CartBloc _bloc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: context.width / 30,
          right: context.width / 30,
          bottom: context.height / 200),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.only(
              top: context.height / 50,
              bottom: context.height / 50,
              left: context.width / 35),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                _cartProduct.imagePath,
                height: context.width / 5,
                width: context.width / 5,
                fit: BoxFit.fitHeight,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: context.width / 80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.width / 3,
                        child: Text(
                          _cartProduct.productName,
                          overflow: TextOverflow.ellipsis,
                          style: poppinsTextStyle(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: context.width / 2.55,
                          ),
                          Padding(
                            padding: EdgeInsets.zero,
                            // .only(right: context.width / 50),
                            child: Container(
                              width: context.width / 4.2,
                              // height: context.height / 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: ConstantColors.colorGreyLightBorder,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_cartProduct.quantity > 0) {
                                        _bloc.decrementProductFromCart(
                                            productId: _cartProduct.productId);
                                      }
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: context.width / 200,
                                        left: context.width / 200,
                                        bottom: context.width / 200,
                                      ),
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          bottomLeft: Radius.circular(5),
                                        ),
                                        color: ConstantColors.appWhiteColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.remove,
                                          size: context.width / 35,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _cartProduct.quantity.toString(),
                                    style: poppinsTextStyle(),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _bloc.addToCart(
                                          productId: _cartProduct.productId);
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: ConstantColors.colorGreen,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Icon(
                                          Icons.add,
                                          color: ConstantColors.appWhiteColor,
                                          size: context.width / 35,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '\$${_cartProduct.amount}',
                        style: poppinsTextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchUserWidget extends StatelessWidget {
  const SearchUserWidget({super.key, required this.cartBloc});
  final CartBloc cartBloc;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        cartBloc.populateSearchUsers();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => SearchUserScreen(cartBloc: cartBloc)));
      },
      child: StreamBuilder(
          initialData: null,
          stream: cartBloc.selectedDropDownValue,
          builder: (
            context,
            selectedUser,
          ) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.width / 20,
              ),
              child: Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: ConstantColors.colorGrey, width: 1.5),
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.width / 40,
                      vertical: context.height / 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      selectedUser.data == null
                          ? Text(
                              "Search User",
                              style: poppinsTextStyle(
                                  fontWeight: FontWeight.w400,
                                  textColor: ConstantColors.colorGreyText),
                            )
                          : SizedBox(
                              width: deviceWidth / 1.3,
                              child: Text(
                                selectedUser.data!.name,
                                overflow: TextOverflow.ellipsis,
                                style: poppinsTextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                      const Icon(
                        Icons.search,
                        color: ConstantColors.colorGrey,
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class SearchUserScreen extends StatelessWidget {
  const SearchUserScreen({super.key, required this.cartBloc});
  final CartBloc cartBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          StreamBuilder<bool>(
              stream: cartBloc.isSearching,
              initialData: false,
              builder: (context, searchSnapShot) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.width / 60,
                      vertical: context.height / 100),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                        ),
                      ),
                      SizedBox(width: context.width / 50),
                      Expanded(
                        child: UserSearchField(
                            clearText: () => cartBloc.clearText(),
                            onTextChange: (v) =>
                                cartBloc.onSearchFieldChange(v!),
                            validate: (v) {
                              if (v!.isEmpty) {
                                return "Please type some text";
                              }
                              return null;
                            },
                            isSearching: searchSnapShot.data!,
                            controller: cartBloc.searchUserTextController,
                            hintText: "Search"),
                      ),
                    ],
                  ),
                );
              }),
          StreamBuilder<List<CartUser>>(
              initialData: cartBloc.userSearchResult.value,
              stream: cartBloc.userSearchResult,
              builder: (context, userList) {
                return Expanded(
                  child: ListView.builder(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (c, i) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: getRandomDarkColor(),
                        child: Text(
                          userList.data![i].name.characters.first.toUpperCase(),
                          style: poppinsTextStyle(
                              textColor: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      onTap: () {
                        cartBloc.selectFromSearch(userList.data![i]);
                      },
                      title: Text(userList.data![i].name),
                    ),
                    itemCount: userList.data!.length,
                    shrinkWrap: true,
                  ),
                );
              })
        ],
      ),
    );
  }

  Color getRandomDarkColor() {
    // Get a random number between 0 and 255.
    num r = math.Random().nextInt(255);
    num g = math.Random().nextInt(255);
    num b = math.Random().nextInt(255);

    // Check if the color is light or dark.
    bool isDarkColor = (r + g + b) / 3 < 128;

    // If the color is light, make it darker.
    if (isDarkColor) {
      r = r * 0.7;
      g = g * 0.7;
      b = b * 0.7;
    }

    // Return the random dark color.
    return Color.fromRGBO(r.toInt(), g.toInt(), b.toInt(), 1.0);
  }
}

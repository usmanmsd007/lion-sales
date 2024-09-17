import 'package:flutter/material.dart';
import 'package:lion_sales/reusable_widgets/app_text_field.dart';
import 'package:lion_sales/screens/home/products/product_bloc.dart';

class MySearchTextField extends StatelessWidget {
  const MySearchTextField({
    super.key,
    required ProductBloc? bloc,
  }) : _bloc = bloc;

  final ProductBloc? _bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
        stream: _bloc!.showClear,
        initialData: false,
        builder: (context, searchSnapShot) {
          return MySearchField(
              clearText: () => _bloc!.clearText(),
              onFieldSubmitted: (v) => _bloc!.onSearchFieldSubmitted(
                  v: v!, isCategories: false, isFiltered: false),
              validate: (v) {
                if (v!.isEmpty) {
                  return "Please type some text";
                }
                return null;
              },
              isSearching: searchSnapShot.data!,
              controller: _bloc!.searchController,
              hintText: "Search");
        });
  }
}

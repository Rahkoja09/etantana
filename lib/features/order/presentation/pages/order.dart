import 'package:e_tantana/config/constants/styles_constants.dart';
import 'package:e_tantana/shared/widget/input/floating_search_bar.dart';
import 'package:e_tantana/shared/widget/loading/app_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

TextEditingController searchInput = TextEditingController();

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: StylesConstants.spacerContent,
                right: StylesConstants.spacerContent,
                top: StylesConstants.spacerContent,
              ),
              child: FloatingSearchBar(
                controller: searchInput,
                hintText: "Rechercher une commande",
                onChanged: (value) {},
                onSortTap: () {},
              ),
            ),

            Expanded(
              child: AppRefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(seconds: 2));
                },
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(StylesConstants.spacerContent),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text("Commande #$index"),
                      subtitle: Text("Détails de la commande de 1688"),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

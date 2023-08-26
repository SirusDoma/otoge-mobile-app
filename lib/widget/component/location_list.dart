import 'package:flutter/material.dart';
import 'package:otoge_mobile_app/model/store.dart';

class LocationList extends StatelessWidget {
  const LocationList({super.key, required this.stores, required this.pageController, required this.itemBuilder, required this.onPageChanged});

  final PageController pageController;
  final List<Store> stores;
  final Widget? Function(BuildContext, Store) itemBuilder;
  final Function(Store) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 210,
        child: Column(
          children: [
            const Center(
                child: Icon(Icons.drag_handle)
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  return itemBuilder(context, stores[index]);
                },
                onPageChanged: (index) async {
                  onPageChanged(stores[index]);
                },
              ),
            )
          ],
        )
    );
  }

}
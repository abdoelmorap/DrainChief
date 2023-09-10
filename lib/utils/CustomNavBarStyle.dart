// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

import 'package:get/get.dart';

// Project imports:
import 'package:lms_flutter_app/Controller/dashboard_controller.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'widgets/persistant_bottom_custom/persistent-tab-view.dart';

class CustomNavBarWidget extends StatelessWidget {
  final int? selectedIndex;
  final List<PersistentBottomNavBarItem>?
      items; // NOTE: You CAN declare your own model here instead of `PersistentBottomNavBarItem`.
  final ValueChanged<int>? onItemSelected;

  CustomNavBarWidget({
    Key? key,
    this.selectedIndex,
    @required this.items,
    this.onItemSelected,
  });

  final DashboardController controller = Get.put(DashboardController());

  Widget _buildItem(PersistentBottomNavBarItem item, bool isSelected) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: IconTheme(
              data: IconThemeData(
                  size: 24,
                  color: isSelected
                      ? (item.activeColorSecondary == null
                          ? item.activeColorPrimary
                          : item.activeColorSecondary)
                      : item.inactiveColorPrimary == null
                          ? item.activeColorPrimary
                          : item.inactiveColorPrimary),
              child: isSelected ? item.icon : item.inactiveIcon!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Material(
              type: MaterialType.card,
              child: FittedBox(
                  child: Text(
                item.title ?? '',
                style: TextStyle(
                    color: isSelected
                        ? (item.activeColorSecondary == null
                            ? item.activeColorPrimary
                            : item.activeColorSecondary)
                        : item.inactiveColorPrimary,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'AvenirNext',
                    fontSize: 12),
              )),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: Offset(2, 3),
              ),
            ]),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items!.map((item) {
              int index = items?.indexOf(item) ?? 0;
              return Flexible(
                child: InkWell(
                  onTap: () {
                    this.onItemSelected!(index);
                  },
                  child: _buildItem(item, selectedIndex == index),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

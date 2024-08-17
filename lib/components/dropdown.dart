import 'package:flutter/material.dart';
import 'package:quranapp/consts/colors.dart';

class CustomDropdown extends StatefulWidget {
final List<String> categories;

  CustomDropdown({required this.categories});

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with TickerProviderStateMixin {
  bool isDropdownOpen = false;
  TextEditingController searchController = TextEditingController();
  late List<String> filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.categories;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isDropdownOpen = !isDropdownOpen;
                });
              },
              child: Container(
                padding: const EdgeInsets.only(
                  top: 15,
                  bottom: 15,
                  left: 15,
                  right: 15,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: buttonColor,
                  boxShadow: [
                    BoxShadow(color: mainBackground),
                  ],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${filteredItems.isNotEmpty ? filteredItems[0].toUpperCase() : "No results"}',
                      style: TextStyle(
                        fontSize: 18,
                        color: titleColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    RotationTransition(
                      turns: Tween<double>(begin: 0.0, end: isDropdownOpen ? 0.25 : 0.0)
                          .animate(
                        CurvedAnimation(
                          parent: AnimationController(
                            vsync: this,
                            duration: Duration(milliseconds: 200),
                          )..forward(),
                          curve: Curves.linear,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (isDropdownOpen)
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 10,
                    right: 10,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: filteredItems.map((item) {
                      return Text(
                        item,
                        style: TextStyle(color: titleColor, fontSize: 20),
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

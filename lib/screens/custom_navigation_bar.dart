import 'package:flutter/material.dart';

class GlobalBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const GlobalBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  // ignore: library_private_types_in_public_api
  _GlobalBottomNavigationBarState createState() =>
      _GlobalBottomNavigationBarState();
}

class _GlobalBottomNavigationBarState extends State<GlobalBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: widget.onTabSelected,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 0
                ? Icons.dashboard
                : Icons.dashboard_outlined,
            color: widget.currentIndex == 0 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 1
                ? Icons.bar_chart
                : Icons.bar_chart_outlined,
            color: widget.currentIndex == 1 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 2 ? Icons.wallet : Icons.wallet_outlined,
            color: widget.currentIndex == 2 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            widget.currentIndex == 3 ? Icons.person : Icons.person_outline,
            color: widget.currentIndex == 3 ? Colors.blue : Colors.grey,
          ),
          label: '',
        ),
      ],
    );
  }
}

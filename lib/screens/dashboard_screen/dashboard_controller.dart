import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  static DashboardController get instance => Get.find<DashboardController>();
  final PageController pageController = PageController(initialPage: 1);
  int index = 0;

  void animateToPage(int page) {
    pageController.animateToPage(page,
        duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
  }
}

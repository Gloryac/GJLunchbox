import 'package:dj_lunchbox/features/authentication/user_management/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController{
  static OnBoardingController get instance=> Get.find();

  //variable
  final pageController =PageController();
  Rx<int> currentPageIndex = 0.obs;

  //Update current index when the page scroll
  void updatePageIndicator(index) => currentPageIndex.value =index;


  //Specific dot selected page
  void dotNavigationClick(index){
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }
  //Update current index and go to the next page
  void nextPage(){
    if (currentPageIndex.value == 2){
      Get.to(LoginPage());
    }else{
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }
  //Update current index and skip to the Last Page
  void skipPage(){
    currentPageIndex.value = 2;
    pageController.jumpToPage(2);
  }
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/custom_drawer/drawer_user_controller.dart';
import 'package:scheduler/view/components/custom_drawer/home_drawer.dart';
import 'package:scheduler/view/pages/transaction/tank_filling.dart';
import 'package:scheduler/view/pages/user/user_home.dart';
import 'package:scheduler/view/styles/colors.dart';

class NavigationHomeScreen extends StatefulWidget {
  final String message;

  const NavigationHomeScreen({super.key, required this.message});
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {

    drawerIndex = DrawerIndex.HOME;
    screenView =  UserHome(msg: widget.message,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: nearlyWhite,
          body: DrawerUserController(
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
              //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {

        });
      } else if (drawerIndex == DrawerIndex.Reports) {
        // Navigator.push(context, MaterialPageRoute(
        //     builder: (context) => Reports()));
      } else if (drawerIndex == DrawerIndex.User) {
        setState(() {

        });
      } else if (drawerIndex == DrawerIndex.Transaction) {
        // Navigator.push(context, MaterialPageRoute(
        //     builder: (context) => AdminTransactions()));
        Get.to(()=> const TankerFilling(pageMode: "VIEW"));
      }else if (drawerIndex == DrawerIndex.About) {
        setState(() {

        });
      }else if (drawerIndex == DrawerIndex.Finger) {
        setState(() {
          // Navigator.push(context, MaterialPageRoute(
          //     builder: (context) => FingerprintAuth()));
        });
      }  else {
        //do in your way......
      }
    }
  }

  fnGetPageData(){
    if(widget.message.isNotEmpty){
      successMsg(context,widget.message.toString());
    }
  }
}



import 'package:flutter/material.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/pages/login/login.dart';
import 'package:scheduler/view/pages/login/login_user.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer({Key? key, this.screenIndex, this.iconAnimationController, this.callBackIndex}) : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;

  Global g = Global();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: const Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Reports,
        labelName: 'Calender',
        icon: const Icon(Icons.event_available),
      ),

      DrawerList(
        index: DrawerIndex.Transaction,
        labelName: 'Tank Fill',
        icon: const Icon(Icons.propane_tank),
      ),
      DrawerList(
        index: DrawerIndex.User,
        labelName: 'Profile',
        icon: const Icon(Icons.person),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'About Us',
        icon: const Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(1.0 - (widget.iconAnimationController!.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(begin: 0.0, end: 24.0)
                                  .animate(CurvedAnimation(parent: widget.iconAnimationController!, curve: Curves.fastOutSlowIn))
                                  .value /
                              360),
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: boxGradientDecoration(20, 90),
                            child: const Icon(Icons.person,color: Colors.white,size: 30,),
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, left: 4.0),
                    child: Text(
                      g.wstrUserCd + " | " + g.wstrUserName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),  Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 4.0),
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_outlined,color: Colors.black,size: 10,),
                        gapWC(5),
                        tc(g.wstrCompany+" | "+g.wstrYearcode, Colors.black, 10)
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Divider(
            height: 1,
            color: grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          ts('   POWERED BY BEAMS .', Colors.black, 10),
          gapHC(5),
          Divider(
            height: 1,
            color: grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: txtSubColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: const Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  fnLogOut();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  fnLogOut(){
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>  const LoginUser()
    ));
  }
  void fnLogOut1() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: ts('Sign Out',Colors.blue[900],20),
        content: ts('Do you want to sign out.', Colors.black, 14),
        actions: <Widget>[
          Container(
            width : 80,
            height:35,
            decoration: boxGradientDecoration(16, 30),
            child:  TextButton(
              onPressed: () => Navigator.pop(context),
              child: tc('NO', Colors.white, 12),
            ),
          ),
          gapWC(3),
          Container(
            width : 80,
            height: 35,
            decoration: boxGradientDecoration(21, 30),
            child:TextButton(
             onPressed: () async {
               Navigator.pushReplacement(context, MaterialPageRoute(
                   builder: (context) =>  const LoginPage()
               ));
             } ,
             child: tc('YES', Colors.white, 12),
           ) ,
          ),
        ],
      ),
    );



  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 6.0,
                    height: 46.0,),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName, color: widget.screenIndex == listData.index ? Colors.blue : nearlyBlack),
                        )
                      : Icon(listData.icon?.icon, color: widget.screenIndex == listData.index ? Colors.blue : nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index ? Colors.blue : nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) * (1.0 - widget.iconAnimationController!.value - 1.0), 0.0, 0.0),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  Reports,
  //FeedBack,
  User,
 // Help,
  Transaction,
 // Share,
  About,
  Finger,
  //Invite,
 // Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}

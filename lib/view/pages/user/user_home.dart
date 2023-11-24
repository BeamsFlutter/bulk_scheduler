
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart' as bubble;
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/resposive/responsive_helper.dart';
import 'package:scheduler/view/pages/transaction/tank_filling.dart';
import 'package:scheduler/view/pages/transaction/tank_receiving.dart';
import 'package:scheduler/view/pages/transaction/trip.dart';
import 'package:scheduler/view/pages/user/user_calender.dart';
import 'package:scheduler/view/pages/user/user_profile.dart';
import 'package:scheduler/view/styles/colors.dart';

class UserHome extends StatefulWidget {
  final String msg;
  const UserHome({Key? key, required this.msg}) : super(key: key);

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {

  //Global
  var g = Global();
  var apiCall =  ApiCall();

  late Future<dynamic> futureFrom;

  //Page Variables
  late int currentIndex;
  var lstrSelectedCard = 'P';
  var tripSts  = false;

  //Filter Details
  var lstrTitleCard  ="Till Today";
  var lstrFPlannedCount  =  0;
  var lstrPcount  =  0;
  var lstrFPcount  =  0;
  var lstrFUcount  =  0;
  var lstrFCcount  =  0;

  var lstrPendingList = [];
  var lstrFPendingList = [];
  var lstrUpcomingList = [];
  var lstrCompletedList = [];


  @override
  void initState() {
    // TODO: implement initState
    currentIndex = 0;
    super.initState();
    fnGetPageData();
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {  },
      //   backgroundColor: subColor,
      //   child: const Icon(Icons.dashboard),
      // ),
      bottomNavigationBar: bubble.BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        onTap: changePage,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(16),
        ), //border radius doesn't work when the notch is enabled.
        elevation: 8,
        tilesPadding: const EdgeInsets.symmetric(
          vertical: 8.0,
        ),
        items: <bubble.BubbleBottomBarItem>[
          bubble.BubbleBottomBarItem(
            showBadge: true,
            badge:  Text(lstrPcount.toString()),
            badgeColor: Colors.amber,
            backgroundColor: bgColorDark,
            icon: const Icon(
              Icons.task_alt,
              color: txtSubColor,
            ),
            activeIcon: const Icon(
              Icons.task_alt,
              color: bgColorDark,
            ),
            title: ts('Task', bgColorDark, 12),
          ),
          bubble.BubbleBottomBarItem(
              backgroundColor: bgColorDark,
              icon: const Icon(
                Icons.event_note ,
                color:txtSubColor,
              ),
              activeIcon: const Icon(
                Icons.event_note,
                color: bgColorDark,
              ),
              title: ts('Calender', bgColorDark, 12)),
          bubble.BubbleBottomBarItem(
              backgroundColor: bgColorDark,
              icon: const Icon(
                Icons.propane_tank_outlined,
                color: txtSubColor,
              ),
              activeIcon: const Icon(
                Icons.propane_tank_outlined,
                color: bgColorDark,
              ),
              title: ts('Filling', bgColorDark, 12)),
          bubble.BubbleBottomBarItem(
              backgroundColor: bgColorDark,
              icon: const Icon(
                Icons.downloading_rounded,
                color: txtSubColor,
              ),
              activeIcon: const Icon(
                Icons.downloading_rounded,
                color: bgColorDark,
              ),
              title: ts('Receiving', bgColorDark, 12)),
          bubble.BubbleBottomBarItem(
              backgroundColor: bgColorDark,
              icon: const Icon(
                Icons.person,
                color: txtSubColor,
              ),
              activeIcon: const Icon(
                Icons.person,
                color: bgColorDark,
              ),
              title: ts('Profile', bgColorDark, 12))
        ],
      ),
      body: ResponsiveWidget(
        mobile: mobileScreen(),
        tab: mobileScreen(),
        windows: windowsScreen(),
      ),
    );
  }
//==================================SCREEN WIDGET
  Widget windowsScreen(){
    return Container();
  }
  Widget mobileScreen(){
    return Container(
      padding: const EdgeInsets.all(20),
      margin: MediaQuery.of(context).padding,
      child: Column(
        children: [
          Container(

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                gapWC(5),
                Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: (){
                    Get.to(()=>  Trip(
                      fnCallBack: apiGetTrip,
                    ));
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                      
                    decoration:tripSts? boxDecoration(Colors.green, 30): boxGradientDecoration( 22, 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(

                        ),
                        Image.asset("assets/icons/tank1.png"),
                        gapWC(6),
                        tcn('Trip',tripSts?Colors.white:bgColorDark , 10),
                        gapWC(6),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          gapHC(10),
          currentIndex == 0 || currentIndex == 2 ||currentIndex == 3?
          Expanded(child:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bounce(
                onPressed: (){
                  fnAll();
                },
                duration: const Duration(milliseconds: 110),
                child:  Container(

                  decoration: boxImageDecoration('assets/images/img_5.png', 20),
                  child:Container(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                    decoration: boxGradientDecorationBase(20, 15),
                    child:  Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: boxDecoration(white, 50),
                          child: const Center(
                            child: Icon(Icons.account_circle,color: subColor,size: 30,),
                          ),
                        ),
                        gapWC(10),
                        Expanded(child:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            th('Hi, ${g.wstrUserName}',white,g.wstrHeadFont),
                            Row(
                              children: [
                                tcn('You have  ', white, g.wstrSubFont),
                                th((lstrPcount).toString(), white, g.wstrSubFont),
                                tcn('  pending task today', white, g.wstrSubFont),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.account_balance_outlined,color: white,size: g.wstrSubIconSize-5,),
                                gapWC(5),
                                ts(g.wstrCompany + " | " + g.wstrYearcode,white,g.wstrSubFont),
                              ],
                            ),
                            tcn('BEAMS GAS DRIVER', white, g.wstrSubFont-2),



                          ],))
                      ],
                    ),
                  ),
                ),
              ),
              gapHC(10),
              Row(
                children: [
                  gapWC(5),
                  th('Today', txtSubColor,g.wstrHeadFont)
                ],
              ),
              gapHC(5),
              Row(
                children: [
                  wTodayCard(Icons.pending, Colors.red, 'Pending',lstrPcount.toString(),'P'),
                  gapWC(5),
                  wTodayCard(Icons.access_time, Colors.orange, 'Today',lstrFPcount.toString(),"T"),
                  gapWC(5),
                  wTodayCard(Icons.task_alt, Colors.green, 'Completed',lstrFCcount.toString(),'C'),

                ],
              ),
              lineS(),
              lstrSelectedCard == 'P'?
              Expanded(child: SingleChildScrollView(
                child: animColumn(wPendingList()),
              )):
              lstrSelectedCard == 'T'?
              Expanded(child: SingleChildScrollView(
                child: animColumn(wTodayPendingList()),
              )):
              lstrSelectedCard == 'C'?
              Expanded(child: SingleChildScrollView(
                child: animColumn(wTodayCompletedList()),
              )):
              Container()

            ],
          ),):
          currentIndex == 1?
          const Expanded(child: UserCalender(),):
          currentIndex == 4?
          const Expanded(child: UserProfile(),):Container(),


        ],
      ),
    );
  }
//==================================WIDGET

  List<Widget> wPendingList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrPendingList){
      rtnWidget.add(wTaskCard(e,"P"),);
    }
    return rtnWidget;
  }
  List<Widget> wTodayPendingList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrFPendingList){
      rtnWidget.add(wTaskCard(e,"P"),);
    }
    return rtnWidget;
  }
  List<Widget> wTodayCompletedList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrCompletedList){
      rtnWidget.add(wTaskCard(e,"C"),);
    }
    return rtnWidget;
  }
  Widget wTodayCard(icon,color,name,count,mode){
    return Flexible(child: Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            lstrSelectedCard =  mode;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
        decoration:lstrSelectedCard == mode ?boxDecoration(white, 10): boxOutlineCustom( white, 10,greyLight),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon,color: color,size: g.wstrIconSize-2,),
                gapWC(5),
                tcn(name, txtSubColor, g.wstrSubFont-2)
              ],
            ),
            th(count.toString(), txtSubColor, g.wstrSubFont)
          ],
        ),
      ),
    ));
  }
  Widget wTaskCard(e,mode){
    var schDate  = e["SCH_DATE"] == null || e["SCH_DATE"] == ""?"": setDate(6, DateTime.parse(e["SCH_DATE"].toString()));
    var docDate  = e["DOCDATE"] == null || e["DOCDATE"] == ""?"": setDate(6, DateTime.parse(e["DOCDATE"].toString()));
    return  Bounce(
      onPressed: (){
        if(mode == "P"){
          fnFilling(e);
        }
      },
      duration: const Duration(milliseconds: 110),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: boxBaseDecoration(white, 10),
        margin: const EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(),
            th('#'+e["DOCNO"]??"",txtSubColor,g.wstrSubFont),
            Row(
              children: [
                Icon(Icons.account_balance,color: subColor,size: g.wstrSubIconSize,),
                gapWC(5),
                Expanded(child: tcn('COMPANY : ${e["COMPANY"]??""} | ${e["COMPANY_DESCP"]??""} ', txtSubColor, g.wstrSubFont))
              ],
            ),
            Row(
              children: [
                Icon(Icons.apartment,color: subColor,size: g.wstrSubIconSize,),
                gapWC(5),
                Expanded(child: tcn('BUILDING : ${e["BUILDING_CODE"]??""} | ${e["BUILDING_DESCP"]??""} ', txtSubColor, g.wstrSubFont))
              ],
            ),
            Row(
              children: [
                Icon(Icons.place,color: subColor,size: g.wstrSubFont,),
                gapWC(5),
                tcn(e["BUILDING_AREA_DESCP"].toString(),txtSubColor,10)
              ],
            ),
            Row(
              children: [
                Icon(Icons.calendar_month_sharp,color: subColor,size: g.wstrSubFont,),
                gapWC(5),
                tcn(schDate.toString(),txtSubColor,10)
              ],
            ),
          ],
        ),
      ),
    );
  }

//==================================PAGE_FN

  fnGetPageData(){
    Future.delayed(Duration.zero,(){
      //your code goes here
      fnAll();

    });

  }

  void changePage(int? index) {
    setState(() {
      currentIndex = index!;
    });
    if(currentIndex == 2){
      Get.to(()=> const TankerFilling(pageMode: "VIEW"));
    }
    if(currentIndex == 3){
      Get.to(()=> const TankReceiving());
    }
  }
  fnAll(){
    var from = "";
    var to = setDate(2, DateTime.now());
    apiDashboard(from,to,[],"ALL");
  }
  fnToday(){
    var from = setDate(2, DateTime.now());
    var to = setDate(2, DateTime.now());
    apiDashboard(from,to,[],"T");
  }

  fnFilling(e){
    Get.to(()=> TankerFilling(
      pageMode: "ADD",
      data: e,
    ));
  }

  fnTripCallBack(){

  }

//==================================APICALL


  apiDashboard(dateFrom,dateTo,area,mode){
    var buildingList  = [];
    var user  =  [{
      "COL_KEY":g.wstrUserCd,
    }];
    g.wstrContext = context;
    futureFrom = apiCall.apiDashboard(g.wstrCompany, dateFrom, dateTo, [], user, area, buildingList,);
    futureFrom.then((value) => apiDashboardRes(value,mode));
  }
  apiDashboardRes(value,mode){
    if(mounted){
      setState(() {

        if(mode == "ALL"){
          lstrPcount  =  0;
          lstrPendingList = [];
        }
        lstrFPlannedCount  =  0;
        lstrFPcount  =  0;
        lstrFUcount  =  0;
        lstrFCcount  =  0;

        lstrFPendingList = [];
        lstrUpcomingList = [];
        lstrCompletedList = [];

        if(g.fnValCheck(value)){

          var filterCount  = [value["FILTERED"]];

          if(mode == "ALL"){
            lstrPcount = g.mfnInt(filterCount[0]["PENDING"]);
            lstrPendingList =  mfnAssign(value["LIST_PENDING"]);
          }else{
            lstrFPlannedCount  =  g.mfnInt(filterCount[0]["PLANNED"]);
            lstrFCcount  =  g.mfnInt(filterCount[0]["COMPLETED"]);
            lstrUpcomingList =  mfnAssign(value["LIST_UPCOMING"]);
            lstrCompletedList =  mfnAssign(value["LIST_COMPLETED"]);
            lstrFPendingList =  mfnAssign(value["LIST_PENDING"]);
            lstrFPcount  =  g.mfnInt(filterCount[0]["PENDING"]);
          }

        }else{
          dprint("NO DATA");
        }

      });
    }
    if(mode == "ALL"){
      fnToday();
    }
    apiGetTrip();
  }

  apiGetTrip(){
    var users =  [{"COL_KEY":g.wstrUserCd}];
    futureFrom = apiCall.apiGetTrip(g.wstrCompany, g.wstrYearcode, users, [], "1");
    futureFrom.then((value) => apiGetTripRes(value));

  }
  apiGetTripRes(value){
    if(mounted){
      setState(() {
        tripSts =  false;
        if(g.fnValCheck(value)){
          tripSts =true;
        }

      });
    }

  }


}

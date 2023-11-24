
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/main.dart';
import 'package:scheduler/view/components/alertDialog/alertDialog.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/resposive/responsive_helper.dart';
import 'package:scheduler/view/history/builidng_search.dart';
import 'package:scheduler/view/pages/login/login.dart';
import 'package:scheduler/view/pages/schedule/fillinghistory.dart';
import 'package:scheduler/view/pages/schedule/schedule.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}


enum Menu { itemOne, itemTwo, itemThree, itemFour }

class _HomePageState extends State<HomePage> {


  //Global
   var g = Global();
   var apiCall = ApiCall();
   GlobalKey key1 = GlobalKey();
   GlobalKey key2 = GlobalKey();
   GlobalKey key3 = GlobalKey();
   GlobalKey key4 = GlobalKey();
   late TutorialCoachMark tutorialCoachMark;

   late Future<dynamic> futureFrom;

   //Calender
   CalendarFormat _calendarFormat = CalendarFormat.month;
   DateTime _focusedDay = DateTime.now();
   DateTime? _selectedDay;

   //PageVariables
   var lstrTaskMode = "T";
   var lstrPageMode = "H";
   var lstrMenuMode = "CO";

   var lstrCompanyList = [];
   var lstrDriverList = [];
   var lstrAreaList = [];


   //OverAll Details
   var lstrOverallDetails = [];
   var lstrTotalPlannedCount  =  0;
   var lstrTotalPcount  =  0;
   var lstrTotalUcount  =  0;
   var lstrTotalCcount  =  0;

   //Filter Details
   var lstrTitleCard  ="Till Today";
   var lstrFPlannedCount  =  0;
   var lstrFPcount  =  0;
   var lstrFUcount  =  0;
   var lstrFCcount  =  0;

   //Filter Selection
   var lstrFilterMode = "TT";

   var lstrSelectedCompany  = [];
   var lstrSelectedDriver  = [];
   var lstrSelectedArea  = [];

   var lstrPendingList = [];
   var lstrUpcomingList = [];
   var lstrCompletedList = [];

   //Month Data
   var lstrMonthData  = [];

   @override
  void initState() {
    // TODO: implement initState
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
      resizeToAvoidBottomInset: false,
        body: ResponsiveWidget(
        mobile: mobileScreen(),
        tab: windowsScreen(),
        windows: windowsScreen(),

      ),
    );
  }

//==================================Responsive WIDGET

  Widget mobileScreen(){
     return Container(
       padding: const EdgeInsets.all(0),
       child:  Column(
         children: [
           Container(
             decoration: boxImageDecorationC('assets/images/img_5.png',0,0,30,30),
             child: Container(
               padding: const EdgeInsets.all(10),
               decoration: boxGradientDecorationBaseC(20,0,0,30,30),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Icon(Icons.dashboard_outlined,color: Colors.white,size: g.wstrIconSize+5,),
                       Icon(Icons.power_settings_new,color: Colors.white,size: g.wstrIconSize+5,)
                     ],
                   ),
                   gapHC(15),
                   Icon(Icons.account_circle,color: Colors.white,size: g.wstrIconSize+25,),
                   th('JAMES ABRAHAM',white,g.wstrHeadFont),
                   tcn('ADMIN', white, 8),
                   tcn('12 MAY 2022', white, 8),
                   gapHC(10),
                 ],
               ),
             ),
           ),
           Expanded(child: Column(
             children: [
               Row(
                 children: [

                 ],
               )
             ],
           ))
         ],
       ),
     );
  }
  Widget windowsScreen(){
     return Column(
       children: [
         Container(
           height: 50,
           decoration: boxDecoration(bgColorDark, 0),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Row(
                 children: [
                   gapWC(20),
                   Container(
                     height: 30,
                     width: 30,
                     decoration: boxDecoration(Colors.white, 10),
                     child:  Center(
                       child: Image.asset("assets/icons/schicon.png",width: 20,),
                     ),
                   ),
                   gapWC(10),
                   th('BEAMS GAS',Colors.white,g.wstrHeadFont),
                   gapWC(5),
                   tcn('SCHEDULER',Colors.white,g.wstrHeadFont),
                 ],
               ),
               Row(
                 children:  [
                   Icon(Icons.notifications,color: Colors.white,size: g.wstrIconSize,),
                   gapWC(15),
                   Bounce(
                     duration: const Duration(milliseconds: 110),
                     onPressed: (){
                     },
                     child:  PopupMenuButton<Menu>(
                         position: PopupMenuPosition.under,
                         tooltip: "User Details",
                         icon: const Icon(Icons.person_pin,color: Colors.white,),
                         iconSize: g.wstrIconSize,
                         // Callback that sets the selected popup menu item.
                         onSelected: (Menu item) {
                           setState(() {
                           });
                         },
                         shape:  RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10)),
                         itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                           PopupMenuItem<Menu>(
                             value: Menu.itemOne,
                             child: mailCard(Icons.account_circle_outlined,g.wstrUserName.toString()),
                           ),
                           PopupMenuItem<Menu>(
                             value: Menu.itemTwo,
                             child:  mailCard(Icons.account_balance,"${g.wstrCompany} | ${g.wstrYearcode}"),
                           ),
                           PopupMenuItem<Menu>(
                             value: Menu.itemThree,
                             child: mailCard(Icons.monitor,g.wstrDeivceId.toString()),
                           ),
                         ]),
                   ),
                   gapWC(15),
                   Bounce(
                     duration: const Duration(milliseconds: 110),
                     onPressed: (){
                     },
                     child:  PopupMenuButton<Menu>(
                         position: PopupMenuPosition.under,
                         tooltip: "Settings",
                         icon: const Icon(Icons.settings,color: Colors.white,),
                         iconSize: g.wstrIconSize,
                         // Callback that sets the selected popup menu item.
                         shape:  RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10)),
                         itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                           PopupMenuItem<Menu>(
                             value: Menu.itemOne,
                             child: mailCard(Icons.zoom_out,"ZOOM 30%"),
                             onTap: (){
                               fnZoom("30");
                             },
                           ),
                           PopupMenuItem<Menu>(
                             value: Menu.itemTwo,
                             child: mailCard(Icons.zoom_out,"ZOOM 50%"),
                             onTap: (){
                               fnZoom("50");
                             },
                           ),
                           PopupMenuItem<Menu>(
                             value: Menu.itemThree,
                             child:  mailCard(Icons.zoom_in,"ZOOM 100%"),
                             onTap: (){
                               fnZoom("100");
                             },

                           ),
                         ]),
                   ),
                   gapWC(20),
                   Bounce( duration: const Duration(milliseconds: 110), onPressed: (){showTutorial();},child:  Icon(Icons.contact_support_rounded,color: Colors.white,size: g.wstrIconSize,),),
                   gapWC(20),
                  
                 ],
               )
             ],
           ),
         ),
         lstrPageMode == "H"?
         Expanded(child: Container(
           padding: const EdgeInsets.all(15),
           child: Row(
             children: [
               Container(
                 width: 250,
                 padding: const EdgeInsets.all(5),
                 decoration: boxDecoration(Colors.white, 15),
                 child: Column(
                   children: [
                     Container(
                       padding: const EdgeInsets.all(10),
                       decoration: boxBaseDecoration(greyLight, 15),
                       child: Row(
                         children: [
                           Bounce(
                             onPressed: (){

                             },
                             duration: const Duration(milliseconds: 110),
                             child:  Container(
                               height: 40,
                               width: 40,
                               decoration: boxBaseDecoration(Colors.white, 60),
                               child: const Center(
                                 child: Icon(Icons.account_circle_rounded,color: txtColor,size: 30,),
                               ),
                             ),
                           ),
                           gapWC(10),
                           Expanded(child:
                           Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               th(g.wstrUserName.toString(),txtColor,g.wstrHeadFont),
                               tcn('Admin',txtColor,g.wstrSubFont),
                             ],))
                         ],
                       ),
                     ),
                     gapHC(10),
                     Expanded(
                       child: SingleChildScrollView(
                         child: animColumn(
                           [
                             // wMenuCard(Icons.task_alt,'All Task',bgColorDark,"A",10),
                             tcn('Task Details', txtColor, g.wstrHeadFont),
                             lineS(),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               key: key1,
                               children: [
                                 tcn('Overall', txtColor, g.wstrHeadFont),
                                 lineS(),
                                 wMenuCard(Icons.task_alt,'Planned',bgColorDark,"T",lstrTotalPlannedCount),
                                 wMenuCard(Icons.pending,'Pending',Colors.orange,"P",lstrTotalPcount),
                                 wMenuCard(Icons.upcoming,'Upcoming',Colors.blue,"U",lstrTotalUcount),
                                 wMenuCard(Icons.done_all_outlined,'Completed',Colors.green,"C",lstrTotalCcount),
                                 lineS(),
                               ],
                             ),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               key: key2,
                               children: [
                                 tcn(lstrTitleCard.toString(), txtColor, g.wstrHeadFont),
                                 lineS(),
                                 wMenuCard(Icons.task_alt,'Planned',bgColorDark,"FT",lstrFPlannedCount),
                                 wMenuCard(Icons.pending,'Pending',Colors.orange,"FP",lstrFPcount),
                                 wMenuCard(Icons.upcoming,'Upcoming',Colors.blue,"FU",lstrFUcount),
                                 wMenuCard(Icons.done_all_outlined,'Completed',Colors.green,"FC",lstrFCcount),
                               ],
                             )


                           ],
                         ),
                       ),
                     ),
                     Column(
                       children: [
                         Bounce(
                           duration: const Duration(milliseconds: 110),
                           onPressed: (){
                            fnFilterOnClick();
                            apiMonthData();
                           },
                           child: Container(
                             height: 35,
                             decoration: boxBaseDecoration(bgColorDark, 10),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.sync,color: Colors.white,size: g.wstrSubIconSize,),
                                 gapWC(5),
                                 tcn("REFRESH", white, g.wstrSubFont)
                               ],
                             ),
                           ),
                         ),
                         gapHC(10),
                         Bounce(
                           duration: const Duration(milliseconds: 110),
                           onPressed: (){
                             fnReceivingFilling();
                           },
                           child: Container(
                             height: 35,
                             decoration: boxBaseDecoration(bgColorDark, 10),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.av_timer,color: Colors.white,size: g.wstrSubIconSize,),
                                 gapWC(5),
                                 tcn("RECEIVING & FILLING", white, g.wstrSubFont)
                               ],
                             ),
                           ),
                         ),
                         gapHC(10),
                         Bounce(
                           duration: const Duration(milliseconds: 110),
                           onPressed: (){
                             fnAddSchedule();
                           },
                           child: Container(
                             height: 35,
                             decoration: boxBaseDecoration(bgColorDark, 10),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.add_rounded,color: Colors.white,size: g.wstrSubIconSize,),
                                 gapWC(5),
                                 tcn("SCHEDULE", white, g.wstrSubFont)
                               ],
                             ),
                           ),
                         ),
                         gapHC(10),
                         Bounce(
                           duration: const Duration(milliseconds: 110),
                           onPressed: (){
                             fnLogout();
                           },
                           child: Container(
                             height: 30,
                             decoration: boxOutlineCustom1(Colors.white, 10,Colors.grey,1.0),
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Icon(Icons.power_settings_new_sharp,color: txtColor,size: g.wstrSubIconSize,),
                                 gapWC(5),
                                 tcn("Logout", txtColor, g.wstrSubFont)
                               ],
                             ),
                           ),
                         ),
                         gapHC(10),
                         tcn('Beams ${g.wstrVersionName}', txtSubColor, g.wstrSubFont),
                         gapHC(10),
                       ],
                     )
                   ],
                 ),
               ),
               gapWC(5),
               Flexible(
                   child: Container(
                     //decoration: boxDecoration(Colors.white, 15),
                     padding: const EdgeInsets.all(10),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(),
                         Container(
                           padding: const EdgeInsets.all(5),
                           decoration: boxBaseDecoration(blueLight, 5),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                              th(lstrTitleCard, bgColorDark, g.wstrHeadFont),
                              Row(
                                key: key3,
                                children: [
                                  wFilterCard("Till Today","TT"),
                                  wFilterCard("Today","T"),
                                  wFilterCard("Yesterday","Y"),
                                  wFilterCard("This Month","TM"),
                                  wFilterCard("This Year","TY"),
                                ],
                              )
                             ],
                           ),
                         ),
                         lineS(),
                         Container(
                           padding: const EdgeInsets.all(10),
                           child: ScrollConfiguration(
                             behavior: MyCustomScrollBehavior(),
                             child: SingleChildScrollView(
                               scrollDirection: Axis.horizontal,
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.start,
                                 children:
                                 lstrMenuMode == "US"? wDriverList():
                                 lstrMenuMode == "CO"? wCompanyList():
                                 lstrMenuMode == "AR"? wAreaList():[],
                               ),
                             ),
                           ),
                         ),
                         subHead('Scheduled Details'),
                         gapHC(10),
                         Expanded(child: Row(
                           children: [
                             Flexible(child: Container(
                               padding: const EdgeInsets.all(10),
                               decoration: boxBaseDecoration(white, 10),
                               child: Column(
                                 children: [
                                   Row(),
                                   wTaskCard(Icons.pending,'Pending',Colors.orange,lstrFPcount.toString()),
                                   gapHC(10),
                                   Expanded(child: SingleChildScrollView(
                                     child: animColumn(wPendingList()),
                                   ))
                                 ],
                               ),
                             )),
                             gapWC(10),
                             Flexible(child: Container(
                               padding: const EdgeInsets.all(10),
                               decoration: boxBaseDecoration(white, 10),
                               child: Column(
                                 children: [
                                   Row(),
                                   wTaskCard(Icons.task_alt,'Completed',Colors.green,lstrFCcount.toString()),
                                   gapHC(10),
                                   Expanded(child: SingleChildScrollView(
                                     child: animColumn(wCompletedList()),
                                   ))

                                 ],
                               ),
                             )),
                             gapWC(10),
                             Flexible(child: Container(
                               padding: const EdgeInsets.all(10),
                               decoration: boxBaseDecoration(white, 10),
                               child: Column(
                                 children: [
                                   Row(),
                                   wTaskCard(Icons.upcoming,'Upcoming',Colors.blue,lstrFUcount.toString()),
                                   gapHC(10),
                                   Expanded(child: SingleChildScrollView(
                                     child: animColumn(wUpcomingList()),
                                   ))
                                 ],
                               ),
                             )),
                           ],
                         ))
                       ],
                     ),
                   )),
               gapWC(5),
               Container(
                 width: 250,
                 padding: const EdgeInsets.all(5),
                 decoration: boxDecoration(Colors.white, 15),
                 child: Column(
                   children: [
                     Expanded(child:
                     Column(children: [
                       Container(
                         child: TableCalendar(
                           key: key4,
                           firstDay: DateTime(2020,01,01),
                           lastDay: DateTime(2060,01,01),
                           focusedDay: _focusedDay,
                           calendarFormat: _calendarFormat,
                           eventLoader: fnCalenderSchedule,
                           headerStyle: const HeaderStyle(titleTextStyle: TextStyle(color: bgColorDark),formatButtonVisible: false,),
                           selectedDayPredicate: (day) {
                             return isSameDay(_selectedDay, day);
                           },
                           onDaySelected: (selectedDay, focusedDay) {
                             if (!isSameDay(_selectedDay, selectedDay)) {
                               setState(() {
                                 _selectedDay = selectedDay;
                                 _focusedDay = focusedDay;
                                 lstrFilterMode = "CC";
                               });
                               var date =  setDate(2, selectedDay);
                               //apiViewMonthSpclHoly();
                               fnFilterOnClick();
                             }
                           },
                           onFormatChanged: (format) {
                             if (_calendarFormat != format) {
                               setState(() {
                                 _calendarFormat = format;
                               });
                             }
                           },
                           onPageChanged: (focusedDay) {
                             _focusedDay = focusedDay;
                             if(mounted){
                               setState(() {
                                 lstrFilterMode = "MM";
                               });
                               fnFilterOnClick();
                             }
                           },
                           calendarStyle: CalendarStyle(
                             // Use `CalendarStyle` to customize the UI
                               holidayTextStyle: const TextStyle(color: bgColorDark),
                               holidayDecoration: const BoxDecoration( border:  Border.fromBorderSide( BorderSide(color:  subColor, width: 2)), shape: BoxShape.rectangle),
                               outsideDaysVisible: false,
                               canMarkersOverflow: true,
                               selectedTextStyle: const TextStyle(color: Colors.white),
                               markerDecoration: boxDecoration(bgColorDark, 30),
                               markersMaxCount: 1,
                               todayTextStyle: TextStyle(fontSize: 10),
                               defaultTextStyle: TextStyle(fontSize: 10),
                               weekendTextStyle: TextStyle(fontSize: 10),

                           ),
                         ),
                       ),
                       lineS(),
                       Expanded(child: SingleChildScrollView(
                         child: Column(
                           children: [
                             wMenuDetCard(Icons.account_balance,'Company','CO'),
                             wMenuDetCard(Icons.supervised_user_circle_outlined,'User','US'),
                             wMenuDetCard(Icons.place_outlined,'Area','AR'),
                             wMenuDetCard(Icons.apartment,'Building','BU'),
                           ],
                         ),
                       )),
                       lineS(),
                       Bounce(
                         duration: const Duration(milliseconds: 110),
                         onPressed: (){
                           fnBuildingHistory();
                         },
                         child: Container(
                           padding: const EdgeInsets.all(10),
                           decoration: boxBaseDecoration(subColor, 5),
                           child: Column(
                             children: [

                               Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   tcn("Building History", white, g.wstrHeadFont),
                                   Icon(Icons.search,color: white,size: g.wstrIconSize,)
                                 ],
                               )
                             ],
                           ),
                         ),
                       )
                     ],)),
                     Column(
                       children: [
                         gapHC(10),
                       ],
                     )
                   ],
                 ),
               ),
             ],
           ),
         )):
         Expanded(child: Schedule(fnCallBack: fnScheduleCallBack,))
       ],
     );
  }

//==================================WIDGET

  Widget wMenuCard(icon,text,subTxtColor,mode,count){
    return  Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            lstrTaskMode = mode;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 3),
        padding: const EdgeInsets.all(5),
        decoration:lstrTaskMode == mode? boxBaseDecoration(bgColorDark.withOpacity(0.1), 10):boxBaseDecoration(white, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon,color:txtSubColor,size: g.wstrIconSize,),
                gapWC(10),
                tcn(text.toString(), lstrTaskMode == mode? bgColorDark:txtSubColor, g.wstrHeadFont)
              ],
            ),
            Container(
              width: 40,
              height: 25,
              decoration: boxBaseDecoration(subTxtColor.withOpacity(0.3), 5),
              child: Center(
                child: th(count.toString(), txtColor, g.wstrSubFont),
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget wMenuDetCard(icon,text,mode){
    return  Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            lstrMenuMode = mode;
            lstrSelectedArea = [];
            lstrSelectedCompany = [];
            lstrSelectedDriver = [];
          });
        }
        fnFilterOnClick();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 5),
        decoration: boxOutlineCustom1(lstrMenuMode == mode?blueLight: Colors.white, 10,greyLight,1.0),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon,color:  txtSubColor,size: g.wstrHeadFont,),
                gapWC(10),
                tcn(text,lstrMenuMode == mode?bgColorDark: txtSubColor, g.wstrHeadFont)
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget wTaskCard(icon,text,subTxtColor,count){
     return Container(
       padding: const EdgeInsets.all(5),
       decoration: boxBaseDecoration(greyLight, 5),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Row(
             children: [
               Icon(icon,color: txtSubColor,size: g.wstrIconSize),
               gapWC(5),
               tcn(text.toString(), txtSubColor, g.wstrHeadFont)
             ],
           ),
           Container(
             width: 40,
             height: 25,
             decoration: boxBaseDecoration( subTxtColor.withOpacity(0.3), 5),
             child: Center(
               child: th(count.toString(), txtColor, g.wstrHeadFont),
             ),
           )
         ],
       ),
     );
  }
  Widget wSchCard(color,e){
     var schDate  = e["SCH_DATE"] == null || e["SCH_DATE"] == ""?"": setDate(6, DateTime.parse(e["SCH_DATE"].toString()));
     var docDate  = e["DOCDATE"] == null || e["DOCDATE"] == ""?"": setDate(6, DateTime.parse(e["DOCDATE"].toString()));
     return  Container(
       decoration: boxBaseDecoration(color, 10),
       padding: const EdgeInsets.all(10),
       margin: const EdgeInsets.only(bottom: 5),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Row(),
           th(e["DOCNO"]??"", txtColor, g.wstrSubFont),
           Row(
             children: [
               Icon(Icons.schedule,color: txtSubColor,size: g.wstrSubIconSize,),
               gapWC(5),
               Expanded(child: tcn('SCHEDULE DATE : $schDate', txtSubColor, g.wstrSubFont))
             ],
           ),
           Row(
             children: [
               Icon(Icons.event,color: txtSubColor,size: g.wstrSubIconSize,),
               gapWC(5),
               Expanded(child: tcn('CREATE DATE : $docDate', txtSubColor, g.wstrSubFont))
             ],
           ),
           Row(
             children: [
               Icon(Icons.person,color: txtSubColor,size: g.wstrSubIconSize,),
               gapWC(5),
               Expanded(child: tcn('ASSIGN TO : ${e["ASSIGNED_USERDESCP"]??""} ', txtSubColor, g.wstrSubFont))
             ],
           ),
           Row(
             children: [
               Icon(Icons.account_balance,color: txtSubColor,size: g.wstrSubIconSize,),
               gapWC(5),
               Expanded(child: tcn('COMPANY : ${e["COMPANY"]??""} | ${e["COMPANY_DESCP"]??""} ', txtSubColor, g.wstrSubFont))
             ],
           ),
           Row(
             children: [
               Icon(Icons.apartment,color: txtSubColor,size: g.wstrSubIconSize,),
               gapWC(5),
               Expanded(child: tcn('BUILDING : ${e["BUILDING_CODE"]??""} | ${e["BUILDING_DESCP"]??""} ', txtSubColor, g.wstrSubFont))
             ],
           )
         ],
       ),
     );
  }
  List<Widget> wDriverList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrDriverList){
      rtnWidget.add(wDriverCard(e["ASSIGNED_USERCD"],e["ASSIGNED_USERDESCP"]??"",e["PENDING"]??"0",e["UPCOMING"]??"0",e["COMPLETED"]??"0"));
    }
    return rtnWidget;
  }
  Widget wDriverCard(code,name,pCount,uCount,cCount){
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            if(lstrSelectedDriver.contains(code)){
              lstrSelectedDriver.remove(code);
            }else{
              lstrSelectedDriver.add(code);
            }
          });
          fnFilterOnClick();
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: lstrSelectedDriver.contains(code)? boxDecoration(white, 20):boxBaseDecoration(white, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_pin ,color: txtSubColor,size: g.wstrIconSize+15,),
            tcn(name, txtSubColor, g.wstrHeadFont),
            gapHC(5),
            lineC(1.0, greyLight),
            gapHC(5),
            wDriverTaskRow(Icons.pending,"Pending",Colors.orange,pCount.toString()),
            wDriverTaskRow(Icons.upcoming,"Upcoming",Colors.blue,uCount.toString()),
            wDriverTaskRow(Icons.task_alt,"Completed",Colors.green,cCount.toString()),
          ],
        ),
      ),
    );
  }
  Widget wDriverTaskRow(icon,text,color,count){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween  ,
      children: [
        Row(
          children: [
            Icon(icon,color: txtSubColor,size: g.wstrSubIconSize,),
            gapWC(5),
            tcn(text, txtSubColor, g.wstrSubFont)
          ],
        ),
        th(count.toString(), color.withOpacity(0.9), g.wstrSubFont)
      ],
    );
  }
  List<Widget> wCompanyList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrCompanyList){
      rtnWidget.add(wCompanyCard(e["COMPANY_CODE"],e["COMPANY_DESCP"]??"",e["PENDING"]??"0",e["UPCOMING"]??"0",e["COMPLETED"]??"0"));
    }
    return rtnWidget;
  }
  Widget wCompanyCard(code,name,pCount,uCount,cCount){
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            if(lstrSelectedCompany.contains(code)){
              lstrSelectedCompany.remove(code);
            }else{
              lstrSelectedCompany.add(code);
            }
          });
          fnFilterOnClick();
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: lstrSelectedCompany.contains(code)? boxDecoration(white, 20):boxBaseDecoration(white, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_outlined ,color: txtSubColor,size: g.wstrIconSize+15,),
            tcn(name, txtSubColor, g.wstrHeadFont),
            gapHC(5),
            lineC(1.0, greyLight),
            gapHC(5),
            wDriverTaskRow(Icons.pending,"Pending",Colors.orange,pCount.toString()),
            wDriverTaskRow(Icons.upcoming,"Upcoming",Colors.blue,uCount.toString()),
            wDriverTaskRow(Icons.task_alt,"Completed",Colors.green,cCount.toString()),
          ],
        ),
      ),
    );
  }
  List<Widget> wAreaList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrAreaList){
      rtnWidget.add(wAreaCard(e["BUILDING_AREA_CODE"]??"",e["BUILDING_AREA_DESCP"]??"",e["PENDING"]??"",e["UPCOMING"]??"",e["COMPLETED"]??""));
    }
    return rtnWidget;
  }
  Widget wAreaCard(code,name,pCount,uCount,cCount){
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            if(lstrSelectedArea.contains(code)){
              lstrSelectedArea.remove(code);
            }else{
              lstrSelectedArea.add(code);
            }
          });
          fnFilterOnClick();
        }
      },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: lstrSelectedArea.contains(code)? boxDecoration(white, 20):boxBaseDecoration(white, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.place_outlined ,color: txtSubColor,size: g.wstrIconSize+15,),
            tcn(name, txtSubColor, g.wstrHeadFont),
            gapHC(5),
            lineC(1.0, greyLight),
            gapHC(5),
            wDriverTaskRow(Icons.pending,"Pending",Colors.orange,pCount.toString()),
            wDriverTaskRow(Icons.upcoming,"Upcoming",Colors.blue,uCount.toString()),
            wDriverTaskRow(Icons.task_alt,"Completed",Colors.green,cCount.toString()),
          ],
        ),
      ),
    );
  }
  Widget wFilterCard(title,mode){
     return Bounce(
       duration: const Duration(milliseconds: 110),
       onPressed: (){
         if(mounted){
           setState(() {
             lstrFilterMode = mode;
           });
         }
         fnFilterOnClick();
       },
       child: Container(
         margin: const EdgeInsets.only(left: 5),
         padding: const EdgeInsets.all(5),
         decoration: boxBaseDecoration(lstrFilterMode == mode?subColor: white, 5),
         child: Column(
           children: [
             tcn(title, lstrFilterMode == mode? Colors.white:txtSubColor, g.wstrSubFont)
           ],
         ),
       ),
     );
  }
  List<Widget> wPendingList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrPendingList){
      rtnWidget.add(wSchCard(yellowLight,e),);
    }
    return rtnWidget;
  }
  List<Widget> wUpcomingList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrUpcomingList){
      rtnWidget.add(wSchCard(blueLight,e),);
    }
    return rtnWidget;
  }
  List<Widget> wCompletedList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrCompletedList){
      rtnWidget.add(wSchCard(greenLight,e),);
    }
    return rtnWidget;
  }

  Widget mailCard(icon,title){
    return Row(
      children: [
        Icon(icon,color: subColor,size: 14,),
        gapWC(5),
        tcn(title, bgColorDark, 13)
      ],
    );
  }


//==================================CALENDER

  List<dynamic> fnCalenderSchedule(dayFrom){
    var data = [];
    for(var e in lstrMonthData){
      var fromDate = DateTime.parse(e["SCH_DATE"].toString());
      var toDate = DateTime.parse(e["SCH_DATE"].toString()).add(const Duration(days: 1));
      if (fromDate.isBefore(dayFrom) && toDate.isAfter(dayFrom)) {
        data.add(e);
      }
    }
    return data;
  }

//==================================PAGE_FN

  fnFilterOnClick(){
     var dFrom  =  DateTime.now();
     var dTo  =  DateTime.now();
     var now = DateTime.now();

    if(mounted){
      setState(() {
        if(lstrFilterMode == "TT"){
          lstrTitleCard = "Till Today";
        }else if(lstrFilterMode == "T"){
          lstrTitleCard = "Today";
        }else if(lstrFilterMode == "Y"){
          dFrom =  DateTime.now().subtract(const Duration(days: 1));
          dTo =  DateTime.now().subtract(const Duration(days: 1));
          lstrTitleCard = "Yesterday";
        }else if(lstrFilterMode == "TM"){
          dFrom =  DateTime(now.year,now.month,1);
          dTo =  DateTime(now.year, now.month + 1, 0);
          lstrTitleCard = "This Month";
        }else if(lstrFilterMode == "TY"){
          dFrom =  DateTime(now.year,1,1);
          dTo =  DateTime(now.year,12,31);
          lstrTitleCard = "This Year";
        }else if(lstrFilterMode == "CC"){
          dFrom =  _selectedDay??DateTime.now();
          dTo =  _selectedDay??DateTime.now();
          lstrTitleCard = setDate(6, dFrom);
        }else if(lstrFilterMode == "MM"){
          dFrom =  DateTime(_focusedDay.year,_focusedDay.month,1);
          dTo =  DateTime(_focusedDay.year, _focusedDay.month + 1, 0);
          lstrTitleCard = setDate(14, dFrom);
        }

      });
      var f  = setDate(2, dFrom);
      var t  = setDate(2, dTo);

      var companyList  = [];
      var userList  = [];
      var areaList  = [];
      var buildingList  = [];

      for(var e in lstrSelectedCompany){
        companyList.add({
          "COL_KEY":e
        });
      }
      for(var e in lstrSelectedArea){
        areaList.add({
          "COL_KEY":e
        });
      }
      for(var e in lstrSelectedDriver){
        userList.add({
          "COL_KEY":e
        });
      }

      if(lstrFilterMode == "TT"){
        apiDashboard("",t,companyList,areaList,userList);
      }else{
        apiDashboard(f,t,companyList,areaList,userList);
      }
    }
  }
  fnAddSchedule(){
    if(mounted){
      setState(() {
        lstrPageMode = "S";
      });
    }
  }
  fnReceivingFilling(){
    if(mounted){
      Get.to(()=> const FillingHistory());
    }
  }
  fnScheduleCallBack(){
    if(mounted){
      setState(() {
        lstrPageMode = "H";
      });
    }
    fnFilterOnClick();
  }
  fnGetPageData(){
     if(mounted){
       setState(() {
          lstrDriverList = [];
          lstrCompanyList = [];
          lstrAreaList = [];
       });
     }
     fnFilterOnClick();
     apiMonthData();
     fnCreateTutorial();
  }
  fnBuildingHistory(){
     PageDialog().showNote(context, const BuildingHistorySearch(), "Building History");
  }

  fnLogout() async{
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) =>  const LoginPage()
    ));
  }

  fnZoom(mode){
    if(mounted){
      setState(() {
        if(mode == "100"){
          g.wstrHeadFont =15.0;
          g.wstrSubFont =12.0;
          g.wstrIconSize =18.0;
          g.wstrSubIconSize =13.0;
        }else if(mode == "50"){
          g.wstrHeadFont =12.0;
          g.wstrSubFont =9.0;
          g.wstrIconSize =15.0;
          g.wstrSubIconSize =10.0;
        }
        else if(mode == "30"){
          g.wstrHeadFont =10.0;
          g.wstrSubFont =7.0;
          g.wstrIconSize =13.0;
          g.wstrSubIconSize =8.0;
        }
      });
    }
  }



//==================================APICALL


  apiDashboard(dateFrom,dateTo,company,area,user){

     var buildingList  = [];
     g.wstrContext = context;
     futureFrom = apiCall.apiDashboard(g.wstrCompany, dateFrom, dateTo, company, user, area, buildingList);
     futureFrom.then((value) => apiDashboardRes(value));
  }
  apiDashboardRes(value){
     if(mounted){
       setState(() {
         lstrOverallDetails = [];
         lstrTotalPlannedCount  =  0;
         lstrTotalPcount  =  0;
         lstrTotalUcount  =  0;
         lstrTotalCcount  =  0;

         lstrFPlannedCount  =  0;
         lstrFPcount  =  0;
         lstrFUcount  =  0;
         lstrFCcount  =  0;

         lstrDriverList = [];
         lstrCompanyList = [];
         lstrAreaList = [];

         lstrPendingList = [];
         lstrUpcomingList = [];
         lstrCompletedList = [];

         if(g.fnValCheck(value)){
           lstrOverallDetails =  [value["OVERALL"]?? {}];
           lstrTotalPlannedCount  =  g.mfnInt(lstrOverallDetails[0]["PLANNED"]);
           lstrTotalPcount  =  g.mfnInt(lstrOverallDetails[0]["PENDING"]);
           lstrTotalUcount  =  g.mfnInt(lstrOverallDetails[0]["UPCOMING"]);
           lstrTotalCcount  =  g.mfnInt(lstrOverallDetails[0]["COMPLETED"]);

           var filterCount  = [value["FILTERED"]];
           lstrFPlannedCount  =  g.mfnInt(filterCount[0]["PLANNED"]);
           lstrFPcount  =  g.mfnInt(filterCount[0]["PENDING"]);
           lstrFUcount  =  g.mfnInt(filterCount[0]["UPCOMING"]);
           lstrFCcount  =  g.mfnInt(filterCount[0]["COMPLETED"]);


           lstrCompanyList =  mfnAssign(value["COMPANYWISE"]);
           lstrDriverList =  mfnAssign(value["USERWISE"]);
           lstrAreaList =  mfnAssign(value["AREAWISE"]);

           lstrPendingList =  mfnAssign(value["LIST_PENDING"]);
           lstrUpcomingList =  mfnAssign(value["LIST_UPCOMING"]);
           lstrCompletedList =  mfnAssign(value["LIST_COMPLETED"]);


         }

       });
       if(lstrFilterMode == "MM"){
         apiMonthDataRes(value);
       }
     }

  }

  apiMonthData(){
    var dFrom =  DateTime(_focusedDay.year,_focusedDay.month,1);
    var dTo =  DateTime(_focusedDay.year, _focusedDay.month + 1, 0);

    var f  = setDate(2, dFrom);
    var t  = setDate(2, dTo);
    g.wstrContext = context;
    futureFrom = apiCall.apiDashboard(g.wstrCompany, f, t, [], [], [], []);
    futureFrom.then((value) => apiMonthDataRes(value));
  }
  apiMonthDataRes(value){
     if(mounted){
       setState(() {
         if(g.fnValCheck(value)){
           var p  =  mfnAssign(value["LIST_PENDING"]);
           var u  =  mfnAssign(value["LIST_UPCOMING"]);
           var c  =  mfnAssign(value["LIST_COMPLETED"]);
           for (var e in p){
            lstrMonthData.add(e);
           }
           for (var e in u){
             lstrMonthData.add(e);
           }
           for (var e in c){
             lstrMonthData.add(e);
           }
         }
       });
     }
  }


//==============================================================Tutorial
  showTutorial() {
    tutorialCoachMark.show(context: context);
  }
  fnCreateTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: fnCreateTargets(),
      colorShadow: Colors.red,
      textSkip: "SKIP",
      paddingFocus: 10,
      opacityShadow: 0.8,
      onFinish: () {
        dprint("finish");
      },
      onClickTarget: (target) {
        dprint('onClickTarget: $target');
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        dprint("target: $target");
        dprint(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        dprint('onClickOverlay: $target');
      },
      onSkip: () {
        dprint("skip");
      },
    );
  }
  List<TargetFocus> fnCreateTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "OVERALL",
        keyTarget: key1,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end  ,
                  children: <Widget>[
                    th('TASK', Colors.white, 25),
                    tcn('Task overall details', Colors.white, 20)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "TASK",
        keyTarget: key2,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end  ,
                  children: <Widget>[
                    th('TASK', Colors.white, 25),
                    tcn('Task details based on filter.', Colors.white, 20)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "FILTER",
        keyTarget: key3,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end  ,
                  children: <Widget>[
                    th('Filter', Colors.white, 25),
                    tcn('Filter task details', Colors.white, 20)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "CALENDER",
        keyTarget: key4,
        alignSkip: Alignment.bottomRight,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end  ,
                  children: <Widget>[
                    th('TASK CALENDER', Colors.white, 25),
                    tcn('You can filter data , date and month wise.', Colors.white, 20)
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }
}

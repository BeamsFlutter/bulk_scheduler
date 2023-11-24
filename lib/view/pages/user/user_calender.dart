
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class UserCalender extends StatefulWidget {
  const UserCalender({Key? key}) : super(key: key);

  @override
  State<UserCalender> createState() => _UserCalenderState();
}

class _UserCalenderState extends State<UserCalender> {

  //Global
  var g =  Global();
  var apiCall =  ApiCall();
  late Future<dynamic> futureFrom;

  //Page variables
  var lstrSelectedCard = 'P';
  var lstrSelectedDate = DateTime.now();

  var lstrFPcount  =  0;
  var lstrFCcount  =  0;

  var lstrPendingList = [];
  var lstrCompletedList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            child: CalendarTimeline(
              initialDate: lstrSelectedDate,
              firstDate: DateTime(2022, 1, 1),
              lastDate: DateTime(2100, 11, 20),
              onDateSelected: (date){
                if(mounted){
                  setState(() {
                    lstrSelectedDate = date;
                  });
                  fnGetPageData();
                }
              },
              leftMargin: 5,
              monthColor: txtSubColor,
              dayColor: txtSubColor,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: subColor,
              dotsColor: Colors.white,
              //selectableDayPredicate: (date) => date.day != 23,
              locale: 'en_ISO',
            ),
          ),
          lineS(),
          Row(
            children: [
              wTodayCard(Icons.pending, Colors.orange, 'Pending',lstrFPcount.toString(),'P'),
              gapWC(5),
              wTodayCard(Icons.task_alt, Colors.green, 'Completed',lstrFCcount.toString(),'C'),
            ],
          ),
          gapHC(5),
          lstrSelectedCard == 'P'?
          Expanded(child: SingleChildScrollView(
            child: animColumn(wTodayPendingList()),
          )):
          lstrSelectedCard == 'C'?
          Expanded(child: SingleChildScrollView(
            child: animColumn(wTodayCompletedList()),
          )):
          Container()
        ],
      ),
    );
  }
//==================================WIDGET
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

  List<Widget> wTodayPendingList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrPendingList){
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
  Widget wTaskCard(e,mode){
    var schDate  = e["SCH_DATE"] == null || e["SCH_DATE"] == ""?"": setDate(6, DateTime.parse(e["SCH_DATE"].toString()));
    var docDate  = e["DOCDATE"] == null || e["DOCDATE"] == ""?"": setDate(6, DateTime.parse(e["DOCDATE"].toString()));
    return  Bounce(
      onPressed: (){
        if(mode == "P"){
          //fnFilling(e);
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
    var today = setDate(2, lstrSelectedDate);
    apiDashboard(today,today,[]);
  }

//==================================API CALL

  apiDashboard(dateFrom,dateTo,area){
    var buildingList  = [];
    var user  =  [{
      "COL_KEY":g.wstrUserCd,
    }];
    futureFrom = apiCall.apiDashboard(g.wstrCompany, dateFrom, dateTo, [], user, area, buildingList);
    futureFrom.then((value) => apiDashboardRes(value));
  }

  apiDashboardRes(value){
    if(mounted){
      setState(() {

        lstrFPcount  =  0;
        lstrFCcount  =  0;

        lstrPendingList = [];
        lstrCompletedList = [];

        if(g.fnValCheck(value)){

          var filterCount  = [value["FILTERED"]];

          lstrFPcount  =  g.mfnInt(filterCount[0]["PENDING"]);
          lstrFCcount  =  g.mfnInt(filterCount[0]["COMPLETED"]);

          lstrPendingList =  mfnAssign(value["LIST_PENDING"]);
          lstrCompletedList =  mfnAssign(value["LIST_COMPLETED"]);
        }

      });
    }
  }
}

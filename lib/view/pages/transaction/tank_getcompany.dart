

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class GetCompany extends StatefulWidget {
  final Function fnCallBack;
  const GetCompany({Key? key, required this.fnCallBack}) : super(key: key);

  @override
  State<GetCompany> createState() => _GetCompanyState();
}

class _GetCompanyState extends State<GetCompany> {
  
  //Global
  var g = Global();
  var apiCall =  ApiCall();
  late Future<dynamic> futureForm;
  
  //Page Variables
  var lstrCompanyList = [];

  var lstrTimeFrom ;
  var lstrTimeTo ;
  var lstrTimeFromStr = "" ;
  var lstrTimeToStr = "";

  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();
    super.initState();

  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      child: SingleChildScrollView(
        child: Column(
          children: wCompanyList(),
        ),
      )
    );
  }
  
  
//==================================WIDGET
  List<Widget> wCompanyList(){
    List<Widget> rtnWidget  = [];
    
    for(var e in lstrCompanyList){
      rtnWidget.add(Bounce(
        duration: const Duration(milliseconds: 110),
        onPressed: (){
          Get.back();
          widget.fnCallBack(e);
        },
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: boxDecoration(white, 5),
          margin: const EdgeInsets.only(bottom: 5),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance,color: subColor,size: g.wstrSubFont,),
                  gapWC(10),
                  Expanded(child: tcn('${e["COMPANY_CODE"].toString()} | ${e["COMPANY_DESCP"].toString()}', txtSubColor, g.wstrSubFont))
                ],
              )
            ],
          ),
        ),
      ));
    }
    
    return rtnWidget;
  }
  
//==================================PAGE_FN
  fnGetPageData(){
    if(mounted){
      setState(() {
        var h = DateTime.now().hour;
        var m = DateTime.now().minute;
        lstrTimeFrom =  TimeOfDay(hour: h, minute: m);
        lstrTimeTo =  TimeOfDay(hour: h, minute: m);
        var now  =  DateTime.now();
        lstrTimeFromStr  =  setDate(11, DateTime(now.year,now.month,now.day,lstrTimeFrom.hour,lstrTimeFrom.minute));
        lstrTimeToStr  =  setDate(11, DateTime(now.year,now.month,now.day,lstrTimeTo.hour,lstrTimeTo.minute));

      });
      apiGetCompany();
    }
  }
//==================================APICALL
  apiGetCompany(){
    futureForm = apiCall.apiGetScheduleCompany();
    futureForm.then((value) => apiGetCompanyRes(value));
  }
  apiGetCompanyRes(value){
    //{ID: 3, COMPANY_CODE: 01, COMPANY_DESCP: SERGAS ABHUDHABI, ACTIVE_YEARCODE: 2022}
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          lstrCompanyList =  value;
        }
      });
    }
  }
}

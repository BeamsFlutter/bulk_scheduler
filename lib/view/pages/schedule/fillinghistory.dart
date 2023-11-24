

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:scheduler/view/tutorials/draglistitems.dart';

class FillingHistory extends StatefulWidget {
  const FillingHistory({Key? key}) : super(key: key);

  @override
  State<FillingHistory> createState() => _FillingHistoryState();
}

class _FillingHistoryState extends State<FillingHistory> {


  //Global
  var g =  Global();
  var apiCall =  ApiCall();
  late Future<dynamic> futureForm;

  //Page Variables
  var lstrSelectedCard = "A";
  var lstrDateFromStr = "";
  var lstrDateToStr = "";
  var lstrSearchData = [];
  var lstrSelectedData = [];
  var lstrFillingData = [];
  var lstrFillingDetData = [];


  var lstrDateFrom = DateTime.now();
  var lstrDateTo = DateTime.now();

  var lstrReceivedQty = 0.0;
  var lstrFilledQty = 0.0;
  var lstrBalanceQty = 0.0;

  //Filter
  var lstrCompanyList = [];
  var lstrDriverList = [];

  var lstrSelectedCompanyList = [];
  var lstrSelectedDriverList = [];


  //Controller
   var txtSearch = TextEditingController();

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              width: 300,
              padding: const EdgeInsets.all(10),
              decoration: boxDecoration(white, 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Bounce(
                        duration: const Duration(milliseconds: 110),
                        onPressed: (){
                          Get.back();
                        },
                        child: Container(
                          decoration: boxBaseDecoration(greyLight, 10),
                          padding: const EdgeInsets.all(10),
                          child: Icon(Icons.arrow_back_outlined,color: txtColor,size: g.wstrIconSize,),
                        ),
                      ),
                      gapWC(10),
                      th('Receiving & Filling',txtColor,g.wstrHeadFont)
                    ],
                  ),
                  lineS(),
                  // Container(
                  //   decoration: boxBaseDecoration(greyLight, 10),
                  //   padding: const EdgeInsets.all(6),
                  //   child: Row(
                  //     children: [
                  //       wSelectionCard("Search",Icons.search,"P"),
                  //       gapWC(10),
                  //       wSelectionCard("Filter",Icons.filter_list,"A"),
                  //     ],
                  //   ),
                  // ),
                  // lineS(),
                  Expanded(child: Column(
                    children: [

                      Row(
                        children: [
                          Expanded(child: Container(
                            height: 40,
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: boxBaseDecoration(greyLight, 5),
                            child: TextFormField(
                              controller: txtSearch,
                              enabled: true,
                              decoration: const InputDecoration(
                                  hintText: 'Search',
                                  border: InputBorder.none,
                                  suffixIcon:  Icon(Icons.search,color: subColor)
                              ),
                              onChanged: (value){
                                apiGetReceivingList();
                              },
                            ),
                          ),),
                          gapWC(10),
                          GestureDetector(
                            onTap: (){
                              if(mounted){
                                setState(() {
                                  lstrSelectedCard =  lstrSelectedCard == "P"?"A":"P";
                                });
                              }
                            },
                            child:  Icon( lstrSelectedCard == "P"? Icons.filter_list_outlined : Icons.keyboard_arrow_up_sharp,color: bgColorDark,size: 15,),
                          ),
                          gapWC(10),
                        ],
                      ),
                      lstrSelectedCard == "A"?
                      Column(
                        children: [
                          gapHC(10),
                          Row(
                            children: [
                              Flexible(
                                child: Bounce(
                                  duration: const Duration(milliseconds: 110),
                                  onPressed: (){
                                    _selectFromDate(context);
                                  },
                                  child: Container(
                                    decoration: boxBaseDecoration(blueLight, 5),
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_month_sharp,color: subColor,size: g.wstrSubIconSize,),
                                        gapWC(5),
                                        tcn(lstrDateFromStr, bgColorDark, g.wstrSubFont)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              gapWC(10),
                              Flexible(
                                  child: Bounce(
                                    duration: const Duration(milliseconds: 110),
                                    onPressed: (){
                                      _selectToDate(context);
                                    },
                                    child: Container(
                                      decoration: boxBaseDecoration(blueLight, 5),
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.calendar_month_sharp,color: subColor,size: g.wstrSubIconSize,),
                                          gapWC(5),
                                          tcn(lstrDateToStr, bgColorDark, g.wstrSubFont)
                                        ],
                                      ),
                                    ),
                                  )
                              )
                            ],
                          ),
                          gapHC(10),
                          // Wrap(
                          //   children: wCompanyList(),
                          // ),
                          gapHC(0),
                          lineS(),
                          Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: (){
                              apiGetReceivingList();
                            },
                            child: Container(
                              decoration: boxBaseDecoration(subColor, 5),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      th('APPLY', Colors.white, g.wstrSubFont),
                                      gapWC(5),
                                      Icon(Icons.task_alt,color: Colors.white,size: g.wstrSubIconSize,)
                                    ],
                                  ),

                                ],
                              ),
                            ),
                          ),
                          lineS(),
                        ],
                      ):Container(),
                      gapHC(5),
                      Expanded(child: SingleChildScrollView(
                        child: Column(
                            children:wRecList()),
                      ))
                    ],
                  ))
                ],
              ),
            ),
            gapWC(10),
            Expanded(child: Container(
              decoration: boxBaseDecoration(Colors.white, 10),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [

                  wReceivingDetails(),
                  subHead('Company Filling Details'),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children:
                                wCompanyFillingList()
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  subHead('Filling History'),
                  Row(
                    children: [
                      wHead("COMPANY",2,"L"),
                      wHead("FILLING #",1,"L"),
                      wHead("DRIVER",1,"L"),
                      wHead("VEHICLE",1,"L"),
                      wHead("DATE",1,"L"),

                      wHead("BUILDING",3,"L"),
                      wHead("QTY",1,"R"),

                    ],
                  ),
                  Expanded(child: Container(
                    decoration: boxBaseDecoration(blueLight.withOpacity(0.2), 5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: wFillingList(),
                      ),
                    ),
                  ))

                ],
              ),
            )),
            // Container(
            //   width: 300,
            //   decoration: boxBaseDecoration(Colors.white, 10),
            //   child: Column(
            //     children: [
            //       Row(),
            //     ],
            //   ),
            // )

          ],
        ),
      ),
    );
  }

  //==========================================WIDGET

   Widget wHead(name,flex,align){
     return Flexible(
       flex: flex,
       child: Container(
         decoration: boxDecoration(Colors.white, 0),
         padding: const EdgeInsets.all(5),
         child: Column(
           crossAxisAlignment:align == "L"? CrossAxisAlignment.start:CrossAxisAlignment.end,
           children: [
             Row(),
             th(name, bgColorDark, 10)
           ],
         ),
       ),
     );
   }
  Widget wSub(name,flex,colorNo,align){
    return Flexible(
      flex: flex,
      child: Container(
        decoration: boxBaseDecoration(colorNo == 0?blueLight:greyLight, 0),
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment:align == "L"? CrossAxisAlignment.start:CrossAxisAlignment.end,
          children: [
            Row(),
            tcn(name, bgColorDark, 10)
          ],
        ),
      ),
    );
  }

   List<Widget> wRecList(){
     List<Widget> rtnList  =  [];
     rtnList.add(Row());
     for(var e in  lstrSearchData){
       var data =  [];
       data =  e["DATA"]??[];
       data.isNotEmpty?
       rtnList.add(
         Bounce(
           duration: const  Duration(milliseconds: 110),
           onPressed: (){
                if(mounted){
                  setState(() {
                    lstrSelectedData = [];
                    lstrSelectedData.add(e);
                    lstrReceivedQty =  g.mfnDbl(data[0]["QTY1"]);
                  });
                  apiGetPDAFillingList(data[0]["PDA_NO"]);
                }
           },
           child: Container(
             margin: const EdgeInsets.all(5),
             padding: const EdgeInsets.all(10),
             decoration: boxDecoration(bgColorDark, 10),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     th(data[0]["DOCNO"], Colors.white, g.wstrSubFont),
                     Row(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Icon(Icons.calendar_month_sharp,color: Colors.white,size: g.wstrSubIconSize,),
                         gapWC(5),
                         tcn(setDate(15, DateTime.parse(data[0]["RECEIVING_DATE"])), Colors.white, g.wstrSubFont),
                       ],
                     ),

                   ],
                 ),
                 gapHC(5),
                 lineC(0.5, greyLight),
                 gapHC(10),
                 wRecRow('Company','${e["COMPANY"]} | ${e["COMPANY_DESCP"]}',Icons.account_balance_rounded,),
                 wRecRow('Supplier','${data[0]["CUSTOMER_CODE"]} | ${data[0]["CUSTOMER_NAME"]}',Icons.person,),
                 wRecRow('Driver','${data[0]["DEL_MAN"]} | ${data[0]["DEL_MAN_NAME"]}',Icons.support,),
                 wRecRow('Vehicle',data[0]["VEHICLE_NO"],Icons.local_taxi_outlined,),
                 wRecRow('PDA No',data[0]["PDA_NO"],Icons.pending_actions,),
                 wRecRow('Time','${data[0]["TIME_FROM"]} - ${data[0]["TIME_TO"]}',Icons.access_time,),
                 gapHC(10),
                 Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                   decoration: boxDecoration(Colors.white, 5),
                   child: Row(
                     children: [
                       Flexible(
                         flex: 3,
                         child: Row(
                           children: [
                             Icon(Icons.gas_meter_outlined,color: bgColorDark,size: g.wstrSubIconSize,),
                             gapWC(5),
                             tcn("QTY ", bgColorDark, g.wstrSubFont),
                           ],
                         ),
                       ),
                       gapWC(5),
                       Flexible(
                           flex: 7,
                           child: Row(
                             children: [
                               th('${data[0]["QTY1"].toString()}   ${data[0]["UNIT1"]}', subColor, g.wstrSubFont),
                             ],
                           ))
                     ],
                   ),
                 )

               ],
             ),
           ),
         )
       ):'';
     }


     return rtnList;
   }
   List<Widget> wFillingList(){
    List<Widget> rtnList  =  [];
    rtnList.add(Row());
    var colorNo = 0;
    for(var e in  lstrFillingDetData){
      rtnList.add(
        Bounce(
          duration: const Duration(milliseconds: 110),
          onPressed: (){

          },
          child: Row(
            children: [
              wSub('${e["COMPANY"].toString()} | ${e["COMPANY_DESCP"]??""}',2,colorNo,"L"),
              wSub(e["DOCNO"].toString(),1,colorNo,"L"),
              wSub(e["DEL_MAN"].toString(),1,colorNo,"L"),
              wSub(e["VEHICLE_NO"].toString(),1,colorNo,"L"),
              wSub(setDate(15, DateTime.parse(e["CURR_FILL_DATE"]??DateTime.now().toString())),1,colorNo,"L"),

              wSub('${e["BUILDING_CODE"].toString()} | ${e["DESCP"].toString()}',3,colorNo,"L"),
              wSub(e["QTY"].toString(),1,colorNo,"R"),

            ],
          ),
        )
      );
      colorNo = colorNo == 0?1:0;
    }


    return rtnList;
  }
   Widget wRecRow(head,text,icon,){
     return Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Flexible(
           flex: 3,
           child: Row(
             children: [
               Icon(icon,color: Colors.white,size: g.wstrSubIconSize-2,),
               gapWC(5),
               tcn(head.toString(), Colors.white, g.wstrSubFont-2),
             ],
           ),
         ),
         gapWC(5),
         Flexible(
           flex: 7,
           child: Row(
           children: [
             Expanded(child: th(text.toString(), Colors.white, g.wstrSubFont-2),)
           ],
         ))
       ],
     );
   }
   Widget wRecRowBlack(head,text,icon,){
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Row(
            children: [
              Icon(icon,color: Colors.black,size: g.wstrSubIconSize-2,),
              gapWC(5),
              tcn(head.toString(), Colors.black, g.wstrSubFont-2),
            ],
          ),
        ),
        gapWC(5),
        Flexible(
            flex: 8,
            child: Row(
              children: [
               Expanded(child:  th(text.toString(), Colors.black, g.wstrSubFont-2),)
              ],
            ))
      ],
    );
  }
   Widget wSelectionCard(title,icon,mode){
     return Flexible(child:
     Bounce(
       onPressed: (){
          if(mounted){
            setState(() {
              lstrSelectedCard = mode;
            });
          }
       },
       duration: const Duration(milliseconds: 110),
       child: Container(
         decoration: boxBaseDecoration(lstrSelectedCard==mode? subColor:Colors.white, 5),
         padding: const EdgeInsets.all(5),
         child: Column(
           children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 tcn(title, lstrSelectedCard==mode?Colors.white:Colors.black, g.wstrHeadFont),
                 Icon(icon,color:lstrSelectedCard==mode?Colors.white:Colors.black,size: g.wstrHeadFont,)
               ],
             )
           ],
         ),
       ),
     )
     );
   }
   wCompanyList() {
     List<Widget> choices = [];
     for (var e in lstrCompanyList) {
       choices.add(Container(
         margin: const EdgeInsets.only(bottom: 5),
         decoration: boxBaseDecoration(greyLight, 5),
         padding: const EdgeInsets.symmetric(horizontal: 10),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Expanded(child: tcn(e["COMPANY_DESCP"].toString().toUpperCase(),bgColorDark,10),),
             Transform.scale(
               scale: .7,
               child: CupertinoSwitch(
                 activeColor: lstrSelectedCompanyList.contains(e["COMPANY_CODE"])
                     ? Colors.greenAccent
                     : Colors.grey.withOpacity(0.6),
                 onChanged: (bool value) {
                   setState(() {
                     lstrSelectedCompanyList.contains(e["COMPANY_CODE"])
                         ? lstrSelectedCompanyList.remove(e["COMPANY_CODE"])
                         : lstrSelectedCompanyList.add(e["COMPANY_CODE"]);
                   });
                 },
                 value: lstrSelectedCompanyList.contains(e["COMPANY_CODE"]),
               ),
             ),
           ],
         ),
       ));
     }

     return choices;
   }
   List<Widget> wCompanyFillingList(){
    List<Widget> rtnWidget = [];
    for(var e in lstrCompanyList){
      rtnWidget.add(wCompanyCard(e["COMPANY_CODE"],e["COMPANY_DESCP"]??"",e["FILLED_QTY"].toString()));
    }
    return rtnWidget;
  }
   Widget wCompanyCard(code,name,fQty){
    return Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        if(mounted){
          setState(() {
            // if(lstrSelectedCompany.contains(code)){
            //   lstrSelectedCompany.remove(code);
            // }else{
            //   lstrSelectedCompany.add(code);
            // }
          });

        }
      },
      child: Container(
        width: 180,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: boxDecoration(white, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance_outlined ,color: txtSubColor,size: g.wstrIconSize+15,),
            tcn(name, txtSubColor, g.wstrHeadFont-2),
            gapHC(5),
            lineC(1.0, greyLight),
            gapHC(5),
            th('FILLED QTY',Colors.black,g.wstrHeadFont-2),
            th(fQty.toString(),subColor,g.wstrHeadFont)
          ],
        ),
      ),
    );
  }
   Widget wReceivingDetails(){
     if(lstrSelectedData.isNotEmpty){
       var e =  lstrSelectedData[0];
       var data =  e["DATA"]??[];
       var balance = 0.0;
       balance =  g.mfnDbl(data[0]["QTY1"])- g.mfnDbl(data[0]["FILL_QTY"]);
       return  Container(
         decoration: boxDecoration(Colors.white, 10),
         padding: const EdgeInsets.all(10),
         child: Column(
           children: [
             Row(
               children: [
                 th('Receiving Details', bgColorDark, 15)
               ],
             ),
             lineS(),
             Row(
               children: [
                 Flexible(child: Column(
                   children: [
                     wRecRowBlack('Company','${e["COMPANY"]} | ${e["COMPANY_DESCP"]}',Icons.account_balance_rounded,),
                     wRecRowBlack('Supplier','${data[0]["CUSTOMER_CODE"]} | ${data[0]["CUSTOMER_NAME"]}',Icons.support,),
                     wRecRowBlack('Driver','${data[0]["DEL_MAN"]} | ${data[0]["DEL_MAN_NAME"]}',Icons.support,),
                     wRecRowBlack('Vehicle',data[0]["VEHICLE_NO"].toString(),Icons.local_taxi_outlined,),
                     wRecRowBlack('PDN No',data[0]["PDA_NO"].toString(),Icons.pending_actions,),
                     wRecRowBlack('Time','${data[0]["TIME_FROM"]} - ${data[0]["TIME_TO"]}',Icons.access_time,),
                   ],
                 )),
                 Flexible(
                     child: Row(
                       children: [
                         Flexible(child: Container(
                           padding: const EdgeInsets.all(10),
                           decoration: boxBaseDecoration(greenLight, 10),
                           child: Column(
                             children: [
                               Row(),
                               tcn('RECEIVED', Colors.black, 15),
                               lineC(0.1, Colors.black),
                               th('${data[0]["QTY1"].toString()}   ${data[0]["UNIT1"]}', Colors.black, 18),
                               lineC(0.1, Colors.black),
                             ],
                           ),
                         )),
                         gapWC(5),
                         Flexible(child: Container(
                           padding: const EdgeInsets.all(10),
                           decoration: boxBaseDecoration(redLight, 10),
                           child: Column(
                             children: [
                               Row(),
                               tcn('FILLED', Colors.black, 15),
                               lineC(0.1, Colors.black),
                               th('${lstrFilledQty.toString()}   ${data[0]["UNIT1"]}', Colors.black, 18),
                               lineC(0.1, Colors.black),
                             ],
                           ),
                         )),
                         gapWC(5),
                         Flexible(child: Container(
                           padding: const EdgeInsets.all(10),
                           decoration: boxBaseDecoration(blueLight, 10),
                           child: Column(
                             children: [
                               Row(),
                               tcn('BALANCE', Colors.black, 15),
                               lineC(0.1, Colors.black),
                               th('${lstrBalanceQty.toString()}   ${data[0]["UNIT1"]}', Colors.black, 18),
                               lineC(0.1, Colors.black),
                             ],
                           ),
                         )),
                       ],
                     )),

               ],
             )
           ],
         ),
       );
     }else{
       return Container();
     }

   }

  //==========================================PAGE FN
  fnGetPageData(){
    if(mounted){
      setState(() {
        lstrDateFrom =  DateTime.now();
        lstrDateTo =  DateTime.now();
        lstrDateFromStr = setDate(15, lstrDateFrom).toString().toUpperCase();
        lstrDateToStr = setDate(15, lstrDateTo).toString().toUpperCase();
      });
      apiGetReceivingList();
      //apiGetCompany();
    }
  }
  Future<void> _selectFromDate(BuildContext context) async {

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: lstrDateFrom,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != lstrDateFrom) {
      setState(() {
        lstrDateFrom = pickedDate;
        lstrDateFromStr = setDate(15, lstrDateFrom).toString().toUpperCase();
      });
    }
  }
  Future<void> _selectToDate(BuildContext context) async {

    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: lstrDateTo,
        firstDate: DateTime(2018),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != lstrDateTo) {
      setState(() {
        lstrDateTo = pickedDate;
        lstrDateToStr = setDate(15, lstrDateTo).toString().toUpperCase();
      });
    }
  }

  fnFillData(){
     if(mounted){
       setState(() {
         lstrCompanyList = [];
         lstrFillingDetData = [];
         lstrFilledQty =  0.0;
         lstrBalanceQty = 0.0;

         for(var e in lstrFillingData){
           var fillQty = 0.0;
           for(var f in e["DATA"]??[]){
             fillQty = fillQty +g.mfnDbl(f["QTY"]);
             lstrFillingDetData.add(f);
           }
           lstrFilledQty = lstrFilledQty+fillQty;
           lstrCompanyList.add({
             "COMPANY_CODE":e["COMPANY"],
             "COMPANY_DESCP":e["COMPANY"],
             "FILLED_QTY":fillQty,
           });

         }

         lstrBalanceQty =  lstrReceivedQty - lstrFilledQty;
       });
     }
  }

  //==========================================API CALL
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

  apiGetReceivingList(){
     var from =  setDate(2, lstrDateFrom);
     var to =  setDate(2, lstrDateTo);
     if(txtSearch.text.isNotEmpty){
       from = null;
       to = null;
     }
     futureForm =  apiCall.apiReceivingList(g.wstrCompany,from,to,txtSearch.text);
     futureForm.then((value) => apiGetReceivingListRes(value));
  }
  apiGetReceivingListRes(value){
     if(mounted){
       setState(() {
         lstrSearchData = [];
         if(g.fnValCheck(value)){
           lstrSearchData = value;
         }
       });
     }
  }

  apiGetPDAFillingList(pdaNo){
    futureForm =  apiCall.apiPDAFillingList(pdaNo);
    futureForm.then((value) => apiGetPDAFillingListRes(value));
  }
  apiGetPDAFillingListRes(value){
    if(mounted){
      setState(() {
        lstrFilledQty =  0.0;
        lstrBalanceQty = 0.0;
        lstrFillingData = [];
        if(g.fnValCheck(value)){
          lstrFillingData = value;
        }
      });
      fnFillData();
    }
  }
}

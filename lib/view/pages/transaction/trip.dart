
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/alertDialog/alertDialog.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/components/lookup/lookupSch_mobile.dart';
import 'package:scheduler/view/pages/transaction/trip_history.dart';
import 'package:scheduler/view/styles/colors.dart';

class Trip extends StatefulWidget {
  final Function fnCallBack;
  const Trip({Key? key, required this.fnCallBack}) : super(key: key);

  @override
  State<Trip> createState() => _TripState();
}



class _TripState extends State<Trip> {

  //Global
  var g  = Global();
  var apiCall = ApiCall();


  //Page Variables
  var wstrPageMode = "ADD";
  var frmCompanyCode = "01";
  var wstrPageForm = [];
  var wstrPageLookup = [];
  late Future<dynamic> futureView;
  var lstrTripData  =  [];
  var lstrTripSts  =  false;
  var lstrTripDocno  = '';
  var lstrTripDoctype  = '';

  var CALL_PDN_FROM_STOCKTXNDET  = "N";

  //Controller
  var txtDriverCode = TextEditingController();
  var txtDriverName = TextEditingController();
  var txtVehicleNo = TextEditingController();
  var txtVehicleDescp = TextEditingController();
  var txtHelp1 = TextEditingController();
  var txtHelp1Name = TextEditingController();
  var txtHelp2 = TextEditingController();
  var txtHelp2Name = TextEditingController();
  var txtSupplierPdnNo = TextEditingController();
  var txtSupplierCode = TextEditingController();
  var txtSupplierName = TextEditingController();
  var txtTripNo  =  TextEditingController();
  var txtStartKm  =  TextEditingController();
  var txtEndKm  =  TextEditingController();
  var lstrTripNo  = "";
  var lstrTripName  = "";
  var lstrTripStartTime  = "";

  var pnDriverCode = FocusNode();
  var pnDriverName = FocusNode();
  var pnVehicleNo = FocusNode();
  var pnHelp1 = FocusNode();
  var pnHelp1Name = FocusNode();
  var pnHelp2 = FocusNode();
  var pnHelp2Name = FocusNode();
  var pnSupplierPdnNo = FocusNode();
  var pnSupplierCode = FocusNode();
  var pnSupplierName = FocusNode();
  var pnTripNo = FocusNode();
  var pnStartKm = FocusNode();
  var pnEndKm = FocusNode();


  var lstrTime = "";
  late Timer timer;

  var tripSts = "";


  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: boxBaseDecoration(Colors.white, 0),
        margin: MediaQuery.of(context).padding,
        child: Column(
          children: [
            Container(
              height: 70,
              decoration: boxImageDecorationC("assets/images/img_5.png", 0,0,0,0),
              child: Container(
                decoration: boxGradientDecorationBaseC(20, 0,0,0,0),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: (){
                            Get.back();
                          },
                          child: const Icon(Icons.arrow_back_sharp,color: Colors.white,size: 18,),
                        ),
                        tcn('Trip Details', Colors.white, 15),
                        GestureDetector(
                          onTap: (){
                            Get.to(()=>  const TripHistory());
                          },
                          child: const Icon(Icons.history,color: Colors.white,size: 18,),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child:Container(
              decoration: boxDecoration(Colors.white, 10),
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              child: wTripCard()
            )),
            gapHC(5),
            wstrPageMode == "ADD"?
            Bounce(
              duration: const Duration(milliseconds: 110),
              onPressed: (){
                fnStart();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(5),
                decoration: boxDecoration(Colors.green, 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time_sharp,color: Colors.white,size: 15,),
                    gapWC(5),
                    tcn('START', Colors.white , 15)
                  ],
                ),
              )
            ):Row(
              children: [
                
                Flexible(
                  child: Bounce(
                      duration: const Duration(milliseconds: 110),
                      onPressed: (){
                        fnEnd("EDIT");
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        decoration: boxBaseDecoration(greyLight, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.edit,color: Colors.black,size: 13,),
                            gapWC(5),
                            tcn('UPDATE', Colors.black , 13)
                          ],
                        ),
                      )
                  ),
                ),
                Flexible(
                  child: Bounce(
                      duration: const Duration(milliseconds: 110),
                      onPressed: (){
                        fnEndTrip();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        decoration: boxDecoration(Colors.red, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.task_alt,color: Colors.white,size: 13,),
                            gapWC(5),
                            tcn('TRIP END', Colors.white , 13)
                          ],
                        ),
                      )
                  ),
                )
              ],
            )

          ],
        ),
      ),
    );
  }
  //======================================WIDGET
    Widget previewRow(icon,text,color){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,size: 12,color: color,),
          gapWC(10),
          Expanded(child:  tcn(text,color , 10))
        ],
      );
    }

  Widget wTripCard(){
    return Container(
      padding: const EdgeInsets.all(2),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Bounce(
              duration: const Duration(milliseconds: 110),
              onPressed: (){
                fnLookup("TRIP");
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: boxDecoration(bgColorDark, 10),
                child: Column(
                  children: [
                    Row(

                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        wstrPageMode == "ADD"?
                        tcn('CHOOSE TRIP',Colors.white,10):
                        tcn('TRIP DETAILS',Colors.white,10),
                        const Icon(Icons.search,color: Colors.white,size: 12,)
                      ],
                    ),
                    gapHC(5),
                    lineC(0.1, greyLight),
                    gapHC(5),
                    Row(
                      children: [
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            th(lstrTripNo.toString(),Colors.white,15),
                            gapHC(5),
                            tcn(lstrTripName.toString(), Colors.white, 12)
                          ],
                        ),),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            tcn('START TIME', Colors.white , 10),
                            wstrPageMode == "ADD"?
                            tcn(lstrTime.toString(), Colors.white , 15):
                            tcn(lstrTripStartTime.toString(), Colors.white , 12)
                          ],
                        )
                      ],
                    )

                  ],
                ),
              ),
            ),
            lineS(),
            Row(
              children: [
                Icon(Icons.drive_eta_rounded
                  ,color: txtSubColor,size: g.wstrSubIconSize,),
                gapWC(5),
                th('Vehicle Details', txtSubColor, g.wstrSubFont)
              ],
            ),
            lineS(),
            Bounce(
              duration: const Duration(milliseconds: 110),
              onPressed: (){
                fnLookup("DRIVER");
              },
              child: Slidable(
                closeOnScroll: true,
                enabled: txtDriverCode.text.isEmpty? false:true,
                endActionPane:  ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.2,
                  children: [

                    SlidableAction(
                      onPressed: (context){
                        txtDriverCode.clear();
                        txtDriverName.clear();
                      },
                      backgroundColor: greyLight,
                      foregroundColor: Colors.grey,
                      icon: Icons.clear,
                      label: 'Clear',
                    ),
                  ],
                ),
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: boxDecoration(Colors.white, 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxBaseDecoration(greyLight, 5),
                          child: Image.asset("assets/icons/driverc.png",width: 20,)),
                        gapWC(8),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            txtDriverCode.text.isEmpty?
                            tcn('Choose Driver', subColor, 10):
                            th('Driver', bgColorDark, 10),
                            lineC(0.3, greyLight),
                            txtDriverCode.text.isEmpty?
                            tcn("Driver Code", greyLight, 10):
                            tcn(txtDriverCode.text.toString(), Colors.black, 10),
                            txtDriverCode.text.isEmpty?
                            tcn("Driver Name", greyLight, 10):
                            tcn(txtDriverName.text.toString(), Colors.black, 10),
                          ],
                        ))
                      ],
                    )
                ),
              ),
            ),
            gapHC(5),
            Bounce(
              duration: const Duration(milliseconds: 110),
              onPressed: (){
                fnLookup("VEHICLE");
              },
              child: Slidable(
                closeOnScroll: true,
                enabled: txtVehicleNo.text.isEmpty? false:true,
                endActionPane:  ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.2,
                  children: [

                    SlidableAction(
                      onPressed: (context){
                          txtVehicleNo.clear();
                          txtVehicleDescp.clear();
                      },
                      backgroundColor: greyLight,
                      foregroundColor: Colors.grey,
                      icon: Icons.clear,
                      label: 'Clear',
                    ),
                  ],
                ),
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: boxDecoration(Colors.white, 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxBaseDecoration(greyLight, 5),
                          child: Image.asset("assets/icons/tanker1.png",width: 20,)),
                        gapWC(8),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            txtVehicleNo.text.isEmpty?
                            tcn('Select Vehicle', subColor, 10):
                            th('Vehicle', bgColorDark, 10),
                            lineC(0.3, greyLight),
                            txtVehicleNo.text.isEmpty?
                            tcn("Vehicle Code", greyLight, 10):
                            tcn(txtVehicleNo.text.toString(), Colors.black, 10),
                            txtVehicleNo.text.isEmpty?
                            tcn("Vehicle No", greyLight, 10):
                            tcn(txtVehicleDescp.text.toString(), Colors.black, 10),

                          ],
                        ))
                      ],
                    )
                ),
              ),
            ),
            gapHC(5),
            Bounce(

              duration: const Duration(milliseconds: 110),
              onPressed: (){

              },
              child:  Container(
                  padding: const EdgeInsets.all(5),
                  decoration: boxDecoration(Colors.white, 10),
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxBaseDecoration(greyLight, 5),
                          child: Image.asset("assets/icons/kmh.png",width: 20,)),
                      gapWC(8),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          th('START KM', bgColorDark, 10),
                          lineC(0.3, greyLight),
                          FormInput(
                            txtController:txtStartKm,
                            hintText: "Eg : 265355",
                            labelYn: "N",
                            focusNode: pnStartKm,
                            txtWidth: 1,
                            textType: TextInputType.number,
                            focusSts:pnStartKm.hasFocus?true:false,
                            enablests: true,
                            emptySts: true,
                            onClear: (){
                              txtStartKm.clear();
                            },
                          ),

                        ],
                      ))
                    ],
                  )
              ),
            ),
            gapHC(5),
            wstrPageMode == "EDIT"?
            Bounce(

              duration: const Duration(milliseconds: 110),
              onPressed: (){

              },
              child:  Container(
                  padding: const EdgeInsets.all(5),
                  decoration: boxDecoration(Colors.white, 10),
                  child: Row(
                    children: [
                      Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxBaseDecoration(greyLight, 5),
                          child: Image.asset("assets/icons/kmh.png",width: 20,)),
                      gapWC(8),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          th('FINAL KM', bgColorDark, 10),
                          lineC(0.3, greyLight),
                          FormInput(
                            txtController:txtEndKm,
                            hintText: "Eg : 285355",
                            labelYn: "N",
                            focusNode: pnEndKm,
                            txtWidth: 1,
                            textType: TextInputType.number,
                            focusSts:pnEndKm.hasFocus?true:false,
                            enablests: true,
                            emptySts: true,
                            onClear: (){
                              txtEndKm.clear();
                            },
                          ),

                        ],
                      ))
                    ],
                  )
              ),
            ):gapHC(0),
            gapHC(5),
            Bounce(
              duration: const Duration(milliseconds: 110),
              onPressed: (){
                fnLookup("HELP1");
              },
              child: Slidable(
                closeOnScroll: true,
                enabled: txtHelp1.text.isEmpty? false:true,
                endActionPane:  ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.2,
                  children: [

                    SlidableAction(
                      onPressed: (context){
                        txtHelp1.clear();
                        txtHelp1Name.clear();
                      },
                      backgroundColor: greyLight,
                      foregroundColor: Colors.grey,
                      icon: Icons.clear,
                      label: 'Clear',
                    ),
                  ],
                ),
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: boxDecoration(Colors.white, 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxBaseDecoration(greyLight, 5),
                          child: Image.asset("assets/icons/help.png",width: 20,)),
                        gapWC(8),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            txtHelp1.text.isEmpty?
                            tcn('Select Helper 1', subColor, 10):
                            th('Helper 1', bgColorDark, 10),
                            lineC(0.3, greyLight),
                            txtHelp1.text.isEmpty?
                            tcn("Code", greyLight, 10):
                            tcn(txtHelp1.text.toString(), Colors.black, 10),
                            txtHelp1.text.isEmpty?
                            tcn("Helper Name", greyLight, 10):
                            tcn(txtHelp1Name.text.toString(), Colors.black, 10),
                          ],
                        ))
                      ],
                    )
                ),
              ),
            ),
            gapHC(5),
            Bounce(

              duration: const Duration(milliseconds: 110),
              onPressed: (){
                fnLookup("HELP2");
              },
              child: Slidable(
                closeOnScroll: true,
                enabled: txtHelp2.text.isEmpty? false:true,
                endActionPane:  ActionPane(
                  motion: const StretchMotion(),
                  extentRatio: 0.2,
                  children: [

                    SlidableAction(
                      onPressed: (context){
                        txtHelp2.clear();
                        txtHelp2Name.clear();
                      },
                      backgroundColor: greyLight,
                      foregroundColor: Colors.grey,
                      icon: Icons.clear,
                      label: 'Clear',
                    ),
                  ],
                ),
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: boxDecoration(Colors.white, 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxBaseDecoration(greyLight, 5),
                            child: Image.asset("assets/icons/help.png",width: 20,)),
                        gapWC(8),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            txtHelp2.text.isEmpty?
                            tcn('Select Helper 2', subColor, 10):
                            th('Helper 2', bgColorDark, 10),
                            lineC(0.3, greyLight),
                            txtHelp2.text.isEmpty?
                            tcn("Code", greyLight, 10):
                            tcn(txtHelp2.text.toString(), Colors.black, 10),
                            txtHelp2.text.isEmpty?
                            tcn("Helper Name", greyLight, 10):
                            tcn(txtHelp2Name.text.toString(), Colors.black, 10),
                          ],
                        ))
                      ],
                    )
                ),
              ),
            ),
            gapHC(5),
            lineS(),
            Row(
              children: [
                Icon(Icons.gas_meter_outlined,color: txtSubColor,size: g.wstrSubIconSize,),
                gapWC(5),
                th('Supplier Details', txtSubColor, g.wstrSubFont)
              ],
            ),
            lineS(),
            FormInput(
              txtController:txtSupplierPdnNo,
              hintText: "Supplier PDN",
              focusNode: pnSupplierPdnNo,
              txtWidth: 1,
              focusSts:pnSupplierPdnNo.hasFocus?true:false,
              enablests: wstrPageMode == "VIEW"? false:true,
              emptySts: txtSupplierPdnNo.text.isEmpty?false:true,
              suffixIcon: Icons.search,
              suffixIconOnclick: (){
                fnLookup("GASPDNDET");
              },
              onClear: (){
                setState((){
                  txtSupplierPdnNo.clear();
                });
              },
              onChanged: (value){
                setState((){
                });
              },
              onSubmit: (value){
              },
              validate: true,
            ),
            gapHC(5),
            FormInput(
              txtController:txtSupplierCode,
              hintText: "Supplier Code",
              focusNode: pnSupplierCode,
              txtWidth: 1,
              focusSts:pnSupplierCode.hasFocus?true:false,
              enablests: wstrPageMode == "VIEW"? false:true,
              emptySts: txtSupplierCode.text.isEmpty?false:true,
              suffixIcon: Icons.search,
              suffixIconOnclick: (){
                fnLookup("SUPPLIER");
              },
              onClear: (){
                setState((){
                  txtSupplierCode.clear();
                });
              },
              onChanged: (value){
                setState((){
                });
              },
              onSubmit: (value){
              },
              validate: true,
            ),
            gapHC(5),
            FormInput(
              txtController:txtSupplierName,
              hintText: "Supplier Name",
              focusNode: pnSupplierName,
              txtWidth: 1,
              focusSts:pnSupplierName.hasFocus?true:false,
              enablests: false,
              emptySts: false,

              validate: true,
            ),
            gapHC(5),

          ],
        ),
      ),
    );
  }

  //======================================LOOKUP
  fnLookup(mode){
    if(wstrPageMode == "VIEW"){
      return;
    }

    if (mode == "DRIVER") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'DEL_MAN_CODE', 'Display': 'Driver Code'},
        {'Column': 'NAME', 'Display': 'Name'},
        {'Column': 'MOBILE', 'Display': 'Mobile'},
        {'Column': 'VEHICLE_NO', 'Display': 'Vehicle No'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'DEL_MAN_CODE',
          'contextField': txtDriverCode,
          'context': 'window'
        },
        {
          'sourceColumn': 'NAME',
          'contextField': txtDriverName,
          'context': 'window'
        },
        {
          'sourceColumn': 'VEHICLE_NO',
          'contextField': txtVehicleNo,
          'context': 'window'
        },
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtDriverCode,
        oldValue: "",
        lstrTable: 'CRDELIVERYMANMASTER',
        title: 'Driver',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'DEL_MAN_CODE',
        mode: "S",
        layoutName: "B",
        callback: fnDriverLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "VEHICLE") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'VEHICLE_NO', 'Display': 'Vehicle No'},
        {'Column': 'DESCP', 'Display': 'Vehicle Code'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'VEHICLE_NO',
          'contextField': txtVehicleNo,
          'context': 'window'
        },
        {
          'sourceColumn': 'DESCP',
          'contextField': txtVehicleDescp,
          'context': 'window'
        },
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtVehicleNo,
        oldValue: '',
        lstrTable: 'CRVEHICLEMASTER',
        title: 'Driver',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'VEHICLE_NO',
        mode: "S",
        layoutName: "B",
        callback: fnLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "HELP1") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'DEL_MAN_CODE', 'Display': 'Driver Code'},
        {'Column': 'NAME', 'Display': 'Name'},
        {'Column': 'MOBILE', 'Display': 'Mobile'},
        {'Column': 'VEHICLE_NO', 'Display': 'Vehicle No'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'DEL_MAN_CODE',
          'contextField': txtHelp1,
          'context': 'window'
        },
        {
          'sourceColumn': 'NAME',
          'contextField': txtHelp1Name,
          'context': 'window'
        },
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtHelp1,
        oldValue: "",
        lstrTable: 'CRDELIVERYMANMASTER',
        title: 'Helper 1',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'DEL_MAN_CODE',
        mode: "S",
        layoutName: "B",
        callback: fnLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "HELP2") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'DEL_MAN_CODE', 'Display': 'Driver Code'},
        {'Column': 'NAME', 'Display': 'Name'},
        {'Column': 'MOBILE', 'Display': 'Mobile'},
        {'Column': 'VEHICLE_NO', 'Display': 'Vehicle No'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'DEL_MAN_CODE',
          'contextField': txtHelp2,
          'context': 'window'
        },
        {
          'sourceColumn': 'NAME',
          'contextField': txtHelp2Name,
          'context': 'window'
        },
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtHelp2,
        oldValue: "",
        lstrTable: 'CRDELIVERYMANMASTER',
        title: 'Helper 2',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'DEL_MAN_CODE',
        mode: "S",
        layoutName: "B",
        callback: fnLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "SUPPLIER") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'SLCODE', 'Display': 'Supplier Code'},
        {'Column': 'SLDESCP', 'Display': 'Supplier Name'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'SLCODE',
          'contextField': txtSupplierCode,
          'context': 'window'
        },
        {
          'sourceColumn': 'SLDESCP',
          'contextField': txtSupplierName,
          'context': 'window'
        },
      ];
      //"ACTYPE='AP' AND CONTROLAC_YN<>'Y' AND COMPANY='" + COMPANY + "'"
      var lstrFilter =[
        {'Column': "ACTYPE", 'Operator': '=', 'Value': "AP", 'JoinType': 'AND'},
        {'Column': "CONTROLAC_YN", 'Operator': '<>', 'Value': "Y", 'JoinType': 'AND'},
        {'Column': "COMPANY", 'Operator': '=', 'Value': g.wstrCompany, 'JoinType': 'AND'},
      ];

      Get.to(()=> LookupSchMob(
        txtControl: txtSupplierCode,
        oldValue: "",
        lstrTable: 'SLMAST',
        title: 'Supplier',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'SLCODE',
        mode: "S",
        layoutName: "B",
        callback: fnLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "GASPDNDET") {

      if(CALL_PDN_FROM_STOCKTXNDET == "Y"){
        final List<Map<String, dynamic>> lookup_Columns = [
          {'Column': 'BATCHNO', 'Display': 'Batch No'},
          {'Column': 'SLCODE', 'Display': 'Supplier Code'},
          {'Column': 'STKCODE', 'Display': 'Stock Code'},
        ];
        final List<Map<String, dynamic>> lookup_Filldata = [
          {
            'sourceColumn': 'BATCHNO',
            'contextField': txtSupplierPdnNo,
            'context': 'window'
          },
          {
            'sourceColumn': 'SLCODE',
            'contextField': txtSupplierCode,
            'context': 'window'
          },
        ];
        //"ACTYPE='AP' AND CONTROLAC_YN<>'Y' AND COMPANY='" + COMPANY + "'"
        var lstrFilter =[
          {'Column': "COMPANY", 'Operator': '=', 'Value': frmCompanyCode, 'JoinType': 'AND'},
        ];

        if(txtSupplierCode.text.isNotEmpty){
          lstrFilter.add({'Column': "SLCODE", 'Operator': '=', 'Value': txtSupplierCode.text, 'JoinType': 'AND'},);
        }

        Get.to(()=> LookupSchMob(
          txtControl: txtSupplierPdnNo,
          oldValue: "",
          lstrTable: 'GASPDNDET',
          title: 'Supplier PDN NO',
          lstrColumnList: lookup_Columns,
          lstrFilldata: lookup_Filldata,
          lstrPage: '0',
          lstrPageSize: '100',
          lstrFilter: lstrFilter,
          keyColumn: 'BATCHNO',
          mode: "S",
          layoutName: "B",
          callback: fnSupplierPdnCallBack,
          company: frmCompanyCode,
        ));
      }else{
        final List<Map<String, dynamic>> lookup_Columns = [
          {'Column': 'PDA_NO', 'Display': 'Batch No'},
          {'Column': 'CUSTOMER_CODE', 'Display': 'Supplier Code'},
          {'Column': 'CUSTOMER_NAME', 'Display': 'Supplier'},
          {'Column': 'STKCODE', 'Display': 'Stock Code'},

        ];
        final List<Map<String, dynamic>> lookup_Filldata = [
          {
            'sourceColumn': 'PDA_NO',
            'contextField': txtSupplierPdnNo,
            'context': 'window'
          },
          {
            'sourceColumn': 'CUSTOMER_CODE',
            'contextField': txtSupplierCode,
            'context': 'window'
          },
          {
            'sourceColumn': 'CUSTOMER_NAME',
            'contextField': txtSupplierName,
            'context': 'window'
          },
        ];
        //"ACTYPE='AP' AND CONTROLAC_YN<>'Y' AND COMPANY='" + COMPANY + "'"
        var lstrFilter =[
          {'Column': "COMPANY", 'Operator': '=', 'Value': frmCompanyCode, 'JoinType': 'AND'},
        ];
        if(txtSupplierCode.text.isNotEmpty){
          lstrFilter.add({'Column': "SLCODE", 'Operator': '=', 'Value': txtSupplierCode.text, 'JoinType': 'AND'},);
        }

        Get.to(()=> LookupSchMob(
          txtControl: txtSupplierPdnNo,
          oldValue: "",
          lstrTable: 'GTANK_REC',
          title: 'Supplier PDN NO',
          lstrColumnList: lookup_Columns,
          lstrFilldata: lookup_Filldata,
          lstrPage: '0',
          lstrPageSize: '100',
          lstrFilter: lstrFilter,
          keyColumn: 'BATCHNO',
          mode: "S",
          layoutName: "B",
          callback: fnLookupCallBack,
          company: frmCompanyCode,
        ));
      }


    }
    else if (mode == "GTANK_REC") {

      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'PDA_NO', 'Display': 'Batch No'},
        {'Column': 'CUSTOMER_CODE', 'Display': 'Supplier Code'},
        {'Column': 'STKCODE', 'Display': 'Stock Code'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'PDA_NO',
          'contextField': txtSupplierPdnNo,
          'context': 'window'
        },
        {
          'sourceColumn': 'CUSTOMER_CODE',
          'contextField': txtSupplierCode,
          'context': 'window'
        },
      ];
      //"ACTYPE='AP' AND CONTROLAC_YN<>'Y' AND COMPANY='" + COMPANY + "'"
      var lstrFilter =[
        {'Column': "COMPANY", 'Operator': '=', 'Value': g.wstrCompany, 'JoinType': 'AND'},
      ];
      if(txtSupplierCode.text.isNotEmpty){
        lstrFilter.add({'Column': "CUSTOMER_CODE", 'Operator': '=', 'Value': txtSupplierCode.text, 'JoinType': 'AND'},);
      }

      Get.to(()=> LookupSchMob(
        txtControl: txtSupplierPdnNo,
        oldValue: "",
        lstrTable: 'GTANK_REC',
        title: 'Supplier PDN NO',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'PDA_NO',
        mode: "S",
        layoutName: "B",
        callback: fnSupplierPdnCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "TRIP") {

      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Trip'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtTripNo,
          'context': 'window'
        },
        {
          'sourceColumn': 'CODE',
          'contextField': lstrTripNo,
          'context': 'variable'
        },
        {
          'sourceColumn': 'DESCP',
          'contextField': lstrTripName,
          'context': 'variable'
        },
      ];

      Get.to(()=> LookupSchMob(
        txtControl: txtTripNo,
        oldValue: "",
        lstrTable: 'GTRIPMASTER',
        title: 'Trip',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'CODE',
        mode: "S",
        layoutName: "B",
        callback: fnTripLookupCallBack,
        company: frmCompanyCode,
      ));
    }

  }
  fnLookupCallBack(value){

  }
  fnDriverLookupCallBack(value){
    if(mounted){
      if(g.fnValCheck(value)){
        apiGetVehicleDetails(value["VEHICLE_NO"]);
      }
    }
  }
  fnSupplierPdnCallBack(value){
    apiGetSupplierDetails(value["SLCODE"]);
  }
  fnTripLookupCallBack(value){
    setState(() {
      lstrTripNo = "";
      lstrTripName = "";
      if(g.fnValCheck(value)){
        lstrTripNo = value["CODE"];
        lstrTripName = value["DESCP"];
      }
    });
  }

  fnLookupFocus(){
    for(var e in wstrPageLookup){
      try{
        e["PAGE_NODE"].addListener(() {
          if(!e["PAGE_NODE"].hasFocus && e["CONTROLLER"].text.isNotEmpty && wstrPageMode != "VIEW"){
            e["COMPANY"] = frmCompanyCode;
            g.mfnApiValidate(e,fnLookupValidate);
          }else if(!e["PAGE_NODE"].hasFocus && e["CONTROLLER"].text.isEmpty && wstrPageMode != "VIEW"){
            //Clear fill data
            setState(() {
              if(e["MODE"] == "DRIVER"){
              }else if(e["MODE"] == "VEHICLE"){
              }else if(e["MODE"] == "HELP1"){
              }else if(e["MODE"] == "HELP2"){
              }
            });
          }
        });
      }catch(e){
        dprint(e);
      }
    }
  }
  fnLookupValidate(value,e){
    if(!g.fnValCheck(value)){
      fnLookup(e["MODE"]??"");
    }else{
      setState(() {
        if(e["MODE"] == "DRIVER"){
        }else if(e["MODE"] == "AREA"){
        }else if(e["MODE"] == "BUILDING"){
        }else if(e["MODE"] == "USER"){
        }
      });

    }
  }
  //======================================PAGE FN

  fnGetPageData(){
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => fnRefresh());
    setState(() {
      wstrPageLookup = [];
      // wstrPageLookup.add({"CONTROLLER":txtDriverCode,"PAGE_NODE":pnDriverCode,"TABLE":"DEL_MAN_CODE","KEY":"DEL_MAN_CODE","MODE":"DRIVER","TYPE":""});
      // wstrPageLookup.add({"CONTROLLER":txtVehicleNo,"PAGE_NODE":pnVehicleNo,"TABLE":"CRVEHICLEMASTER","KEY":"VEHICLE_NO","MODE":"VEHICLE","TYPE":""});
      // wstrPageLookup.add({"CONTROLLER":txtVehicleDescp,"PAGE_NODE":pnVehicleNo,"TABLE":"CRVEHICLEMASTER","KEY":"VEHICLE_NO","MODE":"VEHICLE","TYPE":""});
      // wstrPageLookup.add({"CONTROLLER":txtHelp1,"PAGE_NODE":pnHelp1,"TABLE":"DEL_MAN_CODE","KEY":"DEL_MAN_CODE","MODE":"HELP1","TYPE":""});
      // wstrPageLookup.add({"CONTROLLER":txtHelp2,"PAGE_NODE":pnHelp2,"TABLE":"DEL_MAN_CODE","KEY":"DEL_MAN_CODE","MODE":"HELP2","TYPE":""});
      // wstrPageLookup.add({"CONTROLLER":txtSupplierCode,"PAGE_NODE":pnSupplierCode,"TABLE":"SLMAST","KEY":"SLCODE","MODE":"SUPPLIER","TYPE":""});
      wstrPageForm =[];
      wstrPageForm.add({"CONTROLLER":txtTripNo,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"TRIP_CODE","PAGE_NODE":pnDriverCode,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtDriverCode,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"DRIVER_CODE","PAGE_NODE":pnDriverCode,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtDriverName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"DRIVER_DESCP","PAGE_NODE":pnDriverName,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtVehicleNo,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"VEHICLE_CODE","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtVehicleDescp,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"VEHICLE_DESCP","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtHelp1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELP1_CODE","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtHelp1Name,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELP1_DESCP","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtHelp2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELP2_CODE","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtHelp2Name,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELP2_DESCP","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtSupplierPdnNo,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"PDN","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtSupplierCode,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"SLCODE","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtSupplierName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"SLDESCP","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtStartKm,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"KM_START","PAGE_NODE":pnVehicleNo,"MODE":"H"});
      wstrPageForm.add({"CONTROLLER":txtEndKm,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"KM_END","PAGE_NODE":pnVehicleNo,"MODE":"H"});


    });

    apiGetPdnFromYn();
  }
  fnRefresh(){
    if(mounted){
      setState(() {
        lstrTime = setDate(11, DateTime.now());
      });
    }
  }

  fnStart(){
    if(lstrTripNo.isEmpty){
      customMsg(context, 'Please Select trip Details', Icons.mode_of_travel);
      return;
    }
    // var data = {
    //   "DRIVER":txtDriverCode.text,
    //   "DRIVER_NAME":txtDriverName.text,
    //   "VEHICLE_NO":txtVehicleNo.text,
    //   "HELPER1":txtHelp1.text,
    //   "HELPER1_NAME":txtHelp1Name.text,
    //   "HELPER2":txtHelp2.text,
    //   "HELPER2_NAME":txtHelp2Name.text,
    //   "SUPPLIER_PDN":txtSupplierPdnNo.text,
    //   "SUPPLIER_CODE":txtSupplierCode.text,
    //   "SUPPLIER_NAME":txtSupplierName.text,
    //   "TRIP":lstrTripNo,
    //   "TRIP_NAME":lstrTripName,
    // };


    var data =  {
      "COMPANY" : g.wstrCompany,
      "YEARCODE" : g.wstrYearcode,
      "TRIP_CODE" : txtTripNo.text,
      "TRIP_DESCP" : lstrTripName,
      "USERCD" : g.wstrUserCd,
      "VEHICLE_CODE" : txtVehicleNo.text,
      "VEHICLE_DESCP" : txtVehicleDescp.text,
      "DRIVER_CODE" : txtDriverCode.text,
      "DRIVER_DESCP" : txtDriverName.text,
      "HELP1_CODE" : txtHelp1.text,
      "HELP1_DESCP" : txtHelp1Name.text,
      "HELP2_CODE" : txtHelp2.text,
      "HELP2_DESCP" : txtHelp2Name.text,
      "PDN" : txtSupplierPdnNo.text,
      "SLCODE" : txtSupplierCode.text,
      "SLDESCP" : txtSupplierName.text,
      "QTY" : "0",
      "START_TIME" : setDate(4, DateTime.now()),
      "END_TIME" : "",
      "REMARKS" : "",
      "LOC_START" : "",
      "LOC_END" : "",
      "KM_START" : txtStartKm.text,
      "KM_END" : "",
      "STATUS" : "1",
    };

    dprint(data);
    apiStartTrip(data);

  }
  fnEndTrip(){
    PageDialog().endDialog(context, fnEnd);
  }
  fnEnd(mode){
    if(mode != "EDIT"){
       Navigator.pop(context);
    }
    var data =  {
      "COMPANY" : g.wstrCompany,
      "YEARCODE" : g.wstrYearcode,
      "DOCNO" : lstrTripDocno,
      "DOCTYPE" : lstrTripDoctype,
      "DOCDATE" : lstrTripData[0]["DOCDATE"],
      "TRIP_CODE" : txtTripNo.text,
      "TRIP_DESCP" : lstrTripName,
      "USERCD" : g.wstrUserCd,
      "VEHICLE_CODE" : txtVehicleNo.text,
      "VEHICLE_DESCP" : txtVehicleDescp.text,
      "DRIVER_CODE" : txtDriverCode.text,
      "DRIVER_DESCP" : txtDriverName.text,
      "HELP1_CODE" : txtHelp1.text,
      "HELP1_DESCP" : txtHelp1Name.text,
      "HELP2_CODE" : txtHelp2.text,
      "HELP2_DESCP" : txtHelp2Name.text,
      "PDN" : txtSupplierPdnNo.text,
      "SLCODE" : txtSupplierCode.text,
      "SLDESCP" : txtSupplierName.text,
      "QTY" : "0",
      "START_TIME" : lstrTripData[0]["START_TIME"],
      "END_TIME" : setDate(4, DateTime.now()),
      "REMARKS" : "",
      "LOC_START" : lstrTripData[0]["LOC_START"],
      "LOC_END" : "",
      "KM_START" : txtStartKm.text,
      "KM_END" : mode == "EDIT"?"":txtEndKm.text,
      "STATUS" : mode == "EDIT"?lstrTripData[0]["STATUS"]:2
    };

    apiUpdateTrip(data);
  }

  fnClear(){
    if(mounted){
      setState((){
        for(var e in wstrPageForm){
          e["CONTROLLER"].clear();
        }
        lstrTripName = "";
        lstrTripDocno  = '';
        lstrTripDoctype  = '';
        lstrTripStartTime = '';
      });
    }
  }
  fnFill(data){
    fnClear();
    if(data != null){
      if(mounted){
        setState((){
          wstrPageMode = "EDIT";
          for(var e in wstrPageForm){
            if(e["TYPE"] == "D"){
              e["CONTROLLER"].text = setDate(6, DateTime.parse(data[e["FILL_CODE"]].toString()));
            }else{
              e["CONTROLLER"].text = data[e["FILL_CODE"]].toString() == "null"?"":data[e["FILL_CODE"]].toString();
            }
          }
          lstrTripDocno  = data["DOCNO"].toString();
          lstrTripDoctype  = data["DOCTYPE"].toString();
          lstrTripNo = data["TRIP_CODE"].toString();
          lstrTripName = data["TRIP_DESCP"].toString();
          lstrTripStartTime =  setDate(8, DateTime.parse(data["START_TIME"]));

        });
      }
    }
  }



  //======================================API CALL

  apiGetPdnFromYn(){
    var filterVal= [];
    final List<Map<String, dynamic >> columnList= [
      {'Column': 'CODE'},
      {'Column': 'DESCP'},
      {'Column': 'CALL_PDN_FROM_STOCKTXNDET'},
    ];
    // ignore: prefer_typing_uninitialized_variables
    var columnListTemp;
    for(var e in columnList){
      columnListTemp == null ?  columnListTemp = e['Column'] + "|": columnListTemp += e['Column'] + "|";
    }

    filterVal = [{'Column': "CODE", 'Operator': '=', 'Value': "GTFA", 'JoinType': 'AND'}];

    futureView =  apiCall.apiLookupSearch("GASDOCMASTER", columnListTemp, 0, 10000, filterVal,frmCompanyCode);
    futureView.then((value) =>  apiGetPdnFromYnRes(value));
  }
  apiGetPdnFromYnRes(value){
    if(mounted){
      setState((){
        if(g.fnValCheck(value)){
          CALL_PDN_FROM_STOCKTXNDET = value[0]["CALL_PDN_FROM_STOCKTXNDET"];
        }
      });
      apiGetTrip();
    }
  }

  apiGetSupplierDetails(slcode){
    var filterVal= [];
    final List<Map<String, dynamic >> columnList= [
      {'Column': 'SLCODE'},
      {'Column': 'SLDESCP'},
      {'Column': 'MOBILE'},
      {'Column': 'EMAIL'},
      {'Column': 'CITY'},
    ];
    // ignore: prefer_typing_uninitialized_variables
    var columnListTemp;
    for(var e in columnList){
      columnListTemp == null ?  columnListTemp = e['Column'] + "|": columnListTemp += e['Column'] + "|";
    }

    filterVal = [{'Column': "SLCODE", 'Operator': '=', 'Value': slcode, 'JoinType': 'AND'}];

    futureView =  apiCall.apiLookupSearch("SLMAST", columnListTemp, 0, 10000, filterVal,frmCompanyCode);
    futureView.then((value) =>  apiGetSupplierDetailsRes(value));
  }
  apiGetSupplierDetailsRes(value){
    if(mounted){
      setState((){
        if(g.fnValCheck(value)){
          txtSupplierName.text  =  value[0]["SLDESCP"]??"";
        }
      });
    }
  }
  apiGetVehicleDetails(vehicleNo){
    var filterVal= [];
    final List<Map<String, dynamic >> columnList= [
      {'Column': 'VEHICLE_NO'},
      {'Column': 'DESCP'},
    ];
    // ignore: prefer_typing_uninitialized_variables
    var columnListTemp;
    for(var e in columnList){
      columnListTemp == null ?  columnListTemp = e['Column'] + "|": columnListTemp += e['Column'] + "|";
    }

    filterVal = [{'Column': "VEHICLE_NO", 'Operator': '=', 'Value': vehicleNo.toString(), 'JoinType': 'AND'}];

    futureView =  apiCall.apiLookupSearch("CRVEHICLEMASTER", columnListTemp, 0, 10000, filterVal,frmCompanyCode);
    futureView.then((value) =>  apiGetVehicleDetailsRes(value));
  }
  apiGetVehicleDetailsRes(value){
    if(mounted){
      setState((){
        txtVehicleDescp.clear();
        if(g.fnValCheck(value)){
          txtVehicleDescp.text  =  value[0]["DESCP"]??"";
        }
      });
    }
  }

  apiStartTrip(data){
    futureView = apiCall.apiTripStart(data);
    futureView.then((value) => apiStartTripRes(value));
  }
  apiStartTripRes(value){
    dprint(value);
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          var sts = value[0]["STATUS"].toString();
          if(sts  == "1"){
            widget.fnCallBack();
            Get.back();
          }else{
            errorMsg(context, 'Please try again!!');
          }
        }else{
          errorMsg(context, 'Please try again!!');
        }
      });
    }
  }
  apiUpdateTrip(data){
    futureView = apiCall.apiTripEdit(data);
    futureView.then((value) => apiUpdateTripRes(value));
  }
  apiUpdateTripRes(value){
    dprint(value);
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          var sts = value[0]["STATUS"].toString();
          if(sts  == "1"){
            widget.fnCallBack();
            Get.back();
          }else{
            errorMsg(context, 'Please try again!!');
          }
        }else{
          errorMsg(context, 'Please try again!!');
        }
      });
    }
  }

  apiGetTrip(){
    var users =  [{"COL_KEY":g.wstrUserCd}];
    futureView = apiCall.apiGetTrip(g.wstrCompany, g.wstrYearcode, users, [], "1");
    futureView.then((value) => apiGetTripRes(value));

  }
  apiGetTripRes(value){
    if(mounted){
      setState(() {
        lstrTripData = [];
        if(g.fnValCheck(value)){
          lstrTripData = value??[];
          lstrTripSts =true;
          fnFill(value[0]);
        }

      });
    }

  }



}



import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/pages/transaction/tank_filling.dart';
import 'package:scheduler/view/pages/user/user_mainscreen.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:signature/signature.dart';

class TankRecSubmit extends StatefulWidget {
  final header;
  final sign;
  final String mainDocno;
  final String mode;
  final Function fnCallBack;
  const TankRecSubmit({Key? key, this.header, required this.mode, this.sign, required this.fnCallBack, required this.mainDocno}) : super(key: key);

  @override
  State<TankRecSubmit> createState() => _TankRecSubmitState();
}

class _TankRecSubmitState extends State<TankRecSubmit> {

  //Global
  var g =  Global();
  late Future<dynamic> futureForm;
  ApiCall apiCall = ApiCall();


  //PageVariables

  var headerData  = [];
  var detData = [];
  var schedule = [];
  var sign = [];

  var frmDocNo = "";
  var frmDocDate  = "";
  var frmCompanyCode = "";
  var frmCompanyName = "";
  var frmCF = 1.0;
  var frmTotalAmount = 0.0;
  var frmImageEncode = "" ;
  var frmSupplierCode = "";
  var frmSupplierName = "";
  Uint8List frmImageDecode = base64Decode("R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==") ;

  //ItemDetails
  var frmItemCode = '';
  var frmItemName = '';
  var frmItemRate1 = 0.0;
  var frmItemRate2 = 0.0;
  var frmItemUnit1 = '';
  var frmItemUnit2 = '';
  var frmItemQty1 = 0.0;
  var frmItemQty2 = 0.0;

  //Vehicle Details
  var frmVehicleNo = '';
  var frmDriverCode = '';
  var frmDriverName = '';
  var frmHelper1Code = '';
  var frmHelper1Name = '';
  var frmHelper2Code = '';
  var frmHelper2Name = '';
  var frmCustomerEmail = '';
  var txtCustomerEmail = TextEditingController();

  var pnCustomerEmail = FocusNode();

  var cRateYn  = "Y";


  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                tcn('Receiving Details',  txtSubColor, g.wstrHeadFont+5),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.cancel_outlined,color: txtSubColor,size: g.wstrIconSize+10,),
                ),

              ],
            ),
            lineS(),
            Expanded(child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  tcn('Invoice for', txtSubColor, g.wstrSubFont),
                  gapHC(10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: boxDecoration(bgColorDark, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        th(frmSupplierCode.toString(), white, g.wstrHeadFont),
                        Row(
                          children: [
                            Icon(Icons.person_pin,color: white,size: g.wstrSubIconSize,),
                            gapWC(10),
                            Expanded(child: tcn("$frmSupplierName", white, g.wstrSubFont),)
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.account_balance,color: white,size: g.wstrSubIconSize,),
                            gapWC(10),
                            Expanded(child: tcn("$frmCompanyCode | $frmCompanyName", white, g.wstrSubFont),)
                          ],
                        ),
                      ],
                    ),
                  ),
                  gapHC(10),
                  cRateYn == "Y"?
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: boxBaseDecoration(white, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(),
                        tcn('TOTAL AMOUNT', txtSubColor, g.wstrSubFont-2),
                        th('AED ${g.mfnCurr(frmTotalAmount.toString())}', subColor, g.wstrHeadFont+15),
                      ],
                    ),
                  ):gapHC(0),
                  gapHC(5),
                  tcn('Item Details', txtSubColor, g.wstrSubFont),
                  gapHC(5),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: boxBaseDecoration(white, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        th(frmItemCode.toString(), txtSubColor, g.wstrHeadFont),
                        Row(
                          children: [
                            Icon(Icons.gas_meter,color: txtSubColor,size: g.wstrSubIconSize,),
                            gapWC(10),
                            Expanded(child: th(frmItemName.toString(), txtSubColor, g.wstrSubFont),)
                          ],
                        ),
                        lineSC(5.0),
                        cRateYn == "Y"?
                        Column(
                          children: [
                            wItemCard(Icons.money,"RATE"," ${frmItemRate1.toString()} /${frmItemUnit1.toString()}",txtSubColor),
                            lineSC(5.0),
                            wItemCard(Icons.money,"RATE"," ${frmItemRate2.toString()} /${frmItemUnit2.toString()}",txtSubColor),
                            lineSC(5.0),

                          ],
                        ):gapHC(0),
                        wItemCard(Icons.propane_tank_outlined,"QTY (${frmItemUnit1.toString()})","${frmItemQty1.toString()}",subColor),
                        wItemCard(Icons.propane_tank_outlined,"QTY (${frmItemUnit2.toString()})","${frmItemQty2.toString()}",subColor),



                      ],
                    ),
                  ),
                  gapHC(10),
                  tcn('Vehicle Details', txtSubColor, g.wstrSubFont),
                  gapHC(5),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: boxBaseDecoration(white, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(),
                        th(frmVehicleNo.toString(), txtSubColor, g.wstrHeadFont),
                        lineSC(5.0),
                        wItemCard(Icons.support,"Driver",frmDriverName.toString(),txtSubColor),
                        lineSC(5.0),
                        wItemCard(Icons.manage_accounts,"Helper 1",frmHelper1Name.toString(),txtSubColor),
                        lineSC(5.0),
                        wItemCard(Icons.manage_accounts,"Helper 2",frmHelper2Name.toString(),txtSubColor),
                        lineSC(5.0),
                      ],
                    ),
                  ),
                  gapHC(5),

                  FormInput(
                    txtController:txtCustomerEmail,
                    hintText: "Email",
                    focusNode: pnCustomerEmail,
                    txtWidth: 1,
                    focusSts:pnCustomerEmail.hasFocus?true:false,
                    enablests: true,
                    emptySts: true,
                    onClear: (){
                      setState(() {
                        txtCustomerEmail.clear();
                      });
                    },

                    validate: true,
                  ),
                  gapHC(5),
                  tcn('Signature', txtSubColor, g.wstrSubFont),

                  gapHC(5),
                  widget.mode == "EDIT"?
                  Container(
                      decoration: boxOutlineCustom(white, 5,txtSubColor),
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          Row(),
                          frmImageDecode != null? Image.memory(frmImageDecode,width: 100,):gapHC(0)
                        ],
                      )
                  ):gapHC(0),
                  gapHC(5),
                  Container(
                    decoration: boxOutlineCustom(white, 5,txtSubColor),
                    padding: const EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Signature(
                          controller: _controller,
                          width: 300,
                          height: 150,
                          backgroundColor: Colors.white,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Bounce(
                              duration: const Duration(milliseconds: 110),
                              onPressed: (){
                                _controller.clear();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
                                decoration: boxBaseDecoration(greyLight, 10),
                                child: Center(
                                  child: tcn('CLEAR',txtSubColor,g.wstrSubFont),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                  ),

                  gapHC(10),
                ],
              ),
            )),
            Bounce(
              onPressed: (){
                exportImage(context);
              },
              duration: const Duration(milliseconds: 110),
              child: Container(
                decoration: boxDecoration(subColor, 30),
                padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt,color: Colors.white,size: g.wstrIconSize,),
                    gapWC(10),
                    th('SAVE', white, g.wstrHeadFont),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
//==================================WIDGET

  Widget wItemCard(icon,title,value,color){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon,color: txtSubColor,size: g.wstrSubIconSize,),
            gapWC(10),
            tcn(title, txtSubColor, g.wstrSubFont),
          ],
        ),
        th(value, color, g.wstrSubFont)
      ],
    );
  }

//==================================PAGE_FN

  fnGetPageData(){
    if(mounted){
      setState(() {
        headerData = widget.header??[];
        sign = widget.sign??[];
      });
    }
    fnFillData();
  }
  fnFillData(){
    if(mounted){
      setState(() {

        frmDocNo = "";
        frmDocDate  = "";
        frmCompanyCode = "";
        frmCompanyName = "";
        frmCustomerEmail = "";
        txtCustomerEmail.text = "";
        frmCF = 1.0;
        frmTotalAmount = 0.0;

        if(g.fnValCheck(headerData)){
          var data  =  headerData[0];
          frmCompanyCode = data["COMPANY"]??"";
          frmCompanyName = data["COMPANY_NAME"]??"";
          frmTotalAmount = g.mfnDbl(data["TOTAL_FILLING_AMT"]);

          frmItemCode =  data["STKCODE"]??"";
          frmItemName =  data["STKDESCP"]??"";
          frmItemUnit1 = data["UNIT1"]??"";
          frmItemUnit2 = data["UNIT2"]??"";
          frmItemQty1 = data["QTY1"]??"";
          frmItemQty2 = data["QTY2"]??"";
          frmItemRate1 = data["RATEFC"]??"";
          frmItemRate2 = data["RATEFC2"]??"";

          frmVehicleNo =  data["VEHICLE_NO"]??"";
          frmDriverCode = data["DEL_MAN"]??"";
          frmDriverName = data["DEL_MAN_NAME"]??"";
          frmHelper1Code =data["HELPER1"]??"";
          frmHelper1Name =data["HELPER1_NAME"]??"";
          frmHelper2Code =data["HELPER2"]??"";
          frmHelper2Name =data["HELPER2_NAME"]??"";

          frmSupplierCode =data["CUSTOMER_CODE"]??"";
          frmSupplierName =data["CUSTOMER_NAME"]??"";

        }


        if(g.fnValCheck(sign) && widget.mode == "EDIT"){
          frmImageEncode = sign[0]["IMAGE_SIGNATURE"]??"";
          loadImage(context);
        }

      });
    }
  }
  Future<void> exportImage(BuildContext context) async {

    if(widget.mode == "EDIT" && _controller.isEmpty){
      fnSave();
    }else{
      if(mounted){
        setState(() {
          frmImageEncode = "";
        });
      }
      if (_controller.isEmpty) {
        errorMsg(context, 'Please Sign');
        return;
      }

      final Uint8List? data = await _controller.toPngBytes();
      if (data == null) {
        return;
      }
      // must be called in async method
      final imageEncoded = base64.encode(data); // returns base64 string
      dprint(imageEncoded.toString());
      if(mounted){
        setState(() {
          frmImageEncode = imageEncoded.toString();
        });
      }
      fnSave();
    }


  }
  Future<void> loadImage(BuildContext context) async {
    final Uint8List data = base64.decode(frmImageEncode);
    if(mounted){
      setState(() {
        if(frmImageEncode != ""){
          frmImageDecode =data;
        }
      });
    }
  }

  fnSave(){

    apiSaveFilling(headerData[0]);
  }


//==================================APICALL

  apiSaveFilling(headerTable){
    var scheduleData;
    if(g.fnValCheck(schedule)){
      scheduleData = schedule[0];
    }
    headerTable["IMAGE_SIGNATURE"] = frmImageEncode;
    headerTable["CUSTOMER_EMAIL"] = txtCustomerEmail.text;
    futureForm =  apiCall.apiSaveTankReceiving(g.wstrCompany, frmCompanyCode, g.wstrDeivceId, headerTable, widget.mode,txtCustomerEmail.text);
    futureForm.then((value) => apiSaveFillingRes(value));
  }
  apiSaveFillingRes(value){
    dprint(value);
    // [{STATUS: 1, DOCNO: GTF001302, DOCTYPE: GTF}]
    if(mounted){
      if(g.fnValCheck(value)){
        var sts = value[0]["STATUS"].toString();
        if(sts  == "1"){
          if(widget.mode == "ADD"){
            Get.off(() =>   const NavigationHomeScreen(message: 'Saved Successfully',));
            successMsg(context, 'Saved Successfully');
          }else{
            Get.back();
            widget.fnCallBack(widget.mainDocno);
          }
        }else{
          errorMsg(context, 'Please try again!!');
        }
      }else{
        errorMsg(context, 'Please try again!!');
      }
    }
  }

}


import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/alertDialog/alertDialog.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_areafield.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/components/lookup/lookupSch_mobile.dart';
import 'package:scheduler/view/pages/transaction/tank_getcompany.dart';
import 'package:scheduler/view/pages/transaction/tankrec_submit.dart';
import 'package:scheduler/view/styles/colors.dart';

class TankReceiving extends StatefulWidget {
  const TankReceiving({Key? key}) : super(key: key);

  @override
  State<TankReceiving> createState() => _TankReceivingState();
}

class _TankReceivingState extends State<TankReceiving> {


  //Global
  var g =  Global();
  var apiCall =  ApiCall();
  var wstrPageMode = "VIEW";
  var wstrDoctype = "GTRA";
  late Future<dynamic> futureForm;
  int _selectedPage = 0;
  late PageController _pageController;

  //PageVariables
  var wstrPageForm  = [];

  //Formdata
  var frmMainDocno = "";
  var frmDocNo = "";
  var frmDoctype = "";
  var frmDocDate  = "";
  var frmCompanyCode = "";
  var frmSign = [];

  var lstrOptionMode = "0";
  var frmCompanyName = "";
  var cRateYn  =  "Y";

  var frmCF = 1.0;
  var frmTotalAmount = 0.0;
  var lstrTimeFrom ;
  var lstrTimeTo ;
  var lstrTimeFromStr = "" ;
  var lstrTimeToStr = "";

  var lstrItemRate1 = 0.0;
  var lstrItemRate2 = 0.0;
  var lstrDocdate = DateTime.now();


  //Item Details
  var txtItemCode = TextEditingController();
  var txtItemName = TextEditingController();
  var txtItemUnit1 = TextEditingController();
  var txtItemUnit2 = TextEditingController();
  var txtItemRate1 = TextEditingController();
  var txtItemRate2 = TextEditingController();
  var txtItemQty1 = TextEditingController();
  var txtItemQty2 = TextEditingController();
  var txtLevelBef = TextEditingController();
  var txtLevelAft = TextEditingController();
  var txtLevelBefPer = TextEditingController();
  var txtLevelAftPer = TextEditingController();
  var txtPrsrBef = TextEditingController();
  var txtPrsrAft = TextEditingController();
  var txtTripNo = TextEditingController();

  var txtPdnNo = TextEditingController();
  var txtMeterReading = TextEditingController();
  var txtLpoNo = TextEditingController();

  var txtRef1 = TextEditingController();
  var txtRef2 = TextEditingController();
  var txtRef3 = TextEditingController();
  var txtRemarks = TextEditingController();
  var txtManagedBy = TextEditingController();

  var pnItemCode  = FocusNode();
  var pnItemName = FocusNode();
  var pnItemUnit1 = FocusNode();
  var pnItemUnit2 = FocusNode();
  var pnItemRate1 = FocusNode();
  var pnItemRate2 = FocusNode();
  var pnItemQty1 = FocusNode();
  var pnItemQty2 = FocusNode();
  var pnLevelBef = FocusNode();
  var pnLevelAft = FocusNode();
  var pnPrsrBef = FocusNode();
  var pnPrsrAft = FocusNode();
  var pnLevelBefPer = FocusNode();
  var pnLevelAftPer = FocusNode();
  var pnTripNo = FocusNode();

  var pnRef1 = FocusNode();
  var pnRef2 = FocusNode();
  var pnRef3 = FocusNode();
  var pnRemarks = FocusNode();

  var pnManagedBy = FocusNode();
  var pnPdnNo = FocusNode();
  var pnMeterReading = FocusNode();
  var pnLpoNo = FocusNode();


  //Driver
  var txtDriverCode = TextEditingController();
  var txtDriverName = TextEditingController();
  var txtVehicleNo = TextEditingController();
  var txtHelp1 = TextEditingController();
  var txtHelp1Name = TextEditingController();
  var txtHelp2 = TextEditingController();
  var txtHelp2Name = TextEditingController();
  var txtSupplierPdnNo = TextEditingController();
  var txtSupplierCode = TextEditingController();
  var txtSupplierName = TextEditingController();

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


  //Enable sts
  var blnUnit1 =  false;
  var blnUnit2 =  false;



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fnGetPageData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Container(
              padding: MediaQuery.of(context).padding,
              decoration: boxDecoration(bgColorDark, 0),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_outlined,color: Colors.white,size: g.wstrIconSize+5,),
                        ),
                        gapWC(10),
                        tcn('Tank Receiving',  Colors.white, g.wstrHeadFont)
                      ],
                    ),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.confirmation_num_rounded,color: Colors.white,size: g.wstrSubIconSize,),
                            gapWC(10),
                            th(frmDocNo.toString(), white, g.wstrSubFont)
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_month,color: Colors.white,size: g.wstrSubIconSize,),
                            gapWC(5),
                            th(frmDocDate.toString().toUpperCase(), Colors.white, g.wstrSubFont)
                          ],
                        )
                      ],
                    ),
                    gapHC(5),
                    Row(
                      children: [
                        Icon(Icons.account_balance,color: Colors.white,size: g.wstrSubIconSize,),
                        gapWC(10),
                        Expanded(child: tcn("$frmCompanyCode | $frmCompanyName", white, g.wstrSubFont),)
                      ],
                    ),

                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
              decoration: boxDecoration(Colors.white, 10),
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  wOptionCard(Icons.gas_meter,0),
                  wOptionCard(Icons.person,1),
                  wOptionCard(Icons.notes,2),
                ],
              ),
            ),
            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: PageView(
                    onPageChanged: (int page){
                      setState(() {
                        _selectedPage =page;
                        lstrOptionMode = page.toString();
                      });
                    },
                    controller: _pageController,
                    children: [
                        wItemCard1(),
                        wDriverCard(),
                        wTripCard(),
                    ],
                  ),
                )
            ),
            cRateYn == "Y"?
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(left: 10,right: 10,bottom: 5),
              decoration: boxDecoration(white, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  tcn('AMOUNT', txtSubColor, g.wstrHeadFont),
                  th(g.mfnCurr(frmTotalAmount.toStringAsFixed(2)).toString(), subColor, g.wstrHeadFont),
                ],
              ),
            ):gapHC(0),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: boxDecorationC(Colors.white, 30,30,0,0),
              child:wstrPageMode == "VIEW"? Row(
                children:  [
                  wButtons(Icons.skip_previous,"P"),
                  wButtons(Icons.skip_next,"N"),
                  wButtons(Icons.add_circle_outline_sharp,"A"),
                  wButtons(Icons.edit,"E"),
                  wButtons(Icons.cancel,"L"),

                ],
              ):Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children:  [
                  Bounce(
                    duration: const Duration(milliseconds: 110),
                    onPressed: (){
                      fnMenu("C");
                    },
                    child: customBButtonFlat('Cancel', greyLight, txtSubColor, Icons.cancel),
                  ),
                  gapWC(10),
                  Bounce(
                    duration: const Duration(milliseconds: 110),
                    onPressed: (){
                      fnSubmit();
                    },
                    child: customBButtonFlat('Submit', subColor, white, Icons.task_alt),
                  ),

                ],
              ),

            )
          ],
      ),
    );
  }

  //==========================================WIDGET
  Widget wButtons(icon,mode){
    return Flexible(child: Bounce(
      duration: const Duration(milliseconds: 110),
      onPressed: (){
        fnMenu(mode);
      },
      child: Center(
        child: Icon(icon,color:bgColorDark,size:g.wstrIconSize+5),
      ),
    ));
  }
  Widget wOptionCard(icon,mode){
    return Flexible(child: GestureDetector(
      onTap: (){
        if(mounted){
          setState(() {
            lstrOptionMode = mode.toString();
            _selectedPage = g.mfnInt(lstrOptionMode);
            _pageController.jumpToPage(_selectedPage);
          });

        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.only(right: 5),
        decoration:  boxBaseDecoration(lstrOptionMode == mode.toString()?bgColorDark:white, 5),
        child:  Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color:lstrOptionMode == mode.toString()? Colors.white:bgColorDark,size: g.wstrSubIconSize,)
          ],
        ),
      ),
    ));
  }
  Widget wItemCard1(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxDecoration(white, 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person,color: txtSubColor,size: g.wstrSubIconSize,),
                gapWC(5),
                th('Supplier Details', txtSubColor, g.wstrSubFont)
              ],
            ),
            lineS(),
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
            gapHC(10),
            Row(
              children: [
                Icon(Icons.gas_meter_outlined,color: txtSubColor,size: g.wstrSubIconSize,),
                gapWC(5),
                th('Item Details', txtSubColor, g.wstrSubFont)
              ],
            ),
            lineS(),
            Bounce(
              onPressed: (){
                fnLookup('STKCODE');
              },
              duration: const Duration(milliseconds: 110),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: boxGradientDecoration(20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        th(txtItemCode.text.toString(), white, g.wstrHeadFont),
                        Icon(Icons.search,color: Colors.white,size: g.wstrIconSize,)
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.gas_meter_outlined,color: Colors.white,size: g.wstrSubIconSize,),
                        gapWC(5),
                        Expanded(child: th(txtItemName.text.toString(), white, g.wstrSubFont))
                      ],
                    ),
                    cRateYn == "Y"?
                    Column(
                      children: [
                        Row(
                          children: [
                            Icon(Icons.money,color: Colors.white,size: g.wstrSubIconSize,),
                            gapWC(5),
                            tcn('Rate  ', white, g.wstrSubFont),
                            th(txtItemRate1.text, white, g.wstrHeadFont),
                            tcn(" / ${txtItemUnit1.text}", white, g.wstrHeadFont),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.money,color: Colors.white,size: g.wstrSubIconSize,),
                            gapWC(5),
                            tcn('Rate  ', white, g.wstrSubFont),
                            th(txtItemRate2.text, white, g.wstrHeadFont),
                            tcn(" / ${txtItemUnit2.text}", white, g.wstrHeadFont),
                          ],
                        ),
                      ],
                    ):gapHC(0)
                  ],
                ),
              ),
            ),
            gapHC(15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormInput(
                  txtController:txtItemUnit1,
                  hintText: "Unit 1",
                  focusNode: pnItemUnit1,
                  txtWidth: 0.41,
                  focusSts:pnItemUnit1.hasFocus?true:false,
                  enablests:false,
                  emptySts: false,
                  validate: true,
                ),
                FormInput(
                  txtController:txtItemUnit2,
                  hintText: "Unit 2",
                  focusNode: pnItemUnit2,
                  txtWidth: 0.41,
                  focusSts:pnItemUnit2.hasFocus?true:false,
                  enablests:wstrPageMode == "VIEW"? false:true,
                  emptySts: false,
                  validate: true,
                  suffixIcon: Icons.search,
                  suffixIconOnclick: (){
                    fnLookup("UNIT2");
                  },
                  onChanged: (val){
                    fnCalc("");
                  },
                ),
              ],
            ),
            gapHC(5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: boxBaseDecoration(blueLight, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormInput(
                    txtController:txtItemQty1,
                    hintText: txtItemUnit2.text.isNotEmpty? "Qty (${txtItemUnit1.text} = ${txtItemUnit2.text} * ${frmCF.toString()} )":"Qty (${txtItemUnit1.text})",
                    focusNode: pnItemQty1,
                    txtWidth: 0.41,
                    focusSts:pnItemQty1.hasFocus?true:false,
                    enablests: wstrPageMode == "VIEW"? false: blnUnit1,
                    emptySts: txtItemQty1.text.isEmpty?false:true,
                    textType: TextInputType.number,
                    onClear: (){
                      setState((){
                        txtItemQty1.clear();
                      });
                    },
                    onChanged: (val){
                      fnCalc("QTY1");
                    },
                    validate: true,
                  ),
                  FormInput(
                    txtController:txtItemQty2,
                    hintText: txtItemUnit2.text.isNotEmpty?"Qty (${txtItemUnit2.text})": "Qty  (${txtItemUnit2.text} )",
                    focusNode: pnItemQty2,
                    txtWidth: 0.41,
                    focusSts:pnItemQty2.hasFocus?true:false,
                    enablests: wstrPageMode == "VIEW"? false:blnUnit2,
                    emptySts: txtItemUnit2.text.isEmpty?false:true,
                    textType: TextInputType.number,
                    onClear: (){
                      setState((){
                        txtItemQty2.clear();
                      });
                    },
                    onChanged: (val){
                       fnCalc("QTY2");
                    },
                    validate: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget wDriverCard(){
    return SingleChildScrollView(
      child: Column(
        children: [
          FormInput(
            txtController:txtDriverCode,
            hintText: "Driver",
            focusNode: pnDriverCode,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnDriverCode.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtDriverCode.text.isEmpty?false:true,
            suffixIcon: Icons.search,
            suffixIconOnclick: (){
              fnLookup("DRIVER");
            },
            onClear: (){
              setState((){
                txtDriverCode.clear();
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
            txtController:txtDriverName,
            hintText: "Driver Name",
            focusNode: pnDriverName,
            txtWidth: 1,
            focusSts:pnDriverName.hasFocus?true:false,
            enablests: false,
            emptySts: false,

            validate: true,
          ),
          gapHC(5),
          FormInput(
            txtController:txtVehicleNo,
            hintText: "Vehicle No",
            focusNode: pnVehicleNo,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnVehicleNo.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtVehicleNo.text.isEmpty?false:true,
            suffixIcon: Icons.search,
            suffixIconOnclick: (){
              fnLookup("VEHICLE");
            },
            onClear: (){
              setState((){

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
            txtController:txtHelp1,
            hintText: "Helper 1",
            focusNode: pnHelp1,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnHelp1.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtHelp1.text.isEmpty?false:true,
            suffixIcon: Icons.search,
            suffixIconOnclick: (){
              fnLookup("HELP1");
            },
            onClear: (){
              setState((){
                txtHelp1.clear();
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
            txtController:txtHelp1Name,
            hintText: "Helper Name",
            focusNode: pnHelp1Name,
            txtWidth: 1,
            focusSts:pnHelp1Name.hasFocus?true:false,
            enablests: false,
            emptySts: false,

            validate: true,
          ),
          gapHC(5),
          FormInput(
            txtController:txtHelp2,
            hintText: "Helper 2",
            focusNode: pnHelp2,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnHelp2.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtHelp2.text.isEmpty?false:true,
            suffixIcon: Icons.search,
            suffixIconOnclick: (){
              fnLookup("HELP2");
            },
            onClear: (){
              setState((){
                txtHelp2.clear();
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
            txtController:txtHelp2Name,
            hintText: "Helper Name",
            focusNode: pnHelp2Name,
            txtWidth: 1,
            focusSts:pnHelp2Name.hasFocus?true:false,
            enablests: false,
            emptySts: false,

            validate: true,
          ),
          gapHC(5),
          FormInput(
            txtController:txtTripNo,
            hintText: "Trip",
            focusNode: pnTripNo,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnTripNo.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtTripNo.text.isEmpty?false:true,
            suffixIcon: Icons.search,
            suffixIconOnclick: (){
              fnLookup("TRIP");
            },
            onClear: (){
              setState((){
                txtTripNo.clear();
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
          gapHC(10),
          Row(
            children: [
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  tcn('Filling Start Time', Colors.black, 12),
                  Bounce(
                    duration: const Duration(milliseconds: 110),
                    onPressed: (){
                      _selectTimeFrom(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: boxOutlineCustom1(Colors.white, 5, Colors.black.withOpacity(0.5), 0.5),
                      child: tcn(lstrTimeFromStr.toString(), bgColorDark, g.wstrSubFont),
                    ),
                  )
                ],
              )),
              gapWC(10),
              Flexible(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(),
                  tcn('Filling End Time', Colors.black, 12),
                  Bounce(
                    duration: const Duration(milliseconds: 110),
                    onPressed: (){
                      _selectTimeTo(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      alignment: Alignment.center,
                      decoration: boxOutlineCustom1(Colors.white, 5, Colors.black.withOpacity(0.5), 0.5),
                      child: tcn(lstrTimeToStr.toString(), bgColorDark, g.wstrSubFont),
                    ),
                  )
                ],
              )),
            ],
          ),
        ],
      ),
    );
  }
  Widget wTripCard(){
    return SingleChildScrollView(
      child: Column(
        children: [
          FormInput(
            txtController:txtManagedBy,
            hintText: "Managed BY",
            focusNode: pnManagedBy,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnManagedBy.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtManagedBy.text.isEmpty?false:true,
            suffixIcon: Icons.search,
            suffixIconOnclick: (){
              fnLookup("SMAN");
            },
            onClear: (){
              setState((){
                txtManagedBy.clear();
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
          FormInput(
            txtController:txtPdnNo,
            hintText: "PDN No",
            focusNode: pnPdnNo,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnPdnNo.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtPdnNo.text.isEmpty?false:true,
            onClear: (){
              setState((){
                txtPdnNo.clear();
              });
            },
            onChanged: (value){
              setState((){
              });
            },
            validate: true,
          ),
          FormInput(
            txtController:txtLpoNo,
            hintText: "LPO No",
            focusNode: pnLpoNo,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnLpoNo.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtLpoNo.text.isEmpty?false:true,
            onClear: (){
              setState((){
                txtLpoNo.clear();
              });
            },
            onChanged: (value){
              setState((){
              });
            },
            validate: true,
          ),
          FormInput(
            txtController:txtMeterReading,
            hintText: "Meter Reading",
            focusNode: pnMeterReading,
            labelYn: "Y",
            txtWidth: 1,
            textType: TextInputType.number,
            focusSts:pnMeterReading.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtMeterReading.text.isEmpty?false:true,
            onClear: (){
              setState((){
                txtMeterReading.clear();
              });
            },
            onChanged: (value){
              setState((){
              });
            },
            validate: true,
          ),
          FormInput(
            txtController:txtRef1,
            hintText: "Ref 1",
            focusNode: pnRef1,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnRef1.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtRef1.text.isEmpty?false:true,
            onClear: (){
              setState((){
                txtRef1.clear();
              });
            },
            onChanged: (value){
              setState((){
              });
            },
            validate: true,
          ),
          FormInput(
            txtController:txtRef2,
            hintText: "Ref 2",
            focusNode: pnRef2,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnRef2.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtRef2.text.isEmpty?false:true,
            onClear: (){
              setState((){
                txtRef2.clear();
              });
            },
            onChanged: (value){
              setState((){
              });
            },
            validate: true,
          ),
          FormInput(
            txtController:txtRef3,
            hintText: "Ref 3",
            focusNode: pnRef3,
            labelYn: "Y",
            txtWidth: 1,
            focusSts:pnRef3.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtRef3.text.isEmpty?false:true,
            onClear: (){
              setState((){
                txtRef3.clear();
              });
            },
            onChanged: (value){
              setState((){
              });
            },
            validate: true,
          ),
          FormArea(
            txtController:txtRemarks,
            hintText: "Remarks",
            focusNode: pnRemarks,
            labelYn: "Y",
            txtWidth: 1,
            maxLines: 5,
            focusSts:pnRemarks.hasFocus?true:false,
            enablests: wstrPageMode == "VIEW"? false:true,
            emptySts: txtRemarks.text.isEmpty?false:true,
            onClear: (){
              setState((){
                txtRemarks.clear();
              });
            },
            onChanged: (value){
              setState((){
              });
            },
            validate: true,
          ),


        ],
      ),
    );
  }
  //==========================================LOOKUP
  fnLookup(mode){
    if(wstrPageMode == "VIEW"){
      return;
    }
    if (mode == "STKCODE") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'STKCODE', 'Display': 'Stock Code'},
        {'Column': 'STKDESCP', 'Display': 'Stock Descp'},
        {'Column': 'UNIT', 'Display': 'Unit'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'STKCODE',
          'contextField': txtItemCode,
          'context': 'window'
        },
        {
          'sourceColumn': 'STKDESCP',
          'contextField': txtItemName,
          'context': 'window'
        },
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtItemCode,
        oldValue: txtItemCode.text,
        lstrTable: 'STOCKMASTER',
        title: 'Item',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'STKCODE',
        mode: "S",
        layoutName: "B",
        callback: fnStkLookupCallBack,
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
        {'Column': "COMPANY", 'Operator': '=', 'Value': frmCompanyCode, 'JoinType': 'AND'},
      ];

      Get.to(()=> LookupSchMob(
        txtControl: txtSupplierCode,
        oldValue: txtSupplierCode.text,
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
        callback: fnStkSpLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "DRIVER") {
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
        oldValue: txtDriverCode.text,
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
        callback: fnLookupCallBack,
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
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtVehicleNo,
        oldValue: txtVehicleNo.text,
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
        oldValue: txtHelp1.text,
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
        oldValue: txtHelp2.text,
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
    else if (mode == "UNIT2") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'UNIT', 'Display': 'Unit'},
        {'Column': 'STKCODE', 'Display': 'Stock Code'},
        {'Column': 'COMPANY', 'Display': 'Company'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'UNIT',
          'contextField': txtItemUnit2,
          'context': 'window'
        },
      ];
      var lstrFilter =[
        {'Column': "COMPANY", 'Operator': '=', 'Value': frmCompanyCode.toString(), 'JoinType': 'AND'},
        {'Column': "STKCODE", 'Operator': '=', 'Value': txtItemCode.text, 'JoinType': 'AND'},
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtItemUnit2,
        oldValue: "",
        lstrTable: 'STOCKUNIT',
        title: 'Unit',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'UNIT',
        mode: "S",
        layoutName: "B",
        callback: fnUnit2LookupCallBack,
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
        callback: fnLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "SMAN") {

      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Code'},
        {'Column': 'DESCP', 'Display': 'Sman'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtManagedBy,
          'context': 'window'
        },
      ];

      Get.to(()=> LookupSchMob(
        txtControl: txtManagedBy,
        oldValue: "",
        lstrTable: 'SMANMAST',
        title: 'Trip',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'CODE',
        mode: "S",
        layoutName: "B",
        callback: fnLookupCallBack,
        company: frmCompanyCode,
      ));
    }
  }
  fnLookupCallBack(value){
    if(mounted){
      setState(() {

      });
    }
  }
  fnUnit2LookupCallBack(value){
    if(mounted){
      setState(() {
          txtItemUnit2.text = value["UNIT"]??"";
      });
      apiGetStockDetails(txtItemCode.text,txtSupplierCode.text);
    }
  }
  fnStkLookupCallBack(value){
    if(g.fnValCheck(value)){
      apiGetStockDetails(value["STKCODE"],txtSupplierCode.text);
    }

  }
  fnStkSpLookupCallBack(value){
    apiGetStockDetails(txtItemCode.text,value["SLCODE"]);
  }
  //==========================================MENU
  fnMenu(mode){
    if(mounted){
      if(mode == "A"){
        fnGetCompany();
      }else if(mode == "C"){
        fnClear();
        setState(() {
          wstrPageMode = "VIEW";
        });
        apiView("", "LAST");
      }
      else if(mode == "E"){
        setState(() {
          wstrPageMode = "EDIT";
        });
        fnCalc("");
      }
      else if(mode == "L"){
        Navigator.pop(context);
      }
      else if(mode == "N"){
        fnView("NEXT");
      }
      else if(mode == "P"){
        fnView("PREVIOUS");
      }
    }

  }
  //==========================================PAGE Fn
  fnGetPageData(){
    if(mounted){
      setState(() {

        var h = DateTime.now().hour;
        var m = DateTime.now().minute;
        lstrTimeFrom =  TimeOfDay(hour: h, minute: m);
        lstrTimeTo =  TimeOfDay(hour: h, minute: m);
        _pageController = PageController();
        wstrPageForm = [];
        wstrPageForm =[];
        wstrPageForm.add({"CONTROLLER":txtItemCode,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Select Item.","FILL_CODE":"STKCODE","PAGE_NODE":pnItemCode,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"STKDESCP","PAGE_NODE":pnItemName,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemUnit1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"UNIT1","PAGE_NODE":pnItemUnit1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemUnit2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"UNIT2","PAGE_NODE":pnItemUnit2,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemRate1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"RATEFC","PAGE_NODE":pnItemRate1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemRate2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"RATEFC2","PAGE_NODE":pnItemRate2,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemQty1,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please enter qty","FILL_CODE":"QTY1","PAGE_NODE":pnItemQty1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemQty2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"QTY2","PAGE_NODE":pnItemQty2,"MODE":"H"});

        wstrPageForm.add({"CONTROLLER":txtDriverCode,"TYPE":"S","VALIDATE":true ,"ERROR_MSG":"Please Select Driver","FILL_CODE":"DEL_MAN","PAGE_NODE":pnDriverCode,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtDriverName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"DEL_MAN_NAME","PAGE_NODE":pnDriverName,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtVehicleNo,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please select vehicle ","FILL_CODE":"VEHICLE_NO","PAGE_NODE":pnVehicleNo,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER1","PAGE_NODE":pnHelp1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp1Name,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER1_NAME","PAGE_NODE":pnHelp1Name,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER2","PAGE_NODE":pnHelp2,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp2Name,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER2_NAME","PAGE_NODE":pnHelp2Name,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtSupplierCode,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Select Supplier","FILL_CODE":"CUSTOMER_CODE","PAGE_NODE":pnSupplierCode,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtSupplierName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"CUSTOMER_NAME","PAGE_NODE":pnSupplierName,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtTripNo,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"TRIP_NO","PAGE_NODE":pnTripNo,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtManagedBy,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"MANAGED_BY","PAGE_NODE":pnManagedBy,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtRemarks,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"REMARKS","PAGE_NODE":pnRemarks,"MODE":"H"});

        wstrPageForm.add({"CONTROLLER":txtRef1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"REF1","PAGE_NODE":pnRef1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtRef2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"REF2","PAGE_NODE":pnRef2,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtRef3,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"REF3","PAGE_NODE":pnRef3,"MODE":"H"});

        wstrPageForm.add({"CONTROLLER":txtPdnNo,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Select PDN no","FILL_CODE":"PDA_NO","PAGE_NODE":pnPdnNo,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtLpoNo,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"LPO_NO","PAGE_NODE":pnLpoNo,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtMeterReading,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"METER_READING","PAGE_NODE":pnRef3,"MODE":"H"});

      });
      Future.delayed(Duration.zero,(){
        //your code goes here
        apiView("","LAST");
      });

    }

  }
  fnGetCompany(){
    PageDialog().showNote(context,  GetCompany(
      fnCallBack: fnAdd,
    ), "Choose Company");
  }
  fnAdd(company){
    if(mounted){
      fnClear();
      setState(() {
        frmDocNo = "NEW";
        frmDocDate =  setDate(15, DateTime.now());
        wstrPageMode = "ADD";
        frmCompanyCode = company["COMPANY_CODE"]??"";
        frmCompanyName = company["COMPANY_DESCP"]??"";
      });

    }
  }
  Future<void> _selectTimeFrom(BuildContext context) async {
    if(wstrPageMode == "VIEW"){
      return;
    }
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime:  lstrTimeFrom,
        builder: (context, childWidget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false), child: childWidget!,);
        }
    );
    if (newTime != null) {
      setState(() {
        var now = DateTime.now();
        lstrTimeFrom = newTime;
        lstrTimeFromStr  =  setDate(11, DateTime(now.year,now.month,now.day,newTime.hour,newTime.minute));
      });
    }
  }
  Future<void> _selectTimeTo(BuildContext context) async {
    if(wstrPageMode == "VIEW"){
      return;
    }
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime:  lstrTimeTo,
        builder: (context, childWidget) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false), child: childWidget!,);
        }
    );
    if (newTime != null) {
      setState(() {
        var now = DateTime.now();
        lstrTimeTo = newTime;
        lstrTimeToStr  =  setDate(11, DateTime(now.year,now.month,now.day,newTime.hour,newTime.minute));
      });
    }
  }
  fnCalc(mode){
    if(mounted){
      setState(() {
        if(frmCF == 0){
          frmCF =1.0;
        }
        var qty1 = g.mfnDbl(txtItemQty1.text);
        var qty2 = g.mfnDbl(txtItemQty2.text);

        var rate1 = lstrItemRate1;
        var rate2 = lstrItemRate2;
        //1. CHECK UNIT 2 != ""
        if(txtItemUnit2.text.isNotEmpty){
          //qty1 disable
          //rate1 disable
          qty1 =  qty2*frmCF;
          rate1 =  rate2/frmCF;
          blnUnit2 = true;
          blnUnit1 = false;
        }else{
          blnUnit2 = false;
          blnUnit1 = true;
          txtItemQty2.clear();
        }

        if(mode != "QTY1"){
          txtItemQty1.text =qty1.toString();
        }
        if(mode != "QTY2"){
          txtItemQty2.text =qty2.toString();
        }

        txtItemRate1.text =rate1.toString();
        txtItemRate2.text =rate2.toString();

        var total  = qty1*rate1;
        frmTotalAmount =total;

      });
    }
  }

  fnView(mode){
    apiView(frmMainDocno,mode);
  }
  fnClear(){
    if(mounted){
      setState((){
        for(var e in wstrPageForm){
          e["CONTROLLER"].clear();
        }

        frmDocNo = "";
        frmDocDate  = "";
        frmDoctype  = "";
        frmCompanyCode = "";
        frmCompanyName = "";
        frmCF = 1.0;
        frmTotalAmount = 0.0;
        frmSign = [];
        frmMainDocno = "";
        lstrTimeFromStr = "";
        lstrTimeToStr = "";



      });
    }
  }
  fnFill(data,maindata,sign){
    fnClear();
    if(data != null){
      if(mounted){
        setState((){
          wstrPageMode = "VIEW";
          for(var e in wstrPageForm){
            if(e["TYPE"] == "D"){
              if(e["MODE"] == "H"){
                e["CONTROLLER"].text = setDate(6, DateTime.parse(data[e["FILL_CODE"]].toString()));
              }else{
                //e["CONTROLLER"].text = setDate(6, DateTime.parse(detData[e["FILL_CODE"]].toString()));
              }
            }else{
              if(e["MODE"] == "H"){
                e["CONTROLLER"].text = data[e["FILL_CODE"]].toString() == "null"?"":data[e["FILL_CODE"]].toString();
              }else{
               // e["CONTROLLER"].text = detData[e["FILL_CODE"]].toString() == "null"?"":detData[e["FILL_CODE"]].toString();
              }

            }
          }
          frmDocNo = data["DOCNO"].toString();
          frmDoctype = data["DOCTYPE"].toString();
          frmDocDate  = setDate(6, DateTime.parse(data["DOCDATE"].toString()) );
          lstrDocdate = DateTime.parse(data["DOCDATE"].toString());
          frmCompanyCode = data["COMPANY"];
          frmCompanyName = "";
          frmCF = data["UNITCF"];
          frmTotalAmount =data["TOTAL_FILLING_AMT"];
          frmMainDocno = maindata["MAIN_DOCNO"];
          lstrTimeFromStr = data["TIME_FROM"]??"";
          lstrTimeToStr = data["TIME_TO"]??"";
          frmSign =sign;
          lstrItemRate1 = g.mfnDbl(data["RATEFC"]);
          lstrItemRate2 = g.mfnDbl(data["RATEFC2"]);


        });
      }
    }
  }
  fnSubmit(){
    if(mounted){

      if(wstrPageMode =="VIEW"){
        return;
      }
      var saveSts = true;
      for(var e in wstrPageForm){
        var validate =  e["VALIDATE"];
        if(validate){
          if(e["CONTROLLER"].text ==  null || e["CONTROLLER"].text ==  ""){
            errorMsg(context, e["ERROR_MSG"].toString());
            saveSts = false;
            e["PAGE_NODE"].requestFocus();
            return;
          }
        }
      }
      
      if(g.mfnDbl(txtItemQty1.text) == 0 && g.mfnDbl(txtItemQty2.text) == 0 ){
        errorMsg(context, "Please enter qty!!!");
        saveSts = false;
        return;
      }

      if(!saveSts){
        return;
      }

      var headerData = [];

      headerData.add({
        'COMPANY' : frmCompanyCode,
        'DOCNO' : frmDocNo,
        'DOCTYPE' : frmDoctype,
        'DOCDATE' : setDate(2, lstrDocdate),
        'RECEIVING_DATE' :  setDate(2, lstrDocdate),
        'MANAGED_BY' : txtManagedBy.text,
        'REMARKS' : txtRemarks.text,
        'REF1' : txtRef1.text,
        'REF2' : txtRef2.text,
        'REF3' : txtRef3.text,
        'TOTAL_FILLING_AMT' : frmTotalAmount,
        'DEL_MAN' : txtDriverCode.text,
        'DEL_MAN_NAME' : txtDriverName.text,
        'VEHICLE_NO' : txtVehicleNo.text,
        'HELPER1' : txtHelp1.text,
        'HELPER1_NAME' : txtHelp1Name.text,
        'HELPER2' : txtHelp2.text,
        'HELPER2_NAME' : txtHelp2Name.text,
        'STKCODE' : txtItemCode.text,
        'STKDESCP' : txtItemName.text,
        'CURR' : 'AED',
        'CURRATE' : 1,
        'UNITCF' : frmCF,
        'UNIT1' : txtItemUnit1.text,
        'UNIT2' : txtItemUnit2.text,
        'RATELC2' : g.mfnDbl(txtItemRate2.text),
        'RATEFC2' : g.mfnDbl(txtItemRate2.text),
        'RATELC' : g.mfnDbl(txtItemRate1.text),
        'RATEFC' : g.mfnDbl(txtItemRate1.text),
        'BRNCODE' :'',
        'CCCODE' : '',
        'DIVCODE' : '',
        'DBACCODE' : '',
        'CRACCODE' : '',
        'SHIFT_NO' : '',
        'PDA_NO' : txtPdnNo.text,
        'TIME_FROM' : lstrTimeFromStr,
        'TIME_TO' : lstrTimeToStr,
        'QTY1' : g.mfnDbl(txtItemQty1.text),
        'QTY2' : g.mfnDbl(txtItemQty2.text),
        'AMTFC' : frmTotalAmount,
        'AMTLC' : frmTotalAmount,
        'TRIP_NO' : txtTripNo.text,
        'CUSTOMER_CODE' : txtSupplierCode.text,
        'CUSTOMER_NAME' : txtSupplierName.text,
        'CREATE_USER' : g.wstrUserCd,
        'CREATE_DATE' :  setDate(2, DateTime.now()),
        'EDIT_USER' : g.wstrUserCd,
        'EDIT_DATE' : setDate(2, DateTime.now()),
        'SRNO' : 1,
        'CLEARED_QTY' : 0.0,
        'LPO_NO' : txtLpoNo.text,
        'METER_READING' : txtMeterReading.text,
        'MOBILENO_IMEI_EDITER' : g.wstrDeivceId,
        'MOBILENO_EDITER_LATITUDE' : '',
        'MOBILENO_EDITER_LONGTITUDE' : '',
        'IMAGE_SIGNATURE' : ''
      });


      Get.to(()=> TankRecSubmit(
        header: headerData,
        mode: wstrPageMode, fnCallBack: fnEditCallBack, mainDocno: frmMainDocno,
        sign: frmSign,
      ));

    }
  }
  fnEditCallBack(docno){
    fnClear();
    setState(() {
      wstrPageMode = "VIEW";
    });
    successMsg(context, 'Updated Successfully');
    apiView(docno, "");
  }

  //==========================================API CALL

  apiView(docno,mode){
    futureForm =apiCall.apiViewTankReceiving(g.wstrCompany, docno, "GTR", mode);
    futureForm.then((value) => apiViewRes(value));
  }
  apiViewRes(value){
    if(mounted){
      if(g.fnValCheck(value)){
        dprint(value["Table4"]);
        // fnFill(data,maindata)

        fnFill(value["Table1"][0],value["Table0"][0],value["Table3"]);
      }
    }
  }

  apiGetStockDetails(stkCode,spCode){
    var recDate =  setDate(2, DateTime.now());
    stkCode =  stkCode == ""?"LPG1":stkCode;
    futureForm = apiCall.apiGetRecStockRate(frmCompanyCode, stkCode, recDate, spCode, txtItemUnit2.text);
    futureForm.then((value) => apiGetStockDetailsRes(value));
  }
  apiGetStockDetailsRes(value){
    //[{STKCODE: LPG1, STKDESCP: SUPPLY OF LPG 1, UNIT: LTR, UNIT2: M3, CF: 4.0, RATEFC: 0.8, RATEFC2: 0.2}]
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
            txtItemCode.text = value[0]["STKCODE"];
            txtItemName.text = value[0]["STKDESCP"];
            txtItemUnit1.text = value[0]["UNIT"];
            txtItemUnit2.text = value[0]["UNIT2"];
            frmCF = g.mfnDbl(value[0]["CF"]);
            txtItemRate1.text = g.mfnDbl(value[0]["RATEFC"]).toString();
            txtItemRate2.text = g.mfnDbl(value[0]["RATEFC2"]).toString();
            lstrItemRate1 = g.mfnDbl(value[0]["RATEFC"]);
            lstrItemRate2 = g.mfnDbl(value[0]["RATEFC2"]);

        }
      });
      fnCalc("");
    }
  }


}

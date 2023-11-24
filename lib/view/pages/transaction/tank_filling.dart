
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/alertDialog/alertDialog.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/components/lookup/lookupSch_mobile.dart';
import 'package:scheduler/view/pages/transaction/tank_getcompany.dart';
import 'package:scheduler/view/pages/transaction/tankfill_submit.dart';
import 'package:scheduler/view/styles/colors.dart';

class TankerFilling extends StatefulWidget {
  final data;
  final String pageMode;
  const TankerFilling({Key? key, this.data, required this.pageMode}) : super(key: key);

  @override
  State<TankerFilling> createState() => _TankerFillingState();
}

class _TankerFillingState extends State<TankerFilling> {

  //Global
  var g =  Global();
  var apiCall =  ApiCall();
  var wstrPageMode = "VIEW";
  var wstrDoctype = "GTFS";
  late Future<dynamic> futureForm;
  int _selectedPage = 0;
  late PageController _pageController;
  var lstrTripData = [];

  //Page Variables
  var lstrOptionMode  = "0";
  var lstrOldData = [];
  var wstrPageForm  = [];
  var lstrDocdate = DateTime.now();

  //Formdata
  var frmMainDocno = "";
  var frmDocNo = "";
  var frmDoctype = "";
  var frmDocDate  = "";
  var frmCompanyCode = "";
  var frmCompanyName = "";
  var frmBuildingCode = "";
  var frmBuildingName = "";
  var frmBldCustomer = "";
  var frmBldLoc = "";
  var frmCustomerEmail = "";
  var frmBldCustomerName = "";
  var frmPlannedQty = 0.0;
  var frmCF = 1.0;
  var frmTotalAmount = 0.0;
  var frmSign = [];


  var frmStkCode = "LPG1";
  var frmStkCodeName = "";
  var lstrTimeFrom ;
  var lstrTimeTo ;
  var lstrTimeFromStr = "" ;
  var lstrTimeToStr = "";

  var frmStartKm = "";

  var CALL_PDN_FROM_STOCKTXNDET = "N";

  //======================================Controller
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


  //BuildingDetails
  var txtBuildingCode = TextEditingController();
  var txtBuildingName = TextEditingController();
  var txtBldCustomer = TextEditingController();
  var txtBldCustomerName = TextEditingController();
  var txtBldTank = TextEditingController();
  var txtBldTankCapacity = TextEditingController();

  var pnBuildingCode = FocusNode();
  var pnBuildingName = FocusNode();
  var pnBldCustomer = FocusNode();
  var pnBldCustomerName = FocusNode();
  var pnBldTank = FocusNode();
  var pnBldTankCapacity = FocusNode();

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


  //Company Controls
  var cRateYn  = "Y";

  //======================================Controller

  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();
    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
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
                      tcn('Tank Filling',  Colors.white, g.wstrHeadFont)
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
                  Row(
                    children: [
                      Icon(Icons.apartment,color: Colors.white,size: g.wstrSubIconSize,),
                      gapWC(10),
                      Expanded(child: tcn("$frmBuildingCode | $frmBuildingName", white, g.wstrSubFont),)
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_pin,color: Colors.white,size: g.wstrSubIconSize,),
                      gapWC(10),
                      Expanded(child: tcn(frmBldCustomerName, white, g.wstrSubFont),)
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
                wOptionCard(Icons.apartment,1),
                wOptionCard(Icons.drive_eta_rounded,2),
                wOptionCard(Icons.mode_of_travel_rounded,3),
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
                    wBuildingCard(),
                    wTripCard(),
                    wUserCard(),
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
    ),
      onWillPop: ()async{
      if(wstrPageMode != "VIEW"){
        return false;
      }else{
        return true;
      }
    });
  }

//==================================WIDGET
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
  Widget wItemCard(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxDecoration(white, 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.gas_meter_outlined,color: txtSubColor,size: g.wstrSubIconSize,),
                gapWC(5),
                th('Item Details', txtSubColor, g.wstrSubFont)
              ],
            ),
            lineS(),
            FormInput(
              txtController:txtItemCode,
              hintText: "Stock Code",
              focusNode: pnItemCode,
              labelYn: "Y",
              txtWidth: 1,
              focusSts:pnItemCode.hasFocus?true:false,
              enablests: wstrPageMode == "VIEW"? false:true,
              emptySts: txtItemCode.text.isEmpty?false:true,
              suffixIcon: Icons.search,
              suffixIconOnclick: (){
                fnLookup("STKCODE");
              },
              onClear: (){
                setState((){
                  txtItemCode.clear();
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
              txtController:txtItemName,
              hintText: "Stock Name",
              focusNode: pnItemName,
              txtWidth: 1,
              focusSts:pnItemCode.hasFocus?true:false,
              enablests: false,
              emptySts: false,

              validate: true,
            ),
            // gapHC(5),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     FormInput(
            //       txtController:txtItemUnit1,
            //       hintText: "Unit 1",
            //       focusNode: pnItemUnit1,
            //       txtWidth: 0.4,
            //       focusSts:pnItemUnit1.hasFocus?true:false,
            //       enablests:false,
            //       emptySts: false,
            //       validate: true,
            //     ),
            //     FormInput(
            //       txtController:txtItemUnit2,
            //       hintText: "Unit 2",
            //       focusNode: pnItemUnit2,
            //       txtWidth: 0.4,
            //       focusSts:pnItemUnit2.hasFocus?true:false,
            //       enablests:false,
            //       emptySts: false,
            //       validate: true,
            //     ),
            //   ],
            // ),
            gapHC(5),
            cRateYn == "Y"?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormInput(
                  txtController:txtItemRate1,
                  hintText: "Rate (${txtItemUnit1.text})",
                  focusNode: pnItemRate1,
                  txtWidth: 0.4,
                  focusSts:pnItemRate1.hasFocus?true:false,
                  enablests:false,
                  emptySts: false,
                  textType: TextInputType.number,
                  validate: true,
                ),
                FormInput(

                  txtController:txtItemRate2,
                  hintText: "Rate (${txtItemUnit2.text})",
                  focusNode: pnItemRate2,
                  txtWidth: 0.4,
                  focusSts:pnItemRate2.hasFocus?true:false,
                  enablests: false,
                  emptySts: false,
                  textType: TextInputType.number,
                  validate: true,
                ),
              ],
            ):gapHC(0),
            gapHC(5),
            Container(
              padding: const EdgeInsets.all(5),
              decoration: boxBaseDecoration(greyLight, 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FormInput(
                    txtController:txtItemQty1,
                    hintText: "Qty 1",
                    focusNode: pnItemQty1,
                    txtWidth: 0.4,
                    focusSts:pnItemQty1.hasFocus?true:false,
                    enablests: wstrPageMode == "VIEW"? false:true,
                    emptySts: txtItemQty1.text.isEmpty?false:true,
                    textType: TextInputType.number,
                    onClear: (){
                      setState((){
                        txtItemQty1.clear();
                      });
                      fnCalc("Q");
                    },
                    onChanged: (val){
                      fnCalc("Q");
                    },
                    validate: true,
                  ),
                  FormInput(
                    txtController:txtItemQty2,
                    hintText: "Qty 2",
                    focusNode: pnItemQty2,
                    txtWidth: 0.4,
                    focusSts:pnItemQty2.hasFocus?true:false,
                    enablests: false,
                    emptySts: false,
                    textType: TextInputType.number,
                    validate: true,
                  ),
                ],
              ),
            ),
            gapHC(5),
            InkWell(
              onTap: (){
                txtItemQty1.text = frmPlannedQty.toString();
                fnCalc("Q");
              },
              child: tcn(' Planned QTY  ${frmPlannedQty.toString()}', subColor, g.wstrSubFont),
            ),
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormInput(
                  txtController:txtLevelBef,
                  hintText: "Level Before",
                  focusNode: pnLevelBef,
                  txtWidth: 0.4,
                  focusSts:pnLevelBef.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelBef.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelBef.clear();
                    });
                    fnCalc("L");
                  },
                  onChanged: (val){
                    fnCalc("L");
                  },
                  validate: true,
                ),
                FormInput(
                  txtController:txtLevelAft,
                  hintText: "Level After",
                  focusNode: pnLevelAft,
                  txtWidth: 0.4,
                  focusSts:pnLevelAft.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelAft.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelAft.clear();
                    });
                    fnCalc("L");
                  },
                  onChanged: (val){
                    fnCalc("L");
                  },
                  validate: true,
                ),
              ],
            ),
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormInput(
                  txtController:txtLevelBefPer,
                  hintText: "Level Before %",
                  focusNode: pnLevelBefPer,
                  txtWidth: 0.4,
                  focusSts:pnLevelBefPer.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelBefPer.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelBefPer.clear();
                    });
                  },
                  validate: true,
                ),
                FormInput(
                  txtController:txtLevelAftPer,
                  hintText: "Level After %",
                  focusNode: pnLevelAftPer,
                  txtWidth: 0.4,
                  focusSts:pnLevelAftPer.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelAftPer.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelAftPer.clear();
                    });
                  },
                  validate: true,
                ),
              ],
            ),
            gapHC(5),
          ],
        ),
      ),
    );
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
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormInput(
                  txtController:txtLevelBef,
                  hintText: "Level Before",
                  focusNode: pnLevelBef,
                  txtWidth: 0.41,
                  focusSts:pnLevelBef.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelBef.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelBef.clear();
                    });
                    fnCalc("L");
                  },
                  onChanged: (val){
                    fnCalc("L");
                  },
                  validate: true,
                ),
                FormInput(
                  txtController:txtLevelAft,
                  hintText: "Level After",
                  focusNode: pnLevelAft,
                  txtWidth: 0.41,
                  focusSts:pnLevelAft.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelAft.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelAft.clear();
                    });
                    fnCalc("L");
                  },
                  onChanged: (val){
                    fnCalc("L");
                  },
                  validate: true,
                ),
              ],
            ),
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormInput(
                  txtController:txtLevelBefPer,
                  hintText: "Level Before %",
                  focusNode: pnLevelBefPer,
                  txtWidth: 0.41,
                  focusSts:pnLevelBefPer.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelBefPer.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelBefPer.clear();
                    });
                  },
                  validate: true,
                ),
                FormInput(
                  txtController:txtLevelAftPer,
                  hintText: "Level After %",
                  focusNode: pnLevelAftPer,
                  txtWidth: 0.41,
                  focusSts:pnLevelAftPer.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtLevelAftPer.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtLevelAftPer.clear();
                    });
                  },
                  validate: true,
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
                    hintText: "Qty (${txtItemUnit1.text})",
                    focusNode: pnItemQty1,
                    txtWidth: 0.41,
                    focusSts:pnItemQty1.hasFocus?true:false,
                    enablests: wstrPageMode == "VIEW"? false:true,
                    emptySts: txtItemQty1.text.isEmpty?false:true,
                    textType: TextInputType.number,
                    onClear: (){
                      setState((){
                        txtItemQty1.clear();
                      });
                      fnCalc("Q");
                    },
                    onChanged: (val){
                      fnCalc("Q");
                    },
                    validate: true,
                  ),
                  FormInput(
                    txtController:txtItemQty2,
                    hintText: "Qty  (${txtItemUnit2.text} = ${txtItemUnit1.text} / ${frmCF.toString()} )",
                    focusNode: pnItemQty2,
                    txtWidth: 0.41,
                    focusSts:pnItemQty2.hasFocus?true:false,
                    enablests: false,
                    emptySts: false,
                    textType: TextInputType.number,
                    validate: true,
                  ),
                ],
              ),
            ),
            gapHC(5),
            InkWell(
              onTap: (){
                txtItemQty1.text = frmPlannedQty.toString();
                fnCalc("Q");
              },
              child: tcn(' Planned QTY  ${frmPlannedQty.toString()}', subColor, g.wstrSubFont),
            ),
            gapHC(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FormInput(
                  txtController:txtPrsrBef,
                  hintText: "Pressure Before",
                  focusNode: pnPrsrBef,
                  txtWidth: 0.4,
                  focusSts:pnPrsrBef.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtPrsrBef.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtPrsrBef.clear();
                    });
                  },
                  validate: true,
                ),
                FormInput(
                  txtController:txtPrsrAft,
                  hintText: "Pressure After",
                  focusNode: pnPrsrAft,
                  txtWidth: 0.4,
                  focusSts:pnPrsrAft.hasFocus?true:false,
                  enablests: wstrPageMode == "VIEW"? false:true,
                  emptySts: txtPrsrAft.text.isEmpty?false:true,
                  textType: TextInputType.number,
                  onClear: (){
                    setState((){
                      txtPrsrAft.clear();
                    });
                  },
                  validate: true,
                ),
              ],
            ),
            gapHC(15),
          ],
        ),
      ),
    );
  }
  Widget wBuildingCard(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxDecoration(white, 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.maps_home_work_outlined,color: txtSubColor,size: g.wstrSubIconSize,),
                gapWC(5),
                th('Building Details', txtSubColor, g.wstrSubFont)
              ],
            ),
            lineS(),
            FormInput(
              txtController:txtBuildingCode,
              hintText: "Building Code",
              focusNode: pnBuildingCode,
              labelYn: "Y",
              txtWidth: 1,
              focusSts:pnBuildingCode.hasFocus?true:false,
              enablests: wstrPageMode == "VIEW"? false:true,
              emptySts: txtBuildingCode.text.isEmpty?false:true,
              suffixIcon: Icons.search,
              suffixIconOnclick: (){
                fnLookup("BUILDING");
              },
              onClear: (){
                setState((){
                  txtBuildingCode.clear();
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
              txtController:txtBuildingName,
              hintText: "Building Name",
              focusNode: pnBuildingName,
              txtWidth: 1,
              focusSts:pnBuildingName.hasFocus?true:false,
              enablests: false,
              emptySts: false,

              validate: true,
            ),
            gapHC(5),
            FormInput(
              txtController:txtBldCustomer,
              hintText: "Customer Code",
              focusNode: pnBldCustomer,
              labelYn: "Y",
              txtWidth: 1,
              focusSts:pnBldCustomer.hasFocus?true:false,
              enablests: wstrPageMode == "VIEW"? false:true,
              emptySts: txtBldCustomer.text.isEmpty?false:true,
              suffixIcon: Icons.search,
              suffixIconOnclick: (){
                fnLookup("SLMAST");
              },
              onClear: (){
                setState((){
                  txtBldCustomer.clear();
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
              txtController:txtBldCustomerName,
              hintText: "Customer Name",
              focusNode: pnBldCustomerName,
              txtWidth: 1,
              focusSts:pnBldCustomerName.hasFocus?true:false,
              enablests: false,
              emptySts: false,
              validate: true,
            ),
            gapHC(5),
            FormInput(
              txtController:txtBldTank,
              hintText: "Tank",
              focusNode: pnBldTank,
              labelYn: "Y",
              txtWidth: 1,
              focusSts:pnBldTank.hasFocus?true:false,
              enablests: wstrPageMode == "VIEW"? false:true,
              emptySts: txtBldTank.text.isEmpty?false:true,
              suffixIcon: Icons.search,
              suffixIconOnclick: (){
                fnLookup("TANK");
              },
              onClear: (){
                setState((){
                  txtBldTank.clear();
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
              txtController:txtBldTankCapacity,
              hintText: "Capacity",
              focusNode: pnBldTankCapacity,
              txtWidth: 1,
              focusSts:pnBldTankCapacity.hasFocus?true:false,
              enablests: wstrPageMode == "VIEW"? false:true,
              emptySts: txtBldTankCapacity.text.isEmpty?false:true,
              onClear: (){
                setState((){
                  txtBldTankCapacity.clear();
                });
              },
              textType: TextInputType.number,
              validate: true,
            ),

          ],
        ),
      ),
    );
  }
  Widget wTripCard(){
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: boxDecoration(white, 10),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.drive_eta_rounded,color: txtSubColor,size: g.wstrSubIconSize,),
                gapWC(5),
                th('Vehicle Details', txtSubColor, g.wstrSubFont)
              ],
            ),
            lineS(),
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
  Widget wUserCard(){
    return Container(
      decoration: boxBaseDecoration(white, 5),
      child: Column(
        children: [
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

//==================================MENU
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
      apiGetAddData();
    }
  }
  fnView(mode){
    apiView(frmMainDocno,mode);
  }

//==================================LOOKUP
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
        callback: fnStockLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "BUILDING") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'BUILDING_CODE', 'Display': 'Building Code'},
        {'Column': 'DESCP', 'Display': 'Building Name'},
        {'Column': 'SLCODE', 'Display': 'Customer Code'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'BUILDING_CODE',
          'contextField': txtBuildingCode,
          'context': 'window'
        },
        {
          'sourceColumn': 'DESCP',
          'contextField': txtBuildingName,
          'context': 'window'
        },
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtBuildingCode,
        oldValue: txtBuildingCode.text,
        lstrTable: 'GBUILDINGMASTER',
        title: 'Building',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'BUILDING_CODE',
        mode: "S",
        layoutName: "B",
        callback: fnBuildingLookupCallBack,
        company: frmCompanyCode,
      ));
    }
    else if (mode == "SLMAST") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'SLCODE', 'Display': 'Customer Code'},
        {'Column': 'SLDESCP', 'Display': 'Customer Descp'},
        {'Column': 'EMAIL', 'Display': 'Customer Descp'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'SLCODE',
          'contextField': txtBldCustomer,
          'context': 'window'
        },
        {
          'sourceColumn': 'SLDESCP',
          'contextField': txtBldCustomerName,
          'context': 'window'
        },
        {
          'sourceColumn': 'EMAIL',
          'contextField': frmCustomerEmail,
          'context': 'variable'
        },
      ];
      Get.to(()=> LookupSchMob(
        txtControl: txtBldCustomer,
        oldValue: txtBldCustomer.text,
        lstrTable: 'SLMAST',
        title: 'Customer',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'SLMAST',
        mode: "S",
        layoutName: "B",
        callback: fnCustomerCallBack,
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
    else if (mode == "TANK") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'TANK_NO', 'Display': 'Tank No'},
        {'Column': 'TANK_DESCP', 'Display': 'Tank'},
        {'Column': 'CAPACITY', 'Display': 'Capacity'},
        {'Column': 'BUILDING_CODE', 'Display': 'Building'},
        {'Column': 'COMPANY', 'Display': 'Company'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'TANK_NO',
          'contextField': txtBldTank,
          'context': 'window'
        },
        {
          'sourceColumn': 'CAPACITY',
          'contextField': txtBldTankCapacity,
          'context': 'window'
        },
      ];

      var lstrFilter =[{'Column': "BUILDING_CODE", 'Operator': '=', 'Value': txtBuildingCode.text, 'JoinType': 'AND'}];

      Get.to(()=> LookupSchMob(
        txtControl: txtBldTank,
        oldValue: txtBldTank.text,
        lstrTable: 'GBUILDINGMASTER_TANKDETAILDET',
        title: 'Tank No',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'TANK_NO',
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
        callback: fnLookupCallBack,
        company: frmCompanyCode,
      ));
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
        oldValue: txtSupplierPdnNo.text,
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
          callback: fnSupplierPdnCallBack,
          company: frmCompanyCode,
        ));
      }


    }


  }
  fnLookupCallBack(value){

  }
  fnBuildingLookupCallBack(value){
    if(g.fnValCheck(value)){
      apiGetAddData();
    }
  }
  fnStockLookupCallBack(value){
    if(g.fnValCheck(value)){
      apiGetStock(value["STKCODE"]);
    }else{
      txtItemName.clear() ;
      txtItemUnit1.clear();
      txtItemUnit2.clear();
      txtItemRate1.clear();
      txtItemRate2.clear();
    }
  }
  fnSupplierPdnCallBack(value){
    if(g.fnValCheck(value)){
      txtItemCode.text = value["STKCODE"];
      apiGetStock(value["STKCODE"]);
    }
  }
  fnCustomerCallBack(value){
    if(g.fnValCheck(value)){
      frmCustomerEmail = value["EMAIL"]??"";
    }
  }
//==================================PAGE_FN

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

        wstrPageForm =[];
        wstrPageForm.add({"CONTROLLER":txtItemCode,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Select Item.","FILL_CODE":"STKCODE","PAGE_NODE":pnItemCode,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"STKDESCP","PAGE_NODE":pnItemName,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemUnit1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"UNIT1","PAGE_NODE":pnItemUnit1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemUnit2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"UNIT2","PAGE_NODE":pnItemUnit2,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemRate1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"RATEFC","PAGE_NODE":pnItemRate1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemRate2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"RATEFC2","PAGE_NODE":pnItemRate2,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtItemQty1,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please enter qty","FILL_CODE":"QTY1","PAGE_NODE":pnItemQty1,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtItemQty2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"QTY2","PAGE_NODE":pnItemQty2,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtLevelBef,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Fill Level","FILL_CODE":"LEVEL_BEFORE","PAGE_NODE":pnLevelBef,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtLevelAft,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please Fill Level","FILL_CODE":"LEVEL_AFTER","PAGE_NODE":pnLevelAft,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtLevelBefPer,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"LEVEL_BEFORE_PER","PAGE_NODE":pnLevelBefPer,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtLevelAftPer,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"LEVEL_AFTER_PER","PAGE_NODE":pnLevelAftPer,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtPrsrBef,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"PRESSURE_BEFORE","PAGE_NODE":pnPrsrBef,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtPrsrAft,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"PRESSURE_AFTER","PAGE_NODE":pnPrsrAft,"MODE":"D"});

        wstrPageForm.add({"CONTROLLER":txtBuildingCode,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Select Building Code","FILL_CODE":"BUILDING_CODE","PAGE_NODE":pnBuildingCode,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtBuildingName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"DESCP","PAGE_NODE":pnBuildingName,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtBldCustomer,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"CUSTOMER_CODE","PAGE_NODE":pnBldCustomer,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtBldCustomerName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"CUSTOMER_NAME","PAGE_NODE":pnBldCustomerName,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtBldTank,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"TANK_NO","PAGE_NODE":pnBldTank,"MODE":"D"});
        wstrPageForm.add({"CONTROLLER":txtBldTankCapacity,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"CONTAINER_CAPACITY","PAGE_NODE":pnBldTankCapacity,"MODE":"D"});

        wstrPageForm.add({"CONTROLLER":txtDriverCode,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"DEL_MAN","PAGE_NODE":pnDriverCode,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtDriverName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"DEL_MAN_NAME","PAGE_NODE":pnDriverName,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtVehicleNo,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"VEHICLE_NO","PAGE_NODE":pnVehicleNo,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp1,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER1","PAGE_NODE":pnHelp1,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp1Name,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER1_NAME","PAGE_NODE":pnHelp1Name,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp2,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER2","PAGE_NODE":pnHelp2,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtHelp2Name,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"HELPER2_NAME","PAGE_NODE":pnHelp2Name,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtSupplierPdnNo,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please select PDN NO","FILL_CODE":"SUPPLIER_PDN","PAGE_NODE":pnSupplierPdnNo,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtSupplierCode,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"SLCODE","PAGE_NODE":pnSupplierCode,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtSupplierName,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"SLDESCP","PAGE_NODE":pnSupplierName,"MODE":"H"});
        wstrPageForm.add({"CONTROLLER":txtTripNo,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"","FILL_CODE":"TRIP_NO","PAGE_NODE":pnSupplierName,"MODE":"H"});


        _pageController = PageController();
        if(widget.pageMode == "ADD"){
          wstrPageMode = "ADD";
          lstrOldData = [widget.data];
          var data = widget.data;
          frmDocNo = "NEW";
          frmDocDate =  setDate(15, DateTime.now());
          frmCompanyCode = data["COMPANY"]??"";
          frmCompanyName = data["COMPANY_DESCP"]??"";

          frmBuildingCode = data["BUILDING_CODE"]??"";
          frmBuildingName = data["BUILDING_DESCP"]??"";

          txtBuildingCode.text = data["BUILDING_CODE"]??"";
          txtBuildingName.text = data["BUILDING_DESCP"]??"";

          txtItemQty1.text = (data["QTY"]??"").toString();
          frmPlannedQty  = g.mfnDbl(data["QTY"]);

          txtItemCode.text = "LPG1";
        }
      });
      if(wstrPageMode == "ADD"){

        Future.delayed(Duration.zero,(){
          //your code goes here

          apiGetAddData();
        });

      }else{
        Future.delayed(Duration.zero,(){
          //your code goes here
          apiView("","LAST");
        });

      }
    }
  }
  fnCalc(mode){
    // if(mode == "L"){
    //   txtLevelBefPer.clear();
    //   txtLevelAftPer.clear();
    // }else if(mode == "LP"){
    //   txtLevelBef.clear();
    //   txtLevelAft.clear();
    // }else if(mode == "Q"){
    //   txtLevelBef.clear();
    //   txtLevelAft.clear();
    //   txtLevelBefPer.clear();
    //   txtLevelAftPer.clear();
    // }

    if(mounted){
      setState(() {
        if(frmCF == 0){
          frmCF =1.0;
        }

        var rate1 = g.mfnDbl(txtItemRate1.text);
        var rate2 = rate1 * frmCF;
        txtItemRate2.text = rate2.toString();


        var levelBef = g.mfnDbl(txtLevelBef.text);
        var levelAfter = g.mfnDbl(txtLevelAft.text);

        var levelBefPer = g.mfnDbl(txtLevelBefPer.text);
        var levelAfterPer = g.mfnDbl(txtLevelAftPer.text);

        var qtyLp =  levelAfter - levelBef;
        var qty2Lp =  (levelAfter - levelBef) * frmCF;

        if(qtyLp > 0 && mode == "L"){
          txtItemQty1.text = qtyLp.toString();
        }else if(mode == "L"){
          txtItemQty1.clear();
          txtItemQty2.clear();
        }

        var qty1 = g.mfnDbl(txtItemQty1.text);
        txtItemQty2.text = (qty1/frmCF).toString();
        var qty2 = g.mfnDbl(txtItemQty2.text);

        if(levelBef > 0 &&  mode == "Q"){
          txtLevelAft.text = (levelBef+qty1).toString();
        }

        var total  = qty1*rate1;
        frmTotalAmount =total;

      });
    }



  }
  fnSubmit(){

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

    if(!saveSts){
      return;
    }

    var headerTable = [];
    var detailTable = [];
    var schedule = [];
    var docDate =  setDate(2, lstrDocdate);
    var editDate =  setDate(2, DateTime.now());


    headerTable.add({
      'MAIN_COMPANYCODE'           :'',
      'COMPANY'                    :frmCompanyCode,
      'DOCNO'                      :frmDocNo,
      'DOCTYPE'                    :frmDoctype,
      'YEARCODE'                   :g.wstrYearcode,
      'DOCDATE'                    :docDate,
      'FILLING_DATE'               :docDate,
      'MANAGED_BY'                 :g.wstrUserCd,
      'REMARKS'                    :'',
      'REF1'                       :'',
      'REF2'                       :'',
      'REF3'                       :'',
      'TOTAL_FILLING_AMT'          :frmTotalAmount,
      'DEL_MAN'                    :txtDriverCode.text,
      'DEL_MAN_NAME'               :txtDriverName.text,
      'VEHICLE_NO'                 :txtVehicleNo.text,
      'HELPER1'                    :txtHelp1.text,
      'HELPER1_NAME'               :txtHelp1Name.text,
      'HELPER2'                    :txtHelp2.text,
      'HELPER2_NAME'               :txtHelp2Name.text,
      'STKCODE'                    :txtItemCode.text,
      'STKDESCP'                   :txtItemName.text,
      'BRNCODE'                    :'',
      'CCCODE'                     :'',
      'DIVCODE'                    :'',
      'CURR'                       :'AED',
      'CURRATE'                    :'1',
      'UNITCF'                     :frmCF,
      'UNIT1'                      :txtItemUnit1.text,
      'UNIT2'                      :txtItemUnit2.text,
      'DBACCODE'                   :'',
      'CRACCODE'                   :'',
      'RATELC2'                    :txtItemRate2.text,
      'RATEFC2'                    :txtItemRate2.text,
      'RATELC'                     :txtItemRate1.text,
      'RATEFC'                     :txtItemRate1.text,
      'SHIFT_NO'                   :'',
      'TRIP_NO'                    :txtTripNo.text,
      'SLCODE'                     :txtSupplierCode.text,
      'ADJ_QTY'                    :0,
      'SUPPLIER_PDN'               :txtSupplierPdnNo.text,
      'DESPATCH_TIME'              :lstrTimeFromStr,
      'START_TIME'                 :lstrTimeFromStr,
      'END_TIME'                   :lstrTimeToStr,
      'DUTY_ENDING'                :'',
      'START_KM'                   :frmStartKm,
      'END_KM'                     :0,
      'CREATE_USER'                :g.wstrUserCd,
      'CREATE_DATE'                :editDate,
      'EDIT_USER'                  :g.wstrUserCd,
      'EDIT_DATE'                  :editDate,
      'LOC_FROM'                   :frmBldLoc,
      'LOC_TO'                     :frmBldLoc,
      'METER_READING'              :0,
      'MOBILENO_IMEI_EDITER'       :g.wstrDeivceId,
      'MOBILENO_EDITER_LATITUDE'   :'',
      'MOBILENO_EDITER_LONGTITUDE' :'',
      'IMAGE_BEFORE'               :'',
      'IMAGE_AFTER'                :'',
      'IMAGE_SIGNATURE'            :'',
      'RECEIVED_BY'                :'',
      'DRIVER_NAME'                :'',
      'SLDESP'					 :''
    }
    );

    // headerTable.add({
    //   "COMPANY" :frmCompanyCode ,
    //   "COMPANY_NAME" :frmCompanyName ,
    //   "DOCNO" :frmDocNo ,
    //   "DOCTYPE" :frmDoctype ,
    //   "YEARCODE" :g.wstrYearcode ,
    //   "DOCDATE" :docDate ,
    //   "FILLING_DATE" :docDate ,
    //   "MANAGED_BY" :g.wstrUserCd ,
    //   // "REMARKS" :'' ,
    //   // "REF1" :'' ,
    //   // "REF2" :'' ,
    //   // "REF3" :'' ,
    //   "TOTAL_FILLING_AMT" :frmTotalAmount ,
    //   "DEL_MAN" :txtDriverCode.text ,
    //   "DEL_MAN_NAME" :txtDriverName.text ,
    //   "VEHICLE_NO" :txtVehicleNo.text ,
    //   "HELPER1" :txtHelp1.text ,
    //   "HELPER1_NAME" :txtHelp1Name.text ,
    //   "HELPER2" :txtHelp2.text ,
    //   "HELPER2_NAME" :txtHelp2Name.text ,
    //   "STKCODE" :txtItemCode.text ,
    //   "STKDESCP" :txtItemName.text ,
    //   "PLANNED_QTY" :frmPlannedQty,
    //   // "BRNCODE" :'' ,
    //   // "CCCODE" :'' ,
    //   // "DIVCODE" :'' ,
    //   "CURR" :'' ,
    //   "CURRATE" :'' ,
    //   "UNITCF" :frmCF ,
    //   "UNIT1" :txtItemUnit1.text ,
    //   "UNIT2" :txtItemUnit2.text ,
    //   // "DBACCODE" :'' ,
    //   // "CRACCODE" :'' ,
    //   "RATELC2" :txtItemRate2.text ,
    //   "RATEFC2" :txtItemRate2.text ,
    //   "RATELC" :txtItemRate2.text ,
    //   "RATEFC" :txtItemRate1.text ,
    //   "SHIFT_NO" :'' ,
    //   "TRIP_NO" :'' ,
    //   "POST_YN" :'' ,
    //   "POSTDATE" :'' ,
    //   "SLCODE" :txtSupplierCode.text ,
    //   // "ADJ_QTY" :'' ,
    //   "SUPPLIER_PDN" :txtSupplierPdnNo.text ,
    //   "DESPATCH_TIME" :'' ,
    //   "START_TIME" :'' ,
    //   "END_TIME" :'' ,
    //   "DUTY_ENDING" :'' ,
    //   "START_KM" :'' ,
    //   "END_KM" :'' ,
    //   "CREATE_USER" :g.wstrUserCd ,
    //   "CREATE_DATE" :editDate ,
    //   "EDIT_USER" :g.wstrUserCd ,
    //   "EDIT_DATE" :editDate ,
    //   // "LOC_FROM" :'' ,
    //   // "LOC_TO" :'' ,
    //   // "METER_READING" :'' ,
    //   // "METER_READING_TO" :'' ,
    //   // "ONLINE_SYNCH_STATUS" :''
    // });
    detailTable.add({
      'MAIN_COMPANYCODE'  :'',
      'COMPANY'           :frmCompanyCode,
      'DOCNO'             :frmDocNo,
      'DOCTYPE'           :frmDoctype,
      'YEARCODE'          :g.wstrYearcode,
      'SRNO'              :1,
      'BUILDING_CODE'     :txtBuildingCode.text,
      'DESCP'             :txtBuildingName.text,
      'CONTAINER_CAPACITY':txtBldTankCapacity.text ,
      'LAST_FILL_QTY'     :0.0 ,
      'LAST_FILL_DATE'    :'',
      'CURR_FILL_QTY'     :txtItemQty1.text,
      'CURR_FILL_DATE'    :docDate,
      'FILLING_RATE'      :txtItemRate1.text ,
      'CUSTOMER_CODE'     :txtBldCustomer.text,
      'CUSTOMER_NAME'     :txtBldCustomerName.text,
      'CUSTOMER_EMAIL'     :frmCustomerEmail,
      'ROUTE_CODE'        :'',
      'DEL_SHEET_NO'      :frmDocNo,
      'REF1'              :'',
      'REF2'              :'',
      'REF3'              :'',
      'QTY2'              :txtItemQty2.text ,
      'QTY1'              :txtItemQty1.text,
      'RATEFC2'           :txtItemRate2.text,
      'RATELC2'           :txtItemRate2.text,
      'RATEFC1'           :txtItemRate1.text,
      'RATELC1'           :txtItemRate1.text,
      'AMTFC'             :frmTotalAmount,
      'AMTLC'             :frmTotalAmount,
      'LEVEL_AFTER_PERC'  :g.mfnDbl(txtLevelAftPer.text),
      'LEVEL_BEFORE_PERC'	:g.mfnDbl(txtLevelBefPer.text),
      'LEVEL_BEFORE'      :g.mfnDbl(txtLevelBef.text),
      'LEVEL_AFTER'       :g.mfnDbl(txtLevelAft.text),
      'PRESSURE_BEFORE'   :g.mfnDbl(txtPrsrBef.text) ,
      'PRESSURE_AFTER'    :g.mfnDbl(txtPrsrAft.text),
      'TIME_FROM'         :lstrTimeFromStr,
      'TIME_TO'           :lstrTimeToStr,
      'TANK_NO'           :txtBldTank.text ,
      'LOC'               :'',
      'CLEARED_QTY'       :0,
      'FROM_LOC'          :frmBldLoc,
      'DBACCODE'          :'',
      'CRACCODE'          :'',
      'JOBNO'             :txtBuildingCode.text,

    });

    // detailTable.add({
    //   "COMPANY" :frmCompanyCode ,
    //   "DOCNO" :frmDocNo ,
    //   "DOCTYPE" :frmDoctype ,
    //   "YEARCODE" :g.wstrYearcode ,
    //   "SRNO   " :1 ,
    //   "BUILDING_CODE" :txtBuildingCode.text ,
    //   "DESCP" :txtBuildingName.text ,
    //   "CONTAINER_CAPACITY" :txtBldTankCapacity.text ,
    //   "LAST_FILL_QTY" :0.0  ,
    //   "LAST_FILL_DATE" :"",
    //   "CURR_FILL_QTY" :txtItemQty1.text ,
    //   "CURR_FILL_DATE" :docDate ,
    //   "FILLING_RATE" :txtItemRate1.text ,
    //   "AMOUNT" :frmTotalAmount ,
    //   "CUSTOMER_CODE" :txtBldCustomer.text ,
    //   "CUSTOMER_NAME" :txtBldCustomerName.text ,
    //   "ROUTE_CODE" :'' ,
    //   "DEL_SHEET_NO" :frmDocNo ,//docno
    //   "REF1" :'' ,
    //   "REF2" :'' ,
    //   "REF3" :'' ,
    //   "QTY2" :txtItemQty2.text ,
    //   "QTY1" :txtItemQty1.text ,
    //   "RATEFC2" :txtItemRate2.text ,
    //   "RATELC2" :txtItemRate2.text ,
    //   "RATEFC1" :txtItemRate1.text ,
    //   "RATELC1" :txtItemRate1.text ,
    //   "AMTFC" :frmTotalAmount,
    //   "AMTLC" :frmTotalAmount ,
    //   "LEVEL_BEFORE" :txtLevelBef.text ,
    //   "LEVEL_AFTER" :txtLevelAft.text ,
    //   "LEVEL_BEFORE_PER" :txtLevelBefPer.text ,
    //   "LEVEL_AFTER_PER" :txtLevelAftPer.text ,
    //   "PRESSURE_BEFORE" :txtPrsrBef.text ,
    //   "PRESSURE_AFTER" :txtPrsrAft.text ,
    //   "TIME_FROM" :'' ,
    //   "TIME_TO" :'' ,
    //   "TANK_NO" :txtBldTank.text ,
    //   "LOC" :'' ,
    //   "CLEARED_QTY" :'' ,
    //   "FROM_LOC" :'' ,
    //   "DBACCODE" :'' ,
    //   "CRACCODE" :'' ,
    //   "JOBNO" :'' ,
    //   "ONLINE_SYNCH_STATUS" :''
    // });

    if(g.fnValCheck(lstrOldData)){
      schedule.add({
        "MAIN_COMPANY":g.wstrCompany,
        "DOCNO":lstrOldData[0]["DOCNO"],
        "DOCTYPE":lstrOldData[0]["DOCTYPE"],
        "SRNO":lstrOldData[0]["SRNO"],
        "BUILDING_CODE":lstrOldData[0]["BUILDING_CODE"],
        "TASK_REMARK":"",
      });
    }


    Get.to(()=> TankFillSubmit(
      header: headerTable,
      det: detailTable,
      schedule: schedule,
      sign: frmSign,
      mode: wstrPageMode, fnCallBack: fnEditCallBack, mainDocno: frmMainDocno,
    ));

  }
  fnClear(){
    if(mounted){
      setState((){
        for(var e in wstrPageForm){
          e["CONTROLLER"].clear();
        }

        frmDocNo = "";
        frmDocDate  = "";
        frmCompanyCode = "";
        frmCompanyName = "";
        frmBuildingCode = "";
        frmBuildingName = "";
        frmBldCustomer = "";
        frmBldCustomerName = "";
        frmBldLoc = "";
        frmCustomerEmail = "";
        frmPlannedQty = 0.0;
        frmCF = 1.0;
        frmTotalAmount = 0.0;
        frmStkCode = "LPG1";
        frmStkCodeName = "";

      });
    }
  }
  fnFill(data,detData,maindata,sign){
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
               e["CONTROLLER"].text = setDate(6, DateTime.parse(detData[e["FILL_CODE"]].toString()));
             }
            }else{
              if(e["MODE"] == "H"){
                e["CONTROLLER"].text = data[e["FILL_CODE"]].toString() == "null"?"":data[e["FILL_CODE"]].toString();
              }else{
                e["CONTROLLER"].text = detData[e["FILL_CODE"]].toString() == "null"?"":detData[e["FILL_CODE"]].toString();
              }

            }
          }
          frmDocNo = data["DOCNO"].toString();
          frmDoctype = data["DOCTYPE"].toString();
          frmDocDate  = setDate(6, DateTime.parse(data["DOCDATE"].toString()) );
          lstrDocdate = DateTime.parse(data["DOCDATE"].toString());
          frmCompanyCode = data["COMPANY"];
          frmCompanyName = "";
          frmBuildingCode = detData["BUILDING_CODE"];
          frmBuildingName = detData["DESCP"];
          frmBldCustomer = detData["CUSTOMER_CODE"];
          frmBldCustomerName = detData["CUSTOMER_NAME"];
          frmBldLoc= detData["FROM_LOC"];
          frmPlannedQty = detData["PLANNED_QTY"]??0.0;
          frmCF = data["UNITCF"];
          frmTotalAmount =data["TOTAL_FILLING_AMT"];
          frmStkCode = data["STKCODE"];
          frmStkCodeName = data["STKDESCP"];


          frmMainDocno = maindata["MAIN_DOCNO"];
          frmSign = sign;

          lstrTimeFromStr = data["START_TIME"];
          lstrTimeToStr = data["END_TIME"];

        });
      }
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

//==================================APICALL
  apiGetAddData(){
      futureForm = apiCall.apiNewFilling(frmCompanyCode, g.wstrUserCd, frmBuildingCode, txtItemCode.text);
      futureForm.then((value) => apiGetAddDataRes(value));
  }
  apiGetAddDataRes(value){
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          var table1 = value["Table1"];
          if(g.fnValCheck(table1)){
              txtDriverCode.text  = table1[0]["DEL_MAN_CODE"]??"";
              txtDriverName.text  = table1[0]["NAME"]??"";
              txtVehicleNo.text  = table1[0]["VEHICLE_NO"]??"";
          }
          var table2 = value["Table2"];
          if(g.fnValCheck(table2)){
            txtBldCustomer.text =  table2[0]["SLCODE"]??"";
            txtBldCustomerName.text =  table2[0]["SLDESCP"]??"";
            frmBldLoc = table2[0]["LOC"]??"";
            frmCustomerEmail = table2[0]["EMAIL"]??"";
          }
          var table3 = value["Table3"];
          if(g.fnValCheck(table3)){
            dprint(table3);
            txtItemName.text  =  table3[0]["STKDESCP"]??"";
            txtItemUnit1.text  =  table3[0]["UNIT"]??"";
            txtItemUnit2.text  =  table3[0]["UNIT2"]??"";
            txtItemRate1.text  =  table3[0]["RATEFC"].toString();
            txtItemRate2.text  =  table3[0]["RATEFC2"].toString();
            frmCF  =  g.mfnDbl(table3[0]["CF"]);
          }
          var table4 = value["Table4"];
          if(g.fnValCheck(table4)){
            CALL_PDN_FROM_STOCKTXNDET = table4[0]["CALL_PDN_FROM_STOCKTXNDET"]??"N";
          }
        }

      });

      fnCalc("Q");
      apiGetTrip();
    }
  }
  apiGetStock(code){
    futureForm = apiCall.apiNewFilling(frmCompanyCode, g.wstrUserCd, frmBuildingCode, code);
    futureForm.then((value) => apiGetStockRes(value));
  }
  apiGetStockRes(value){
    if(mounted){
      setState(() {
        if(g.fnValCheck(value)){
          var table3 = value["Table3"];
          if(g.fnValCheck(table3)){
            dprint(table3);
            var saleUnit  = table3[0]["SALEUNIT"]??"";
            txtItemName.text  =  table3[0]["STKDESCP"]??"";
            txtItemUnit1.text  =  table3[0]["UNIT"]??"";
            txtItemUnit2.text  =  table3[0]["UNIT2"]??"";
            txtItemRate1.text  =  table3[0]["RATEFC"].toString();
            txtItemRate2.text  =  table3[0]["RATEFC2"].toString();
            frmCF  =  g.mfnDbl(table3[0]["CF"]);
          }
        }
      });
      fnCalc("Q");
    }
  }

  apiView(docno,mode){
    futureForm =apiCall.apiViewTankFilling(g.wstrCompany, docno, "GF", mode);
    futureForm.then((value) => apiViewRes(value));
  }
  apiViewRes(value){
    if(mounted){
      if(g.fnValCheck(value)){
        dprint(value["Table4"]);
        fnFill(value["Table1"][0], value["Table2"][0],value["Table0"][0],value["Table4"]);
      }
    }
  }

  apiGetTrip(){
    var users =  [{"COL_KEY":g.wstrUserCd}];
    futureForm = apiCall.apiGetTrip(g.wstrCompany, g.wstrYearcode, users, [], "1");
    futureForm.then((value) => apiGetTripRes(value));

  }
  apiGetTripRes(value){
    if(mounted){
      setState(() {
        lstrTripData = [];
        if(g.fnValCheck(value)){
          txtDriverCode.text  = value[0]["DRIVER_CODE"]??txtDriverCode.text;
          txtDriverName.text  = value[0]["DRIVER_DESCP"]??txtDriverName.text;
          txtVehicleNo.text  = value[0]["VEHICLE_CODE"]??txtVehicleNo.text;

          txtSupplierPdnNo.text  = value[0]["PDN"]??"";
          txtSupplierCode.text  = value[0]["SLCODE"]??"";
          txtSupplierName.text  = value[0]["SLDESCP"]??"";

          txtHelp1.text  = value[0]["HELP1_CODE"]??"";
          txtHelp1Name.text  = value[0]["HELP1_DESCP"]??"";
          txtHelp2.text  = value[0]["HELP2_CODE"]??"";
          txtHelp2Name.text  = value[0]["HELP2_DESCP"]??"";

          txtTripNo.text  = value[0]["TRIP_CODE"]??"";
          frmStartKm = value[0]["KM_START"]??"";
        }
      });
    }
    //apiGetPdnFromYn();
  }


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

    futureForm =  apiCall.apiLookupSearch("GASDOCMASTER", columnListTemp, 0, 10000, filterVal,frmCompanyCode);
    futureForm.then((value) =>  apiGetPdnFromYnRes(value));
  }
  apiGetPdnFromYnRes(value){
    if(mounted){
      setState((){
        if(g.fnValCheck(value)){
          CALL_PDN_FROM_STOCKTXNDET = value[0]["CALL_PDN_FROM_STOCKTXNDET"];
        }
      });
    }
  }

}

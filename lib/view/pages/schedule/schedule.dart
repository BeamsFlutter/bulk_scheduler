
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/model/company.dart';
import 'package:scheduler/view/components/Log/bbm_log.dart';
import 'package:scheduler/view/components/alertDialog/alertDialog.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/components/lookup/lookup.dart';
import 'package:scheduler/view/components/lookup/lookupSch.dart';
import 'package:scheduler/view/history/builidng_history.dart';
import 'package:scheduler/view/styles/colors.dart';

class Schedule extends StatefulWidget {
  final Function fnCallBack;
  const Schedule({Key? key, required this.fnCallBack}) : super(key: key);

  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {

  //Global
  var g = Global();
  var apiCall = ApiCall();
  late Future<dynamic> futureForm;

  //Page variable
  var wstrPageMode = "VIEW";
  var wstrDoctype = "SCH";
  final _formKey = GlobalKey<FormState>();

  var wstrPageForm  = [];
  var wstrPageData  = [];
  var wstrPageLookup = [];
  var lstrSearchResult = [];
  var buildingGrid = [];
  var lstrBuildingHistory = [];
  List<Company> companyList = [];
  var lstrCompanyList  = [];
  var lstrDateFrom ;

  var lstrSelectedCompany = '';
  var lstrCompanyName = '';
  var lstrAreaName = '';
  var lstrBuildingName = '';
  var lstrUserName = '';

  var lstrBuildingCompany = "";
  var lstrBuildingArea  = "";
  var lstrAreaCompany  = "";

  //Controller
  var txtSearch = TextEditingController();
  var txtCode  = TextEditingController();
  var txtDocDate  = TextEditingController();
  var txtScheduleDate  = TextEditingController();
  var txtUser  = TextEditingController();

  var txtCompany = TextEditingController();
  var txtBuilding = TextEditingController();
  var txtArea = TextEditingController();
  var txtQty = TextEditingController();
  var txtSubmit = TextEditingController();

  var pnCode  =  FocusNode();
  var pnDocDate  =  FocusNode();
  var pnScheduleDate  =  FocusNode();
  var pnUser  =  FocusNode();

  var pnCompany  =  FocusNode();
  var pnBuilding  =  FocusNode();
  var pnArea  =  FocusNode();
  var pnQty  =  FocusNode();
  var pnSubmit  =  FocusNode();

  late Size size;


  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.all(20),
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
                        widget.fnCallBack();
                      },
                      child: Container(
                        decoration: boxBaseDecoration(greyLight, 10),
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back_outlined,color: txtColor,size: g.wstrIconSize,),
                      ),
                    ),
                    gapWC(10),
                    th('Schedule',txtColor,g.wstrHeadFont)
                  ],
                ),
                lineS(),
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: boxBaseDecoration(greyLight, 5),
                  child: TextFormField(
                    controller: txtSearch,
                    enabled: wstrPageMode == "VIEW"?true:false,
                    decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        suffixIcon:  Icon(Icons.search,color: bgColorDark)
                    ),
                    onChanged: (value){
                      apiSearchSchedule();
                    },
                  ),
                ),
                gapHC(10),
                Expanded(child: SingleChildScrollView(
                  child: Column(
                    children: getPageData(),
                  ),
                ))
              ],
            ),
          ),
          gapWC(15),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: boxBaseDecoration(white, 15),
              child: Column(
                children: [
                  Row(),
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: boxBaseDecoration(blueLight, 5),
                    child: Row(
                      children: [
                        Expanded(child: masterMenu(fnMenu,wstrPageMode) )
                      ],
                    ),
                  ),
                  gapHC(10),
                  Expanded(child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FormInput(
                              txtController:txtCode,
                              hintText: "Schedule #",
                              focusNode: pnCode,
                              txtWidth: 0.15,
                              enablests: false,
                              emptySts: false,
                              onChanged: (value){
                                setState((){
                                });
                              },
                              validate: true,
                            ),
                            gapWC(5),
                            FormInput(
                              txtController:txtDocDate,
                              hintText: "Create Date",
                              focusNode: pnDocDate,
                              txtWidth: 0.15,
                              enablests: false,
                              emptySts: false,
                              onChanged: (value){
                                setState((){
                                });
                              },
                              validate: true,
                            ),

                          ],
                        ),
                        gapHC(10),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: (){
                                if(wstrPageMode == "VIEW"){
                                  return;
                                }
                                _selectFromDate(context);
                              },
                              child: FormInput(
                                txtController:txtScheduleDate,
                                hintText: "Schedule Date",
                                focusNode: pnScheduleDate,
                                txtWidth: 0.15,
                                focusSts:pnScheduleDate.hasFocus?true:false,
                                enablests:  false,
                                emptySts: txtScheduleDate.text.isEmpty?false:true,
                                onClear: (){
                                  setState((){
                                    txtScheduleDate.clear();
                                  });
                                },
                                onChanged: (value){
                                  setState((){
                                  });
                                },
                                validate: true,
                              ),
                            ),
                            gapWC(5),
                            GestureDetector(
                              onTap: (){
                                if(wstrPageMode != "VIEW"){
                                  //fnLookup("BBM_TERMS");
                                }
                              },
                              child:  FormInput(
                                txtController:txtUser,
                                hintText: "Assign to",
                                focusNode: pnUser,
                                txtWidth: 0.15,
                                focusSts:pnUser.hasFocus?true:false,
                                enablests: wstrPageMode == "VIEW"? false:true,
                                emptySts: txtUser.text.isEmpty?false:true,
                                suffixIcon: Icons.search,
                                suffixIconOnclick: (){
                                  fnLookup("USER");
                                },
                                onClear: (){
                                  setState((){
                                    txtUser.clear();
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
                            )
                          ],
                        ),
                        subHead('Building Details'),
                        wstrPageMode != "VIEW"?
                        Container(
                          decoration: boxBaseDecoration(greyLight, 10),
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              if(wstrPageMode != "VIEW"){
                                              }
                                            },
                                            child:  FormInput(
                                              txtController:txtCompany,
                                              hintText: "Company",
                                              txtWidth: 0.12,
                                              focusNode: pnCompany,
                                              focusSts:pnCompany.hasFocus?true:false,
                                              enablests: wstrPageMode == "VIEW"? false:true,
                                              emptySts: txtCompany.text.isEmpty?false:true,
                                              suffixIcon: Icons.search,
                                              suffixIconOnclick: (){
                                                fnLookup("COMPANY");
                                              },
                                              onClear: (){
                                                setState((){
                                                  txtCompany.clear();
                                                });
                                              },
                                              onChanged: (value){
                                                //fnLookup("COMPANY");
                                              },
                                              onSubmit: (value){
                                                pnArea.requestFocus();
                                              },
                                              validate: true,
                                            ),
                                          ),
                                          th(lstrCompanyName, txtSubColor, g.wstrSubFont)
                                        ],
                                      ),
                                      // Container(
                                      //   width: 200,
                                      //   height: 35,
                                      //   decoration: boxOutlineInput(true, false),
                                      //   child: Autocomplete<Company>(
                                      //     displayStringForOption: _displayStringForOption,
                                      //     optionsBuilder: (TextEditingValue textEditingValue) {
                                      //       if (textEditingValue.text == '') {
                                      //         return const Iterable<Company>.empty();
                                      //       }
                                      //       return companyList.where((Company option) {
                                      //         return option
                                      //             .toString()
                                      //             .contains(textEditingValue.text.toLowerCase());
                                      //       });
                                      //     },
                                      //
                                      //     onSelected: (Company selection) {
                                      //       debugPrint('You just selected ${_displayStringForOption(selection)}');
                                      //     },
                                      //
                                      //
                                      //
                                      //
                                      //   ),
                                      // ),
                                      gapWC(5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              if(wstrPageMode != "VIEW"){
                                                //fnLookup("BBM_TERMS");
                                              }
                                            },
                                            child:  FormInput(
                                              txtController:txtArea,
                                              hintText: "Area",
                                              txtWidth: 0.12,
                                              focusNode: pnArea,
                                              focusSts:pnArea.hasFocus?true:false,
                                              enablests: wstrPageMode == "VIEW"? false:true,
                                              emptySts: txtArea.text.isEmpty?false:true,
                                              suffixIcon: Icons.search,
                                              suffixIconOnclick: (){
                                                fnLookup("AREA");
                                              },
                                              onClear: (){
                                                setState((){
                                                  txtArea.clear();
                                                });
                                              },
                                              onChanged: (value){
                                                setState((){
                                                });
                                              },
                                              onSubmit: (value){
                                                pnBuilding.requestFocus();
                                              },
                                              validate: true,
                                            ),
                                          ),
                                          th(lstrAreaName, txtSubColor, g.wstrSubFont)
                                        ],
                                      ),

                                      gapWC(5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              if(wstrPageMode != "VIEW"){
                                                //fnLookup("BUILDING");
                                              }
                                            },
                                            child:  FormInput(
                                              txtController:txtBuilding,
                                              hintText: "Building#",
                                              txtWidth: 0.12,
                                              focusNode: pnBuilding,
                                              focusSts:pnBuilding.hasFocus?true:false,
                                              enablests: wstrPageMode == "VIEW"? false:true,
                                              emptySts: txtBuilding.text.isEmpty?false:true,
                                              suffixIcon: Icons.search,
                                              suffixIconOnclick: (){
                                                fnLookup("BUILDING");
                                              },
                                              onClear: (){
                                                setState((){
                                                  txtBuilding.clear();
                                                });
                                              },
                                              onChanged: (value){
                                                setState((){
                                                });
                                              },
                                              onSubmit: (value){
                                                pnQty.requestFocus();
                                              },
                                              validate: true,
                                            ),
                                          ),
                                          th(lstrBuildingName, txtSubColor, g.wstrSubFont)
                                        ],
                                      ),
                                      gapWC(5),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: (){
                                              if(wstrPageMode != "VIEW"){
                                                //fnLookup("BBM_TERMS");
                                              }
                                            },
                                            child:  FormInput(
                                              txtController:txtQty,
                                              hintText: "Quantity Plan",
                                              txtWidth: 0.12,
                                              focusNode: pnQty,
                                              textType: TextInputType.number,
                                              txtLength: 10,
                                              focusSts:pnQty.hasFocus?true:false,
                                              enablests: wstrPageMode == "VIEW"? false:true,
                                              emptySts: txtQty.text.isEmpty?false:true,
                                              onClear: (){
                                                setState((){
                                                  txtQty.clear();
                                                });
                                              },
                                              onChanged: (value){
                                                setState((){
                                                });
                                              },
                                              onSubmit: (value){
                                                pnCompany.requestFocus();
                                                fnAddToGrid();
                                              },
                                              validate: true,
                                            ),
                                          ),
                                          th(txtQty.text.toString(), txtSubColor, g.wstrSubFont)
                                        ],
                                      ),

                                      gapWC(5),
                                      Visibility(
                                          visible: false,
                                          child: FormInput(
                                            txtController:txtSubmit,
                                            hintText: "SUBMIT",
                                            txtWidth: 0.12,
                                            focusNode: pnSubmit,
                                            focusSts:pnSubmit.hasFocus?true:false,
                                            enablests: wstrPageMode == "VIEW"? false:true,
                                            emptySts:true,
                                            onChanged: (value){
                                              setState((){
                                              });
                                            },
                                            onSubmit: (value){
                                              fnAddToGrid();
                                            },
                                            validate: true,
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                              Bounce(
                                duration: const Duration(milliseconds: 110),
                                onPressed: (){
                                  fnAddToGrid();
                                },
                                child: Container(
                                  decoration: boxDecoration(bgColorDark, 20),
                                  height: 35,
                                  width: 100,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add,color: Colors.white,size: g.wstrSubIconSize,),
                                      gapWC(5),
                                      tcn('Add', white, g.wstrSubFont)
                                    ],
                                  ),
                                ),
                              )

                            ],
                          ),
                        ):gapHC(0),
                        gapHC(10),
                        Expanded(child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: boxBaseDecoration(blueLight, 10),
                          child: SingleChildScrollView(
                            child: animColumn(gridList(),),
                          ),
                        )),


                      ],
                    ),
                  )),
                  wstrPageMode == "ADD" || wstrPageMode=="EDIT"?
                  Container(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Bounce(
                          onPressed: (){
                            fnCancel();
                          },
                          duration: const Duration(milliseconds: 110),
                          child: closeButton(),
                        ),
                        gapWC(10),
                        Bounce(
                          onPressed: (){
                            fnSave();
                          },
                          duration: const Duration(milliseconds: 110),
                          child: saveButton(),
                        ),

                      ],
                    ),
                  ):gapHC(0)

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
//==================================WIDGET
  Widget wGridCard(icon,title,mode){
    return Row(
      children: [
        Icon(icon,color: subColor,size: g.wstrSubIconSize,),
        gapWC(5),
        tcn(mode, txtSubColor, g.wstrSubFont),
        gapWC(5),
        th(title, txtSubColor, g.wstrSubFont)
      ],
    );
  }
  Widget wGridCardEt(icon,title,mode){
    return Row(
      children: [
        Icon(icon,color: subColor,size: g.wstrSubIconSize,),
        gapWC(5),
        tcn(mode, txtSubColor, g.wstrSubFont),
        gapWC(5),
        const FormInput(
          txtWidth: 0.06,
          labelYn: 'N',
          hintText: 'QTY',
          textType: TextInputType.number,
        )
      ],
    );
  }
  List<Widget> getPageData(){
    List<Widget> rtnWidget = [];
    var srno  = 0;
    for(var e in wstrPageData){

      var schDate  =  setDate(6, DateTime.parse(e["SCH_DATE"].toString()));
      var docDate  =  setDate(6, DateTime.parse(e["DOCDATE"].toString()));
      var assignUser  =  e["ASSIGNED_USERCD"].toString();
      rtnWidget.add(Bounce(
        duration: const Duration(milliseconds: 110),
        onPressed: (){
            if(wstrPageMode == "VIEW"){
              apiViewSchedule(e["DOCNO"].toString(), "");
            }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          decoration: boxBaseDecoration(bgColorDark, 10),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(),
              th(e["DOCNO"].toString(), white, g.wstrSubFont),
              Row(
                children: [
                  Icon(Icons.schedule,color: Colors.white,size: g.wstrSubIconSize,),
                  gapWC(5),
                  tcn('SCHEDULE DATE : $schDate', white, g.wstrSubFont)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.event,color: Colors.white,size: g.wstrSubIconSize,),
                  gapWC(5),
                  tcn('CREATE DATE : $docDate', white, g.wstrSubFont)
                ],
              ),
              Row(
                children: [
                  Icon(Icons.person,color: Colors.white,size: g.wstrSubIconSize,),
                  gapWC(5),
                  tcn('ASSIGN TO : $assignUser ', white, g.wstrSubFont)
                ],
              )
            ],
          ),
        ),
      ));
      srno = srno+1;
    }
    return rtnWidget;
  }
  List<Widget> gridList(){
    List<Widget> rtnWidget = [];
    var srno  = 0;
    for(var e in buildingGrid){
      rtnWidget.add(Container(
          decoration: boxDecoration(white, 5),
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              th((srno+1).toString(),txtColor,g.wstrHeadFont),
              gapWC(15),
              Expanded(child: GestureDetector(
                onDoubleTap: (){
                  if(wstrPageMode == "VIEW"){
                    return;
                  }

                  if(mounted){
                    setState(() {
                      txtCompany.text =  e["COMPANY"]??"";
                      lstrCompanyName = e["COMPANY_DESCP"]??"";
                      txtBuilding.text =  e["BUILDING_CODE"]??"";
                      lstrBuildingName =  e["BUILDING_DESCP"]??"";
                      txtArea.text =  e["BUILDING_AREA_CODE"]??"";
                      lstrAreaName = e["BUILDING_AREA_DESCP"]??"";
                      txtQty.text =  g.mfnDbl(e["QTY"]).toString()??"";
                      lstrBuildingCompany =  e["COMPANY"]??"";
                      pnCompany.requestFocus();
                    });
                  }
                  fnRemoveFromGrid(e);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    wGridCard(Icons.account_balance,"${e["COMPANY"].toString()} | ${e["COMPANY_DESCP"].toString()}","COMPANY"),
                    wGridCard(Icons.apartment,"${e["BUILDING_CODE"].toString()} | ${e["BUILDING_DESCP"].toString()}","BUILDING"),
                    e["BUILDING_AREA_CODE"] == ""?gapHC(0):
                    wGridCard(Icons.place_outlined,"${e["BUILDING_AREA_CODE"].toString()} | ${e["BUILDING_AREA_DESCP"].toString()}","AREA"),

                    wGridCard(Icons.confirmation_number_outlined,e["QTY"].toString(),"QTY"),
                    wstrPageMode !="VIEW"?
                    Row(
                      children: [
                        Icon(Icons.confirmation_number_outlined,color: subColor,size: g.wstrSubIconSize,),
                        gapWC(5),
                        tcn("QTY", txtSubColor, g.wstrSubFont),
                        gapWC(5),
                        FormInput(
                          txtWidth: 0.06,
                          txtLength: 10,
                          labelYn: 'N',
                          hintText: 'QTY',
                          textType: TextInputType.number,
                          onChanged: (val){
                            if(mounted){
                              setState(() {
                                e["QTY"] = g.mfnInt(val).toString();
                              });
                            }
                          },
                        )
                      ],
                    ):gapHC(0),
                    wstrPageMode !="VIEW"?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      ],
                    ):gapHC(0)

                  ],
                ),
              )),
              wstrPageMode != "VIEW"?
              Bounce(
                duration: const Duration(milliseconds: 110),
                onPressed: (){
                  fnBuildingHistory(e["COMPANY"],e["BUILDING_CODE"]);
                },
                child: Container(
                  decoration: boxBaseDecoration(greyLight, 5),
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.access_time_rounded,size: g.wstrIconSize,color: txtSubColor,),
                ),
              ):gapHC(0),
              gapWC(10),
              wstrPageMode != "VIEW"?
              Bounce(
                duration: const Duration(milliseconds: 110),
                onPressed: (){
                  fnRemoveFromGrid(e);
                },
                child: Container(
                  decoration: boxBaseDecoration(greyLight, 5),
                  padding: const EdgeInsets.all(10),
                  child: Icon(Icons.delete_sweep_outlined,size: g.wstrIconSize,color: subColor

                    ,),
                ),
              ):gapHC(0),

            ],
          )
      ));
      srno = srno+1;
    }
    if(rtnWidget.isEmpty){
      rtnWidget.add(Container());
    }
    return rtnWidget;
  }
  Widget wBuildingHistory(){
    return SizedBox(
      height: size.height*0.4,
      child: Column(
        children: [

        ],
      ),
    );
  }

//==================================MENU
  fnMenu(mode){
    switch(mode) {
      case "ADD": {
        fnAdd();
      }
      break;
      case "SAVE": {
        fnSave();
      }
      break;
      case "EDIT": {
        fnEdit();
      }
      break;
      case "DELETE": {
        fnDelete();
      }
      break;
      case "FIRST": {
        fnView("","FIRST");
      }
      break;
      case "NEXT": {
        fnView(txtCode.text,"NEXT");
      }
      break;
      case "LAST": {
        fnView("","LAST");
      }
      break;
      case "BACK": {
        fnView(txtCode.text,"PREVIOUS");
      }
      break;
      case "ATTACH": {
        fnAttachment();
      }
      break;
      case "LOG": {
        fnLog();
      }
      break;
      case "HELP": {

      }
      break;
      case "CLOSE": {
        fnCancel();
      }
      break;
      default: {
        //statements;
      }
      break;
    }
  }
  fnAdd(){
    fnClear();
    setState((){
      wstrPageMode = "ADD";
      txtDocDate.text = setDate(6, DateTime.now());
      txtScheduleDate.text = setDate(6, DateTime.now());
    });
    pnCode.requestFocus();
  }
  fnEdit(){
    setState((){
      wstrPageMode = "EDIT";
    });
  }
  fnCancel(){
    fnClear();
    setState((){
      wstrPageMode = "VIEW";
    });
    apiViewSchedule("", "LAST");
  }
  fnView(code,mode){
    if(wstrPageMode == "VIEW"){
      apiViewSchedule(code, mode);
    }
  }
  fnSave(){
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

    if(!g.fnValCheck(buildingGrid)){
      errorMsg(context, "Please Select Building");
      return;
    }

    var scheduleDet  =  [];
    var srno  = 1;
    var schDate  =  setDate(2, lstrDateFrom);
    for(var e in buildingGrid){
      //{MAIN_COMPANY,SRNO,SCH_DATE,ASSIGNED_USER_COMPANY,ASSIGNED_USER_COMPANYDESCP,ASSIGNED_USERCD,COMPANY,COMPANY_DESCP,BUILDING_CODE,BUILDING_DESCP,'TASK_DESCP','TASK_REMARK','BUILDING_AREA_CODE','BUILDING_AREA_DESCP','QTY'}
      scheduleDet.add({
        "MAIN_COMPANY":g.wstrCompany,
        "SRNO":srno,
        "DOCNO":txtCode.text,
        "DOCTYPE":wstrDoctype,
        "SCH_DATE":schDate,
        "ASSIGNED_USERCD":txtUser.text,
        "ASSIGNED_USERDESCP":lstrUserName,
        "COMPANY":e["COMPANY"],
        "COMPANY_DESCP":e["COMPANY_DESCP"],
        "BUILDING_CODE":e["BUILDING_CODE"],
        "BUILDING_DESCP":e["BUILDING_DESCP"],
        "BUILDING_AREA_CODE":e["BUILDING_AREA_CODE"],
        "BUILDING_AREA_DESCP":e["BUILDING_AREA_DESCP"],
        "QTY":e["QTY"],
      });
      srno =srno+1;
    }

    if(wstrPageMode == "ADD"){
      apiSave(schDate, scheduleDet);
    }else  if(wstrPageMode == "EDIT"){
      apiEdit(schDate, scheduleDet);
    }

  }
  fnDelete(){
    if(wstrPageMode != "VIEW"){
      return;
    }
   if(txtCode.text.isEmpty){
     infoMsg(context, "Select Document");
     return;
   }
   PageDialog().deleteDialog(context, apiDeleteSchedule);
  }
  fnAttachment(){

  }
  fnAttachmentCallBack(code){

  }
  fnLog(){
    PageDialog().showNote(context, BbmLog(docno: txtCode.text ,doctype:wstrDoctype), "Log");
  }

  //==================================LOOKUP

  fnLookup(mode){
    if(wstrPageMode == "VIEW"){
      return;
    }
    if (mode == "COMPANY") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY_CODE', 'Display': '#'},
        {'Column': 'COMPANY_DESCP', 'Display': 'Name'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'COMPANY_CODE',
          'contextField': txtCompany,
          'context': 'window'
        },
        {
          'sourceColumn': 'COMPANY_DESCP',
          'contextField': lstrCompanyName,
          'context': 'variable'
        },
      ];
      PageDialog().showNote(context, Lookup(
        txtControl: txtCompany,
        oldValue: txtCompany.text,
        lstrTable: 'BS_DBMAST',
        title: 'Company',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'COMPANY_CODE',
        mode: "S",
        layoutName: "B",
        callback: fnLookupCompanyCallBack,
      ), "Company");
    }
    else  if (mode == "BUILDING") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'BUILDING_CODE', 'Display': 'Building'},
        {'Column': 'DESCP', 'Display': 'Name'},
        // {'Column': 'AREA', 'Display': 'Area'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'BUILDING_CODE',
          'contextField': txtBuilding,
          'context': 'window'
        },
        {
          'sourceColumn': 'DESCP',
          'contextField': lstrBuildingName,
          'context': 'variable'
        },
      ];
      var lstrFilter = [];
      if(txtArea.text.isNotEmpty){
        lstrFilter =[{'Column': "AREA", 'Operator': '=', 'Value': txtArea.text, 'JoinType': 'AND'}];
      }

      PageDialog().showNote(context, LookupSch(
        txtControl: txtBuilding,
        oldValue: txtBuilding.text,
        lstrTable: 'GBUILDINGMASTER',
        title: 'Building',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: lstrFilter,
        keyColumn: 'BUILDING_CODE',
        mode: "S",
        layoutName: "B",
        callback: fnLookupBuildingCallBack,
        company: txtCompany.text,
      ), "Building");
    }
    else  if (mode == "AREA") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'CODE', 'Display': 'Area'},
        {'Column': 'DESCP', 'Display': 'Description'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'CODE',
          'contextField': txtArea,
          'context': 'window'
        },
        {
          'sourceColumn': 'DESCP',
          'contextField': lstrAreaName,
          'context': 'variable'
        },
      ];
      PageDialog().showNote(context, LookupSch(
        txtControl: txtArea,
        oldValue: txtArea.text,
        lstrTable: 'AREAMASTER',
        title: 'Area',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'CODE',
        mode: "S",
        layoutName: "B",
        callback: fnLookupAreaCallBack,
        company: txtCompany.text,
      ), "Area");
    }
    else  if (mode == "USER") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'USER_CD', 'Display': 'Code'},
        {'Column': 'USER_NAME', 'Display': 'Name'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'USER_CD',
          'contextField': txtUser,
          'context': 'window'
        },
        {
          'sourceColumn': 'USER_NAME',
          'contextField': lstrUserName,
          'context': 'variable'
        },
      ];
      PageDialog().showNote(context, LookupSch(
        txtControl: txtUser,
        oldValue: txtUser.text,
        lstrTable: 'ONLINE_USERMAST',
        title: 'User',
        lstrColumnList: lookup_Columns,
        lstrFilldata: lookup_Filldata,
        lstrPage: '0',
        lstrPageSize: '100',
        lstrFilter: [],
        keyColumn: 'USER_CD',
        mode: "S",
        layoutName: "B",
        callback: fnLookupUserCallBack,
        company: lstrSelectedCompany,
      ), "User");
    }
  }
  fnLookupCallBack(value){

  }
  fnLookupAreaCallBack(value){
    if(mounted){
      setState(() {
        lstrBuildingName = "";
        lstrAreaName = "";
        txtBuilding.clear();
        if(g.fnValCheck(value)){
          lstrAreaName =  value["DESCP"];
        }
      });

    }
  }
  fnLookupBuildingCallBack(value){
    if(mounted){
      setState(() {
        lstrBuildingName = "";
        lstrBuildingCompany = "";
        lstrBuildingArea = "";
        if(g.fnValCheck(value)){
          lstrBuildingName =  value["DESCP"]??"";
          lstrBuildingCompany = value["COMPANY"]??"";
          lstrBuildingArea = value["AREA"]??"";
          if(lstrBuildingCompany != txtCompany.text){
            lstrBuildingName =  '';
            lstrBuildingCompany = '';
            lstrBuildingArea = '';
            txtBuilding.clear();
          }
        }
      }
      );

    }
  }
  fnLookupCompanyCallBack(value){
    if(mounted){
      setState(() {
        lstrCompanyName = "";
        lstrBuildingName = "";
        lstrAreaName = "";
        txtArea.clear();
        txtBuilding.clear();
        if(g.fnValCheck(value)){
          lstrCompanyName =  value["COMPANY_DESCP"]??"";
        }
      });

    }
  }
  fnLookupUserCallBack(value){
    if(mounted){
      setState(() {
         lstrUserName= "";
        if(g.fnValCheck(value)){
          lstrUserName =  value["USER_NAME"]??"";
        }
      });

    }
  }
  fnLookupFocus(){
    for(var e in wstrPageLookup){
      try{
        e["PAGE_NODE"].addListener(() {
          if(!e["PAGE_NODE"].hasFocus && e["CONTROLLER"].text.isNotEmpty && wstrPageMode != "VIEW"){
            if(e["KEY"] == "USER_CD"){
              e["COMPANY"] = lstrSelectedCompany;
            }else{
              e["COMPANY"] = txtCompany.text;
            }
            g.mfnApiValidate(e,fnLookupValidate);
          }else if(!e["PAGE_NODE"].hasFocus && e["CONTROLLER"].text.isEmpty && wstrPageMode != "VIEW"){
            //Clear fill data
            setState(() {
              if(e["MODE"] == "COMPANY"){
                lstrCompanyName =  "";
                lstrAreaName =  "";
                lstrBuildingName =  "";

                txtBuilding.clear();
                txtCompany.clear();
                txtArea.clear();

              }else if(e["MODE"] == "AREA"){
                lstrAreaName =  "";
              }else if(e["MODE"] == "BUILDING"){
                lstrBuildingName =  "";
              }else if(e["MODE"] == "USER"){
                lstrUserName = "";
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
        if(e["MODE"] == "COMPANY"){
          lstrCompanyName =  value[0]["COMPANY_DESCP"]??"";
          if(txtCompany.text != lstrBuildingCompany){
            lstrBuildingName =  "";
            txtBuilding.clear();
            txtArea.clear();
            lstrAreaName = '';
          }

        }else if(e["MODE"] == "AREA"){
          lstrAreaName =  value[0]["DESCP"]??"";
          lstrAreaCompany =  value[0]["COMPANY"]??"";
          if(txtArea.text != lstrBuildingArea){
            lstrBuildingName =  "";
            txtBuilding.clear();
          }
        }else if(e["MODE"] == "BUILDING"){
          lstrBuildingName =  value[0]["DESCP"]??"";
          lstrBuildingCompany =  value[0]["COMPANY"]??"";
          lstrBuildingArea =  value[0]["AREA"]??"";
          if(lstrBuildingCompany != txtCompany.text){
            lstrBuildingName =  '';
            lstrBuildingCompany = '';
            lstrBuildingArea = '';
            txtBuilding.clear();

          }
          if((lstrBuildingArea != txtArea.text) && txtArea.text.isNotEmpty){
            lstrBuildingName =  '';
            lstrBuildingCompany = '';
            lstrBuildingArea = '';
            txtBuilding.clear();

          }

        }else if(e["MODE"] == "USER"){
          fnLookupUserCallBack(value[0]);
        }
      });

    }
  }

//==================================PAGE_FN

  fnFill(data){
    fnClear();
    if(data != null){
      if(mounted){
        setState((){
          wstrPageMode = "VIEW";
          for(var e in wstrPageForm){
            if(e["TYPE"] == "D"){
              e["CONTROLLER"].text = setDate(6, DateTime.parse(data[e["FILL_CODE"]].toString()));
            }else{
              e["CONTROLLER"].text = data[e["FILL_CODE"]].toString() == "null"?"":data[e["FILL_CODE"]].toString();
            }
          }

          buildingGrid =  data["DET"]??[];
          lstrDateFrom =  DateTime.parse(data["SCH_DATE"].toString());

        });
      }
    }
    apiSearchSchedule();
  }
  fnGetPageData(){
    if(mounted){
      setState(() {
        lstrDateFrom = DateTime.now();

        wstrPageForm = [];
        wstrPageForm.add({"CONTROLLER":txtCode,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please fill CODE.","FILL_CODE":"DOCNO","PAGE_NODE":pnCode});
        wstrPageForm.add({"CONTROLLER":txtDocDate,"TYPE":"D","VALIDATE":false,"ERROR_MSG":"Please select date","FILL_CODE":"DOCDATE","PAGE_NODE":pnDocDate});
        wstrPageForm.add({"CONTROLLER":txtScheduleDate,"TYPE":"D","VALIDATE":true,"ERROR_MSG":"Please select date","FILL_CODE":"SCH_DATE","PAGE_NODE":pnScheduleDate});
        wstrPageForm.add({"CONTROLLER":txtUser,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please select user","FILL_CODE":"ASSIGNED_USERCD","PAGE_NODE":pnUser});
        wstrPageForm.add({"CONTROLLER":txtCompany,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please select user","FILL_CODE":"","PAGE_NODE":pnCompany});
        wstrPageForm.add({"CONTROLLER":txtBuilding,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please select user","FILL_CODE":"","PAGE_NODE":pnBuilding});
        wstrPageForm.add({"CONTROLLER":txtArea,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please select user","FILL_CODE":"","PAGE_NODE":pnArea});
        wstrPageForm.add({"CONTROLLER":txtQty,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please select user","FILL_CODE":"","PAGE_NODE":pnQty});

        wstrPageLookup = [];
        wstrPageLookup.add({"CONTROLLER":txtCompany,"PAGE_NODE":pnCompany,"TABLE":"BS_DBMAST","KEY":"COMPANY_CODE","MODE":"COMPANY","TYPE":""});
        wstrPageLookup.add({"CONTROLLER":txtBuilding,"PAGE_NODE":pnBuilding,"TABLE":"GBUILDINGMASTER","KEY":"BUILDING_CODE","MODE":"BUILDING","TYPE":"SCH","COMPANY":txtCompany.text});
        wstrPageLookup.add({"CONTROLLER":txtArea,"PAGE_NODE":pnArea,"TABLE":"AREAMASTER","KEY":"CODE","MODE":"AREA","TYPE":"SCH","COMPANY":txtCompany.text});
        wstrPageLookup.add({"CONTROLLER":txtUser,"PAGE_NODE":pnUser,"TABLE":"ONLINE_USERMAST","KEY":"USER_CD","MODE":"USER","TYPE":"SCH","COMPANY":lstrSelectedCompany,});

      });

    }
    fnLookupFocus();
    apiGetCompany();
    apiViewSchedule("", "LAST");

  }
  fnClear(){
    if(mounted){
      setState((){
        lstrDateFrom =  DateTime.now();
        for(var e in wstrPageForm){
          e["CONTROLLER"].clear();
        }
        lstrCompanyName = '';
        lstrAreaName = '';
        lstrBuildingName = '';
        buildingGrid = [];
        lstrUserName = '';

        lstrBuildingCompany = "";
        lstrBuildingArea  = "";
        lstrAreaCompany  = "";

      });
    }
  }
  fnAddToGrid(){
    if(wstrPageMode == "VIEW"){
      return;
    }
    if(txtCompany.text.isEmpty ){
      errorMsg(context, 'Select Company!');
      pnCompany.requestFocus();
      return;
    }
    if(txtBuilding.text.isEmpty ){
      errorMsg(context, 'Select Building!');
      pnBuilding.requestFocus();
      return;
    }

    if(mounted){
      setState(() {
        //buildingGrid.where((e) => e["COMPANY"] == txtCompany.text && e["BUILDING"] == txtBuilding.text).isEmpty
        if(buildingGrid.where((e) => e["COMPANY"] == txtCompany.text && e["BUILDING_CODE"] == txtBuilding.text).isEmpty){
          buildingGrid.add({
            "COMPANY":txtCompany.text,
            "COMPANY_DESCP":lstrCompanyName,
            "BUILDING_CODE":txtBuilding.text,
            "BUILDING_DESCP":lstrBuildingName,
            "BUILDING_AREA_CODE":txtArea.text,
            "BUILDING_AREA_DESCP":lstrAreaName,
            "QTY":txtQty.text,
          });
          txtCompany.clear();
          txtBuilding.clear();
          txtArea.clear();
          txtQty.clear();
          lstrCompanyName = '';
          lstrBuildingName = '';
          lstrAreaName = '';
          pnCompany.requestFocus();
        }else{
          warningMsg(context, 'Already selected!!');
          pnCompany.requestFocus();
        }

      });
    }
  }
  fnRemoveFromGrid(e){

    if(wstrPageMode == "VIEW"){
      return;
    }

    if(mounted){
      setState(() {
        buildingGrid.remove(e);
      });
    }
  }
  Future<void> _selectFromDate(BuildContext context) async {
    if(wstrPageMode == "VIEW"){
      return;
    }
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: lstrDateFrom,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (pickedDate != null && pickedDate != lstrDateFrom) {
      setState(() {
        lstrDateFrom = pickedDate;
        txtScheduleDate.text = setDate(6, lstrDateFrom);
      });
    }
  }
  fnBuildingHistory(company,buildingCode){
    PageDialog().showNote(context, BuildingHistory(company: company,buildingCode: buildingCode, docno: '',), "Schedule History");

  }
//=================================APICALL

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
        lstrSelectedCompany = value[0]["COMPANY_CODE"];
      }
      for(var e in lstrCompanyList){
        companyList.add(Company(e["ID"].toString(), e["COMPANY_CODE"].toString(), e["COMPANY_DESCP"].toString()));
      }

    });
   }
  }

  apiSave(schDate,scheduleDet){
    futureForm =  apiCall.apiCreateScheduler(g.wstrCompany, schDate, txtUser.text,lstrUserName, scheduleDet);
    futureForm.then((value) => apiSaveRes(value));
  }
  apiSaveRes(value){
    dprint(value);
    if(g.fnValCheck(value)){
      var sts =  value[0]["STATUS"];
      var msg =  value[0]["MSG"];
      if(sts  == "1"){
        //call fill api with code;
        successMsg(context, "Saved");
        apiViewSchedule("", "LAST");
      }else{
        errorMsg(context, msg);
      }
    }else{
      errorMsg(context, "Please try again!");
    }
  }

  apiEdit(schDate,scheduleDet){
    futureForm =  apiCall.apiEditSchedule(g.wstrCompany,txtCode.text,wstrDoctype, schDate, txtUser.text,lstrUserName, scheduleDet);
    futureForm.then((value) => apiEditRes(value));
  }
  apiEditRes(value){
    dprint(value);
    if(g.fnValCheck(value)){
      var sts =  value[0]["STATUS"];
      var msg =  value[0]["MSG"];
      if(sts  == "1"){
        //call fill api with code;
        successMsg(context, "Updated");
        apiViewSchedule(txtCode.text, "");
      }else{
        errorMsg(context, msg);
      }
    }else{
      errorMsg(context, "Please try again!");
    }
  }

  apiViewSchedule(code,mode){
    futureForm =  apiCall.apiViewSchedule(g.wstrCompany,code,wstrDoctype,mode);
    futureForm.then((value) =>  apiViewScheduleRes(value));
  }
  apiViewScheduleRes(value){
    if(g.fnValCheck(value)){
      fnFill(value);
    }
  }

  apiSearchSchedule(){
    futureForm = apiCall.apiSearchSchedule(g.wstrCompany, txtSearch.text);
    futureForm.then((value) => apiSearchScheduleRes(value));
  }
  apiSearchScheduleRes(value){
    dprint(value);
    setState(() {
      wstrPageData = [];
      if(g.fnValCheck(value)){
        wstrPageData = value;
      }
    });

  }

  apiDeleteSchedule(){
    Navigator.pop(context);
    futureForm =  apiCall.apiDeleteSchedule(g.wstrCompany,txtCode.text,wstrDoctype);
    futureForm.then((value) => apiDeleteScheduleRes(value));
  }
  apiDeleteScheduleRes(value){
    if(g.fnValCheck(value)){
      var sts =  value[0]["STATUS"];
      var msg =  value[0]["MSG"];
      if(sts  == "1"){
        //call fill api with code;
        customMsg(context, "Deleted",Icons.delete_sharp);
        apiViewSchedule("", "LAST");
      }else{
        errorMsg(context, msg);
      }
    }else{
      errorMsg(context, "Please try again!");
    }
  }

  apiBuildingHistory(company,buildingCode){
    futureForm = apiCall.apiBuildingHistory(g.wstrCompany, company, buildingCode);
    futureForm.then((value) => apiBuildingHistoryRes(value));
  }
  apiBuildingHistoryRes(value){
    if(mounted){
      setState(() {
        lstrBuildingHistory = [];
        if(g.fnValCheck(value)){
          lstrBuildingHistory = value;
          PageDialog().showNote(context, wBuildingHistory(), "Schedule History");
        }
      });
    }
  }

}


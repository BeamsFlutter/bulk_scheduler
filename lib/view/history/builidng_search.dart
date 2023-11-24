


import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/main.dart';
import 'package:scheduler/view/components/alertDialog/alertDialog.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/components/lookup/lookup.dart';
import 'package:scheduler/view/components/lookup/lookupSch.dart';
import 'package:scheduler/view/styles/colors.dart';

class BuildingHistorySearch extends StatefulWidget {

  const BuildingHistorySearch({Key? key,}) : super(key: key);

  @override
  State<BuildingHistorySearch> createState() => _BuildingHistorySearchState();
}

class _BuildingHistorySearchState extends State<BuildingHistorySearch> {

  //Global
  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureLog;

  //Page variable
  var lstrLog = [];


  var txtCompany = TextEditingController();
  var txtBuilding = TextEditingController();
  var txtArea = TextEditingController();

  var pnCompany  =  FocusNode();
  var pnBuilding  =  FocusNode();
  var pnArea  =  FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.5,
      child: Column(
        children: [
         Row(

           children: [
             Flexible(child: GestureDetector(
               onTap: (){

               },
               child:  FormInput(
                 txtController:txtCompany,
                 hintText: "Company",
                 focusNode: pnCompany,
                 focusSts:pnCompany.hasFocus?true:false,
                 enablests: true,
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
             ),),
             gapWC(10),
             Flexible(child: GestureDetector(
               onTap: (){

               },
               child:  FormInput(
                 txtController:txtArea,
                 hintText: "Area",
                 focusNode: pnArea,
                 focusSts:pnArea.hasFocus?true:false,
                 enablests: true,
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
             ),)

           ],
         ),
          gapHC(5),
          GestureDetector(
            onTap: (){
            },
            child:  FormInput(
              txtController:txtBuilding,
              hintText: "Building#",
              focusNode: pnBuilding,
              focusSts:pnBuilding.hasFocus?true:false,
              enablests: true,
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
              },
              validate: true,
            ),
          ),
          gapHC(10),
          Bounce(
            duration: const Duration(milliseconds: 110),
            onPressed: (){
              apiViewLog();
            },
            child: Container(
              decoration: boxBaseDecoration(greyLight, 5),
              padding: const EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  tcn('SEARCH', bgColorDark, g.wstrSubFont),
                  gapWC(10),
                  Icon(Icons.search,color: bgColorDark,size: g.wstrSubIconSize,)
                ],
              ),
            ),
          ),
          Expanded(child: viewLog())
        ],
      ),
    );
  }

//========================================WIDGET

  Widget viewLog(){
    return lstrLog.isNotEmpty? ScrollConfiguration(behavior: MyCustomScrollBehavior(),
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: lstrLog.length,
            itemBuilder: (context, index) {
              var dataList = lstrLog[index];
              var docno  =  dataList["DOCNO"]??"";
              var user  =  dataList["ASSIGNED_USERCD"]??"";
              var qty  =  g.mfnDbl(dataList["QTY"]).toString();
              var schDate  = dataList["SCH_DATE"] != null? setDate(6, DateTime.parse(dataList["SCH_DATE"].toString())):"";
              var taskDate  = dataList["TASK_DATE"] != null? setDate(6, DateTime.parse(dataList["SCH_DATE"].toString())):"";

              return Bounce(
                onPressed: (){

                },
                duration: const Duration(milliseconds: 110),
                child:  Container(
                    decoration: boxBaseDecoration(blueLight, 0),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 5,top: 5),
                    child:Column(
                      children: [
                        Row(
                          children: [
                            th('#$docno', txtSubColor, g.wstrSubFont),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.access_time_outlined,color: subColor,size: 15,),
                            gapWC(10),
                            Expanded(child:  tcn('SCHEDULE DATE : $schDate', bgColorDark, 12)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.event_available_sharp,color: subColor,size: 15,),
                            gapWC(10),
                            Expanded(child:  tcn('COMPLETED DATE : $taskDate', bgColorDark, 12)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.person,color: subColor,size: 15,),
                            gapWC(10),
                            Expanded(child:  tcn('USER : $user', bgColorDark, 12)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.gas_meter,color: subColor,size: 15,),
                            gapWC(10),
                            Expanded(child:  tcn('QTY : $qty', bgColorDark, 12)),
                          ],
                        ),
                      ],
                    )


                ),
              );
            })):SizedBox(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.access_time_outlined,color: greyLight,size: 50,),
            gapHC(10),
            tcn('No logs', greyLight, 15)
          ],
        ),
      ),
    );
  }

//========================================LOOKUP

  fnLookup(mode){

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
        callback: fnLookupCallBack,
      ), "Company");
    }
    else  if (mode == "BUILDING") {
      final List<Map<String, dynamic>> lookup_Columns = [
        {'Column': 'COMPANY', 'Display': 'Company'},
        {'Column': 'BUILDING_CODE', 'Display': 'Building'},
        {'Column': 'DESCP', 'Display': 'Name'},
      ];
      final List<Map<String, dynamic>> lookup_Filldata = [
        {
          'sourceColumn': 'BUILDING_CODE',
          'contextField': txtBuilding,
          'context': 'window'
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
        callback: fnLookupCallBack,
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
        callback: fnLookupCallBack,
        company: txtCompany.text,
      ), "Area");
    }

  }
  fnLookupCallBack(value){

  }

//========================================PAGFN

//========================================APICALL

  apiViewLog(){
    futureLog = apiCall.apiBuildingHistory(g.wstrCompany,txtCompany.text, txtBuilding.text);
    futureLog.then((value) => apiViewLogRes(value));
  }
  apiViewLogRes(value){
    if(mounted){
      setState((){
        lstrLog = [];
        if(g.fnValCheck(value)){
          lstrLog = value;
        }
      });
    }
  }

}




import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/main.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class BuildingHistory extends StatefulWidget {
  final String docno;
  final String company;
  final String buildingCode;
  const BuildingHistory({Key? key, required this.docno, required this.company, required this.buildingCode}) : super(key: key);

  @override
  State<BuildingHistory> createState() => _BuildingHistoryState();
}

class _BuildingHistoryState extends State<BuildingHistory> {

  //Global
  Global g = Global();
  ApiCall apiCall = ApiCall();
  late Future<dynamic> futureLog;

  //Page variable
  var lstrLog = [];

  @override
  void initState() {
    apiViewLog();
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
          Container(
            decoration: boxBaseDecoration(greyLight, 5),
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                th(widget.buildingCode.toString(), bgColorDark, 15)
              ],
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

//========================================PAGFN

//========================================APICALL

  apiViewLog(){
    futureLog = apiCall.apiBuildingHistory(g.wstrCompany,widget.company, widget.buildingCode);
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

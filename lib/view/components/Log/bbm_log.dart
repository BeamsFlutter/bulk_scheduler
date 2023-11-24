


import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/main.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class BbmLog extends StatefulWidget {
  final String docno;
  final String doctype;
  const BbmLog({Key? key, required this.docno, required this.doctype}) : super(key: key);

  @override
  State<BbmLog> createState() => _BbmLogState();
}

class _BbmLogState extends State<BbmLog> {

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
                th(widget.docno.toString(), bgColorDark, 15)
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
            var user  =  dataList["USERCODE"];
            var action  =  dataList["ACTION"];
            var actionDate  =  setDate(7, DateTime.parse(dataList["ACTIONDATE"].toString()));
            var actionTime  =  dataList["ACTIONTIME"];
            var macName  =  dataList["MACHINENAME"];
            var macIp  =  dataList["IPADDRESS"];

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
                        const Icon(Icons.edit,color: subColor,size: 15,),
                        gapWC(10),
                        Expanded(child:  th(action.toString().toUpperCase(), bgColorDark, 12)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.person_outlined,color: subColor,size: 15,),
                        gapWC(10),
                        Expanded(child:  tcn(user.toString().toUpperCase(), bgColorDark, 12)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time,color: subColor,size: 15,),
                        gapWC(10),
                        Expanded(child:  tcn(actionDate.toString().toUpperCase(), bgColorDark, 12)),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.monitor,color: subColor,size: 15,),
                        gapWC(10),
                        Expanded(child:  tcn(macIp.toString().toUpperCase(), bgColorDark, 12)),
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
    futureLog = apiCall.apiViewLog(widget.docno, widget.doctype);
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

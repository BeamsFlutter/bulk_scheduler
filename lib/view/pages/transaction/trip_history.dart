

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class TripHistory extends StatefulWidget {
  const TripHistory({Key? key}) : super(key: key);

  @override
  State<TripHistory> createState() => _TripHistoryState();
}

class _TripHistoryState extends State<TripHistory> {

  //Global
  var g = Global();
  var apiCall =  ApiCall();
  late Future<dynamic> futureForm;

  //Page Variables
  var lstrTripData = [];

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    apiGetTrip();
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
                        tcn('Trip History', Colors.white, 15),
                        gapWC(0)
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
                child: SingleChildScrollView(
                  child: Column(
                    children: wUserList(),
                  ),
                )
            )),
            gapHC(5),
          ],
        ),
      ),
    );
  }

//=======================================WIDGET
 List<Widget> wUserList (){
   List<Widget> returnList  = [];
   returnList.add(Row());
   for (var e in  lstrTripData){
     var lstrTripDocno  = e["DOCNO"].toString();
     var lstrTripDoctype  = e["DOCTYPE"].toString();
     var lstrTripNo = e["TRIP_CODE"].toString();
     var driverCode = e["DRIVER_CODE"].toString();
     var driverName = e["DRIVER_DESCP"].toString();
     var vehicleCode = e["VEHICLE_CODE"].toString();
     var vehicleName = e["VEHICLE_DESCP"].toString();
     var lstrTripName = e["TRIP_DESCP"].toString();
     var lstrTripStartTime =  setDate(8, DateTime.parse(e["START_TIME"]));
     var lstrTripEndTime =  setDate(8, DateTime.parse(e["END_TIME"]));

     returnList.add(Container(
       decoration: boxBaseDecoration(greyLight, 5),
       padding: const EdgeInsets.all(10),
       margin: const EdgeInsets.only(bottom: 5),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            Row(),
            th("#"+lstrTripDocno.toString(), bgColorDark, 12),
             Row(
               children: [
                 const Icon(Icons.mode_of_travel,color: subColor,size: 10,),
                 gapWC(5),
                 tcn('TRIP  ', Colors.black  , 10),
                 gapWC(5),
                 th("$lstrTripNo | $lstrTripName" , Colors.black  , 10)
               ],
             ),
           Row(
             children: [
               const Icon(Icons.person,color: subColor,size: 10,),
               gapWC(5),
               tcn('DRIVER  ', Colors.black  , 10),
               gapWC(5),
               th("$driverCode | $driverName" , Colors.black  , 10)
             ],
           ),
           Row(
             children: [
               const Icon(Icons.taxi_alert,color: subColor,size: 10,),
               gapWC(5),
               tcn('VEHICLE  ', Colors.black  , 10),
               gapWC(5),
               th("$vehicleCode | $vehicleName" , Colors.black  , 10)
             ],
           ),
            Row(
              children: [
                const Icon(Icons.access_time_outlined,color: subColor,size: 10,),
                gapWC(5),
                tcn('START TIME', Colors.black  , 10),
                gapWC(5),
                th(lstrTripStartTime.toString(), Colors.black  , 10)
              ],
            ),
           Row(
             children: [
               const Icon(Icons.access_time_outlined,color: subColor,size: 10,),
               gapWC(5),
               tcn('END TIME', Colors.black  , 10),
               gapWC(5),
               th(lstrTripEndTime.toString(), Colors.black  , 10)
             ],
           ),
         ],
       ),
     ));
   }
   return returnList;
 }



//=======================================PAGE FN
//=======================================API CALL

  apiGetTrip(){
    var users =  [{"COL_KEY":g.wstrUserCd}];
    futureForm = apiCall.apiGetTrip(g.wstrCompany, g.wstrYearcode, users, [], "");
    futureForm.then((value) => apiGetTripRes(value));

  }
  apiGetTripRes(value){
    if(mounted){
      setState(() {
        lstrTripData = [];
        if(g.fnValCheck(value)){
          lstrTripData = value??[];
        }
      });
    }
  }
}




import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/styles/colors.dart';

class LookupMob extends StatefulWidget {

  final title;
  final mode;
  final source;
  final TextEditingController  txtControl;
  final selectColumns;
  final keyColumn;
  final fillDataTo;
  final String  oldValue;
  final Function  callback;
  final String  layoutName;
  final lstrColumns;
  final lstrTable;
  final lstrPage;
  final lstrPageSize;
  final List<dynamic> ? lstrFilter;
  final List<dynamic>  lstrColumnList;
  final FocusNode ? focusNode;
  final List<dynamic>  lstrFilldata;
  LookupMob({Key ?key, this.title, this.source, required this.txtControl, this.selectColumns, this.keyColumn, this.fillDataTo, required this.oldValue, required this.callback, required this.layoutName, this.lstrColumns, this.lstrTable, this.lstrPage, this.lstrPageSize, this.lstrFilter, required this.lstrColumnList, this.focusNode, required this.lstrFilldata, this.mode}) : super(key: key);




  @override
  _LookupState createState() => _LookupState();
}

class _LookupState extends State<LookupMob> {

  late Future<dynamic> lstrFutureLookup;
  late Future<dynamic> lstrFutureLookupValidate;
  late List<Map<String, dynamic >> lookupFilterVal ;
  var  apiCall = ApiCall();
  var g = Global();

  late Function fnCallback;
  String keyColumn = "";
  String lstrOldvalue = "" ;
  String lstrSearchval = "";
  String lstrLayoutName = "";
  var txSearchControl = TextEditingController();
  var txtControl = TextEditingController();
  var columnList;
  var lstrSelectedDataList;

  late FocusNode focusNode;

  @override
  void dispose() {
    // TODO: implement dispose
    txSearchControl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fnSortColumns();
    fnCallback = widget.callback;
    txtControl = widget.txtControl;
    lstrOldvalue = widget.oldValue;
    lstrSearchval = lstrOldvalue;
    lstrLayoutName  = widget.layoutName;
    txSearchControl.text = lstrOldvalue.toString();
    keyColumn = widget.keyColumn;
    lookupFilterVal = [{'Column': keyColumn, 'Operator': '=', 'Value': lstrSearchval, 'JoinType': 'AND'}];
    fnLookupValidate(widget.lstrTable, lookupFilterVal);

    lstrFutureLookup = apiCall.LookupSearch(widget.lstrTable, columnList, widget.lstrPage, widget.lstrPageSize, widget.lstrFilter);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return  Scaffold(
      body: Container(
        margin: MediaQuery.of(context).padding,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FormInput(
              txtRadius: 5,
              txtWidth: 1,
              autoFocus: true,
              txtController: txSearchControl,
              icon: Icons.search,
              textType: TextInputType.text,
              suffixIcon: Icons.search,
              hintText: "Search...",
              onChanged: (value){
                setState(() {
                  lstrSearchval = value;
                  fnLookupsearch();
                });
              },

            ),
            _createListView(),
            Container(
              margin: const EdgeInsets.only(right: 5, bottom: 0,top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: (){
                      var filter = [{'Column': keyColumn, 'Operator': '=', 'Value': txSearchControl.text, 'JoinType': 'AND'}];
                      fnLookupValidate(widget.lstrTable, filter);
                      Navigator.pop(context);
                    },
                    child: customBButton('Done', subColor, Colors.white, Icons.done_all_rounded),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  Widget _createListView() {
    return Expanded(

        child: FutureBuilder<dynamic>(
        future: lstrFutureLookup,
        builder: (context, snapshot) {
      if (snapshot.hasData) {
        return _Listview(snapshot);
      } else if (snapshot.hasError) {
        return const Text("NO DATA");
      }

      // By default, show a splashscreen spinner.
      return  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const[
           CircularProgressIndicator()
        ],
      );
    },
    )
    );
  }
  //List layout Create here
  Widget _Listview(snapshot){
   if(lstrLayoutName == "B"){
      return ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: snapshot.data.length,
          itemBuilder: (context, index) {
            var datalist;

            datalist = snapshot.data[index];
            return Container(

              margin: const EdgeInsets.all(8),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 0),
                  Flexible(
                      child: GestureDetector(
                          onTap: (){
                            fnCallback(datalist);
                            fnFillData(datalist);
                            //txtControl.text = datalist['$key_column'];
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.only(top: 10,right: 5,left: 10,bottom: 10),
                            decoration: boxBaseDecoration(blueLight, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: fnColumnList(datalist),
                            ),
                          )
                      )
                  ),
                ],
              ),
            );
          });
    }else{
       return const Text('No Layout Found');
    }
  }
  fnColumnList(datalist){
    final children = <Widget>[];
    for ( var i in widget.lstrColumnList){

      children.add( i['Column'] != null && i['Column'] != "" ? datalist[i['Column']] != null ?tcn(i['Display'].toString() +' :  ' + datalist[i['Column']].toString(),bgColorDark,12):tcn(i['Display'].toString() +' :  ',bgColorDark,12) :Text(''));
    }

    return children;
  }
  fnSortColumns(){
    for ( var i in widget.lstrColumnList){
      columnList == null ?  columnList = i['Column'] + "|": columnList += i['Column'] + "|";
    }
    print(columnList);
  }
  fnLookupsearch(){
    var filterVal= [];
    filterVal  = g.mfnJson(widget.lstrFilter)??[];
    for(var e in widget.lstrColumnList){
      filterVal.add({ "Column": e['Column'], "Operator": "LIKE", "Value": lstrSearchval, "JoinType": "OR" });
    }
    lstrFutureLookup = apiCall.LookupSearch(widget.lstrTable, columnList, widget.lstrPage, widget.lstrPageSize, filterVal);
    lstrFutureLookup.then((value) => fnLookupSearchSuccess(value));
  }
  fnLookupSearchSuccess(value){
    setState(() {

    });
  }
  fnLookupValidate(lstrTable,lstrfilter){

    lstrFutureLookupValidate = apiCall.LookupValidate(lstrTable, lstrfilter);
    lstrFutureLookupValidate.then((value) =>
        fnValidate(value)
    );

  }
  fnValidate(value) async{

    if(value.length > 0){

      lstrSelectedDataList =  value[0];
      fnCallback(value[0]);
      fnFillData(value[0]);
       if(widget.mode == "C"){
         Navigator.pop(context);
       }

    }else{
      txtControl.text= "";
      for ( var i in widget.lstrFilldata ){

        if(i['context'] == 'window'){

          i['contextField'].text = "";

        }else if (i['context'] == 'variable'){

          i['contextField'] = "";

        }
      }
    }

  }
  fnFillData(datalist){
    for ( var i in widget.lstrFilldata){

       if(i['context'] == 'window'){

         i['contextField'].text = datalist[i['sourceColumn']]??'';

       }else if (i['context'] == 'variable'){

         i['contextField'] = datalist[i['sourceColumn']]??'';

       }
      // {'sourceColumn': 'USER_CD', 'contextField': txtMobilenoArea, 'context': 'window'}

    }
  }
}


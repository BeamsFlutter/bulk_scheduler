
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/inputField/form_inputfield.dart';
import 'package:scheduler/view/pages/home_page/home.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
  late BuildingDataSource buildingDataSource;

  //Page variable
  var wstrPageMode = "VIEW";
  var wstrPageForm  = [];
  final _formKey = GlobalKey<FormState>();
  var lstrSearchResult = [];
  var buildingGrid = [];

  var lstrDateFrom ;

  //Controller
  var txtSearch = TextEditingController();
  var txtCode  = TextEditingController();
  var txtDocDate  = TextEditingController();
  var txtScheduleDate  = TextEditingController();
  var txtUser  = TextEditingController();

  var pnCode  =  FocusNode();
  var pnDocDate  =  FocusNode();
  var pnScheduleDate  =  FocusNode();
  var pnUser  =  FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    fnGetPageData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 400,
            padding: const EdgeInsets.all(10),
            decoration: boxBaseDecoration(white, 15),
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
                    decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        suffixIcon:  Icon(Icons.search,color: bgColorDark)
                    ),
                    onChanged: (value){
                    },
                  ),
                ),
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
                                  enablests: false,
                                  emptySts: false,
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
                                  txtWidth: 0.15,
                                  enablests:false,
                                  emptySts: txtUser.text.isEmpty?false:true,
                                  onClear: (){
                                    setState((){
                                      txtUser.clear();
                                    });
                                  },
                                  onChanged: (value){
                                    setState((){
                                    });
                                  },
                                  validate: true,
                                ),
                              )
                            ],
                          ),
                          subHead('Building Details'),
                          Expanded(
                            child: SfDataGrid(
                              source: buildingDataSource,
                              allowEditing: true,
                              navigationMode: GridNavigationMode.cell,
                              selectionMode: SelectionMode.single,
                              editingGestureType: EditingGestureType.doubleTap,
                              columns: <GridColumn>[
                                GridColumn(
                                    columnName: 'SRNO',
                                    label: Container(
                                        padding: EdgeInsets.all(16.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'SRNO',
                                        ))),
                                GridColumn(
                                    columnName: 'COMPANY',
                                    label: Container(
                                        padding: EdgeInsets.all(16.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text('COMPANY'))),
                                GridColumn(
                                    columnName: 'BUILDING',
                                    width: 120,
                                    label: Container(
                                        padding: EdgeInsets.all(16.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text('BUILDING'))),
                              ],
                            ),
                          ),

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
    ));
  }
//==================================WIDGET
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
       // fnView(txtCode.text,"NEXT");
      }
      break;
      case "LAST": {
        fnView("","LAST");
      }
      break;
      case "BACK": {
       // fnView(txtCode.text,"PREVIOUS");
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
  }
  fnView(code,mode){
    if(wstrPageMode == "VIEW"){
    }
  }
  fnSave(){
    if(wstrPageMode =="VIEW"){
      return;
    }
  }
  fnDelete(){

  }
  fnAttachment(){

  }
  fnAttachmentCallBack(code){

  }
  fnLog(){

  }

//==================================PAGE_FN

  fnGetPageData(){
    if(mounted){
      setState(() {
        lstrDateFrom = DateTime.now();

        wstrPageForm = [];
        wstrPageForm.add({"CONTROLLER":txtCode,"TYPE":"S","VALIDATE":false,"ERROR_MSG":"Please fill CODE.","FILL_CODE":"DOCNO","PAGE_NODE":pnCode});
        wstrPageForm.add({"CONTROLLER":txtDocDate,"TYPE":"D","VALIDATE":false,"ERROR_MSG":"Please select date","FILL_CODE":"DOCDATE","PAGE_NODE":pnDocDate});
        wstrPageForm.add({"CONTROLLER":txtScheduleDate,"TYPE":"D","VALIDATE":true,"ERROR_MSG":"Please select date","FILL_CODE":"SCH_DATE","PAGE_NODE":pnScheduleDate});
        wstrPageForm.add({"CONTROLLER":txtUser,"TYPE":"S","VALIDATE":true,"ERROR_MSG":"Please select user","FILL_CODE":"ASSIGN_USER","PAGE_NODE":pnUser});
      });
      buildingGrid = [];
      buildingGrid.add({"SRNO":"0","COMPANY":"01","COMPANY_DESCP":"ABUDHABI","AREA":"AREA","BUILDING":"BUILDING","BUILDING_DESCP":"BUILDING_DESCP",});
      buildingGrid.add({"SRNO":"1","COMPANY":"02","COMPANY_DESCP":"DUBAI","AREA":"AREA","BUILDING":"BUILDING","BUILDING_DESCP":"BUILDING_DESCP",});
      buildingGrid.add({"SRNO":"2","COMPANY":"03","COMPANY_DESCP":"ABUDHABI","AREA":"AREA","BUILDING":"BUILDING","BUILDING_DESCP":"BUILDING_DESCP",});
      buildingGrid.add({"SRNO":"3","COMPANY":"04","COMPANY_DESCP":"ABUDHABI","AREA":"AREA","BUILDING":"BUILDING","BUILDING_DESCP":"BUILDING_DESCP",});

      buildingDataSource = BuildingDataSource(buildingGrid: buildingGrid);
    }
  }
  fnClear(){
    if(mounted){
      setState((){
        lstrDateFrom =  DateTime.now();
        for(var e in wstrPageForm){
          e["CONTROLLER"].clear();
        }
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


//==================================APICALL
}


class BuildingDataSource extends DataGridSource {
  BuildingDataSource({required List<dynamic> buildingGrid}) {
    _building = buildingGrid
        .map<DataGridRow>((e) => DataGridRow(cells: [
      DataGridCell<String>(columnName: 'SRNO', value: e["SRNO"]),
      DataGridCell<String>(columnName: 'COMPANY', value: e["COMPANY"]),
      DataGridCell<String>(
          columnName: 'BUILDING', value: e["BUILDING"]),
    ]))
        .toList();
    oldDataBuilding = buildingGrid;
  }

  List<DataGridRow>  _building = [];
  List<dynamic>  oldDataBuilding = [];

  TextEditingController editingController = TextEditingController();
  dynamic newCellValue;
   TextStyle textStyle = TextStyle(
       fontFamily: 'Roboto',
       fontWeight: FontWeight.w400,
       fontSize: 14,
       color: Colors.black87);

  @override
  List<DataGridRow> get rows =>  _building;

  @override
  DataGridRowAdapter? buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((dataGridCell) {
          return Container(
            alignment: (dataGridCell.columnName == 'id' || dataGridCell.columnName == 'salary')
                ? Alignment.centerRight
                : Alignment.centerLeft,
            padding: EdgeInsets.all(16.0),
            child: Text(dataGridCell.value.toString()),
          );
        }).toList());
  }
  @override
  Widget? buildEditWidget(DataGridRow dataGridRow,
      RowColumnIndex rowColumnIndex, GridColumn column, CellSubmit submitCell) {
    // Text going to display on editable widget
    final String displayText = dataGridRow
        .getCells()
        .firstWhereOrNull((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)
        ?.value
        ?.toString() ??
        '';

    // The new cell value must be reset.
    // To avoid committing the [DataGridCell] value that was previously edited
    // into the current non-modified [DataGridCell].
    newCellValue = null;

    return _buildTextFieldWidget(displayText, column, submitCell);
  }
  @override
  void onCellSubmit(DataGridRow dataGridRow, RowColumnIndex rowColumnIndex,
      GridColumn column) {
    final dynamic oldValue = dataGridRow
        .getCells()
        .firstWhereOrNull((DataGridCell dataGridCell) =>
    dataGridCell.columnName == column.columnName)
        ?.value ??
        '';

    final int dataRowIndex = _building.indexOf(dataGridRow);

    if (newCellValue == null || oldValue == newCellValue) {
      return;
    }
    _building[dataRowIndex].getCells()[rowColumnIndex.columnIndex] =
        DataGridCell<String>(columnName: 'SRNO', value: newCellValue);
    oldDataBuilding[dataRowIndex]["SRNO"] = newCellValue.toString();
  }
  Widget _buildTextFieldWidget(
      String displayText, GridColumn column, CellSubmit submitCell) {
    final bool isTextAlignRight = column.columnName == 'Product No' ||
        column.columnName == 'Shipped Date' ||
        column.columnName == 'Price';

    final bool isNumericKeyBoardType =
        column.columnName == 'Product No' || column.columnName == 'Price';

    // Holds regular expression pattern based on the column type.
    final RegExp regExp = _getRegExp(isNumericKeyBoardType, column.columnName);

    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment:
      isTextAlignRight ? Alignment.centerRight : Alignment.centerLeft,
      child: TextField(
        autofocus: true,
        controller: editingController..text = displayText,
        textAlign: isTextAlignRight ? TextAlign.right : TextAlign.left,
        autocorrect: false,
        decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: greyLight))),
        style: textStyle,
        cursorColor: bgColorDark,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(regExp)
        ],
        keyboardType:
        isNumericKeyBoardType ? TextInputType.number : TextInputType.text,
        onChanged: (String value) {
          if (value.isNotEmpty) {
            if (isNumericKeyBoardType) {
              newCellValue = column.columnName == 'Price'
                  ? double.parse(value)
                  : int.parse(value);
            } else {
              newCellValue = value;
            }
          } else {
            newCellValue = null;
          }
        },
        onSubmitted: (String value) {
          /// Call [CellSubmit] callback to fire the canSubmitCell and
          /// onCellSubmit to commit the new value in single place.
          submitCell();
        },
      ),
    );
  }
  RegExp _getRegExp(bool isNumericKeyBoard, String columnName) {
    return isNumericKeyBoard
        ? columnName == 'Price'
        ? RegExp('[0-9.]')
        : RegExp('[0-9]')
        : RegExp('[a-zA-Z ]');
  }

}
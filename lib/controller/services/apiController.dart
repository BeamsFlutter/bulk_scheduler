

import 'dart:convert';


import 'package:scheduler/controller/services/appExceptions.dart';
import 'package:scheduler/controller/services/baseController.dart';
import 'package:scheduler/view/components/alertDialog/alertDialog.dart';
import 'package:scheduler/view/components/common/common.dart';

import 'apiManager.dart';

class ApiCall  with BaseController{

  //============================================LOGIN
  Future<dynamic> apiLogin(company,yearcode,usercd,password) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'USERCD':usercd,
      'PASSWORD':password,
    });
    dprint('api/LOGIN');
    dprint(request);
    var response = await ApiManager().postLoading('api/LOGIN',request,"S").catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;

  }
  Future<dynamic> apiGetCompany() async{

    var response = await ApiManager().postLink('api/GetCompanyYear').catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint('api/GetCompanyYear');
    dprint(response);

    if (response == null) return;

    return response;

  }
  Future<dynamic> apiDriverLogin(company,usercd,password) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'USER_CD':usercd,
      'USER_PWD':password,
    });
    dprint('api/DriverLogin');
    dprint(request);
    var response = await ApiManager().post('api/DriverLogin',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;

  }

  //============================================LOOKUP
  Future<dynamic> LookupSearch(lstrTable,lstrColumn,lstrPage,lstrPageSize,lstrFilter) async {

    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrSearchColumn" :lstrColumn,
      "lstrPage" : lstrPage,
      "lstrLimit": lstrPageSize,
      "lstrFilter" : lstrFilter,
    });
    dprint('api/lookupSearch');
    dprint(request);

    var response = await ApiManager().post('api/lookupSearch',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;

  }
  Future<dynamic> LookupValidate(lstrTable,lstrFilter) async {

    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrFilter" : lstrFilter
    });
    dprint('api/lookupValidate');
    dprint(request);
    var response = await ApiManager().post('api/lookupValidate',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;

  }
  Future<dynamic> apiLookupValidate(lstrTable,key,value) async {
    var lstrFilter =[{'Column': key, 'Operator': '=', 'Value': value, 'JoinType': 'AND'}];
    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrFilter" : lstrFilter
    });
    dprint('api/lookupValidate');
    dprint(request);
    var response = await ApiManager().post('api/lookupValidate',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;

  }

  //CALL BASED ON COMPANY
  Future<dynamic> apiLookupValidateSch(lstrTable,key,value,company) async {
    var lstrFilter =[{'Column': key, 'Operator': '=', 'Value': value, 'JoinType': 'AND'}];
    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrFilter" : lstrFilter,
      "COMPANY" : company
    });
    var response = await ApiManager().post('api/lookupValidate_sch',request).catchError((error){
      if (error is BadRequestException) {
        // var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;

  }
  Future<dynamic> apiLookupSearch(lstrTable,lstrColumn,lstrPage,lstrPageSize,lstrFilter,company) async {

    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrSearchColumn" :lstrColumn,
      "lstrPage" : lstrPage,
      "lstrLimit": lstrPageSize,
      "lstrFilter" : lstrFilter,
      "COMPANY" : company,
    });
    dprint('api/lookupSearch_sch');
    dprint(request);

    var response = await ApiManager().post('api/lookupSearch_sch',request).catchError((error){
      if (error is BadRequestException) {
        var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;

  }
  Future<dynamic> LookupValidateSch(lstrTable,lstrFilter,company) async {

    var request = jsonEncode(<dynamic, dynamic>{
      "lstrTable" : lstrTable,
      "lstrFilter" : lstrFilter,
      "COMPANY" : company
    });

    var response = await ApiManager().post('api/lookupValidate_sch',request).catchError((error){
      if (error is BadRequestException) {
        //var apiError = json.decode(error.message!);
        //Fluttertoast.showToast(msg: apiError["reason"].toString());
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    return response;

  }

  //============================================COMMON
  Future<dynamic> apiDeleteAttachment(company,yearcode,brncode,docno,doctype,srno,path) async{

    var request = jsonEncode(<dynamic, dynamic>{
      'COMPANY':company,
      'YEARCODE':yearcode,
      'BRNCODE':brncode,
      'DOCNO':docno,
      'DOCTYPE':doctype,
      'SRNO':srno,
      'PATH':path,
    });

    var response = await ApiManager().post('api/deletefile',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });

    if (response == null) return;

    return response;

  }
  Future<dynamic> apiViewLog(docno,doctype) async{

    dprint('${'api/getlog?DOCNO='+docno}&DOCTYPE='+doctype);
    var response = await ApiManager().postLink('${'api/getlog?DOCNO='+docno}&DOCTYPE='+doctype).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;

    return response;

  }

 //============================================SCHEDULER
  Future<dynamic> apiGetScheduleCompany() async{

    dprint('api/GetCompany');
    var response = await ApiManager().postLink('api/GetCompany').catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });

    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiGetArea(company,search) async{

    dprint('api/GetArea');
    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY" : company,
      "SEARCH" : search,
    });
    dprint(request);
    var response = await ApiManager().post('api/GetArea',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiGetBuilding(company,area,search) async{

    dprint('api/GetBuilding');
    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY" : company,
      "AREA" : area,
      "SEARCH" : search,
    });
    dprint(request);
    var response = await ApiManager().post('api/GetBuilding',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiGetUsers(search) async{

    dprint('api/GetUsers');
    var request = jsonEncode(<dynamic, dynamic>{
      "SEARCH" : search,
    });
    dprint(request);
    var response = await ApiManager().post('api/GetUsers',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiCreateScheduler(company,schDate,assignUserCd,assignUserDescp,scheduleDet) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "SCH_DATE" : schDate,
      "ASSIGNED_USERCD" : assignUserCd,
      "ASSIGNED_USERDESCP" : assignUserDescp,
      "POST_YN" : "Y",
      "SCHEDULEDET" : scheduleDet,//{MAIN_COMPANY,SRNO,SCH_DATE,ASSIGNED_USER_COMPANY,ASSIGNED_USER_COMPANYDESCP,ASSIGNED_USERCD,COMPANY,COMPANY_DESCP,BUILDING_CODE,BUILDING_DESCP,'TASK_DESCP','TASK_REMARK','BUILDING_AREA_CODE','BUILDING_AREA_DESCP','QTY'}
    });
    dprint('api/createschedule');
    dprint(request);
    var response = await ApiManager().postLoading('api/createschedule',request,"S").catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiEditSchedule(company,docno,doctype,schDate,assignUserCd,assignUserDescp,scheduleDet) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "DOCNO" : docno,
      "DOCTYPE" : doctype,
      "SCH_DATE" : schDate,
      "ASSIGNED_USERCD" : assignUserCd,
      "ASSIGNED_USERDESCP" : assignUserDescp,
      "POST_YN" : "Y",
      "SCHEDULEDET" : scheduleDet,//{MAIN_COMPANY,SRNO,SCH_DATE,ASSIGNED_USER_COMPANY,ASSIGNED_USER_COMPANYDESCP,ASSIGNED_USERCD,COMPANY,COMPANY_DESCP,BUILDING_CODE,BUILDING_DESCP,'TASK_DESCP','TASK_REMARK','BUILDING_AREA_CODE','BUILDING_AREA_DESCP','QTY'}
    });
    dprint('api/editschedule');
    dprint(request);
    var response = await ApiManager().post('api/editschedule',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiViewSchedule(company,docno,doctype,mode) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "DOCNO" : docno,
      "DOCTYPE" : doctype,
      "MODE" : mode,
    });
    dprint('api/viewschedule');
    dprint(request);
    var response = await ApiManager().post('api/viewschedule',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiSearchSchedule(company,search) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "SEARCH" : search,
    });
    dprint('api/schedulesearch');
    dprint(request);
    var response = await ApiManager().post('api/schedulesearch',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiDeleteSchedule(company,docno,doctype) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "DOCNO" : docno,
      "DOCTYPE" : doctype,
    });
    dprint('api/deleteschedule');
    dprint(request);
    var response = await ApiManager().post('api/deleteschedule',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiBuildingHistory(mainCompany,company,buildingCode) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : mainCompany,
      "COMPANY" : company,
      "BUILDING_CODE" : buildingCode,
    });
    dprint('api/buildinghistory');
    dprint(request);
    var response = await ApiManager().post('api/buildinghistory',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }

 //============================================DASHBOARD
  Future<dynamic> apiDashboard(company,dateFrom,dateTo,companyList,userList,areaList,buildingList) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "DATE_FROM" : dateFrom,
      "DATE_TO" : dateTo,
      "COMPANY_LIST" : companyList, //{COL_KEY,COL_VAL,}
      "USER_LIST" : userList, //{COL_KEY,COL_VAL,}
      "AREA_LIST" : areaList, //{COL_KEY,COL_VAL,}
      "BUILDING_LIST" : buildingList, //{COL_KEY,COL_VAL,}
    });
    dprint('api/dashboard');
    dprint(request);
    var response = await ApiManager().post('api/dashboard',request,).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }

 //============================================TANK FILLING
  Future<dynamic> apiNewFilling(company,userCd,buildingCode,stkCd) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY" : company,
      "USER_CD" : userCd,
      "BUILDING_CODE" : buildingCode,
      "STKCODE" : stkCd,
    });
    dprint('api/driverdet');
    dprint(request);
    var response = await ApiManager().postLoading('api/driverdet',request,'S').catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }
  Future<dynamic> apiSaveTankFilling(mainCompany,company,macId,headerTable,detailTable,schedule,sign,imgF,imgB,mode,email) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : mainCompany,
      "COMPANY" : company,
      "DEVICE_ID":macId,
      "LICENCE_PERIOD":'',
      "NO_OF_USER":'',
      "MODE":mode,
      "HeaderTable" : headerTable,
      "DetailTable" : detailTable,
      "SCHEDULE" : schedule,
      "IMG_BEFORE_BASE64":imgB,
      "IMG_AFTER_BASE64":imgF,
      "IMG_SIGNATURE_BASE64":sign,
      "EMAIL":email,
    });
    dprint('api/savetankfill');
    dprint(request);
    var response = await ApiManager().postLoading('api/savefilling',request,"S").catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiViewTankFilling(company,docno,doctype,mode) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "MAIN_DOCNO" : docno,
      "MAIN_DOCTYPE":doctype,
      "MODE":mode,
    });
    dprint('api/viewfilling');
    dprint(request);
    var response = await ApiManager().postLoading('api/viewfilling',request,"S").catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }

  //============================================TRIP
  Future<dynamic> apiTripStart(data) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY" : data["COMPANY"],
      "YEARCODE" : data["YEARCODE"],
      "TRIP_CODE" : data["TRIP_CODE"],
      "TRIP_DESCP" : data["TRIP_DESCP"],
      "USERCD" : data["USERCD"],
      "VEHICLE_CODE" : data["VEHICLE_CODE"],
      "VEHICLE_DESCP" : data["VEHICLE_DESCP"],
      "DRIVER_CODE" : data["DRIVER_CODE"],
      "DRIVER_DESCP" : data["DRIVER_DESCP"],
      "HELP1_CODE" : data["HELP1_CODE"],
      "HELP1_DESCP" : data["HELP1_DESCP"],
      "HELP2_CODE" : data["HELP2_CODE"],
      "HELP2_DESCP" : data["HELP2_DESCP"],
      "PDN" : data["PDN"],
      "SLCODE" : data["SLCODE"],
      "SLDESCP" : data["SLDESCP"],
      "QTY" : data["QTY"],
      "START_TIME" : data["START_TIME"],
      "END_TIME" : data["END_TIME"],
      "REMARKS" : data["REMARKS"],
      "LOC_START" : data["LOC_START"],
      "LOC_END" : data["LOC_END"],
      "KM_START" : data["KM_START"],
      "KM_END" : data["KM_END"],
      "STATUS" : 1,
    });
    dprint('api/tripadd');
    dprint(request);
    var response = await ApiManager().postLoading('api/tripadd',request,'S').catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }
  Future<dynamic> apiTripEdit(data) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY" : data["COMPANY"],
      "YEARCODE" : data["YEARCODE"],
      "DOCNO" : data["DOCNO"],
      "DOCTYPE" : data["DOCTYPE"],
      "DOCDATE" : data["DOCDATE"],
      "TRIP_CODE" : data["TRIP_CODE"],
      "TRIP_DESCP" : data["TRIP_DESCP"],
      "USERCD" : data["USERCD"],
      "VEHICLE_CODE" : data["VEHICLE_CODE"],
      "VEHICLE_DESCP" : data["VEHICLE_DESCP"],
      "DRIVER_CODE" : data["DRIVER_CODE"],
      "DRIVER_DESCP" : data["DRIVER_DESCP"],
      "HELP1_CODE" : data["HELP1_CODE"],
      "HELP1_DESCP" : data["HELP1_DESCP"],
      "HELP2_CODE" : data["HELP2_CODE"],
      "HELP2_DESCP" : data["HELP2_DESCP"],
      "PDN" : data["PDN"],
      "SLCODE" : data["SLCODE"],
      "SLDESCP" : data["SLDESCP"],
      "QTY" : data["QTY"],
      "START_TIME" : data["START_TIME"],
      "END_TIME" : data["END_TIME"],
      "REMARKS" : data["REMARKS"],
      "LOC_START" : data["LOC_START"],
      "LOC_END" : data["LOC_END"],
      "KM_START" : data["KM_START"],
      "KM_END" : data["KM_END"],
      "STATUS" : data["STATUS"],


    });
    dprint('api/tripedit');
    dprint(request);
    var response = await ApiManager().postLoading('api/tripedit',request,'S').catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }
  Future<dynamic> apiGetTrip(company,yearcode,users,vehicles,status) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY" : company,
      "YEARCODE" : yearcode,
      "USERS" : users,//[{COL_KEY:""}]
      "VEHICLES" : vehicles,
      "STATUS" : status,
    });
    dprint('api/gettrip');
    dprint(request);
    var response = await ApiManager().post('api/gettrip',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }

  //============================================TANK Receiving
  Future<dynamic> apiGetRecStockRate(company,stkCode,recDate,slcode,unit2) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "COMPANY" : company,
      "STKCODE" : stkCode,//[{COL_KEY:""}]
      "RECEIVING_DATE" : recDate,
      "SLCODE" : slcode,
      "UNIT2" : unit2,
    });
    dprint('api/receivingrate');
    dprint(request);
    var response = await ApiManager().post('api/receivingrate',request).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }
  Future<dynamic> apiSaveTankReceiving(mainCompany,company,macId,headerTable,mode,email) async{
    var request = jsonEncode(<dynamic, dynamic>{
      'MAIN_COMPANY' :mainCompany,
      'COMPANY' :company,
      'DEVICE_ID': macId,
      'LICENCE_PERIOD':'',
      'NO_OF_USER' :1,
      'MODE':mode,
      'EMAIL' :email,
      'TANK_REC':headerTable
    });
    dprint('api/savetankerrec');
    dprint(request);
    var response = await ApiManager().postLoading('api/savetankerrec',request,"S").catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    if (response == null) return;
    dprint(response);
    return response;
  }
  Future<dynamic> apiViewTankReceiving(company,docno,doctype,mode) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : company,
      "MAIN_DOCNO" : docno,
      "MAIN_DOCTYPE":doctype,
      "MODE":mode,
    });
    dprint('api/viewreceiving');
    dprint(request);
    var response = await ApiManager().postLoading('api/viewreceiving',request,"S").catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }

  //============================================Filling History
  Future<dynamic> apiReceivingList(mainCompany,dateFrom,dateTo,search) async{
    var request = jsonEncode(<dynamic, dynamic>{
      "MAIN_COMPANY" : mainCompany,
      "DATE_FROM" : dateFrom,
      "DATE_TO" : dateTo,
      "SEARCH" : search,
    });
    dprint('api/receivinglist');
    dprint(request);
    var response = await ApiManager().postLoading('api/receivinglist',request,'').catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }
  Future<dynamic> apiPDAFillingList(pdano) async{

    dprint('api/get_filling_pda');

    var response = await ApiManager().postLink('api/get_filling_pda?PDA_NO='+pdano).catchError((error){
      if (error is BadRequestException) {
      } else {
        handleError(error);
      }
    });
    dprint(response);
    if (response == null) return;
    return response;
  }




}
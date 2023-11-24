

import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/controller/services/apiManager.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/pages/home_page/home.dart';
import 'package:scheduler/view/pages/splashscreen/splashscreen.dart';
import 'package:scheduler/view/pages/user/user_home.dart';
import 'package:scheduler/view/pages/user/user_mainscreen.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  const LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {

  //Global
  var g = Global();
  var apiCall  = ApiCall();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<dynamic> futureToken;
  late Future<dynamic> futureCompany;
  late Future<dynamic> futureLogin;
  late Future<dynamic> futureForm;

  //Page variables
  var passWordView = true;
  var lstrErrorMsg = "";
  var loginsts = true;

  //Controllers
  var pagefocusNode = FocusNode();
  var userNameFocusNode = FocusNode();
  var txtUserName  = TextEditingController();
  var txtPassword  = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnGetPageData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: boxImageDecoration('assets/images/img_5.png', 0),
        child: Container(
          decoration: boxGradientDecoration(20, 0),
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),
                    th('BEAMS GAS ', Colors.white, g.wstrHeadFont+15),
                    tcn('DRIVER', Colors.white, g.wstrHeadFont+5),
                  ],
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.all(50),
                decoration: boxDecorationC(Colors.white, 50,50,0,0),
                child: SingleChildScrollView(

                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Row(
                      children: [
                        const Icon(Icons.verified_user),
                        gapWC(10),
                        th('USER LOGIN ', txtColor, 23),
                      ],
                    ),
                    tcn('Welcome back!  Please enter your details', txtSubColor, 12),
                    gapHC(5),
                    tcn(lstrErrorMsg, subColor, 12),
                    gapHC(5),
                    tcn('Username', Colors.black, 15),
                    gapHC(5),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: boxBaseDecoration(greyLight, 5),
                      child: TextFormField(
                        controller: txtUserName,
                        focusNode: userNameFocusNode,
                        decoration: const InputDecoration(
                          hintText: 'Username',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    gapHC(10),
                    tcn('Password', Colors.black, 15),
                    gapHC(5),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: boxBaseDecoration(greyLight, 5),
                      child: TextFormField(
                        controller: txtPassword,
                        obscureText: passWordView,
                        keyboardType: TextInputType.visiblePassword,
                        decoration:  InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                            suffixIcon: InkWell(
                              onTap: (){
                                setState(() {
                                  passWordView =  passWordView? false:true;
                                });
                              },
                              child: passWordView? const Icon(Icons.lock, color: Colors.grey,):const Icon(Icons.lock_open, color: Colors.grey,),
                            )
                        ),

                      ),
                    ),
                    gapHC(30),
                    Bounce(
                      duration: const Duration(milliseconds: 110),
                      onPressed: (){
                        if(loginsts){
                          fnDriverLogin();
                        }
                      },
                      child: Container(
                        height: 50,
                        decoration: boxBaseDecoration(subColor, 30),
                        child: Center(
                          child: loginsts?  tc('SIGN IN', Colors.white, 15):const SpinKitThreeBounce(color: Colors.white,size: 20,),
                        ),
                      ),),
                        gapHC(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            tcn('Help ? Customer Team', txtSubColor, 10)
                          ],
                        )
                  ]),
                ),
              )),
              Container(
                decoration: boxBaseDecoration(white, 0),
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tcn('Beams  ${g.wstrVersionName}', txtSubColor, 10)
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
  //==================================PAGE_FN

  fnGetPageData(){
    userNameFocusNode.requestFocus();
    apiGetToken();
  }
  fnLogin(){
    setState((){
      lstrErrorMsg = '';
    });
    if(txtUserName.text.isEmpty){
      setState((){
        lstrErrorMsg = 'Please enter username.';
      });
      return;
    }
    setState((){
      loginsts = true;
    });

    apiLogin();
  }
  fnDriverLogin(){
    setState((){
      lstrErrorMsg = '';
    });
    if(txtUserName.text.isEmpty){
      setState((){
        lstrErrorMsg = 'Please enter username.';
      });
      return;
    }
    setState((){
      loginsts = true;
    });

    apiDriverLogin();
  }

  fnRefresh(){
    Navigator.pushReplacement( context, MaterialPageRoute( builder: (context) => const SplashScreen()), ).then((value) => {});
  }
  fnLoginDone(data,mode) async{
    final SharedPreferences prefs = await _prefs;

    try{
      var now = DateTime.now();
      var lstrLoginDate = setDate(9,now);

      prefs.setString('wstrUserCd', data["USER_CD"]);
      prefs.setString('wstrUserName', data["USER_NAME"]);
      prefs.setString('wstrLoginYn', "Y");
      prefs.setString('wstrLoginDate', lstrLoginDate);

      g.wstrLoginYn = "Y";
      g.wstrLoginDate = lstrLoginDate;
      g.wstrUserCd = data["USER_CD"];
      g.wstrUserName = data["USER_NAME"];
      if(mode == "D"){
        fnGoStaffPage();
      }else{
        fnGoHome();
      }

    }catch(e){
      dprint(e);
    }

  }
  fnGoHome(){
    Get.off(() =>  const HomePage());
  }

  fnGoStaffPage(){
    Get.off(() =>   const NavigationHomeScreen(message: '',));
  }

//==================================APICALL

  apiGetToken(){
    futureToken =  ApiManager().mfnGetToken();
    futureToken.then((value) => apiGetTokenRes(value));
  }
  apiGetTokenRes(value) async{
    final SharedPreferences prefs = await _prefs;
    prefs.setString('wstrToken', value["access_token"]);
    g.wstrToken =  value["access_token"];
    apiGetCompany();
  }

  apiGetCompany(){
    futureCompany =  apiCall.apiGetCompany();
    futureCompany.then((value) => apiGetCompanyRes(value));
  }
  apiGetCompanyRes(value) async{
    final SharedPreferences prefs = await _prefs;
    if(g.fnValCheck(value)){
      prefs.setString('wstrCompany', value["COMPANY"]);
      prefs.setString('wstrYearcode', value["YEARCODE"]);
      g.wstrCompany = value["COMPANY"]??"00";
      g.wstrYearcode = value["YEARCODE"]??"00";
    }

  }

  apiLogin(){
    if(loginsts){
      setState((){
        loginsts = false;
      });
      futureLogin = apiCall.apiLogin(g.wstrCompany,g.wstrYearcode, txtUserName.text, txtPassword.text);
      futureLogin.then((value) => apiLoginRes(value));
    }
  }
  apiLoginRes(value){
    if(mounted){
      setState((){
        loginsts = true;
      });
    }


    if(g.fnValCheck(value)){
      var sts  =  value["STATUS"];
      var msg  =  value["MSG"];
      if(sts == "1"){
        var data =  value;
        if(g.fnValCheck(data)){
          fnLoginDone(data[0],"");
        }
      }


      if(mounted){
        setState((){
          lstrErrorMsg = msg;
        });
      }

    }else{
      if(mounted){
        setState((){
          lstrErrorMsg = "Please try again";
        });
      }
    }
  }

  apiDriverLogin(){
    if(loginsts){
      setState((){
        loginsts = false;
      });
      futureLogin = apiCall.apiDriverLogin(g.wstrCompany, txtUserName.text, txtPassword.text);
      futureLogin.then((value) => apiDriverLoginRes(value));
    }
  }
  apiDriverLoginRes(value){
    if(mounted){
      setState((){
        loginsts = true;
      });
    }


    if(g.fnValCheck(value)){
      var sts = "1";
      var msg = "SUCCESS";

      if(sts == "1"){
        //var data =  value["DATA"];
        var data = value;
        fnLoginDone(data[0],"D");
      }


      if(mounted){
        setState((){
          lstrErrorMsg = msg;
        });
      }

    }else{
      if(mounted){
        setState((){
          lstrErrorMsg = "Please try again";
        });
      }
    }
  }


}

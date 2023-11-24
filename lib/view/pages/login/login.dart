
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/controller/services/apiController.dart';
import 'package:scheduler/controller/services/apiManager.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/components/resposive/responsive_helper.dart';
import 'package:scheduler/view/pages/home_page/home.dart';
import 'package:scheduler/view/pages/splashscreen/splashscreen.dart';
import 'package:scheduler/view/pages/user/user_home.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    Size size  = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: boxImageDecoration("assets/images/img.png",0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ResponsiveWidget(
                mobile: mobileView(size),
                tab: mobileView(size),
                windows: windowsView(size))
          ],
        ),
      ),
    );
  }

//==================================WIDGET

  Widget windowsView(size){
    return Container(
      height: size.height*0.7,
      width: size.width*0.6,
      decoration: boxDecoration(Colors.white, 40),
      child: Row(
        children: [
          Flexible(
            child: bnc(Container(
              margin: const EdgeInsets.all(20),
              decoration: boxImageDecoration("assets/images/img_1.png",40),
              child: Container(
                decoration: boxGradientDecoration(20, 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),
                    //Image.asset("assets/gifs/bookingdark.gif",width: size.width*0.2,),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: boxDecoration(Colors.white, 20),
                      child:  Center(
                        child: Image.asset("assets/icons/schicon.png",width: 60,),
                      ),
                    ),
                    gapHC(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        th('BEAMS', Colors.white, 25),
                        gapWC(5),
                        tcn('GAS', Colors.white, 25),
                      ],
                    ),
                    tcn('SCHEDULER', Colors.white, 18),
                    tcn(g.wstrVersionName, Colors.white, 10),

                  ],
                ),
              ),
            )),
          ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
                      const Icon(Icons.wifi,color: Colors.redAccent,size: 20,),
                      gapWC(15),
                      Bounce( duration: const Duration(milliseconds: 110), onPressed: (){ fnRefresh(); },child: const Icon(Icons.reset_tv,color: Colors.redAccent,size: 20,),),
                      gapWC(15),
                      const Icon(Icons.computer,color: Colors.redAccent,size: 20,),
                      gapWC(15),
                      const Icon(Icons.settings,color: Colors.redAccent,size: 20,),
                      gapWC(15),
                      const Icon(Icons.help,color: Colors.redAccent,size: 20,),
                    ],
                  ),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      th('USER LOGIN ', bgColorDark, 23),
                      tcn('Welcome back!  Please enter your details', Colors.black, 12),
                      gapHC(5),
                      tcn(lstrErrorMsg, subColor, 12),

                      gapHC(25),
                      tcn('Username', Colors.black, 15),
                      gapHC(5),
                      Container(
                        height: 45,
                        width: size.width*.2,
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
                        width: size.width*.2,
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
                            fnLogin();
                          }
                        },
                        child: Container(
                          height: 45,
                          width: size.width*.2,
                          decoration: boxDecoration(subColor, 30),
                          child: Center(
                            child: loginsts?  tc('SIGN IN', Colors.white, 15):const SpinKitThreeBounce(color: Colors.white,size: 20,),
                          ),
                        ),)
                    ],
                  )),
                  Container(
                    child: tcn('BEAMS', Colors.black, 10),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget mobileView(size){
    return Container(
      height: size.height,
      width : size.width,
      decoration: boxDecoration(white, 0),
      padding: const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          gapHC(10),

          Container(
            margin: const EdgeInsets.all(5),
            height: 200,
            decoration: boxImageDecoration('assets/images/img_5.png', 30),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: boxGradientDecorationBase(20, 30),
              child: Column(
                children: [
                  gapHC(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:  [
                      const Icon(Icons.wifi,color: Colors.white,size: 20,),
                      gapWC(15),
                      Bounce( duration: const Duration(milliseconds: 110), onPressed: (){ fnRefresh(); },child: const Icon(Icons.reset_tv,color: Colors.white,size: 20,),),
                      gapWC(15),
                      const Icon(Icons.computer,color: Colors.white,size: 20,),
                      gapWC(15),
                      const Icon(Icons.settings,color: Colors.white,size: 20,),
                      gapWC(15),
                      const Icon(Icons.help,color: Colors.white,size: 20,),
                    ],
                  ),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          th('BEAMS', Colors.white, 25),
                          gapWC(5),
                          tcn('SCHEDULER', Colors.white, 25),
                        ],
                      )
                    ],
                  ))
                ],
              ),
            ),
          ),
          gapHC(50),
          Expanded(child:
          Container(
            padding: const EdgeInsets.only(left: 40,right: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                    height: 45,
                    decoration: boxBaseDecoration(subColor, 30),
                    child: Center(
                      child: loginsts?  tc('SIGN IN', Colors.white, 15):const SpinKitThreeBounce(color: Colors.white,size: 20,),
                    ),
                  ),)
              ],
            ),
          )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              tcn('Beams Scheduler ${g.wstrVersionName}', txtSubColor, 8)
            ],
          )
        ],
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

      prefs.setString('wstrUserCd', data["USERCD"]);
      prefs.setString('wstrUserName', data["USERCD"]);
      prefs.setString('wstrLoginYn', "Y");
      prefs.setString('wstrLoginDate', lstrLoginDate);

      g.wstrLoginYn = "Y";
      g.wstrLoginDate = lstrLoginDate;
      g.wstrUserCd = data["USERCD"];
      g.wstrUserName = data["USERCD"];
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
    Get.off(() =>  const UserHome(msg: '',));
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
        var data =  value["DATA"];
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
      var sts  =  value["STATUS"];
      var msg  =  value["MSG"];
      if(sts == "1"){
        //var data =  value["DATA"];
        var data = [{
          "USERCD":txtUserName.text
        }];
        if(g.fnValCheck(data)){
          fnLoginDone(data[0],"D");
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

}

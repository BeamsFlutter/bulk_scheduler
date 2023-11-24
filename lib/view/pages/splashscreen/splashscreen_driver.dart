
import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scheduler/controller/global/globalValues.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/pages/login/login.dart';
import 'package:scheduler/view/pages/login/login_user.dart';
import 'package:scheduler/view/styles/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenUser extends StatefulWidget {
  const SplashScreenUser({Key? key}) : super(key: key);

  @override
  State<SplashScreenUser> createState() => _SplashScreenUserState();
}

class _SplashScreenUserState extends State<SplashScreenUser> {

  //Global
  Global g = Global();
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Page variables
  var deviceId = '';
  var deviceName = '';
  var deviceIp = '';
  var deviceMode ='';

  var appMode =  "U";

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
    return Scaffold(
      backgroundColor: Colors.white,
      body:Container(
        decoration: boxImageDecoration("assets/images/img_5.png", 0),
        child: Container(
          decoration: boxGradientDecoration(20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              gapHC(0),
              Column(
                children: [
                  Container(
                    height: 110,
                    width: 110,
                    decoration: boxGradientDecoration(21, 15),
                    child: Center(
                      child: Image.asset("assets/icons/schicon.png",width: 80,),
                    ),
                  ),
                  gapHC(5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      th('BEAMS', Colors.white, 25),
                      gapWC(5),
                      th('GAS', Colors.white, 25),
                    ],
                  ),
                  tcn('DRIVER', Colors.white, 20),
                  gapHC(10),
                  const SpinKitThreeBounce(color: Colors.white,size: 25,),
                ],
              ),
              Column(
                children: [
                  tcn('BEAMS ${g.wstrVersionName}', white, 10),
                  gapHC(15),
                  gapHC(20),

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  //==================================WIDGET

  //==================================PAGE_FN

  fnGetPageData(){
    initPlatformState();
    fnDefaultPageSettings();
    var duration = const Duration(seconds: 5);
    return Timer(duration, route);
  }
  route() async{
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => appMode == "A"?const LoginPage():const LoginUser()
    ));
  }
  fnDefaultPageSettings() async{
    final SharedPreferences prefs = await _prefs;
    g.wstrVersionName = "V 1.0";
    g.wstrBaseUrl =  "http://192.168.1.205:1120";
    //g.wstrBaseUrl =  "http://laptop-vi4dgus9:1111";

    prefs.setString("wstrDeviceId", deviceId);
    prefs.setString("wstrVersionName",  g.wstrVersionName);
    prefs.setString("wstrDeviceName", deviceName);
    prefs.setString("wstrDeviceIP", deviceIp);



  }

  //==================================APICALL

  //==================================SYSTEM INFO

  Future<void> initPlatformState() async {

    var deviceData = <String, dynamic>{};
    try {

      if (kIsWeb) {
        _readWebBrowserInfo(await deviceInfoPlugin.webBrowserInfo);

      } else {
        if (Platform.isAndroid) {
          _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        } else if (Platform.isIOS) {
          _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
        } else if (Platform.isLinux) {
          _readLinuxDeviceInfo(await deviceInfoPlugin.linuxInfo);
        } else if (Platform.isMacOS) {
          _readMacOsDeviceInfo(await deviceInfoPlugin.macOsInfo);
        } else if (Platform.isWindows) {
          _readWindowsDeviceInfo(await deviceInfoPlugin.windowsInfo);
        }
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    if (!mounted) return;
    g.wstrDeviceName = deviceName;
    g.wstrDeivceId = deviceId;
    g.wstrDeviceIP = deviceIp;

  }
  _readAndroidBuildData(AndroidDeviceInfo build) {

    setState(() {
      deviceMode = '';
      deviceId = build.id??'';
      deviceName =  build.model??'';
    });

  }
  _readIosDeviceInfo(IosDeviceInfo data) {

    setState(() {
      deviceMode = '';
      deviceId = data.name??'';
      deviceName =  data.systemName??'';
    });

  }
  _readLinuxDeviceInfo(LinuxDeviceInfo data) {

  }
  _readWebBrowserInfo(WebBrowserInfo data)  {

    setState(() {
      deviceMode = 'W';
      deviceId = describeEnum(data.browserName);
      deviceName =  describeEnum(data.browserName);
    });


  }
  _readMacOsDeviceInfo(MacOsDeviceInfo data) {
    setState(() {
      deviceMode = '';
      deviceId = data.systemGUID??'';
      deviceName =  data.computerName;
    });
  }
  _readWindowsDeviceInfo(WindowsDeviceInfo data) {
    setState(() {
      deviceMode = '';
      deviceId = data.computerName;
      deviceName =  data.computerName;
    });
  }

}

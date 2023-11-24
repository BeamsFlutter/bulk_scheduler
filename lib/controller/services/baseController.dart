


import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:scheduler/controller/services/appExceptions.dart';
import 'package:scheduler/view/components/common/common.dart';

class BaseController {
  void  handleError(error) {
    if (error is BadRequestException) {
      var message = error.message;
      dprint(message);
      //Fluttertoast.showToast(msg: message.toString());
      Get.off(() =>  Error());

    } else if (error is FetchDataException) {
      var message = error.message;
     //Fluttertoast.showToast(msg: message.toString());
      //showToast(message.toString());
      dprint(message);


    } else if (error is ApiNotRespondingException) {
      var message = error.message;
      //Fluttertoast.showToast(msg: message.toString());
      //showToast(message.toString());
      dprint(message);
      Get.off(() =>  Error());
    }
  }
}
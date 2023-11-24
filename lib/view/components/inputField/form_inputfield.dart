

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scheduler/view/components/common/common.dart';
import 'package:scheduler/view/styles/colors.dart';

class FormInput extends StatelessWidget {

  final String ? hintText;
  final IconData ? icon;
  final IconData ? suffixIcon;
  final ValueChanged<String> ? onChanged;
  final ValueChanged<String> ? onSubmit;
  final VoidCallback? onEditingComplete;
  final TextInputType ? textType;
  final TextEditingController ? txtController;
  final double ? txtHeight;
  final double ? txtWidth;
  final double ? txtRadius;
  final int ? txtLength;
  final FocusNode ? focusNode;
  final Function ? suffixIconOnclick;
  final Function ? onClear;
  final bool ? enablests;
  final bool ? autoFocus;
  final bool ? validate;
  final bool ? emptySts;
  final bool ? focusSts;
  final String ? errorMsg;
  final String ? labelYn;
  final String ? value;
  final Color ?  labelColor;
  final double ? fontSize;
  final IconData ? labelIcon;
  const FormInput({Key? key, this.hintText, this.icon, this.suffixIcon, this.onChanged, this.onSubmit, this.onEditingComplete, this.textType, this.txtController, this.txtHeight, this.txtWidth, this.txtRadius, this.focusNode, this.suffixIconOnclick, this.onClear, this.enablests, this.autoFocus, this.validate, this.emptySts, this.errorMsg, this.labelYn, this.labelColor, this.fontSize, this.txtLength, this.focusSts, this.value, this.labelIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<TextInputFormatter> inputFormatters = [];
    if(textType == TextInputType.number){
      inputFormatters.add(FilteringTextInputFormatter.digitsOnly);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        labelYn != "N"?
        Row(
          children: [
            labelIcon == null?gapHC(0):Icon(labelIcon,color: txtSubColor,size: 10,),
            tcn(hintText??"",labelColor ?? txtColor, 12),
          ],
        ):gapHC(0),
        gapHC(2),
        Container(
          height: txtHeight??40,
          width:size.width * (txtWidth??0.6),
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
          decoration: boxOutlineInput(enablests??true,focusSts??false),
          child: TextFormField(
            focusNode: focusNode,
            maxLength: txtLength,
            controller: txtController,
            autofocus: autoFocus??false,
            enabled: enablests??true,
            keyboardType: textType,
            onChanged:onChanged??fn() ,
            cursorColor: subColor,
            minLines: 1,
            maxLines: 1,
            onFieldSubmitted: onSubmit??fn(),
            inputFormatters: inputFormatters,
            style: GoogleFonts.poppins(fontSize: 11,color: Colors.black),
            decoration:  InputDecoration(
              counterText: "",
              hintText:hintText.toString(),
              border: InputBorder.none,
              suffixIcon: suffixIcon != null? InkWell(
                onTap: suffixIconOnclick??fn(),
                child: Icon(
                  suffixIcon,
                  color: bgColorDark ,
                  size: 20,
                ),
              ): GestureDetector(
                onTap: onClear??fn(),
                child:  (emptySts??true)?  Icon(Icons.cancel_outlined,size: 20,color: Colors.grey.withOpacity(0.6)): const Icon(Icons.cancel_outlined,size: 20,color: greyLight,),
              ),
            ),
            validator: (value) {
              if(validate??false){
                if (value == null || value.isEmpty) {
                  //return errorMsg;
                }
              }
              return null;
            },
          ),
        ),
        gapHC(2),
        (validate??false) && !emptySts! && (errorMsg??"").isNotEmpty?
        tcn(errorMsg??"",subColor, 12):gapHC(0),

      ],
    );
  }
  fn(){

  }
}

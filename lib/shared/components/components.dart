import 'package:flutter/material.dart';
import 'package:todo/shared/bloc/cubit.dart';

Widget defaultformfield({
  required TextEditingController controle,
  TextInputType? type,
  bool obscure = false,
  String? label,
  String? hint,
  required IconData prefix,
  IconData? suffix,
  VoidCallback? onpress,
  FormFieldValidator? validate,
  GestureTapCallback? ontap,
  bool isClickable = true,
  ValueChanged<String>? onSubmit,
  ValueChanged<String>? onChange,
  Color? iconColor,
  Color? textColor,
}) =>
    TextFormField(
      onFieldSubmitted: onSubmit,
      enabled: isClickable,
      onTap: ontap,
      validator: validate,
      controller: controle,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: textColor),
        labelStyle: TextStyle(
          color: textColor,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 3,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            width: 3,
          ),
        ),
        labelText: label,
        prefixIconColor: Colors.blue.shade900,
        hintText: hint,
        prefixIcon: Icon(
          prefix,
          color:  Colors.blue.shade900,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            suffix,
          ),
          onPressed: onpress,
        ),
      ),
      onChanged: onChange,
    );

Widget defaultTextButton({
  required VoidCallback onPress,
  required String text,
  Color? textColor,
  Color? pressColor,
  double? fontSize,
}) =>
    TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
              if (states.contains(MaterialState.pressed))
                return pressColor; //<-- SEE HERE
              return null; // Defer to the widget's default.
            },
          ),
        ),
        onPressed: onPress,
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: fontSize),
        ));

Widget taskBuilder(Map taskModel, context) => Dismissible(
      key: Key(taskModel['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade900,
              borderRadius: BorderRadius.circular(30 ),
              border: Border.all(color: Colors.blue.shade900)),
          child: Padding (
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    ToDoCubit.get(context).UpdateData(
                      status: 'done',
                      id: taskModel['id'],
                    );
                  },
                  icon: Icon(
                    taskModel['status'] == 'done'
                        ? Icons.check_box
                        : Icons.check_box_outline_blank_sharp,

                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10,) ,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${taskModel['title']}',
                        maxLines: 2,

                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${taskModel['date'] + ' , '}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white),
                          ),
                          Text(taskModel['time'] ,style: TextStyle(color: Colors.white),)
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),
                IconButton(
                  onPressed: () {
                    ToDoCubit.get(context).UpdateData(
                      status: 'archive',
                      id: taskModel['id'],
                    );
                  },
                  icon: Icon(
                    Icons.archive,
                    color:  Colors.white
                        ,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        ToDoCubit.get(context).DeleteData(id: taskModel['id']);
      },
    );

Widget myDivider() => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20,
      ),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Colors.grey[400],
      ),
    );

navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false);

void printFullText(String text) {
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

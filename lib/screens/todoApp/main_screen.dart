import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/shared/components/components.dart';
import '../../shared/bloc/cubit.dart';
import '../../shared/bloc/states.dart';


class homeLayout extends StatelessWidget {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ToDoCubit()..createDatabase(),
      child: BlocConsumer<ToDoCubit, TodoState>(
          listener: (context, state) => {
            if(state is InsertState)
              {
                Navigator.pop(context)
              }
          },
          builder: (context, state) {
            ToDoCubit cubit = ToDoCubit.get(context);
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                backgroundColor: Colors.blue.shade900,
                title: Text(
                    cubit.title[cubit.current]
                ),
              ),
              body: state is! GetLoadingState ? cubit.screens[cubit.current]: const Center(child:
              CircularProgressIndicator()),
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue.shade900,
                onPressed: () {
                  if (cubit.isBottomSheet) {
                    if (formKey.currentState!.validate()) {
                      cubit.insertDatabase(title: titleController.text, date: dateController.text, time: timeController.text);
                    }
                  }
                  else {
                    scaffoldKey.currentState!.showBottomSheet((context) =>
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  defaultformfield(
                                    controle: titleController,
                                    label: 'Task Title',
                                    prefix: Icons.title,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'title is empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15,),
                                  defaultformfield(
                                    controle: timeController,
                                    label: 'Task Time',
                                    prefix: Icons.watch_later,
                                    ontap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                      ).then((value) {
                                        timeController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                    type: TextInputType.datetime,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Time is empty';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15,),
                                  defaultformfield(
                                    controle: dateController,
                                    label: 'Task Date',
                                    prefix: Icons.calendar_today,
                                    ontap: () {
                                      showDatePicker(

                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.parse('2024-12-12'),
                                      ).then((value) {
                                        dateController.text =
                                            DateFormat.yMMMd().format(value!);
                                      });
                                    },
                                    type: TextInputType.datetime,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return 'Date is empty';
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                      elevation: 20,
                    ).closed.then((value) {
                     cubit.ChangeBottomSheet(
                         isShow: false, icon: Icons.edit)
                     ;
                    });
                    cubit.ChangeBottomSheet(
                        isShow: true,
                        icon: Icons.save)
                    ;
                  }
                },
                child: Icon (
                  cubit.fabIcon,
                ),
              ),
              bottomNavigationBar: CurvedNavigationBar(
                backgroundColor: Colors.blue.shade900,
                animationCurve: Curves.easeInOutSine,
                animationDuration: Duration(milliseconds: 400),
                onTap: (value) {
                  cubit.change(value);
                },
                items: const [
                  Icon(
                    Icons.checklist_rtl,
                  ),
                  // label: 'Tasks',
                  Icon(
                    Icons.check_box_outlined,
                  ),
                  //  label: 'Done',
                  Icon (
                    Icons.archive_outlined,

                    //  label: 'Archived',
                  ),
                ],
              ),
            );
          }
      ),
    );
  }
}
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocl/cubit.dart';
import '../blocl/status.dart';
import '../componants/componants.dart';
import 'package:intl/intl.dart';


// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var formKey = GlobalKey<FormState>();

  var titleController = TextEditingController();

  var timeController = TextEditingController();

  var dateController = TextEditingController();
@override
  void dispose() {

    super.dispose();
  }
  // @override
  @override

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStatus>(
      listener: (context, state) {
        if(state is InsertDataBaseStatus){
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        AppCubit cubit = BlocProvider.of(context);
        return  Scaffold(
            key: scaffoldKey,
            bottomNavigationBar: BottomNavigationBar(
              elevation: 20.0,
              // selectedIconTheme: IconThemeData(color: Colors.black),
              // selectedItemColor: Color.fromARGB(255, 0, 0, 0),
              landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.menu,
                    // color: Color.fromARGB(255, 167, 47, 236),
                  ),
                  label: "New Task",

                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.done,
                    // color: Color.fromARGB(255, 167, 47, 236),
                  ),
                  label: "Done Task ",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive,
                    // color: Color.fromARGB(255, 167, 47, 236),
                  ),
                  label: "Archived Task ",
                ),
              ],
              currentIndex: AppCubit.get(context).currentIndex,
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                AppCubit.get(context).ChangeButton(index);
                // ChangeButton();
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromARGB(255, 167, 47, 236),
              onPressed: () {
                if(cubit.fabBotton){
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertToDataBase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text
                    );
                  }
                }else{
                  scaffoldKey.currentState?.showBottomSheet
                    (

                        (context) =>
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                //TextFormField title
                                defaultFormField(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String value){
                                    if(value.isEmpty){
                                      return 'Title must not be empty';
                                    }return null;
                                  },
                                  label: 'task title',
                                  prefix: Icons.title,
                                ),
                                const SizedBox(height: 15,),
                                //textForm time
                                defaultFormField(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  validate: (String value){
                                    if(value.isEmpty){
                                      return 'time must not be empty';
                                    }return null;
                                  },
                                  onTap: (){
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()).then((value) {
                                      timeController.text = value?.format(context)??TimeOfDay.now().format(context);

                                    });
                                  },
                                  label: 'task time',
                                  prefix: Icons.watch_later_outlined,
                                ),
                                const SizedBox(height: 15,),
                                //Text Form date
                                defaultFormField(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  validate: (String value){
                                    if(value.isEmpty){
                                      return 'date must not be empty';
                                    }return null;
                                  },
                                  onTap: (){
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2023-10-20') ,
                                    ).then((value) {
                                      dateController.text = DateFormat.yMMMd().format(value??DateTime.now());

                                    });
                                  },
                                  label: 'task date',
                                  prefix: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),


                  ).closed.then((value) {
titleController.clear();
timeController.clear();
dateController.clear();
                    cubit.changeBottomSheet(isShow: false, icon:Icons.edit);

                  });

                  cubit.changeBottomSheet(isShow: true, icon:Icons.add);

                }

              },
              child:  Icon(
                cubit.fabIcon,
                color: Colors.white,
                size: 30,
              ),
            ),
            appBar: AppBar(
              // backgroundColor:Color.fromARGB(255, 167, 47, 236),
              elevation: 0.0,
              title: const Text(
                'My Tasks',
              ),
              actions: [
                IconButton(onPressed: (){
                  AppCubit.get(context).changeAppMode();
                }, icon: const Icon(Icons.brightness_4))
              ],
            ),
            body: ConditionalBuilder(
              condition:state is! LoadScreen ,
              builder:(context) =>  cubit.screens[cubit.currentIndex],
              fallback:(context) => const Center(child: CircularProgressIndicator()) ,
            )

        );

      },

    );

  }
}








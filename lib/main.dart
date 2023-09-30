import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


import 'package:tasks_todo_app/pages/home_page.dart';
import 'package:tasks_todo_app/sharedpref/shared_pref.dart';

// import 'bloc/cubit.dart';
// import 'bloc/status.dart';
import 'bloc_observer/observer.dart';
import 'blocl/cubit.dart';
import 'blocl/status.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
 await SharedPref.init();
  Bloc.observer = MyBlocObserver();
  // if (Platform.isWindows || Platform.isLinux) {
  //   // Initialize FFI
  //   sqfliteFfiInit();
  // }
  // databaseFactory = databaseFactoryFfi;
  bool? isDark = SharedPref.getData(key:'isDark');
  runApp( MyApp(isDark));
}
class MyApp extends StatelessWidget {
final bool? isDark;
MyApp(this.isDark);
  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => AppCubit()..createDataBase()..changeAppMode(
fromSharedPref: isDark
      ),
      child: BlocConsumer<AppCubit,AppStatus>(
        listener:(context, state) {},
        builder:(context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(

              textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.black,fontWeight: FontWeight.w500)),
              datePickerTheme: const DatePickerThemeData(
                  headerBackgroundColor:Color.fromARGB(255, 167, 47, 236),
                  headerHelpStyle: TextStyle(color: Colors.white),
                  headerForegroundColor: Colors.white
              ),
              timePickerTheme: const TimePickerThemeData(
                  backgroundColor: Colors.white
              ),
              appBarTheme:  const AppBarTheme(
                  iconTheme: IconThemeData(
                      color: Colors.black
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Colors.white,
                      statusBarIconBrightness: Brightness.dark
                  ),
                  elevation: 0.0,
                  titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.w500),
                  backgroundColor: Colors.white),
            ),
            darkTheme: ThemeData(
              bottomSheetTheme: BottomSheetThemeData(
                backgroundColor:HexColor('333739'), ),
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                showSelectedLabels: true,
                backgroundColor: HexColor('333739'),
                selectedItemColor:  const Color.fromARGB(255, 167, 47, 236),
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                selectedLabelStyle: const TextStyle(color: Colors.white),
              ),
              textTheme: const TextTheme(bodyText1: TextStyle(color: Colors.white,fontWeight: FontWeight.w500)
              ),
              scaffoldBackgroundColor: HexColor('333739'),
              appBarTheme:  AppBarTheme(
                  iconTheme: IconThemeData(
                      color: Colors.white
                  ),
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: HexColor('333739'),
                      statusBarIconBrightness: Brightness.light
                  ),
                  elevation: 0.0,
                  titleTextStyle: const TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),
                  backgroundColor: HexColor('333739')),
              floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Color.fromARGB(255, 167, 47, 236),
              ),
            ),
            themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            home: HomePage(),
          );
        },

      ),
    );
  }
}



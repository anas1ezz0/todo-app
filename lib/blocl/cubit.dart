import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
// import 'package:tasks_todo_app/bloc/status.dart';
import 'package:tasks_todo_app/blocl/status.dart';
import '../pages/archive_tasks.dart';
import '../pages/done_tasks.dart';
import '../pages/news_tasks.dart';
import '../sharedpref/shared_pref.dart';
class AppCubit extends Cubit<AppStatus>{
AppCubit() :super (InitialStatus());
static AppCubit get(context) => BlocProvider.of(context);
Database? database;
int currentIndex = 0;
bool fabBotton = false;
bool isDark = false;
IconData fabIcon = Icons.edit;
List<Map> doneTasks = [];
List<Map> archiveTasks = [];
List<Map> newTasks = [];
List<Widget> screens = [
  NewTasks(),
  DoneTasks(),
  ArchiveTasks(),
];
List<String> titels = [
  "New Task ",
  "Done Task",
  "Archived Task",
];
void createDataBase()  {
 openDatabase(
    'tod.db',
    version: 1,
    onCreate: (database, version) {
      if (kDebugMode) {
        print("db created");
      }
      database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,time TEXT,date TEXT,status TEXT)')
          .then((value) {
        if (kDebugMode) {
          print('table created');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('error when Creating Table ${error.toString()}');
        }
      });
    },
    onOpen: (database)
    {
      getDataFromDataBase(database);
      print("database opened");

    },
  ).then((value) {
    database = value;
    emit(CreateDataBaseStatus());
 });

}
 insertToDataBase({
  required String title ,
  required String time ,
  required String date,
})
async{
   await database?.transaction(
          (txn) => txn.rawInsert('INSERT INTO tasks(title,time,date,status) VALUES("$title","$time","$date","new")').then((value) {

        print('$value inserted success');
        emit(InsertDataBaseStatus());
        getDataFromDataBase(database!);
      }).catchError((error){

        print('error when Insert Table ${error.toString()}');

      })
  );
}
void getDataFromDataBase(Database database)async {
newTasks = [];
doneTasks = [];
archiveTasks = [];
  emit(LoadScreen());
    await database.rawQuery('SELECT * FROM tasks').then((value) {

      value.forEach((element) {
        if(element['status'] == 'new'){
          newTasks.add(element);
        }else if(element['status'] == 'done'){
          doneTasks.add(element);
        }else{
          archiveTasks.add(element);
        }

      });
      emit(GetDataBaseStatus());
    });

}
void updateDataFromDataBase({required String status,required int id})async{
 database?.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      [status, '$id'],
  ).then((value) {
   getDataFromDataBase(database!);
    emit(UpdateDataBaseStatus());
 });
}
void editDataFromDataBase({required String status,required int id})async{
 database?.rawUpdate(
     'UPDATE tasks SET status = ? WHERE id = ?',
      [status,"$id"]
 ).then((value) {
   getDataFromDataBase(database!);
    emit((EditDataBaseStatus()));
 });
}
void deleteDataFromDataBase({required int id}) async {
 database?.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
   getDataFromDataBase(database!);
    emit(DeleteDataBaseStatus());
 });
}
void ChangeButton(int index) {
  currentIndex = index;
  emit(ButtonChangeState());
}
void changeBottomSheet({required isShow, required icon}) {
  fabBotton = isShow;
  fabIcon = icon;
  emit(ChangeBotmShet());
}
ThemeMode appMode = ThemeMode.dark;
void changeAppMode({  bool? fromSharedPref})
{
  if(fromSharedPref != null)
  {
    isDark = fromSharedPref;
    emit(ChangeAppMode());
  }else{
    isDark = !isDark;
    SharedPref.putData(key: 'isDark', value: isDark).then((value) {
      emit(ChangeAppMode());
    });
  }



}
}

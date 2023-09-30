import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import '../blocl/cubit.dart';
import '../pages/edit_task.dart';

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  Function? onSubmit,
  Function? onChange,
  Function()? onTap,
  bool isPassword = false,
  required Function validate,
  required String label,
  required IconData? prefix,
  IconData? suffix,
  Function? suffixPressed,
  bool isClickable = true,
})
=> TextFormField(

  onTap: onTap,
  cursorColor: Color.fromARGB(255, 167, 47, 236),
  controller: controller,
  keyboardType: type ,
  obscureText: isPassword,
  enabled: isClickable,
  // onFieldSubmitted: (s)
  // {
  //   onSubmit!(s);
  // },
// onChanged: (s)
// {
// onChange!();
// },
  validator: (a){

    return validate(a);

  },
  decoration: InputDecoration(
      suffixIcon: suffix != null?(IconButton(
        onPressed: (){
          suffixPressed!();
        },
        icon: Icon(
            suffix
        ),
      )):null,
      labelText: label,
      labelStyle:  TextStyle(color: Colors.purple[300]),///////////////////////
      prefixIcon: Icon(
          prefix
      ),
      prefixIconColor: Colors.purple[400],
      border:  const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
  borderSide:
  BorderSide(color:Color.fromARGB(255, 167, 47, 236), width: 1))
  ),
);

Widget buildTaskItem(Map model,context)=>  Dismissible(
  key: Key(model['id'].toString()),
  onDismissed: (direction) {
    print("${model["id"]}");
AppCubit.get(context).deleteDataFromDataBase(id: model['id']);
  },
  child:   Container(
    padding: const EdgeInsets.all(0),
    decoration: BoxDecoration(
      border: Border.all(width: 0.5,color: Colors.grey),
      borderRadius: BorderRadius.circular(10)

    ),
    child: Padding(

      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),

      child: ListTile(

        title:  Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text("${model['title']}",style: Theme.of(context).textTheme.bodyText1,),
        ),

        subtitle: Row(
          children: [
            Text("${model['date']} - ",style: const TextStyle(color: Colors.grey)),
            Text("${model['time']}",style: const TextStyle(color: Colors.grey),
      ),
          ],
        ),
          trailing:Row(
          mainAxisSize: MainAxisSize.min,
    children: [
     IconButton(
       onPressed: (){
       AppCubit.get(context).updateDataFromDataBase(status: 'done', id: model['id']);
     }, icon: const Icon(Icons.check_box),color: const Color.fromARGB(255, 167, 47, 236),),
      IconButton(
          onPressed: (){
            AppCubit.get(context).updateDataFromDataBase(status: 'archive', id: model['id']);
            }, icon:  Icon(Icons.archive_outlined,color: Colors.purple[300],)),
    ],    )
      ),
    ),
  ),
);


Widget tasksCondition({required List<Map> tasks}) => ConditionalBuilder(
  condition:tasks.isNotEmpty ,
  builder:(context) {
    return  ListView.separated(
        separatorBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(7),
          child: Container(
            height: 1.0,
            width: double.infinity,),
        ),
        itemBuilder: (context, index) =>buildTaskItem(tasks[index],context,),

        itemCount: tasks.length);
  },
  fallback: (context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,size: 100,color: Colors.grey,),
          Text("There Is No Tasks Yet...",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.grey),)
        ],
      ),
    );
  },

);
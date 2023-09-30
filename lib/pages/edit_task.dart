import 'package:flutter/material.dart';
import '../blocl/cubit.dart';
import '../componants/componants.dart';
class EditPage extends StatefulWidget {


  @override
  State<EditPage> createState() => _EditPageState();

}
class _EditPageState extends State<EditPage> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController  task = TextEditingController();
@override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          elevation: 0.0,
          title: const Text('Edit Task'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 27, horizontal: 15),
              child: Form(
                key: formState,
                child: TextFormField(
                  controller: task,
                  autofocus: true,
                  style: TextStyle(fontSize: 20,),
                  cursorColor: Theme.of(context).primaryColor,
                  decoration: InputDecoration(
                      hintText: "Write Your Task",
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(20)),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(20))),


                ),
              ),
            ),
  ////
            buildEditItem(context ,context)
          ],
        ));
  }

  Widget buildEditItem( model , context)=>  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 35),
    child: Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20)),
      width: double.infinity,
      child: MaterialButton(
        onPressed: (){
          AppCubit.get(context).editDataFromDataBase(id: context['id'],status: 'new');
          Navigator.pop(context);
        },

        child: const Text(
          "Edit Task",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ),
  );
}


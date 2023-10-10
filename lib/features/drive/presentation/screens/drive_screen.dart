import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:login_mobile/features/shared/shared.dart';

class CapyDriveScreen extends StatelessWidget {
  const CapyDriveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('CapyFiles 𐃶'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: const _FilesView(),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('New 𐃶'),
        icon: const Icon(Icons.add),
        onPressed: () {
          _newModal(context);
        },
      ),
    );
  }

  _newModal(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Color.fromARGB(119, 0, 0, 0),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(60.0), topRight: Radius.circular(60.0), ),
        ),
        context: context,
        builder: (context) {
          return Container(
            
            
            height: 150,
            child: Row(
              children: [
                iconTextButton("Folder", Color.fromARGB(255, 255, 255, 255),
                    Icon(Icons.folder), context, (){}),
                iconTextButton("Upload", Color.fromARGB(255, 255, 255, 255),
                    Icon(Icons.file_upload), context, (){})
              ],
            ),
          );
        });
  }

  Widget iconTextButton(
      String name, Color color, Icon icon, BuildContext context, Function function) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Column(
        children: [
          SizedBox(
            height: 40,
          ),
          Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            child: icon,
          ),
          SizedBox(
            height: 10,
          ),
          Text(name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }

 
}

class _FilesView extends StatelessWidget {
  const _FilesView();


  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('CapyFiles View'));
    
  }
}

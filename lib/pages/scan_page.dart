import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_card/models/contact_model.dart';
import 'package:virtual_card/pages/form_page.dart';
import 'package:virtual_card/utils/constants.dart';

class ScanPage extends ConsumerStatefulWidget {
  static const String routeName ='Scan';
  const ScanPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends ConsumerState<ScanPage> {
  bool isScanOver =false;
  List<String> lines =[];
  String name ='',mobile ='',email='',address='',company='',desgnation='',website='',image='';
  
    void createContact (){
   final contact = ContactModel(
  name: name.trim(),
   mobile: mobile.trim(),
   email: email.trim(),
   address: address.trim(),
   company: company.trim(),
   desgnation:  desgnation.trim(),
   website: website.trim(),
   image: image,
   favorite: false
   );
   context.goNamed(FormPage.routeName,extra: contact);
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Page'),
        actions: [
        IconButton(
          onPressed: image.isEmpty?null:createContact,
           icon: const Icon(Icons.arrow_forward),
           ),
        ],
      ),
      body:  ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: (){
                 getImage(ImageSource.camera);
                },
                label: const Text('Capture'),
                 icon: const Icon(Icons.camera),),
                 TextButton.icon(
                onPressed: (){
                  getImage(ImageSource.gallery);
                },
                label: const Text('Gallary'),
                 icon: const Icon(Icons.photo_album),),
            ],
          ),
         if(isScanOver) Card(
            child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Column(
            children: [
            DropTargetItem(property: ContactProperties.name, onDrop: getPropertyValue),
            DropTargetItem(property: ContactProperties.mobile, onDrop: getPropertyValue),
            DropTargetItem(property: ContactProperties.email, onDrop: getPropertyValue),
            DropTargetItem(property: ContactProperties.company, onDrop: getPropertyValue),
            DropTargetItem(property: ContactProperties.desgnation, onDrop: getPropertyValue),
            DropTargetItem(property: ContactProperties.address, onDrop: getPropertyValue),
             DropTargetItem(property: ContactProperties.website, onDrop: getPropertyValue),
            ],
            ),
            
            ),
          ),
        if(isScanOver) const Padding(
        padding: EdgeInsets.all(8.0),
        child:  Text(hint),
        
        ),
          Wrap(
          children: lines.map((line)=>LineItem(line: line,)).toList(),
          )
        ],
      ),
    );
  }
  
  void getImage(ImageSource camera) async{
final xFile=await ImagePicker().pickImage(source: camera,);
if(xFile !=null){
setState(() {
  image = xFile.path;
});
  EasyLoading.show(status: 'Please Wait ...');
 final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
 final recognizedText = await textRecognizer.processImage(InputImage.fromFile(File(xFile.path)));
 EasyLoading.dismiss();
 final tempList =<String> [];
 for(var block in recognizedText.blocks){
  for(var line in block.lines){
    tempList.add(line.text);
  }
 }
 setState(() {
   lines = tempList;
   isScanOver =true;
 });
}
  }

  getPropertyValue(String property, String value) {
  switch (property) {
    case ContactProperties.name:
      name=value;
      break;
      case ContactProperties.mobile:
      mobile=value;
      break;
      case ContactProperties.email:
      email=value;
      break;
      case ContactProperties.address:
      address=value;
      break;
      case ContactProperties.desgnation:
      desgnation=value;
      break;
      case ContactProperties.website:
      website=value;
      break;
      case ContactProperties.company:
      company=value;
      break;
    default:
  }
  }
}

class LineItem extends ConsumerWidget {
  final String line;
  const LineItem( {super.key,required this.line});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LongPressDraggable(
      data: line,
      dragAnchorStrategy: childDragAnchorStrategy,
       feedback: Container(
        key:GlobalKey() ,
        padding: const EdgeInsets.all(8.0),
        decoration:  const BoxDecoration(
        color:Colors.black45
        ),
        child: Text(line,style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),),
       ),
      child: Chip(label: Text(line)),
       );
  }
}

class DropTargetItem extends ConsumerStatefulWidget {
  final String property;
  final Function(String,String) onDrop;
  const DropTargetItem({super.key,required this.property,required this.onDrop});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DropTargetItemState();
}

class _DropTargetItemState extends ConsumerState<DropTargetItem> {
  String dragItem ='';

  @override
  Widget build(BuildContext context) {
    return Row(
    children: [
    Expanded(
    flex: 1,
    child: Text(widget.property),
    ),
    Expanded(
    flex: 2,
    child: DragTarget<String>(
      builder: (c,candidateData,rejectedData)=>Container(
      padding: const EdgeInsets.all(8.0),
      decoration:  BoxDecoration(
      border: candidateData.isNotEmpty?
      Border.all(color: Colors.red,width: 2): null,
      ),
      child: Row(
      children: [
      Expanded(
      child: Text(
        dragItem.isEmpty? 'Drop here': dragItem
        )
      ),
     if(dragItem.isNotEmpty) InkWell(
      onTap: (){
      setState(() {
        dragItem ='';
      });
      },
      child: const Icon(Icons.clear,size: 15.0,)
      )
      ],
      ),

      ),
      onAccept: (value) {
        setState(() {
          if(dragItem.isEmpty){
            dragItem = value;
          }else{
          dragItem += ' $value';
          }
        });
        widget.onDrop(widget.property,dragItem);
      },
      ),
    )
    ],
    );
  }
}
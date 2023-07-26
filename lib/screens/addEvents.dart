import 'dart:io';

import 'package:bitattendance/model/eventData.dart';
import 'package:bitattendance/services/auth.dart';
import 'package:bitattendance/widgets/dateWidget.dart';
import 'package:bitattendance/widgets/loading.dart';
import 'package:bitattendance/widgets/timeWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../services/database_services.dart';

class addEvents extends StatefulWidget {
  const addEvents({super.key});

  @override
  State<addEvents> createState() => _addEventsState();
}

class _addEventsState extends State<addEvents> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  List<String> eventTypeList = [
    "Technical Fest",
    "Cultural Fest",
    "Cavorts",
    "Seminar",
    "Tech Events"
  ];
  late String dropdownValue = eventTypeList.first;
  final formKey = GlobalKey<FormState>();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  List<File> _image = [];
  List<String> _imageUrl = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Create",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.white),
          centerTitle: true,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
        ),
        body: SingleChildScrollView(
          child: (isLoading)
              ? loading()
              : Container(
                  margin: EdgeInsets.all(20),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Event Name",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textField(
                                inputType: TextInputType.multiline,
                                controller: _nameController,
                                maxLine: 1),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Event Description",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textField(
                                inputType: TextInputType.multiline,
                                controller: _descController,
                                maxLine: 4),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  datepickerStart();
                                },
                                child: dateWidget(
                                  title: "Start Date",
                                  date: startDate,
                                )),
                            InkWell(
                                onTap: () {
                                  timepickerStart();
                                },
                                child: timeWidget(
                                  title: "Start Time",
                                  time: startTime,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                                onTap: () {
                                  datepickerEnd();
                                },
                                child: dateWidget(
                                  title: "End Date",
                                  date: endDate,
                                )),
                            InkWell(
                                onTap: () {
                                  timepickerEnd();
                                },
                                child: timeWidget(
                                  title: "End Time",
                                  time: endTime,
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Event Category",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.black26, width: 1)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: dropdownValue,
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  elevation: 16,
                                  style: TextStyle(
                                      color: Colors.black87.withOpacity(0.8),
                                      fontSize: 18),
                                  onChanged: (String? value) {
                                    setState(() {
                                      dropdownValue = value!;
                                    });
                                  },
                                  items: eventTypeList
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Address",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            textField(
                                inputType: TextInputType.multiline,
                                controller: _addressController,
                                maxLine: 3),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Images",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GridView.builder(
                          itemCount: _image.length + 1,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          itemBuilder: ((context, index) {
                            return (index == 0)
                                ? IconButton(
                                    onPressed: () {
                                      showDialogOpt(context);
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      size: 30,
                                    ),
                                  )
                                : Stack(
                                    children: [
                                      Positioned(
                                        top: 25,
                                        right: 25,
                                        child: Container(
                                          height: 95,
                                          width: 95,
                                          child: Image.file(
                                            _image[index - 1],
                                            height: 95,
                                            width: 95,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showSnackbar(
                                                      context,
                                                      Colors.red,
                                                      "Removed image at ${index}");
                                                  _image.removeAt(index - 1);
                                                });
                                              },
                                              icon: InkWell(
                                                onTap: () {},
                                                child: Icon(
                                                  Icons.cancel_outlined,
                                                  size: 35,
                                                  color: Colors.red,
                                                ),
                                              )))
                                    ],
                                  );
                          }),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  _addEventData();
                                },
                                child: Text("Save"))),
                      ],
                    ),
                  ),
                ),
        ));
  }

  Widget textField({
    required TextInputType inputType,
    required TextEditingController controller,
    required int maxLine,
  }) {
    return Padding(
      padding: EdgeInsets.all(0),
      child: TextFormField(
        validator: (val) {
          if (val!.isNotEmpty) {
            return null;
          } else {
            return "Field cannot be empty";
          }
        },
        maxLines: maxLine,
        cursorColor: Colors.purpleAccent,
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
            //helperText: titleText,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black26)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.black26),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.red),
            ),
            border: InputBorder.none),
      ),
    );
  }

  void datepickerStart() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        startDate = value;
      });
    });
  }

  void datepickerEnd() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) return;
      setState(() {
        endDate = value;
      });
    });
  }

  void timepickerStart() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        startTime = value;
      });
    });
  }

  void timepickerEnd() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        endTime = value;
      });
    });
  }

  void pickImage(BuildContext context) async {
    final file = await ImagePicker().pickImage(source: ImageSource.camera);
    File image = File(file!.path);
    File compressedImage = await customCompressed(image);
    setState(() {
      _image.add(compressedImage);
    });
  }

  void pickMultipleImage(BuildContext context) async {
    final file = await ImagePicker().pickMultiImage();
    for (int i = 0; i < file.length; i++) {
      if (file[i] != null) {
        File image = File(file[i].path);
        File compressedImage = await customCompressed(image);
        setState(() {
          _image.add(compressedImage);
        });
      }
    }
  }

  Future<File> customCompressed(File imagePath) async {
    var path = await FlutterNativeImage.compressImage(imagePath.absolute.path,
        quality: 100, percentage: 10);
    return path;
  }

  showDialogOpt(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () {
                    pickImage(context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.camera),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Camera"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    pickMultipleImage(context);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.album),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Gallery"),
                    ],
                  ),
                ),
                SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.close),
                      SizedBox(
                        width: 20,
                      ),
                      Text("Close"),
                    ],
                  ),
                )
              ],
            ));
  }

  _addEventData() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      final ap = Provider.of<AuthProvider>(context, listen: false);
      if (_image == null || _image.length == 0) {
        showSnackbar(context, Colors.red, "Please upload 1 or more images");
        setState(() {
          isLoading = false;
        });
      } else {
        ap.uploadEventPictures(_image).then((value) {
          setState(() {
            _imageUrl = value;
          });
          DatabaseServices(
            uid: FirebaseAuth.instance.currentUser!.uid,
          )
              .savingEventData(EventData(
                  eventId: "",
                  name: _nameController.text.trim(),
                  description: _descController.text.trim(),
                  type: dropdownValue,
                  location: _addressController.text.trim(),
                  endDate: DateFormat.yMd().format(endDate),
                  startDate: DateFormat.yMd().format(startDate),
                  images: _imageUrl,
                  startTime: startTime.format(context),
                  endTime: endTime.format(context),
                  addedBy: ""))
              .whenComplete(() => isLoading = false);
          Navigator.pop(context);
          showSnackbar(context, Colors.green, "Data Uploaded Successfully");
        });
      }
    }
  }
}

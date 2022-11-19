import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginPage.dart';

class NAME extends StatefulWidget {
  const NAME({Key? key}) : super(key: key);

  @override
  State<NAME> createState() => _NAMEState();
}

class _NAMEState extends State<NAME> {
  Position? _position;
  String lat = "0";
  String long = "0";
  _getCurrentLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _position = position;
      lat = _position!.latitude.toString();
      long = _position!.longitude.toString();
    });
    return position;
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future getData(
      String lati, String long, File file, String date, timess) async {
    String urls = "http://192.168.29.247:8000/LocationAdd";
    var body = {
      "latitude": lati,
      "longitude": long,
      "photo": file,
      "date": date,
      "time": timess,
    };

    var request = http.MultipartRequest("POST", Uri.parse(urls));
    request.fields["latitude"] = lati.toString();
    request.fields["longitude"] = long.toString();
    request.fields["employee"] = id.toString();
    request.files.add(http.MultipartFile.fromBytes(
        "photo", File(file!.path).readAsBytesSync(),
        filename: file!.path));
    request.fields["date"] = date.toString();
    request.fields["time"] = timess.toString();
    var res = await request.send();
    if (res.statusCode == 200) {
      final SnackBar _snackBar = SnackBar(
        content: const Text('Attendance Marked'),

      );
      ScaffoldMessenger.of(context).showSnackBar(_snackBar);
      print("sucess");
    }

    //var response = await http.post(Uri.parse(urls),body: jsonEncode(body));

    // if(response.statusCode == 200){
    //   var body = response.body;
    //   // final dataModel = dataModelFromJson(body);
    //   return "";
    // }else{
    //   throw Exception("faild");
    // }
  }

  var name;
  var id;

  getname()async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name =pref.getString("name");
      id = pref.getInt("id");
      print(name);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getname();
    _getCurrentLocation();
  }

  File? image;
  File? im;
  bool isValue = false;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      setState(() {
        this.image = imageTemp;
        im = imageTemp;
        isValue = true;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  todayDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy');
    String formattedTime = DateFormat('kk:mm:a').format(now);
    String formattedDate = formatter.format(now);
    print(formattedTime);
    print(formattedDate);
  }

  logout(String lati, String long, String date, timess) async {
    final url = "http://192.168.29.247:8000/Locationout";

    var body = {
      "latitude": lati,
      "longitude": long,
      "date": date,
      "time": timess,
      "employee":name
    };
    print(body);

    //var response = await http.post(Uri.parse(url),body: jsonEncode(body));
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields["latitude"] = lati.toString();
    request.fields["longitude"] = long.toString();
    request.fields["employee"] = id.toString();
    // request.files.add(http.MultipartFile.fromBytes(
    //     "photo", File(file!.path).readAsBytesSync(),
    //     filename: file!.path));
    request.fields["date"] = date.toString();
    request.fields["time"] = timess.toString();
    var res = await request.send();

    if (res.statusCode == 200) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromRGBO(143, 0, 255, 1),
              Colors.blue,
            ],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: pickImage,
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(2, 2),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromRGBO(143, 0, 255, 1),
                          Colors.blue,
                        ],
                      )),
                  child: Center(
                    child: Text(
                      "Take uplod",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (im == null) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(// is this context <<<
                            SnackBar(content: Text('Please take photo')));
                  } else {
                    var now = new DateTime.now();
                    var formatter = new DateFormat('dd-MM-yyyy');
                    String formattedTime = DateFormat('kk:mm').format(now);
                    String formattedDate = formatter.format(now);
                    print(formattedTime);
                    print(formattedDate);
                    getData(lat, long, im!, formattedDate, formattedTime);
                    print(im);
                  }
                },
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(2, 2),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromRGBO(143, 0, 255, 1),
                          Colors.blue,
                        ],
                      )),
                  child: Center(
                    child: Text(
                      "Attendance",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                " location",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "latitude ${lat} ",
                style: TextStyle(color: Colors.white),
              ),
              Text(
                "longitude ${long}",
                style: TextStyle(color: Colors.white),
              ),
              isValue == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 120,
                          child: Image.file(image!),
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                isValue = false;
                              });
                            },
                            child: Icon(Icons.restart_alt))
                      ],
                    )
                  : Container(),
              SizedBox(
                height: 25,
              ),
              InkWell(
                onTap: () {
                  var now = new DateTime.now();
                  var formatter = new DateFormat('dd-MM-yyyy');
                  String formattedTime = DateFormat('kk:mm').format(now);
                  String formattedDate = formatter.format(now);
                  print(formattedTime);
                  print(formattedDate);
                  logout(lat, long, formattedDate, formattedTime);
                },
                child: Container(
                  height: 50,
                  width: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.white,
                            offset: Offset(2, 2),
                            spreadRadius: 1,
                            blurRadius: 1)
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Color.fromRGBO(143, 0, 255, 1),
                          Colors.blue,
                        ],
                      )),
                  child: Center(
                    child: Text(
                      "Log out",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

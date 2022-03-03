import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning_dio/api/api_interface.dart';
import 'package:flutter_learning_dio/services/dio_services.dart';
import 'package:flutter_learning_dio/utils/helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_learning_dio/screens/home_screen/components/background.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final imageUrl = "https://unsplash.com/photos/iEJVyyevw-U/download?force=true";
  bool downloading = false;
  var progressString = "0%";
  ApiCallObject apiCallObject = ApiCallObject();

  // DioClient dioClient = DioClient();

  Future<void> downloadFile() async {
    Dio dio = Dio();
    progressString = "0%";

    try {
      var dir = await getApplicationDocumentsDirectory();
      print("Directory found ${dir.path}/myimage.jpg");
      Helper.toast(context, "Directory found");

      setState(() {
        downloading = true;
      });
      await dio.download(
        imageUrl,
        "${dir.path}/myimage.jpg",
        onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        },
      );
    } catch (e) {
      setState(() {
        downloading = false;
      });
      print("Something went wrong");
      Helper.toast(context, "Something went wrong");
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
      Helper.toast(context, "Download Completed", 4, Colors.green);
    });
    print("Download completed");
  }

  Future<void> getApiData() async {
    // Dio dio = Dio();
    // final response = await dio.get("https://reqres.in/api/users?page=2");
    // print(response);

    print("step 11");

    showLoading();
    try {
      // final data = await apiCallObject.getData("/users?page=2");
      final data = await apiCallObject.getTestList("/testList");
      Navigator.pop(context);
      print("step 14");
      // print(data.statusCode);
      // print(data.statusMessage);
      // showToast(data.statusMessage.toString());
      print(data);

    } on Exception catch(error) {

      print(error);
      showToast(error.toString());
      Navigator.pop(context);
    }
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void showToast(String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.green,
      dismissDirection: DismissDirection.horizontal,
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: 'UNDO',
        onPressed: scaffold.hideCurrentSnackBar,
        textColor: Colors.white,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: Container(
        height: size.height,
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: downloading
                  ? Container(
                      height: 120.0,
                      width: 200.0,
                      child: Card(
                        color: Colors.black,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CircularProgressIndicator(),
                            SizedBox(
                              height: 20.0,
                            ),
                            Text(
                              "Downloading File: $progressString",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Data"),
                        ElevatedButton(
                          onPressed: () {
                            getApiData();
                            print("DIO GET API Called");
                          },
                          child: Text("GET"),
                        ),
                      ],
                    ),
            ),
            Positioned(
              bottom: 16,
              right: 8,
              child: ElevatedButton(
                onPressed: () {
                  Helper.toast(context, "starting...");
                  downloadFile();
                },
                child: Icon(Icons.download),
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

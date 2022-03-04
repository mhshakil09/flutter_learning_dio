import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_learning_dio/api/api_interface.dart';
import 'package:flutter_learning_dio/services/dio_services.dart';
import 'package:flutter_learning_dio/utils/helper.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    } on Exception catch (error) {
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
        label: 'dismiss',
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
                        Slidable(
                            // Specify a key if the Slidable is dismissible.
                            key: const ValueKey(0),

                            // The start action pane is the one at the left or the top side.
                            startActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),

                              // A pane can dismiss the Slidable.
                              dismissible: DismissiblePane(onDismissed: () {}),

                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: (context) {
                                    showToast("Delete");
                                    },
                                  backgroundColor: Color(0xFFFE4A49),
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                                SlidableAction(
                                  onPressed: (context) {
                                    showToast("Share");
                                    },
                                  backgroundColor: Color(0xFF21B7CA),
                                  foregroundColor: Colors.white,
                                  icon: Icons.share,
                                  label: 'Share',
                                ),
                              ],
                            ),

                            // The end action pane is the one at the right or the bottom side.
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  // An action can be bigger than the others.
                                  flex: 2,
                                  onPressed: (context) {
                                    showToast("Archive");
                                  },
                                  backgroundColor: Color(0xFF7BC043),
                                  foregroundColor: Colors.white,
                                  icon: Icons.archive,
                                  label: 'Archive',
                                ),
                                SlidableAction(
                                  flex: 2,
                                  onPressed: (context) {
                                    showToast("Saved");
                                  },
                                  backgroundColor: Color(0xFF0392CF),
                                  foregroundColor: Colors.white,
                                  icon: Icons.save,
                                  label: 'Save',
                                ),
                              ],
                            ),

                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: Center(
                              child: Container(
                                height: 50,
                                width: 400,
                                color: Colors.green,
                                child: Center(
                                  child: Text(
                                    "test",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),),
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

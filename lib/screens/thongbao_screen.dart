import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/constant/double_x.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/thongbao_model.dart';
import 'package:loginapp/screens/detail_baiviet.dart';

class NotificationScreen extends StatefulWidget {
  final String userID;
  NotificationScreen({Key? key, required this.userID}) : super(key: key);
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List<NotificationModel> notifications = [];
  NotificationApi notificationApi = NotificationApi();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      List<NotificationModel> fetchedNotifications =
          await notificationApi.getNotifications(widget.userID);
      setState(() {
        notifications = fetchedNotifications;
      });
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        title: Text('Thông báo'),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Text('Không có thông báo.'),
            )
          : ListView.builder(
            padding: EdgeInsets.all(8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                String content = notifications[index].content;
                int indexDa = content.indexOf('đã');

                String beforeDa = content.substring(0, indexDa);
                String afterDa = content.substring(indexDa);

                bool containsThich = content.toLowerCase().contains('thích');
                
                return Padding(
                  padding: EdgeInsets.all(5),
                  child: InkWell(
                    onTap: (){
                       Navigator.push(
    context,
    MaterialPageRoute(builder: (context) =>  DetailBaiViet(baivietID:notifications[index].baivietId ,userID: notifications[index].userId )),
  );
                    },
                    child: Container(
                      child: Row(
                        children: [
                          Stack(
                            children: [
                              SizedBox(
                                width: DoubleX.kSizeLarge_1XXX,
                                height: DoubleX.kSizeLarge_1XXX,
                                child: CircleAvatar(
                                  backgroundColor: ColorConst.colorPrimary,
                                  child: Text(
                                    beforeDa.substring(0, 1),
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              if (containsThich)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Icon(Icons.favorite, color: Colors.red),
                                ),
                              if (!containsThich)
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Icon(Icons.comment, color: Colors.blue),
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width/1.4,
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: ColorConst.colorBackgroundGray,
                              ),
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: beforeDa,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 17,
                                      ),
                                    ),
                                    TextSpan(
                                      text: afterDa,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

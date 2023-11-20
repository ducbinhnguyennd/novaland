import 'package:flutter/material.dart';
import 'package:loginapp/constant/colors_const.dart';
import 'package:loginapp/getapi/trangchuapi.dart';
import 'package:loginapp/model/bangtin_model.dart';

class CommentScreen extends StatefulWidget {
  final List<Comment> comments;
  final String baivietID;
  final String userID;
  CommentScreen(
      {required this.comments, required this.baivietID, required this.userID});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController _commentController = TextEditingController();
  ApiSCommentBaiDang _apiService = ApiSCommentBaiDang();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConst.colorPrimary50,
        title: Text('Danh sách bình luận'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.comments[index].username ?? ''),
                  subtitle: Text(widget.comments[index].content ?? ''),
                  trailing: widget.comments[index].userId == widget.userID
                      ? IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            XoaCommentBaiDang.xoaComment(
                                    widget.comments[index].id ?? '',
                                    widget.baivietID,
                                    widget.userID)
                                .then((_) {
                              setState(() {
                                widget.comments.removeWhere(
                                    (comment) => comment.id == widget.comments);
                              });
                            });
                          },
                        )
                      : null,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Nhập bình luận...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _postComment();
                    Navigator.pop(context,true);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _postComment() {
    String baivietId = widget.baivietID;
    String userId = widget.userID;
    String comment = _commentController.text.trim();

    if (comment.isNotEmpty) {
      _apiService.postComment(baivietId, userId, comment).then((_) {
        _commentController.clear();
      });
    }
  }
}

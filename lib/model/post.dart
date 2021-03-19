class Post {
  final String body;
  final String title;
  final int postId;
  final int userId;

  Post({this.body, this.title, this.postId, this.userId});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      body: json["body"],
      title: json["title"],
      postId: json["id"],
      userId: json["userId"],
    );
  }
}

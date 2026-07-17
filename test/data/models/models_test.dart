import 'package:flutter_test/flutter_test.dart';
import 'package:posts_explorer/data/models/comment.dart';
import 'package:posts_explorer/data/models/post.dart';

void main() {
  group('Post', () {
    const json = {'userId': 1, 'id': 2, 'title': 'Title', 'body': 'Body'};

    test('serializes in both directions', () {
      expect(Post.fromJson(json).toJson(), json);
    });

    test('copies selected values and supports value equality', () {
      final post = Post.fromJson(json);

      expect(post.copyWith(title: 'Updated'), post.copyWith(title: 'Updated'));
      expect(post.copyWith(title: 'Updated').title, 'Updated');
      expect(post.copyWith(title: 'Updated').body, post.body);
    });
  });

  group('Comment', () {
    const json = {
      'postId': 1,
      'id': 2,
      'name': 'Name',
      'email': 'name@example.com',
      'body': 'Body',
    };

    test('serializes in both directions', () {
      expect(Comment.fromJson(json).toJson(), json);
    });

    test('copies selected values and supports value equality', () {
      final comment = Comment.fromJson(json);

      expect(
        comment.copyWith(email: 'new@example.com'),
        comment.copyWith(email: 'new@example.com'),
      );
      expect(comment.copyWith(name: 'Updated').name, 'Updated');
      expect(comment.copyWith(name: 'Updated').body, comment.body);
    });
  });
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:post_http_example/post_model.dart';

class PostRepository{
  final http.Client client;
  PostRepository(this.client);

  Future<Post> getPost(int id) async {
    final response = await client.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$id'),
    );
    if (response.statusCode == 200){
    return Post.fromMap(jsonDecode(response.body));
    }
    throw Exception('Erro ao buscar post');
  }

  Future<List<Post>> getPosts() async {
  final response = await client.get(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((post) => Post.fromMap(post)).toList();
  }
  throw Exception('Erro ao buscar posts');
  }

  Future<Post> createPost(Post post) async {
  final response = await client.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(post.toMap()),
  );
  if (response.statusCode == 201) {
    return Post.fromMap(jsonDecode(response.body));
  }
  throw Exception('Erro ao criar post');
}
}
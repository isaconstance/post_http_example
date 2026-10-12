import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:post_http_example/post_model.dart';
import 'package:post_http_example/post_repository.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  late MockHttpClient mockHttpClient;
  late PostRepository postRepository;

  setUp(() {
    mockHttpClient = MockHttpClient();
    postRepository = PostRepository(mockHttpClient);
  });

  group('getPost', () {
    test('Deve retornar um post quando o status for 200', () async {
      // Arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
        ),
      ).thenAnswer(
        (_) async =>
            Response('{"id": 1, "title": "Titulo", "body": "Texto"}', 200),
      );

      // Act
      final post = await postRepository.getPost(1);

      // Assert
      expect(post, isA<Post>());
    });

    test('Deve lançar uma exeção quando o status for 404', () async {
      // Arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts/1'),
        ),
      ).thenAnswer((_) async => Response('Not Found', 404));

      // Act & Assert
      expect(() async => await postRepository.getPost(1), throwsException);
    });
  });

  group('getPosts', () {
    test('Deve retornar uma lista com 2 posts quando o status for 200', () async {
      // Arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        ),
      ).thenAnswer(
        (_) async => Response(
          '[{"id": 1, "title": "A", "body": "a"}, {"id": 2, "title": "B", "body": "b"}]',
          200,
        ),
      );

      // Act
      final posts = await postRepository.getPosts();

      // Assert
      expect(posts.length, 2);
      expect(posts.first, isA<Post>());
    });

    test('Deve retornar lista vazia quando a API devolve []', () async {
      // Arrange
      when(
        () => mockHttpClient.get(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        ),
      ).thenAnswer((_) async => Response('[]', 200));

      // Act
      final posts = await postRepository.getPosts();

      // Assert
      expect(posts, isEmpty);
    });
  });

  group('createPost', () {
    test('Deve retornar o post criado quando o status for 201', () async {
      // Arrange
      final novoPost = Post(id: 101, title: 'Novo', body: 'Corpo');
      when(
        () => mockHttpClient.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer(
        (_) async =>
            Response('{"id": 101, "title": "Novo", "body": "Corpo"}', 201),
      );

      // Act
      final post = await postRepository.createPost(novoPost);

      // Assert
      expect(post, novoPost);
      verify(
        () => mockHttpClient.post(
          Uri.parse('https://jsonplaceholder.typicode.com/posts'),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).called(1);
    });
  });
}

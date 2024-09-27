import 'package:elearning/app/services/user_details_api_client.dart';
import 'package:elearning/app/modules/ui/pages/videos.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class DatabaseHelper {
  late Database _database;
  DatabaseHelper();

  Future<void> openDatabase() async {
    _database = await _openDatabaseHelper();
  }

  Future<Database> _openDatabaseHelper() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = appDocumentDir.path + '/e_learning.db';
    final database = await databaseFactoryIo.openDatabase(dbPath);
    return database;
  }

  Future<void> initialize() async {
    await openDatabase();
  }

  Future<void> insertUser(User user) async {
    final store = intMapStoreFactory.store('users');
    await _database.transaction((txn) async {
      await store.record(user.id).put(txn, user.toMap());
      print('User inserted into cache: ${user.toMap()}');
    });
  }

  Future<List<User>> getUsers() async {
    final store = intMapStoreFactory.store('users');
    final finder = Finder();
    final records = await store.find(_database, finder: finder);
    return records.map((record) => User.fromJson(record.value)).toList();
  }

  Future<void> insertCourse(dynamic course) async {
    final store = intMapStoreFactory.store('courses');
    await _database.transaction((txn) async {
      final courseId = int.parse(course['id'].toString());
      await store.record(courseId).put(txn, course);
      print('Course inserted into cache: $course');
    });
  }

  Future<List<dynamic>> getCourses() async {
    final store = intMapStoreFactory.store('courses');
    final finder = Finder();
    final records = await store.find(_database, finder: finder);
    return records.map((record) => record.value).toList();
  }

  Future<void> insertVideos(String className, List<Video> videos) async {
    try {
      await initialize(); // Make sure the database is initialized
      final List<Map<String, dynamic>> videosJsonList =
          videos.map((video) => video.toJson()).toList();

      final store = intMapStoreFactory.store('videos');
      await _database.transaction((txn) async {
        for (final videoJson in videosJsonList) {
          final videoId = videoJson['id'] as int;
          await store.record(videoId).put(txn, {
            'className': className,
            'video': videoJson,
          });
          print('Video inserted into cache for class $className:');
          print('Video ID: ${videoJson['id']}');
          print('Video Subject: ${videoJson['video_subject']}');
          print('Video Date: ${videoJson['video_date']}');
          // Add more details as needed
        }
        print('Videos inserted into cache for class $className');
      });
    } catch (e) {
      print('Failed to insert videos into cache: $e');
    }
  }

  Future<List<Video>> getVideosByClass(String className) async {
    try {
      await initialize(); // Make sure the database is initialized
      final store = intMapStoreFactory.store('videos');
      final finder = Finder(filter: Filter.equals('className', className));
      final records = await store.find(_database, finder: finder);
      return records.map((record) {
        final videoJson = record['video'] as Map<String, dynamic>;
        return Video.fromJson(videoJson);
      }).toList();
    } catch (e) {
      print('Failed to get videos from cache: $e');
      return [];
    }
  }
}

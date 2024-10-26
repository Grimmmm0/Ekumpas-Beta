import 'package:realm/realm.dart';
import 'package:ekumpas_beta/realm/schema.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io'; // For checking internet connection

class RealmServices {
  RealmServices._(); // Private constructor
  static final RealmServices instance = RealmServices._();
  late final Realm realm;
  late final mongo.Db mongoDb;
  late final User currentUser;
  late final Configuration realmConfig; // Store configuration separately
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize Realm and MongoDB services
  Future<void> initializeRealm() async {
    if (!_isInitialized) {
      final app = App(AppConfiguration("ekumpas-xxlkdja"));

      try {
        final prefs = await SharedPreferences.getInstance();
        final savedUserId = prefs.getString('realmUserId');

        // Check if there is an already logged-in user
        if (app.currentUser != null && app.currentUser?.id == savedUserId) {
          currentUser = app.currentUser!;
          print("Using the saved user ID: ${currentUser.id}");
        } else {
          // Log in as an anonymous user if no current user or saved ID
          currentUser = await app.logIn(Credentials.anonymous());
          await prefs.setString('realmUserId', currentUser.id); // Save user ID
          print("Logged in anonymously, user ID: ${currentUser.id}");
        }

        // Configure Realm with Flexible Sync
        realmConfig = Configuration.flexibleSync(currentUser, [
          SignLanguage.schema,
          Favorite.schema,
          Feedback.schema,
          Updates.schema,
        ]);
        realm = Realm(realmConfig);

        realm.subscriptions.update((mutableSubscriptions) {
          mutableSubscriptions.add(realm.all<SignLanguage>());
          mutableSubscriptions.add(realm.all<Favorite>());
          mutableSubscriptions.add(realm.all<Feedback>());
          mutableSubscriptions.add(realm.all<Updates>());
        });

        // Check for internet connection before attempting to sync
        if (await _hasInternetConnection()) {
          await realm.subscriptions.waitForSynchronization();
          print("Realm synchronized successfully.");
        } else {
          print("No internet connection, skipping Realm sync.");
        }

        // MongoDB connection initialization
        if (await _hasInternetConnection()) {
          mongoDb = await mongo.Db.create(
              'mongodb+srv://admin:powerpupbois@cluster0.uriyxxs.mongodb.net/ekumpas?retryWrites=true&w=majority&appName=Cluster0');
          await mongoDb.open();
          print("MongoDB connected.");
        } else {
          print("No internet connection, skipping MongoDB connection.");
        }

        _isInitialized = true;
        print("Realm initialized successfully.");
      } catch (e) {
        print('Error during Realm initialization: $e');
        if (e.toString().contains("ProtocolErrorCode=208")) {
          await wipeRealmFile(); // Handle sync issues
        }
      }
    } else {
      print("RealmServices already initialized.");
    }
  }

  // Function to wipe Realm file when sync issues arise
  Future<void> wipeRealmFile() async {
    try {
      Realm.deleteRealm(realmConfig.path);
      print('Realm file wiped successfully.');

      // Reinitialize Realm
      await initializeRealm();
    } catch (e) {
      print('Error wiping Realm file: $e');
    }
  }

  // Get all SignLanguage data from Realm
  List<SignLanguage> getSignLanguage() {
    _ensureInitialized();
    return realm.all<SignLanguage>().toList();
  }

  // Fetch video data from MongoDB GridFS
  Future<List<int>> fetchVideoData(String filename) async {
    _ensureInitialized();
    final gridFS = mongo.GridFS(mongoDb, "uploads");
    final file =
        await gridFS.files.findOne(mongo.where.eq("filename", filename));

    if (file != null) {
      final chunks = gridFS.chunks
          .find(mongo.where.eq("files_id", file['_id']).sortBy("n"));
      final videoData = <int>[];
      await for (final chunk in chunks) {
        videoData.addAll(chunk['data'].byteList);
      }
      return videoData;
    }
    return [];
  }

  // Update frequency of SignLanguage usage
  Future<void> updateFrequency(String title) async {
    _ensureInitialized();
    final signLanguages = realm.all<SignLanguage>();
    final signLanguage = signLanguages
        .where((sl) => sl.title.toLowerCase() == title.toLowerCase())
        .firstOrNull;

    if (signLanguage != null) {
      await realm.write(() {
        signLanguage.frequency++;
      });
    }
  }

  // Get list of favorites for a given user email
  List<SignLanguage> getFavorites(String email) {
    _ensureInitialized();
    final favoriteIds = realm
        .all<Favorite>()
        .where((f) => f.userId == email)
        .map((f) => f.signLanguageId)
        .toList();
    return realm
        .all<SignLanguage>()
        .where((sl) => favoriteIds.contains(sl.id.toString()))
        .toList();
  }

// Get all Updates data from Realm
  List<Updates> getUpdates() {
    _ensureInitialized();
    return realm.all<Updates>().toList();
  }

  // Toggle a SignLanguage as favorite/unfavorite for a user
  Future<void> toggleFavorite(SignLanguage signLanguage, String email) async {
    _ensureInitialized();
    final favorite = realm
        .all<Favorite>()
        .where((f) =>
            f.userId == email && f.signLanguageId == signLanguage.id.toString())
        .firstOrNull;
    await realm.write(() {
      if (favorite != null) {
        realm.delete(favorite);
      } else {
        realm.add(Favorite(ObjectId(), email, signLanguage.id.toString()));
      }
    });
  }

  // Log out the current user
  Future<void> logOut() async {
    try {
      await currentUser.logOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('realmUserId');
      _isInitialized = false;
      print('Logged out successfully.');
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Submit user feedback to MongoDB via Realm
  Future<void> submitFeedback(
      String email, String subject, String feedback, double rating) async {
    _ensureInitialized();
    print(
        'Submitting feedback: email=$email, subject=$subject, feedback=$feedback, rating=$rating');
    await realm.write(() {
      realm.add(Feedback(
        ObjectId(),
        email,
        subject,
        feedback,
        rating,
        DateTime.now(),
      ));
    });
    print('Feedback submitted successfully.');
  }

  // Close Realm and MongoDB connections
  void dispose() {
    if (_isInitialized) {
      realm.close();
      mongoDb.close();
      _isInitialized = false;
      print('Realm and MongoDB connections closed.');
    }
  }

  // Ensure that RealmServices is initialized before performing operations
  void _ensureInitialized() {
    if (!_isInitialized) {
      throw Exception(
          'RealmServices not initialized. Call initializeRealm() first.');
    }
  }

  // Function to check for an internet connection
  Future<bool> _hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}

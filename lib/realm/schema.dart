import 'package:realm/realm.dart';

part 'schema.realm.dart';

@RealmModel()
@MapTo('sign languages')
class _SignLanguage {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String title;
  late String description;
  late String category;
  late String video;
  late DateTime createdAt;
  late DateTime updatedAt;
  late int frequency;
}


@RealmModel()
@MapTo('favorites')
class _Favorite {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String userId;
  late String signLanguageId;
}

@RealmModel()
@MapTo('feedbacks')
class _Feedback {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String email;
  late String subject;
  late String feedback;
  late double rating;
  late DateTime createdAt;
  
}

@RealmModel()
@MapTo('updates')
class _Updates {
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId id;
  late String title;
  late String description;
  late String link;
  late DateTime createdAt;
  late DateTime updatedAt;
}
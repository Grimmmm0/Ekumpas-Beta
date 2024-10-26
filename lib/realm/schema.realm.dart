// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schema.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class SignLanguage extends _SignLanguage
    with RealmEntity, RealmObjectBase, RealmObject {
  SignLanguage(
    ObjectId id,
    String title,
    String description,
    String category,
    String video,
    DateTime createdAt,
    DateTime updatedAt,
    int frequency,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'category', category);
    RealmObjectBase.set(this, 'video', video);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'frequency', frequency);
  }

  SignLanguage._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get category =>
      RealmObjectBase.get<String>(this, 'category') as String;
  @override
  set category(String value) => RealmObjectBase.set(this, 'category', value);

  @override
  String get video => RealmObjectBase.get<String>(this, 'video') as String;
  @override
  set video(String value) => RealmObjectBase.set(this, 'video', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime;
  @override
  set updatedAt(DateTime value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  int get frequency => RealmObjectBase.get<int>(this, 'frequency') as int;
  @override
  set frequency(int value) => RealmObjectBase.set(this, 'frequency', value);

  @override
  Stream<RealmObjectChanges<SignLanguage>> get changes =>
      RealmObjectBase.getChanges<SignLanguage>(this);

  @override
  Stream<RealmObjectChanges<SignLanguage>> changesFor(
          [List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<SignLanguage>(this, keyPaths);

  @override
  SignLanguage freeze() => RealmObjectBase.freezeObject<SignLanguage>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'title': title.toEJson(),
      'description': description.toEJson(),
      'category': category.toEJson(),
      'video': video.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
      'frequency': frequency.toEJson(),
    };
  }

  static EJsonValue _toEJson(SignLanguage value) => value.toEJson();
  static SignLanguage _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'title': EJsonValue title,
        'description': EJsonValue description,
        'category': EJsonValue category,
        'video': EJsonValue video,
        'createdAt': EJsonValue createdAt,
        'updatedAt': EJsonValue updatedAt,
        'frequency': EJsonValue frequency,
      } =>
        SignLanguage(
          fromEJson(id),
          fromEJson(title),
          fromEJson(description),
          fromEJson(category),
          fromEJson(video),
          fromEJson(createdAt),
          fromEJson(updatedAt),
          fromEJson(frequency),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(SignLanguage._);
    register(_toEJson, _fromEJson);
    return SchemaObject(
        ObjectType.realmObject, SignLanguage, 'sign languages', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('category', RealmPropertyType.string),
      SchemaProperty('video', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp),
      SchemaProperty('frequency', RealmPropertyType.int),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Favorite extends _Favorite
    with RealmEntity, RealmObjectBase, RealmObject {
  Favorite(
    ObjectId id,
    String userId,
    String signLanguageId,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'signLanguageId', signLanguageId);
  }

  Favorite._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;
  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  String get signLanguageId =>
      RealmObjectBase.get<String>(this, 'signLanguageId') as String;
  @override
  set signLanguageId(String value) =>
      RealmObjectBase.set(this, 'signLanguageId', value);

  @override
  Stream<RealmObjectChanges<Favorite>> get changes =>
      RealmObjectBase.getChanges<Favorite>(this);

  @override
  Stream<RealmObjectChanges<Favorite>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Favorite>(this, keyPaths);

  @override
  Favorite freeze() => RealmObjectBase.freezeObject<Favorite>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'userId': userId.toEJson(),
      'signLanguageId': signLanguageId.toEJson(),
    };
  }

  static EJsonValue _toEJson(Favorite value) => value.toEJson();
  static Favorite _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'userId': EJsonValue userId,
        'signLanguageId': EJsonValue signLanguageId,
      } =>
        Favorite(
          fromEJson(id),
          fromEJson(userId),
          fromEJson(signLanguageId),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Favorite._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Favorite, 'favorites', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('signLanguageId', RealmPropertyType.string),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Feedback extends _Feedback
    with RealmEntity, RealmObjectBase, RealmObject {
  Feedback(
    ObjectId id,
    String email,
    String subject,
    String feedback,
    double rating,
    DateTime createdAt,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'subject', subject);
    RealmObjectBase.set(this, 'feedback', feedback);
    RealmObjectBase.set(this, 'rating', rating);
    RealmObjectBase.set(this, 'createdAt', createdAt);
  }

  Feedback._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;
  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get subject => RealmObjectBase.get<String>(this, 'subject') as String;
  @override
  set subject(String value) => RealmObjectBase.set(this, 'subject', value);

  @override
  String get feedback =>
      RealmObjectBase.get<String>(this, 'feedback') as String;
  @override
  set feedback(String value) => RealmObjectBase.set(this, 'feedback', value);

  @override
  double get rating => RealmObjectBase.get<double>(this, 'rating') as double;
  @override
  set rating(double value) => RealmObjectBase.set(this, 'rating', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  Stream<RealmObjectChanges<Feedback>> get changes =>
      RealmObjectBase.getChanges<Feedback>(this);

  @override
  Stream<RealmObjectChanges<Feedback>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Feedback>(this, keyPaths);

  @override
  Feedback freeze() => RealmObjectBase.freezeObject<Feedback>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'email': email.toEJson(),
      'subject': subject.toEJson(),
      'feedback': feedback.toEJson(),
      'rating': rating.toEJson(),
      'createdAt': createdAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Feedback value) => value.toEJson();
  static Feedback _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'email': EJsonValue email,
        'subject': EJsonValue subject,
        'feedback': EJsonValue feedback,
        'rating': EJsonValue rating,
        'createdAt': EJsonValue createdAt,
      } =>
        Feedback(
          fromEJson(id),
          fromEJson(email),
          fromEJson(subject),
          fromEJson(feedback),
          fromEJson(rating),
          fromEJson(createdAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Feedback._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Feedback, 'feedbacks', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('subject', RealmPropertyType.string),
      SchemaProperty('feedback', RealmPropertyType.string),
      SchemaProperty('rating', RealmPropertyType.double),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

class Updates extends _Updates with RealmEntity, RealmObjectBase, RealmObject {
  Updates(
    ObjectId id,
    String title,
    String description,
    String link,
    DateTime createdAt,
    DateTime updatedAt,
  ) {
    RealmObjectBase.set(this, '_id', id);
    RealmObjectBase.set(this, 'title', title);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'link', link);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
  }

  Updates._();

  @override
  ObjectId get id => RealmObjectBase.get<ObjectId>(this, '_id') as ObjectId;
  @override
  set id(ObjectId value) => RealmObjectBase.set(this, '_id', value);

  @override
  String get title => RealmObjectBase.get<String>(this, 'title') as String;
  @override
  set title(String value) => RealmObjectBase.set(this, 'title', value);

  @override
  String get description =>
      RealmObjectBase.get<String>(this, 'description') as String;
  @override
  set description(String value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String get link => RealmObjectBase.get<String>(this, 'link') as String;
  @override
  set link(String value) => RealmObjectBase.set(this, 'link', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;
  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime;
  @override
  set updatedAt(DateTime value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  Stream<RealmObjectChanges<Updates>> get changes =>
      RealmObjectBase.getChanges<Updates>(this);

  @override
  Stream<RealmObjectChanges<Updates>> changesFor([List<String>? keyPaths]) =>
      RealmObjectBase.getChangesFor<Updates>(this, keyPaths);

  @override
  Updates freeze() => RealmObjectBase.freezeObject<Updates>(this);

  EJsonValue toEJson() {
    return <String, dynamic>{
      '_id': id.toEJson(),
      'title': title.toEJson(),
      'description': description.toEJson(),
      'link': link.toEJson(),
      'createdAt': createdAt.toEJson(),
      'updatedAt': updatedAt.toEJson(),
    };
  }

  static EJsonValue _toEJson(Updates value) => value.toEJson();
  static Updates _fromEJson(EJsonValue ejson) {
    return switch (ejson) {
      {
        '_id': EJsonValue id,
        'title': EJsonValue title,
        'description': EJsonValue description,
        'link': EJsonValue link,
        'createdAt': EJsonValue createdAt,
        'updatedAt': EJsonValue updatedAt,
      } =>
        Updates(
          fromEJson(id),
          fromEJson(title),
          fromEJson(description),
          fromEJson(link),
          fromEJson(createdAt),
          fromEJson(updatedAt),
        ),
      _ => raiseInvalidEJson(ejson),
    };
  }

  static final schema = () {
    RealmObjectBase.registerFactory(Updates._);
    register(_toEJson, _fromEJson);
    return SchemaObject(ObjectType.realmObject, Updates, 'updates', [
      SchemaProperty('id', RealmPropertyType.objectid,
          mapTo: '_id', primaryKey: true),
      SchemaProperty('title', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string),
      SchemaProperty('link', RealmPropertyType.string),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp),
    ]);
  }();

  @override
  SchemaObject get objectSchema => RealmObjectBase.getSchema(this) ?? schema;
}

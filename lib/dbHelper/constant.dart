const MONGO_CONN_URL = "mongodb://192.168.0.69:27017/tons_de_beleza";
const USER_COLLECTION = "usuario";
const DB_NAME = "tons_de_beleza";



// import 'package:mongo_dart/mongo_dart.dart';

// class MongoDB {
//   static var db, userCollection;
//   static connect() async{
//      try {
//     var db = await Db.create('$dbUrl/$dbName');
//     await db.open();
//     print('Conectado ao MongoDB');
//      }
//   }
  // static Db? _db;
  // static const String _dbUrl = 'mongodb://localhost:27017';
  // static const String _dbName = 'tons_de_beleza';

  // static Future<void> connect() async {
  //   try {
  //     _db = await Db.create('$_dbUrl/$_dbName');
  //     await _db?.open();
  //     print('Conectado ao MongoDB');
  //   } catch (e) {
  //     print('Erro ao conectar ao MongoDB: $e');
  //   }
  // }

  // static Future<void> close() async {
  //   await _db?.close();
  //   print('Conexão com MongoDB fechada');
  // }

  // static DbCollection getCollection(String collectionName) {
  //   if (_db == null) {
  //     throw Exception('Conexão com MongoDB não estabelecida');
  //   }
  //   return _db!.collection(collectionName);
  // }


import 'package:mongo_dart/mongo_dart.dart';
import 'package:projeto_quinto_semestre/dbHelper/constant.dart';

class MongoDB {
  
  static var db, userCollection;
  static connect() async {
    try {
      var db = await Db.create(MONGO_CONN_URL);
      await db.open();
      userCollection = db.collection(USER_COLLECTION);
      print('Conectado ao MongoDB');
    } catch (e) {
      print('Erro ao conectar ao MongoDB: $e');
    }
  }
}

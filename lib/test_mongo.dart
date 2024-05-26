import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  const String dbUrl = 'mongodb://localhost:27017';
  const String dbName = 'tons_de_beleza';

  try {
    var db = await Db.create('$dbUrl/$dbName');
    await db.open();
    print('Conectado ao MongoDB');
    await db.close();
    print('Conexão com MongoDB fechada');
  } catch (e) {
    print('Erro ao conectar ao MongoDB: $e');
  }
}

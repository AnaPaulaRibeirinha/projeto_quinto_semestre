const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

// Middlewares
app.use(bodyParser.json());
app.use(cors());

// Conexão com o MongoDB
mongoose.connect('mongodb://192.168.0.69:27017/tons_de_beleza', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('MONGODB Conectado!');
}).catch(err => {
  console.error('Erro de conexão com o MongoDB', err);
});

// Definindo um modelo de exemplo
// const ItemSchema = new mongoose.Schema({
//   name: String,
//   description: String
// });

// const Item = mongoose.model('Item', ItemSchema);

// Rota para obter todos os itens
// app.get('/items', async (req, res) => {
//   try {
//     const items = await Item.find();
//     res.json(items);
//   } catch (err) {
//     res.status(500).send(err);
//   }
// });

// Rota para adicionar um novo item
// app.post('/items', async (req, res) => {
//   const newItem = new Item(req.body);
//   try {
//     const savedItem = await newItem.save();
//     res.status(201).json(savedItem);
//   } catch (err) {
//     res.status(400).send(err);
//   }
// });

// Definindo o modelo de usuário
const UsuarioSchema = new mongoose.Schema({
    nome: String,
    sobrenome: String,
    email: String,
    genero: String,
    senha: String
  }, { collection: 'usuario' });
  
  UsuarioSchema.set('toJSON', {
    transform: (doc, ret, options) => {
      delete ret.__v;
      return ret;
    }
  });
  
  const Usuario = mongoose.model('Usuario', UsuarioSchema);
  
  // Rota para adicionar um novo usuário
  app.post('/usuarios', async (req, res) => {
    const { nome, sobrenome, email, genero, senha } = req.body;
  
    const novoUsuario = new Usuario({
      nome,
      sobrenome,
      email,
      genero,
      senha
    });
  
    try {
      const savedUsuario = await novoUsuario.save();
      res.status(201).json(savedUsuario);
    } catch (err) {
      res.status(400).send(err);
    }
  });

// Iniciar o servidor
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

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
mongoose.connect('mongodb://127.0.0.1:27017/tons_de_beleza', {
  useNewUrlParser: true,
  useUnifiedTopology: true
}).then(() => {
  console.log('MONGODB Conectado!');
}).catch(err => {
  console.error('Erro de conexão com o MongoDB', err);
});


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

  // Rota para login
app.post('/login', async (req, res) => {
  const { email, senha } = req.body;

  try {
    const usuario = await Usuario.findOne({ email, senha });

    if (!usuario) {
      return res.status(401).json({ message: 'Email ou senha incorretos' });
    }

    res.status(200).json({ message: 'Login realizado com sucesso', usuario });
  } catch (err) {
    res.status(500).json({ message: 'Erro ao efetuar login', error: err });
  }
});

app.post('/recuperaUsuario', async (req, res) => {
  const { email, senha } = req.body;
  const usuario = await Usuario.findOne({ email, senha });
  if (usuario) {
    res.status(200).json(usuario);
  } else {
    res.status(404).json({ error: 'Usuário não encontrado ou senha incorreta' });
  }
});


// Iniciar o servidor
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

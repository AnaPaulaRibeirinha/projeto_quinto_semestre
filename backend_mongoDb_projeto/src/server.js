const express = require('express');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
// JWT
const jwt = require('jsonwebtoken');

const app = express();
const port = process.env.PORT || 3001;

// Middlewares
app.use(bodyParser.json());
app.use(cors());

const TOKEN_KEY = "RANDOM_KEY";

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

  function generateAccessToken(userInfo) {
    return jwt.sign({ data: userInfo }, TOKEN_KEY, {
      expiresIn: "1h"
    });
  }

  
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


  app.post('/login', async (req, res) => {
    const { email, senha } = req.body;
  
    console.log('Iniciando processo de login');
  
    try {
      console.log('Procurando usuário no banco de dados');
      const usuario = await Usuario.findOne({ email, senha });
  
      if (!usuario) {
        console.log('Usuário não encontrado ou senha incorreta');
        return res.status(401).json({ message: 'Email ou senha incorretos' });
      }
  
      console.log('Usuário encontrado, gerando token');
      const token = generateAccessToken(usuario);
      
      console.log('Token gerado com sucesso');
      return res.status(200).json({ message: 'Login realizado com sucesso', token });
    } catch (err) {
      console.error('Erro ao efetuar login:', err);
      return res.status(500).json({ message: 'Erro ao efetuar login', error: err.message });
    }
  });

app.post('/recuperaUsuario', async (req, res) => {
  const { email, senha } = req.body;
  const usuario = await Usuario.findOne({ email });
  if (usuario) {
    const isMatch = await bcrypt.compare(senha, usuario.senha);
    if (isMatch) {
      res.status(200).json(usuario);
    } else {
      res.status(401).json({ error: 'Senha incorreta' });
    }
  } else {
    res.status(404).json({ error: 'Usuário não encontrado' });
  }
});

// Middleware para autenticação de token
function authenticationToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) return res.sendStatus(401);

  jwt.verify(token, TOKEN_KEY, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
}

// Rota protegida de exemplo
app.get('/protected', authenticationToken, (req, res) => {
  res.send("This is a protected route");
});


// Iniciar o servidor
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

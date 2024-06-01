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
    const payload = {
      id: userInfo._id,
      email: userInfo.email, // Exemplo de outra informação não sensível
    };
    return jwt.sign(payload, TOKEN_KEY, { expiresIn: '1h' });
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

// Middleware para autenticação de token
function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (token == null) return res.sendStatus(401);

  jwt.verify(token, TOKEN_KEY, (err, user) => {
    if (err) return res.sendStatus(403);
    req.userId = user.id; // Extrai o ID do usuário e anexa ao objeto req
    req.email = user.email; // Exemplo de outra informação não sensível
    next();
  });
}

module.exports = authenticateToken;

app.get('/recuperaUsuario', authenticateToken, async (req, res) => {
  try {
    const userId = req.userId; // ID do usuário extraído do token
    const usuario = await Usuario.findById(userId);

    if (!usuario) {
      return res.status(404).json({ message: 'Usuário não encontrado' });
    }

    res.json(usuario);
  } catch (err) {
    res.status(500).json({ message: 'Erro ao recuperar informações do usuário', error: err });
  }
});

app.post('/logout', (req, res) => {
  const { token } = req.body;
  refreshTokens = refreshTokens.filter(t => t !== token);
  res.status(200).json({ message: 'Logout realizado com sucesso' });
});

// Definindo o modelo de produto
const ProdutoSchema = new mongoose.Schema({
  id: String,
  nome: String,
  descricao: String,
  preco: mongoose.Decimal128,
  imageUrl: String,
  inativo: Boolean,
  destaque: Boolean
}, { collection: 'produto' });

ProdutoSchema.set('toJSON', {
  transform: (doc, ret, options) => {
    delete ret.__v;
    return ret;
  }
});

// Rota protegida de exemplo
app.get('/protected', authenticateToken, (req, res) => {
  res.send("This is a protected route");
});

const Produto = mongoose.model('Produto', ProdutoSchema);

// Recupera todos os produtos
app.get('/produtos', async (req, res) => {
  try {
    const products = await Produto.find();
    res.json(products);
  } catch (err) {
    res.status(500).json({ error: 'Produtos não encontrados' });
  }
});

app.post('/criaProdutos', async (req, res) => {
  const { nome, preco, descricao, imageUrl } = req.body;
  const inativo = false;
  const destaque = false;
  const novoProduto = new Produto({ nome, preco, descricao, imageUrl, inativo, destaque});

  try {
    const produto = await novoProduto.save();
    res.status(201).json(produto);
  } catch (err) {
    res.status(500).json({ error: 'Erro ao criar produto' });
  }

});

app.put('/atualizaProduto/:id', async (req, res) => {
  const { id } = req.params;
  const { nome, preco, descricao, imageUrl } = req.body;

  try {
    const produtoAtualizado = await Produto.findByIdAndUpdate(
      id,
      { nome, preco, descricao, imageUrl },
      { new: true }
    );

    if (!produtoAtualizado) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }

    res.status(200).json(produtoAtualizado);
    } catch (error) {
      console.error('Erro ao atualizar o produto:', error);
      res.status(500).json({ error: 'Erro interno do servidor' });
    }
});

app.put('/desativaProduto/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const produtoDesativado = await Produto.findByIdAndUpdate(
      id,
      { inativo: true },
      { new: true }
    );

    if (!produtoDesativado) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }

    res.status(200).json(produtoDesativado);
  } catch (error) {
    console.error('Erro ao desativar o produto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.get('/produtosAtivos', async (req, res) => {
  try {
    const produtosAtivos = await Produto.find({ inativo: false });
    res.status(200).json(produtosAtivos);
  } catch (error) {
    console.error('Erro ao buscar produtos ativos:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.get('/produtosAtivosDestaque', async (req, res) => {
  try {
    const produtosAtivos = await Produto.find({ inativo: false, destaque: true });
    res.status(200).json(produtosAtivos);
  } catch (error) {
    console.error('Erro ao buscar produtos ativos:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.put('/ativaProduto/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const produtoDesativado = await Produto.findByIdAndUpdate(
      id,
      { inativo: false },
      { new: true }
    );

    if (!produtoDesativado) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }

    res.status(200).json(produtoDesativado);
  } catch (error) {
    console.error('Erro ao ativar o produto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.put('/ativaDestaqueProduto/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const produtoDesativado = await Produto.findByIdAndUpdate(
      id,
      { destaque: true },
      { new: true }
    );

    if (!produtoDesativado) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }

    res.status(200).json(produtoDesativado);
  } catch (error) {
    console.error('Erro ao criar destaque do produto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.put('/desativaDestaqueProduto/:id', async (req, res) => {
  const { id } = req.params;

  try {
    const produtoDesativado = await Produto.findByIdAndUpdate(
      id,
      { destaque: false },
      { new: true }
    );

    if (!produtoDesativado) {
      return res.status(404).json({ error: 'Produto não encontrado' });
    }

    res.status(200).json(produtoDesativado);
  } catch (error) {
    console.error('Erro ao tirar destaque do produto:', error);
    res.status(500).json({ error: 'Erro interno do servidor' });
  }
});

app.get('/produtosPesquisa', async (req, res) => {
  const { search } = req.query;
  try {
    const produtos = await Produto.find({
      nome: { $regex: search, $options: 'i' },
      inativo: false // Apenas produtos ativos
    });
    res.json(produtos);
  } catch (err) {
    res.status(500).send(err);
  }
});

const pedidoSchema = new mongoose.Schema({
  userId: String,
  total: Number,
  totalItens: Number,
  formaPagamento: String,
  codigoPix: String,
  informacoesCartao: {
    numeroCartao: String,
    nomeUsuario: String,
    dataValidade: String,
    cvv: String,
  },
});

const Pedido = mongoose.model('Pedido', pedidoSchema);

app.post('/orders', async (req, res) => {
  try {
    const pedido = new Pedido(req.body);
    await pedido.save();
    res.status(200).send('Pedido criado com sucesso');
  } catch (error) {
    res.status(500).send('Erro ao criar o pedido');
  }
});


// Iniciar o servidor
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

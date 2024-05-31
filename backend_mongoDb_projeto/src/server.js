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

// Iniciar o servidor
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});

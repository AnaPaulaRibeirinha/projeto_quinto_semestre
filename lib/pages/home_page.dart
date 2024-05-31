import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:projeto_quinto_semestre/pages/conta.dart';
import 'package:projeto_quinto_semestre/pages/salvos.dart';
import 'package:projeto_quinto_semestre/api/api_service.dart';
import 'package:projeto_quinto_semestre/pages/paginaProduto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

  List<dynamic> products = [];
  
class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin{
  Color appBarColor = Colors.white;
  Color bottomNavBarColor = const Color(0xFF770624);

  int _selectedIndex = 0;

  void loadProducts() async {
    List<dynamic> fetchedProducts = await ApiService().fetchActiveDestaqueProducts();
    setState(() {
      products = fetchedProducts;
    });
  }

  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    loadProducts();
  _pageViewController = PageController();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (_selectedIndex) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Salvos(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Conta(
              userInfo: {}, // You need to provide userInfo data here
            ),
          ),
        );
        break;
    }
  }

  void _handlePageViewChanged(int currentPageIndex) {
    if (!_isOnDesktopAndWeb) {
      return;
    }
    _tabController.index = currentPageIndex;
    setState(() {
      _currentPageIndex = currentPageIndex;
    });
  }

  void _updateCurrentPageIndex(int index) {
    _tabController.index = index;
    _pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  bool get _isOnDesktopAndWeb {
    if (kIsWeb) {
      return true;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.macOS:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return true;
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.fuchsia:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {

    final List<String> slideImages = [
      'https://i.imgur.com/nc5dc1N.png',
      'https://i.imgur.com/39rOr9o.png',
      'https://i.imgur.com/8H1kicp.png',
    ];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: Container(
          decoration: BoxDecoration(
            border: const Border(
              bottom: BorderSide(
                color: Colors.transparent,
                width: 1.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: appBarColor,
            title: Text(
              "TONS DE BELEZA",
              style: TextStyle(
                color: bottomNavBarColor,
                fontSize: 20,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.shopping_cart, color: bottomNavBarColor),
                onPressed: () {
                  Navigator.pushNamed(context, '/carrinho');
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: bottomNavBarColor),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.folder_special_sharp, color: bottomNavBarColor),
                onPressed: () {
                  Navigator.pushNamed(context, '/crud');
                },
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 16),
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    controller: _pageViewController,
                    onPageChanged: _handlePageViewChanged,
                    itemCount: slideImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Image.network(
                          slideImages[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      );
                    },
                  ),
                ),
                if (_isOnDesktopAndWeb)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          splashRadius: 16.0,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (_currentPageIndex == 0) return;
                            _updateCurrentPageIndex(_currentPageIndex - 1);
                          },
                          icon: const Icon(
                            Icons.arrow_left_rounded,
                            size: 32.0,
                          ),
                        ),
                        TabPageSelector(
                          controller: _tabController,
                          color: Colors.grey,
                          selectedColor: bottomNavBarColor,
                        ),
                        IconButton(
                          splashRadius: 16.0,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (_currentPageIndex == slideImages.length - 1) {
                              return;
                            }
                            _updateCurrentPageIndex(_currentPageIndex + 1);
                          },
                          icon: const Icon(
                            Icons.arrow_right_rounded,
                            size: 32.0,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Produtos',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            products.isEmpty
                ? const Center(
                    child: Text("Sem produtos"),
                  )
                : GridView.builder(
                    itemCount: products.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaginaProduto(product: products[index]),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          color: Colors.grey[100],
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.network(
                                  products[index]['imageUrl']!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Text(
                                  products[index]['descricao']!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Salvos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Conta',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: bottomNavBarColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

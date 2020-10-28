import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_cueto_demo/menu/menu_drawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List<int> _listaNumeros = new List();
  int _ultimoItem = 0;
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;

  @override
  void initState() {    
    super.initState();
    agregarNumeros();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        print("LLEGUE AL FINAL");
        if(!_isLoading){
          _obtenerNuevosDatos();
        }
      }
    });
  }

  @override
  void dispose() {    
    super.dispose();
    _scrollController.dispose();
  }

  void agregarNumeros(){
    for(int i = 0; i < 15; i++){
      _ultimoItem++;
      _listaNumeros.add(_ultimoItem);
    }
    setState(() {       
    });
  }

  void _obtenerNuevosDatos(){
    setState(() {
      _isLoading = true;
    });
    final duration = Duration(seconds: 2);
    Timer(duration, respuestaHttp );
  }

  void respuestaHttp(){
      _isLoading = false;
      agregarNumeros();
      _scrollController.animateTo(
        _scrollController.position.pixels + 100,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      drawer: MenuWidget(),
      body: Stack(
        children: [
          _listaWidget(),
          Positioned(
            bottom: 15, left: 0, right: 0,
            child: _isLoading ? Center(child: CircularProgressIndicator()) : Container()
          )
        ]
      ),
    );
  }

  Widget _listaWidget(){
    return ListView.builder(
        controller: _scrollController,
        itemCount: _listaNumeros.length,
        itemBuilder: (BuildContext context, int index) {
          int image = _listaNumeros[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                FadeInImage(
                  image: NetworkImage("https://picsum.photos/id/$image/500/300"),
                  placeholder: AssetImage("assets/images/jar-loading.gif"),
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Imagen número : $image"),                
                ),
              ],
            ),
          );
        }
      );
  }
}
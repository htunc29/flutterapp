import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Hesaplayarak Öğren'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Random rn = Random();
  late int sayi1;
  late int sayi2;
  late int islemno;
  late String islemStr;
  int correct=0;
  int incorrect=0;
  int nullcorrect=0;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  void _generateNewQuestion() {
    List<String> islemler = ["+", "-", "x", "/"];
    sayi1 = rn.nextInt(100);
    sayi2 = rn.nextInt(100);
    islemno = rn.nextInt(islemler.length);
    islemStr = islemler[islemno];
  }

  @override
  Widget build(BuildContext context) {
    // İlk başta bir soru üret
    _generateNewQuestion();

    // Doğru sonuç hesaplama
    int dogruSonuc;
    if (islemno == 0) {
      dogruSonuc = sayi1 + sayi2;
    } else if (islemno == 1) {
      dogruSonuc = sayi1 - sayi2;
    } else if (islemno == 2) {
      dogruSonuc = sayi1 * sayi2;
    } else {
      dogruSonuc = (sayi1/sayi2).toInt();
    }

    return Scaffold(
      backgroundColor: Colors.deepPurpleAccent,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {

              },
              icon: Icon(Icons.lightbulb),
              style: IconButton.styleFrom(foregroundColor: Colors.white),
            ),
            Text(widget.title, style: TextStyle(color: Colors.white)),
            IconButton(onPressed: () {
              setState(() {
                correct=0;
                incorrect=0;
                nullcorrect=0;
              });
            },
                icon: Icon(Icons.refresh),
              style: IconButton.styleFrom(
                foregroundColor: Colors.white
              ),

            )
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$sayi1 $islemStr $sayi2",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:12.0,bottom: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Doğru Cevap:$correct",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.left,),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Yanlış Cevap:$incorrect",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.left),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Boş Cevap:$nullcorrect",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),textAlign: TextAlign.left),
                      )
                    ],
                  ),
                ),


                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    focusNode: _focusNode,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Sonuç",
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.number,

                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      // TextField'dan gelen değeri al
                      double? kullaniciSonuc = double.tryParse(_controller.text);
          
                      if (kullaniciSonuc == null) {
                        // Eğer geçerli bir sayı girilmediyse
                        nullcorrect++;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Lütfen geçerli bir sayı girin!")),
                        );
                      } else {
                        // Kullanıcı sonucu doğru girerse
                        if (kullaniciSonuc == dogruSonuc) {
                          correct++;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Tebrikler! Doğru cevap.")),
                          );
                        } else {
                          // Yanlış cevap girerse
                          incorrect++;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Yanlış cevap! Doğru sonuç: $dogruSonuc")),
                          );
                        }
                      }
          
                      // TextField'ı temizle
                      _controller.text = "";
                      FocusScope.of(context).requestFocus(_focusNode);
          
                      // Yeni bir soru üret
                      _generateNewQuestion();
                    });
                  },
                  child: Text("Tamam"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

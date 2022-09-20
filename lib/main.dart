import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import 'server_connector.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();

  runApp(const MyApp());
}

class CameraApp extends StatefulWidget {
  /// Default Constructor
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[1], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            debugPrint('User denied camera access.');
            break;
          default:
            debugPrint('Handle other errors.');
            break;
        }
      }
    });
  }

  Future<XFile?> takePicture() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized) {
      debugPrint('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    debugPrint("!CAMERA!");
    try {
      final XFile file = await cameraController.takePicture();
      debugPrint(file.path);
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _showCameraException(CameraException e) {
    debugPrint('Error: ${e.code}\n${e.description}');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Column(
      children: [
        SizedBox(width: 250, child: CameraPreview(controller)),
        Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
                onPressed: () {
                  takePicture().then((XFile? file) {
                    if (mounted) {
                      if (file != null) {
                        debugPrint('Picture saved to ${file.path}');
                      }
                    }
                  });
                },
                child: const Text("Сделать фото")))
      ],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VFC Register Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'VFC Register Panel'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  final ServerConnector serverConnector = const ServerConnector();

  @override
  State<MyHomePage> createState() => _ContentPage();
}

class _ContentPage extends State<MyHomePage> {
  int _stage = 0;
  var _mediaWeight = 0.0;
  var _lang = "";

  final _placeholderTextStyle = const TextStyle(
    fontSize: 30.0,
    color: Colors.white,
    decoration: TextDecoration.none,
    fontWeight: FontWeight.bold,
  );

  Widget _getStageWidget() {
    if (_stage == 0) {
      return _placeholder();
    } else if (_stage == 1) {
      return _langSelect();
    } else if (_stage == 2) {
      return _yourPhoto();
    } else if (_stage == 3) {
      return _yourName();
    } else if (_stage == 4) {
      return _yourGender();
    } else if (_stage == 5) {
      return _yourContacts();
    } else if (_stage == 6) {
      return _yourPlayerNumber();
    } else {
      return _playerDone();
    }
  }

  Widget _placeholder() {
    return GestureDetector(
        onTap: () {
          setState(() {
            _stage++;
          });
        },
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 85, 0, 101),
                    Color.fromARGB(255, 135, 62, 180)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.9])),
          child: Center(
              child: Image.asset(
            'img/visalogo.png',
            width: _mediaWeight * 0.6,
          )),
        ));
  }

  Widget _langSelect() {
    return GestureDetector(
        onTap: () {},
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 85, 0, 101),
                    Color.fromARGB(255, 135, 62, 180)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.9])),
          child: Column(children: [
            Center(
                child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Image.asset(
                      'img/visalogo.png',
                      width: _mediaWeight * 0.4,
                    ))),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text("Пожалуйста выберите язык:",
                    style: _placeholderTextStyle)),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text("Please select a language:",
                    style: _placeholderTextStyle)),
            Padding(
                padding: const EdgeInsets.all(5),
                child: Text("Тілді таңдаңыз:", style: _placeholderTextStyle)),
            Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _lang = "RUS";
                            _stage++;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: const Text(
                          "РУС",
                          style: TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 103, 22, 129)),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _lang = "ENG";
                            _stage++;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: const Text(
                          "ENG",
                          style: TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 103, 22, 129)),
                        )),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _lang = "RUS";
                            _stage++;
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                        child: const Text(
                          "КАЗ",
                          style: TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 103, 22, 129)),
                        ))
                  ],
                ))
          ]),
        ));
  }

  Widget _appBar() => Column(
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 85, 0, 101),
                      Color.fromARGB(255, 135, 62, 180)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9])),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _stage = 0;
                    });
                  },
                  icon: const Icon(
                    Icons.home_rounded,
                    size: 50,
                    color: Colors.white,
                  )),
              const Padding(
                  padding: EdgeInsets.only(top: 20, left: 40),
                  child: Text(
                    "Регистрация игрока",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Image.asset(
                    'img/visalogo.png',
                    width: _mediaWeight * 0.35,
                  ))
            ]),
          ),
          Center(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: (_stage >= 2)
                              ? const Color.fromARGB(255, 103, 22, 129)
                              : const Color.fromARGB(255, 200, 200, 200),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: (_stage >= 3)
                              ? const Color.fromARGB(255, 103, 22, 129)
                              : const Color.fromARGB(255, 200, 200, 200),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: (_stage >= 4)
                              ? const Color.fromARGB(255, 103, 22, 129)
                              : const Color.fromARGB(255, 200, 200, 200),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: (_stage >= 5)
                              ? const Color.fromARGB(255, 103, 22, 129)
                              : const Color.fromARGB(255, 200, 200, 200),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 15.0,
                        height: 15.0,
                        decoration: BoxDecoration(
                          color: (_stage >= 6)
                              ? const Color.fromARGB(255, 103, 22, 129)
                              : const Color.fromARGB(255, 200, 200, 200),
                          shape: BoxShape.circle,
                        ),
                      )
                    ])),
          )
        ],
      );

  Widget _yourPhoto() {
    return Scaffold(
        body: Column(
      children: [
        _appBar(),
        const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Давайте сделаем фото:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        const Padding(
            padding: EdgeInsets.all(80),
            child: SizedBox(height: 300, child: CameraApp())),
        Padding(
          padding: const EdgeInsets.only(left: 240, top: 20),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _stage++;
                });
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 103, 22, 129))),
              child: const Icon(
                Icons.arrow_right_alt,
                size: 50,
              )),
        )
      ],
    ));
  }

  final TextEditingController _controllerPlayerName = TextEditingController();
  final TextEditingController _controllerPlayerLastName =
      TextEditingController();
  bool dataInputed = false;
  final _formNameKey = GlobalKey<FormState>();
  Widget _yourName() {
    return Scaffold(
        body: Form(
            key: _formNameKey,
            child: Column(
              children: [
                _appBar(),
                const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Пожалуйста, заполните ваши данные:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.all(50),
                    child: TextFormField(
                      // Имя
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста введите Ваше имя.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            _controllerPlayerLastName.value.text.isNotEmpty) {
                          setState(() {
                            dataInputed = true;
                          });
                        } else{
                          setState(() {
                            dataInputed = false;
                          });
                        }
                      },
                      cursorColor: const Color.fromARGB(255, 103, 22, 129),
                      controller: _controllerPlayerName,
                      decoration: const InputDecoration(
                        hintText: 'Имя',
                      ),
                    )),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 25),
                    child: TextFormField(
                      // Фамилия
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста введите Вашу фамилию.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            _controllerPlayerName.value.text.isNotEmpty) {
                          setState(() {
                            dataInputed = true;
                          });
                        } else{
                          setState(() {
                            dataInputed = false;
                          });
                        }
                      },
                      cursorColor: const Color.fromARGB(255, 103, 22, 129),
                      controller: _controllerPlayerLastName,
                      decoration: const InputDecoration(
                        hintText: 'Фамилия',
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 240, top: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        if (dataInputed) {
                          if (_formNameKey.currentState!.validate()) {
                            setState(() {
                              _stage++;
                            });
                          }
                        }else {
                          null;
                        }
                      },
                      style: ButtonStyle(
                          backgroundColor: (dataInputed) ? MaterialStateProperty.all(
                              const Color.fromARGB( 255, 103, 22, 129)): MaterialStateProperty.all(
                              const Color.fromARGB( 150, 103, 22, 129))),
                      child: const Icon(
                        Icons.arrow_right_alt,
                        size: 50,
                      )),
                )
              ],
            )));
  }

  var _playerGender = "";

  Widget _yourGender() {
    return Scaffold(
        body: Column(
      children: [
        _appBar(),
        const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Выберите пол:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _playerGender = "male";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          (_playerGender == "male")
                              ? Colors.white
                              : const Color.fromARGB(255, 109, 22, 129))),
                  child: Icon(
                    Icons.male,
                    size: 120,
                    color: (_playerGender == "male")
                        ? const Color.fromARGB(255, 103, 22, 129)
                        : Colors.white,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _playerGender = "female";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          (_playerGender == "female")
                              ? Colors.white
                              : const Color.fromARGB(255, 109, 22, 129))),
                  child: Icon(
                    Icons.female,
                    size: 120,
                    color: (_playerGender == "female")
                        ? const Color.fromARGB(255, 103, 22, 129)
                        : Colors.white,
                  )),
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 240, top: 20),
          child: ElevatedButton(
              onPressed: () {
                if (_playerGender != "") {
                  setState(() {
                    _stage++;
                  });
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color.fromARGB(
                      (_playerGender != "") ? 255 : 150, 103, 22, 129))),
              child: const Icon(
                Icons.arrow_right_alt,
                size: 50,
              )),
        )
      ],
    ));
  }

  final TextEditingController _controllerPlayerEmail = TextEditingController();
  final TextEditingController _controllerPlayerPhone = TextEditingController();
  final _formContactKey = GlobalKey<FormState>();
  Widget _yourContacts() {
    RegExp regExp = RegExp(
        "^[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*\$");
    return Scaffold(
        body: Form(
            key: _formContactKey,
            child: Column(
              children: [
                _appBar(),
                const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      "Пожалуйста, укажите ваши контактные данные:",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )),
                Padding(
                    padding: const EdgeInsets.all(50),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Пожалуйста введите ваш E-mail!';
                        }
                        if (value != null && !value.contains(regExp)) {
                          return "Некорректный почтовый адрес!";
                        }
                        return null;
                      },
                      cursorColor: const Color.fromARGB(255, 103, 22, 129),
                      controller: _controllerPlayerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'E-mail',
                      ),
                    )),
                Padding(
                    padding:
                        const EdgeInsets.only(left: 50, right: 50, bottom: 25),
                    child: IntlPhoneField(
                      initialCountryCode: 'KZ',
                      validator: (value) {
                        if (value == null) {
                          return "Пожалуйста введи ваш номер телефона!";
                        }

                        return null;
                      },
                      cursorColor: const Color.fromARGB(255, 103, 22, 129),
                      controller: _controllerPlayerPhone,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Номер Телефона',
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 240, top: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _stage++;
                        });
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 103, 22, 129))),
                      child: const Icon(
                        Icons.arrow_right_alt,
                        size: 50,
                      )),
                )
              ],
            )));
  }

  var playerNumber;

  final TextEditingController _controllerPlayerNumber = TextEditingController();
  bool success = true;
  Widget _yourPlayerNumber() {
    return Scaffold(
        body: Column(
      children: [
        _appBar(),
        const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(
              "Пожалуйста, укажите номер игрока:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
        Padding(
            padding: const EdgeInsets.all(50),
            child: TextField(
              cursorColor: const Color.fromARGB(255, 103, 22, 129),
              controller: _controllerPlayerNumber,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Номер игрока',
              ),
            )),
        if (!success)
          const Text(
            "Something went wrong",
            style: TextStyle(color: Colors.red),
          ),
        Padding(
          padding: const EdgeInsets.only(left: 240, top: 20),
          child: ElevatedButton(
              onPressed: () async {
                playerNumber = await widget.serverConnector.getPlayerId();
                if (playerNumber.runtimeType == String) {
                  var response = await widget.serverConnector.postData(
                      playerNumber,
                      _controllerPlayerName.text,
                      _controllerPlayerLastName.text,
                      "photo",
                      _controllerPlayerPhone.text,
                      _controllerPlayerEmail.text,
                      int.parse(_controllerPlayerNumber.text),
                      _playerGender);
                  if (response == 200) {
                    setState(() {
                      success = true;
                      _stage++;
                    });
                  } else {
                    setState(() {
                      success = false;
                    });
                  }
                }
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 103, 22, 129))),
              child: const Icon(
                Icons.arrow_right_alt,
                size: 50,
              )),
        )
      ],
    ));
  }

  Widget _playerDone() {
    return Container(
      decoration: const BoxDecoration(),
      child: Center(
        child: Text(playerNumber.toString()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _mediaWeight = MediaQuery.of(context).size.width;
    return Container(child: _getStageWidget());
  }
}

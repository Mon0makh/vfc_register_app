import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter/services.dart';

import 'server_connector.dart';
import 'localization.dart';

late List<CameraDescription> _cameras;
void main() async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom
  ]);

  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();

  runApp(const MyApp());
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
      return _yourName();
    } else if (_stage == 3) {
      return _yourPhoto();
    } else if (_stage == 4) {
      return _yourGender();
    } else if (_stage == 5) {
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
                    Color.fromARGB(255, 26, 31, 113),
                    Color.fromARGB(255, 34, 84, 164)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.9])),
          child: Center(
              child: Image.asset(
            'img/visalogo.png',
            width: _mediaWeight * 0.8,
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
                    Color.fromARGB(255, 26, 31, 113),
                    Color.fromARGB(255, 34, 84, 164)
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
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _lang = "KAZ";
                            _stage++;
                          });
                        },

                        child: const Text(
                          "КАЗ",
                          style: TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                          decoration: TextDecoration.underline),
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _lang = "RUS";
                            _stage++;
                          });
                        },
                        child: const Text(
                          "РУС",
                          style: TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _lang = "ENG";
                            _stage++;
                          });
                        },
                        child: const Text(
                          "ENG",
                          style: TextStyle(
                              fontSize: 65,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              decoration: TextDecoration.underline),
                        )),
                  ],
                ))
          ]),
        ));
  }

  Widget _appBar() => Column(
        children: [
          SizedBox(
            height: 70,

            child: Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      _stashState();
                      _stage = 0;
                    });
                  },
                  icon: const Icon(
                    Icons.home_rounded,
                    size: 50,
                    color: Colors.white,
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 20, left: 40),
                  child: Text(
                    APP_BAR_TITLE[_lang]!,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Image.asset(
                    'img/visalogo.png',
                    width: _mediaWeight * 0.35,
                  ))
            ]),
          ),
          // Center(
          //   child: Padding(
          //       padding: const EdgeInsets.all(20),
          //       child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //           children: [
          //             Container(
          //               width: 15.0,
          //               height: 15.0,
          //               decoration: BoxDecoration(
          //                 color: (_stage >= 2)
          //                     ? const Color.fromARGB(255, 103, 22, 129)
          //                     : const Color.fromARGB(255, 200, 200, 200),
          //                 shape: BoxShape.circle,
          //               ),
          //             ),
          //             Container(
          //               width: 15.0,
          //               height: 15.0,
          //               decoration: BoxDecoration(
          //                 color: (_stage >= 3)
          //                     ? const Color.fromARGB(255, 103, 22, 129)
          //                     : const Color.fromARGB(255, 200, 200, 200),
          //                 shape: BoxShape.circle,
          //               ),
          //             ),
          //             Container(
          //               width: 15.0,
          //               height: 15.0,
          //               decoration: BoxDecoration(
          //                 color: (_stage >= 4)
          //                     ? const Color.fromARGB(255, 103, 22, 129)
          //                     : const Color.fromARGB(255, 200, 200, 200),
          //                 shape: BoxShape.circle,
          //               ),
          //             ),
          //             Container(
          //               width: 15.0,
          //               height: 15.0,
          //               decoration: BoxDecoration(
          //                 color: (_stage >= 5)
          //                     ? const Color.fromARGB(255, 103, 22, 129)
          //                     : const Color.fromARGB(255, 200, 200, 200),
          //                 shape: BoxShape.circle,
          //               ),
          //             ),
          //             Container(
          //               width: 15.0,
          //               height: 15.0,
          //               decoration: BoxDecoration(
          //                 color: (_stage >= 6)
          //                     ? const Color.fromARGB(255, 103, 22, 129)
          //                     : const Color.fromARGB(255, 200, 200, 200),
          //                 shape: BoxShape.circle,
          //               ),
          //             )
          //           ])),
          // )
        ],
      );

  final TextEditingController _controllerPlayerName = TextEditingController();
  final TextEditingController _controllerPlayerLastName =
  TextEditingController();
  final TextEditingController _controllerPlayerEmail = TextEditingController();
  String _playerPhone = "";
  final _formContactKey = GlobalKey<FormState>();
  bool contactDataInputted = false;
  bool dataInputed = false;
  final _formNameKey = GlobalKey<FormState>();
  bool? acceptConf = true;
  var _uniq_response = "";
  Widget _yourName() {
    RegExp regExp = RegExp(
        "^[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*@[a-zA-Z0-9]+(?:\\.[a-zA-Z0-9]+)*\$");
    return Scaffold(
        body: Form(
            key: _formNameKey,
            child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 26, 31, 113),
                          Color.fromARGB(255, 34, 84, 164)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 0.9])),
                child: ListView(
              children: [
                _appBar(),
                Center(child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      USER_DATA_TITLE[_lang]!,
                      style:
                      const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ))),
                Padding(
                    padding: const EdgeInsets.all(50),
                    child: TextFormField(
                      // Имя
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return USER_DATA_NAME_FIELD[_lang];
                        }
                        return null;
                      },

                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            _controllerPlayerLastName.value.text.isNotEmpty &&
                            _controllerPlayerEmail.value.text.isNotEmpty &&
                            _playerPhone.isNotEmpty) {
                          setState(() {
                            dataInputed = true;
                          });
                        } else {
                          setState(() {
                            dataInputed = false;
                          });
                        }
                      },
                      controller: _controllerPlayerName,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: NAME[_lang],
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintStyle: const TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                        focusColor: Colors.white,
                      ),
                    )),
                Padding(
                    padding:
                    const EdgeInsets.only(left: 50, right: 50, bottom: 25),
                    child: TextFormField(
                      // Фамилия
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return USER_DATA_LAST_NAME[_lang];
                        }
                        return null;
                      },
                      onChanged: (value) {

                        print("$dataInputed");
                        if (value.isNotEmpty &&
                            _controllerPlayerName.value.text.isNotEmpty &&
                            _controllerPlayerEmail.value.text.isNotEmpty &&
                            _playerPhone.isNotEmpty) {
                          setState(() {
                            dataInputed = true;
                          });
                        } else {
                          setState(() {
                            dataInputed = false;
                          });
                        }
                      },
                      controller: _controllerPlayerLastName,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: LAST_NAME[_lang],
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintStyle: const TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                        focusColor: Colors.white,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.all(50),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return PLEASE_ENTER_EMAIL[_lang];
                        }
                        if (!value.contains(regExp)) {
                          return INCORRECT_EMAIL[_lang];
                        }
                        return null;
                      },

                      onChanged: (value) {

                        if (value.isNotEmpty &&
                            _playerPhone.isNotEmpty &&
                            _controllerPlayerName.value.text.isNotEmpty &&
                            _controllerPlayerLastName.value.text.isNotEmpty) {


                          setState(() {
                            dataInputed = true;
                          });
                        } else {
                          setState(() {
                            dataInputed = false;
                          });
                        }
                      },
                      controller: _controllerPlayerEmail,
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.white,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'E-mail',
                        fillColor: Colors.white,
                        hoverColor: Colors.white,
                        hintStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                        focusColor: Colors.white,
                      ),
                    )),

                Padding(
                    padding:
                    EdgeInsets.only(left: 50, right: 50, bottom: 25),
                    child:
                    IntlPhoneField(
                      decoration: InputDecoration(hintText: PHONE_NUMBER[_lang],
                                      hintStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255))),
                      invalidNumberMessage: INCORRECT_PHONE_NUMBER[_lang],
                      initialCountryCode: 'KZ',
                      style: TextStyle(color: Colors.white),
                      dropdownTextStyle: TextStyle(color: Color.fromARGB(150, 255, 255, 255), fontSize: 15),
                      flagsButtonPadding: EdgeInsets.only(bottom: 5, right: 10),
                      onChanged: (phone) {

                        _playerPhone = phone.completeNumber;

                        if (phone.number.length == 10  &&
                            _controllerPlayerEmail.value.text.isNotEmpty &&
                            _controllerPlayerName.value.text.isNotEmpty &&
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
                    ),                    // TextFormField(

                ),
                Padding(padding: EdgeInsets.all(45), child: Row(children: [
                  Checkbox( value: acceptConf,
                            onChanged: (value){
                                    setState((){ acceptConf = value;});
                            }
                  ),
                  Text(I_ACCEPT_WITH[_lang]!, style: TextStyle(color: Colors.white)),
                  TextButton(onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Expanded(
                          child: SimpleDialog(
                            title: Text(PERSONAL_DATA_RULES[_lang]!),
                            children: [
                              Padding(padding: EdgeInsets.all(15),
                                      child: Text('1. Условия обработки персональных данных (Далее – Условия) регулируют правоотношения по обработке персональных данных между компанией ООО «______», ОГРН _______, адрес: _______________ (далее - Рекламораспространитель) и Клиентом (дееспособное физическое лицо, достигшее 18-летнего возраста и желающее получать рекламно-информационные рассылки по электронной почте). Под персональными данными понимается любая информация, относящаяся к прямо или косвенно определенному или определяемому физическому лицу (гражданину). Под обработкой персональных данных понимается любое действие (операция) или совокупность действий (операций) с персональными данным, совершаемых с использованием средств автоматизации или без использования таких средств. К таким действиям (операциям) можно отнести: сбор, получение, запись, систематизацию, накопление, хранение, уточнение (обновление, изменение), извлечение, использование, передачу (распространение, предоставление, доступ), обезличивание, блокирование, удаление, уничтожение персональных данных.2. Клиент соглашается с настоящими Условиями путем ввода принадлежащего ему адреса электронной почты в специальное поле на сайте Рекламодателя с предложением подписаться на рассылку, и последующего нажатия кнопки «Подписаться» «Подписаться на рассылку», «Зарегистрироваться», другое перечислить). Совершая указанные действия, Клиент направляет принадлежащий ему адрес электронной почты Рекламораспространителю в целях дальнейшего осуществления рекламно-информационных рассылок по электронной почте.3. При подписке на рекламно-информационные рассылки Клиент предоставляет Рекламораспространителю следующую информацию: Фамилия, Имя, адрес электронной почты, номер контактного телефона .4. Предоставляя свои персональные данные Клиент соглашается на их обработку (вплоть до отзыва Клиента своего согласия на обработку персональных данных) компанией ООО «______», ОГРН _______, адрес: _______________ в целях предоставления Клиенту рекламной и справочной информации и в иных целях согласно п.4 Условий. При обработке персональных данных Рекламораспространитель руководствуется Федеральным законом «О персональных данных», Федеральным законом «О рекламе» и локальными нормативными документами.3. Если Клиент желает уточнения персональных данных в случае, когда персональные данные являются неполными, неточными или неактуальными, либо желает отозвать свое согласие на обработку персональных данных, Клиент должен направить официальный запрос Рекламораспространителю в следующем порядк: письмо с темой «Уточнить персональные данные» или «Прекратить обработку персональных данных» на адрес электронной почты example@email.ru. В письме необходимо указать электронный адрес и соответствующее требование.При отзыве согласия на обработку персональных данных Клиент также отказывается от получения рекламно-информационных рассылок.4. Рекламораспространитель использует предоставленные Клиентом данные в целях:4.1. Отправки сообщений рекламно-информационного характера;4.2. для осуществления деятельности по продвижению товаров и услуг;4.3. оценки и анализа работы системы Рекламораспространителя;4.4. определения победителя в акциях, проводимых Рекламодателями (третьи лица, состоящие в договорных отношениях с Рекламораспространителем, чьи товары и услуги рекламируются в рассылках);4.5. анализа покупательских особенностей Клиента и предоставления персональных рекомендаций;4.6. информирования клиента об акциях, скидках и специальных предложениях Рекламодателей посредством рассылок по электронной почте.5. Рекламораспространитель обязуется не передавать полученную от Клиента информацию третьим лицам. Не считается нарушением предоставление Рекламораспространителя информации агентам и третьим лицам, действующим на основании договора с Рекламораспространителем, для исполнения обязательств перед Клиентом и только в рамках договоров. Не считается нарушением настоящего пункта передача Рекламораспространителем третьим лицам данных о Клиенте в обезличенной форме в целях оценки и анализа работы системы Рекламораспространителя, анализа покупательских особенностей Клиента и предоставления персональных рекомендаций.6. Не считается нарушением обязательств передача информации в соответствии с обоснованными и применимыми требованиями законодательства Российской Федерации.7. Рекламораспространитель вправе использовать технологию «cookies». «Cookies» не содержат конфиденциальную информацию и не передаются третьим лицам.8. Рекламораспространитель получает информацию об ip-адресе Клиента и сведения о том, по ссылке с какого интернет-сайта он пришел. Данная информация не используется для установления личности посетителя.9. Рекламораспространитель при обработке персональных данных принимает необходимые и достаточные организационные и технические меры для защиты персональных данных от неправомерного доступа к ним, а также от иных неправомерных действий в отношении персональных данных.Текст для письма-подтвержденияПереходя по ссылке, Вы, дееспособное физическое лицо, достигшее 18-летнего возраста и желающее получать рекламно-информационные рассылки по электронной почте (далее – Клиент), соглашаетесь со следующими условиями направления рекламно-информационных сообщений:1. С момента перехода по ссылке в сервисном сообщении, направленном на адрес электронной почты Клиента, ООО «______», ОГРН _______, адрес: _______________ (далее - Рекламораспространитель) вправе направлять Клиенту на указанный адрес электронной почты рекламно-информационные сообщения. При направлении рекламно-информационных сообщений Рекламораспространитель руководствуется Федеральным законом "О рекламе" и иными законодательными актами Российской Федерации.2. Если Клиент не желает получать сообщения рекламно-информационного характера от Рекламораспространителя, он должен перейти по соответствующей ссылке, размещаемой в каждом рекламно-информационном сообщении, и после перехода на интернет-страницу подтвердить отказ от рассылки путем нажатия соответствующей кнопки. С момента направления запроса получение рассылок Рекламораспространителя возможно в течение 10 календарных дней] , что обусловлено особенностями работы и взаимодействия информационных систем Рекламораспространителя.3. При направлении Клиенту рекламно-информационных сообщений Рекламораспространитель осуществляет обработку персональных данных клиента согласно Условиям обработки персональных данных .  '))],

                          ),
                        );
                      },
                    );
                  },
                      child: Text(PROCESSING_OF_PERSONAL_DATA[_lang]!,
                      style: const TextStyle(color: Colors.white,
                                        decoration: TextDecoration.underline))
                  )
                ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          _stage--;
                        });
                      },
                      child: const Icon(
                        Icons.chevron_left_rounded,
                        size: 120,
                        color: Colors.white,
                      )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60),
                  child: TextButton(
                      onPressed: () {
                        if (dataInputed) {
                          if (_formNameKey.currentState!.validate()) {
                            setState(() {
                              _stage++;
                            });
                            // if (_uniq_response == "OK"){
                            //
                            // } else {
                            //
                            //   showDialog(
                            //     context: context,
                            //     builder: (BuildContext context) {
                            //       return Expanded(
                            //         child: SimpleDialog(
                            //           title: Text(PERSONAL_DATA_RULES[_lang]!),
                            //           children: [
                            //             Padding(padding: EdgeInsets.all(15),
                            //                 child: Text(DATA_NOT_UNIQUE[_lang]! + _uniq_response))],
                            //         ),
                            //       );
                            //     },
                            //   );
                            //
                            // }

                          }
                        } else {
                          null;
                        }
                      },
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 120,
                        color: dataInputed ? Colors.white : const Color.fromARGB(100, 1, 1, 1),
                        )
                  ),
                )])
              ],
            ))));
  }


/// CAMERAS
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    controller.dispose();
    super.dispose();
  }

  int photoStage = 0;
  String photoPath = "";
  /// END-CAMERAS
  final TextEditingController _controllerPlayerHeight = TextEditingController();
  Widget _yourPhoto(){
    Widget cam;
    if (!controller.value.isInitialized) {
      cam = Container();
    }else{
      int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 6;

      cam = Column(
        children: [
          SizedBox(width: 330, child: Stack(alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(child: CameraPreview(controller)),
                Positioned(child: Image.asset(
                    'img/mask.png'
                )),
                Positioned(child: photoStage == 1 ? CountdownTimer(
                  endTime: endTime,
                  onEnd: () {
                    takePicture().then((XFile? file) {
                      if (mounted) {
                        if (file != null) {
                          debugPrint('Picture saved to ${file.path}');
                          photoPath = file.path;

                          controller.pausePreview();
                          setState((){
                            photoStage = 2;
                          });

                        }
                      }
                    });
                  },
                  widgetBuilder: (_, CurrentRemainingTime? time) {
                    if (time?.sec == null) {
                      return Container();
                    }
                    return Text(
                        '${time?.sec}', style: const TextStyle(fontSize: 300, color: Colors.white));
                  },
                ) : Container(),)
              ])),
          Center(child: Container(
              child: photoStage == 0 ? TextButton(
                  onPressed: () {
                    setState(() {
                      photoStage = 1;
                    });
                  },
                  child: const Icon(Icons.photo_camera, color: Colors.white, size: 60)) :
              photoStage == 2 ? TextButton(
                  onPressed: () {
                    controller.resumePreview();
                    setState(() {
                      photoStage = 1;
                    });
                  },
                  child: const Icon(Icons.refresh_rounded, color: Colors.white, size: 60)
              ) : const SizedBox(height: 76)
          ))
        ],
      );

    }


    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 26, 31, 113),
                      Color.fromARGB(255, 34, 84, 164)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9])),
            child: ListView(
      children: [
        _appBar(),
        Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(child: Text(
              LETS_TAKE_PHOTO[_lang]!,
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
            ))),
        Padding(
            padding: const EdgeInsets.only(top: 20),
            child: SizedBox(
                child: cam)),
        Row(children: [
          TextButton(
              onPressed: () {
                setState(() {
                  _stage--;
                });
              },
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 120,
                color: Colors.white,
              )),
          const SizedBox(width: 298),
          TextButton(
              onPressed: () async {
                if (photoStage == 0) return;
                //print("CAMERA - $photoPath");
                setState(() {
                  _stage++;
                });
                photoPath = await widget.serverConnector.sendImage(photoPath);
              },
              child: Icon(
                Icons.chevron_right_rounded,
                size: 120,
                color: photoStage == 0 ? Color.fromARGB(100, 1, 1, 1): Colors.white,
              )),

        ],)
      ],
    )));
  }

  var _playerGender = "";

  Widget _yourGender() {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 26, 31, 113),
                      Color.fromARGB(255, 34, 84, 164)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9])),
            child: ListView(

      children: [
        _appBar(),
        Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Center(child: Text(
              PHYSICAL_DATAS[_lang]!,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ))),
        Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(child: Text(
              GET_YOUR_GENDER[_lang]!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ))),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _playerGender = "male";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          (_playerGender == "male")
                              ? Colors.white
                              : const Color.fromARGB(0, 0, 0, 0))),
                  child: Text(
                    MALE[_lang]!,
                    style: TextStyle(fontSize: 140,
                    decoration: TextDecoration.underline,
                    color: (_playerGender == "male")
                        ? const Color.fromARGB(255, 26, 31, 113)
                        : Colors.white,
                  ))),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: TextButton(
                  onPressed: () {
                    setState(() {
                      _playerGender = "female";
                    });
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          (_playerGender == "female")
                              ? Colors.white
                              : const Color.fromARGB(0, 1, 1, 1))),
                  child: Text(
                    FEMALE[_lang]!,
                    style: TextStyle(
                    fontSize: 140,
                      decoration: TextDecoration.underline,
                    color: (_playerGender == "female")
                        ? const Color.fromARGB(255, 26, 31, 113)
                        : Colors.white,
                  ))),
            )
          ],
        ),
            Padding(padding: EdgeInsets.all(100),
                child: TextField(
              maxLength: 3,
              controller: _controllerPlayerHeight,
              keyboardType: TextInputType.number,
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white, fontSize: 40),
              decoration: InputDecoration(
                hintText: ENTER_YOUR_HEIGHT[_lang],
                fillColor: Colors.white,
                hoverColor: Colors.white,
                hintStyle: TextStyle(color: Color.fromARGB(100, 255, 255, 255)),
                focusColor: Colors.white,
              ),
            )),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        _stage--;
                      });
                    },
                    child: const Icon(
                      Icons.chevron_left_rounded,
                      size: 120,
                      color: Colors.white,
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: TextButton(
                    onPressed: () {
                      if (_playerGender != "" && _controllerPlayerHeight.value.text.isNotEmpty) {
                        // TODO Height validation
                          setState(() {
                            _stage++;
                          });

                      } else {
                        null;
                      }
                    },
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 120,
                      color: _playerGender != "" && _controllerPlayerHeight.value.text.isNotEmpty ? Colors.white : const Color.fromARGB(100, 1, 1, 1),
                    )
                ),
              )])

      ],
    )));
  }



  var playerNumber = 0;

  final TextEditingController _controllerPlayerNumber = TextEditingController();
  bool success = true;
  Widget _yourPlayerNumber() {
    return Scaffold(
        body: Container(decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 26, 31, 113),
                  Color.fromARGB(255, 34, 84, 164)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.9])),
            child: ListView(
      children: [
        _appBar(),
        Padding(
            padding: EdgeInsets.only(top: 20),
            child: Center(child: Text(
              SELECT_PLAYER_NUMBER[_lang]!,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ))),
        Padding(
            padding: const EdgeInsets.only(top: 30, left: 40, right: 40),
            child: SizedBox(height: 520, child: GridView.count(crossAxisCount: 9,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
              children: List.generate(99, (index) {
                index++;
                return TextButton(
                    onPressed: () {
                      setState((){
                        playerNumber = index;
                      });

                      },
                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(playerNumber == index ? Colors.white : Color.fromARGB(0, 0, 0, 0))),
                    child: Text("$index", style: TextStyle(fontSize: 20, color: playerNumber == index ? Colors.blue : Color.fromARGB(200, 255, 255, 255)),));})))),
        if (!success)
          const Text(
            "Something went wrong",
            style: TextStyle(color: Colors.red),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
          TextButton(
                onPressed: () {
                    setState(() {
                      _stage--;
                    });
                },
                child: const Icon(
                  Icons.chevron_left_rounded,
                  size: 120,
                  color: Colors.white ,
                )),

          TextButton(
              onPressed: () async {
                if (playerNumber != 0) {
                  setState(() {
                    _stage++;
                  });
                }
              },
              child: Icon(
                Icons.chevron_right_rounded,
                size: 120,
                color: playerNumber == 0 ? const Color.fromARGB(150, 0, 0, 0) : Colors.white,
              ))
        ])
      ],
    )));
  }

  void _checkUnique() async{
    var response = await widget.serverConnector.getCheckUniqueData(_controllerPlayerEmail.value.text, _playerPhone);
    if (response.runtimeType == String) {
      try{
        _uniq_response = response.toString();
      } catch (e) {
        print(e);
      }
      }
    _uniq_response = "";
  }

  String _uploadPhoto(){

    return "";
  }

  var playerID;
  Future<Widget> _sendData() async{
    var response = await widget.serverConnector
        .postData(
        _controllerPlayerName.text,
        _controllerPlayerLastName.text,
        photoPath,
        _playerPhone,
        _controllerPlayerEmail.text,
        playerNumber,
        _playerGender,
        int.parse(_controllerPlayerHeight.value.text)
    );
    playerID = response;
    return Text(playerID);
  }

  void _stashState(){
    _playerGender = "";
    _controllerPlayerHeight.clear();
    _controllerPlayerLastName.clear();
    _controllerPlayerName.clear();
    _controllerPlayerEmail.clear();
    _playerPhone = "";
    photoStage = 0;
    playerNumber = 0;

  }

  Widget _playerDone() {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 26, 31, 113),
                      Color.fromARGB(255, 34, 84, 164)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.9])),
            child: ListView(children: [
      _appBar(),
      Padding(
        padding: EdgeInsets.all(100),
        child:
        FutureBuilder<Widget>(
          future: _sendData(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // This shouldn't happen in our case, but good to handle errors.
              return const Text('Error has happened in the future!');
            } else {
              return Column(children: [
                      SizedBox(height: 742, width: 210, child: Container(color: Colors.white,
                      child: Column(
                        children: [
                          Center(child: Image.asset(
                      'img/visalogo.png',
                       height: 15)),
                          SizedBox(height: 3),
                          Center(
                              child: Row(children: [
                                SizedBox(width: 1),
                                Column(children: [
                                  Text("Score: ", style: const TextStyle(fontSize: 18)),
                                  Text("89",
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 80)),
                                  Text("7",
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 100))
                                ]),
                                Image.network('http://185.146.3.41/VFC-backend/$photoPath', height: 27)
                              ], mainAxisAlignment: MainAxisAlignment.spaceAround)),
                          Text("Jonh Doe",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          Divider(
                              color: Colors.blue, height: 20, thickness: 2),
                          Row(children: [
                            Text("Jump: ", style: const TextStyle(fontSize: 20)),
                            Text("240",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.blue))
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Dribbling:   ", style: const TextStyle(fontSize: 20)),
                            Text("00:13",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.blue))
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Accuracy:   ", style: const TextStyle(fontSize: 20)),
                            Text("6/7",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.blue))
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                          Row(children: [
                            Text("Pass:   ", style: const TextStyle(fontSize: 20)),
                            Text("7/10",
                                style: const TextStyle(
                                    fontSize: 15, color: Colors.blue))
                          ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
                        ],
                      )


                      )),
                      Text(
                      "Ваш ID: ${playerID}",
                      style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 50),
                    )]);
            }
          },
        ),
      ),
    ])));
  }

  @override
  Widget build(BuildContext context) {
    _mediaWeight = MediaQuery.of(context).size.width;
    return Container(child: _getStageWidget());
  }
}

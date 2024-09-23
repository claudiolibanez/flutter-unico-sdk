import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unico_check/unico_check.dart';
import 'package:unico_sdk/src/models/project_info_model.dart';

class HomeScreen extends StatefulWidget {
  final AppConfig configAndroid;
  final AppConfig configIos;

  const HomeScreen({
    super.key,
    required this.configAndroid,
    required this.configIos,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    implements UnicoListener, UnicoSelfie, UnicoDocument {
  bool _cameraGranted = false;
  bool _locationGranted = false;
  late UnicoCheckBuilder _unicoCheck;
  late UnicoCheckCameraOpener _opener;

  final _theme = UnicoTheme(
    colorSilhouetteSuccess: "#4ca832",
    colorSilhouetteError: "#fcdb03",
    colorBackground: "#3295a8",
  );

  final _configIos = UnicoConfig(
    getProjectNumber: "55085324891253416698879",
    getProjectId: "P2xPay",
    getMobileSdkAppId: "2:442247:ios",
    getBundleIdentifier: "br.com.p2xpay.app",
    getHostInfo:
        "nRMqSJJeWMZ0K4n9Dxs/Zhb5RslAxes+pmH0gJgmVtZImMYBRmw3bx3E0ehCDJnY",
    getHostKey:
        "yMDlm6sqtnpx6fXClInnKG+xsBKSgr//wdN+WonRSGORNgRnYfkjQJRDy2FBy2Kj",
  );

  final _configAndroid = UnicoConfig(
    getProjectNumber: "55085324891253416698879",
    getProjectId: "P2xPay",
    getMobileSdkAppId: "1:442247:android",
    getBundleIdentifier: "br.com.p2xpay.app",
    getHostInfo:
        "nRMqSJJeWMZ0K4n9Dxs/Zhb5RslAxes+pmH0gJgmVtZImMYBRmw3bx3E0ehCDJnY",
    getHostKey:
        "yMDlm6sqtnpx6fXClInnKG+xsBKSgr//wdN+WonRSGORNgRnYfkjQJRDy2FBy2Kj",
  );

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    initUnicoCamera();
    configUnicoCamera();
  }

  Future<void> _checkPermissions() async {
    var cameraStatus = await Permission.camera.status;
    var locationStatus = await Permission.location.status;

    if (cameraStatus.isGranted && locationStatus.isGranted) {
      setState(() {
        _cameraGranted = true;
        _locationGranted = true;
      });
    } else {
      _requestPermissions();
    }
  }

  Future<void> _requestPermissions() async {
    await Future.wait([
      _requestCameraPermission(),
      _requestLocationPermission(),
    ]);
  }

  Future<void> _requestCameraPermission() async {
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        _showPermissionDeniedDialog('Câmera');
      }
    } else {
      print('Permissão de câmera concedida');
    }
  }

  Future<void> _requestLocationPermission() async {
    var locationStatus = await Permission.locationWhenInUse.status;

    if (!locationStatus.isGranted) {
      locationStatus = await Permission.locationWhenInUse.request();
      if (!locationStatus.isGranted) {
        _showPermissionDeniedDialog('Localização');
      }
    }
  }

  void _showPermissionDeniedDialog(String permission) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permissão Necessária'),
          content: Text(
              'Para continuar, você deve permitir o acesso à $permission nas configurações.'),
          actions: <Widget>[
            TextButton(
              child: Text('Abrir Configurações'),
              onPressed: () {
                Navigator.of(context).pop();
                AppSettings.openAppSettings(type: AppSettingsType.location);
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void initUnicoCamera() {
    _unicoCheck = UnicoCheck(
      listener: this,
      unicoConfigIos: _configIos,
      unicoConfigAndroid: _configAndroid,
    );
  }

  void configUnicoCamera() {
    _unicoCheck
        .setTheme(unicoTheme: _theme)
        .setTimeoutSession(timeoutSession: 55);
  }

  @override
  void onErrorDocument(UnicoError error) {
    print("onErrorDocument");
    print(error);
  }

  @override
  void onErrorSelfie(UnicoError error) {
    print("onErrorSelfie");
    print(error);
  }

  @override
  void onErrorUnico(UnicoError error) {
    print("onErrorUnico");
    print(error);
  }

  @override
  void onSuccessDocument(ResultCamera resultCamera) {
    print("onSuccessDocument");
    print(resultCamera);
  }

  @override
  void onSuccessSelfie(ResultCamera result) {
    print(
      "onSuccessSelfie - base64: ${result.base64}, encrypted: ${result.encrypted}",
    );
  }

  @override
  void onSystemChangedTypeCameraTimeoutFaceInference() {}

  @override
  void onSystemClosedCameraTimeoutSession() {}

  @override
  void onUserClosedCameraManually() {}

  void setCameraSmart() {
    _opener = _unicoCheck
        .setAutoCapture(autoCapture: true)
        .setSmartFrame(smartFrame: true)
        .build();
  }

  void setCameraNormal() {
    _opener = _unicoCheck
        .setAutoCapture(autoCapture: false)
        .setSmartFrame(smartFrame: false)
        .build();
  }

  void setCameraSmartWithButton() {
    _opener = _unicoCheck
        .setAutoCapture(autoCapture: false)
        .setSmartFrame(smartFrame: true)
        .build();
  }

  void openCamera() {
    setCameraSmart();
    _opener.openCameraSelfie(listener: this);
  }

  void openCameraNormal() {
    setCameraNormal();
    _opener.openCameraSelfie(listener: this);
  }

  void openCameraSmartWithButton() {
    setCameraSmartWithButton();
    _opener.openCameraSelfie(listener: this);
  }

  void openCameraDocumentCNH() {
    _unicoCheck.build().openCameraDocument(
          documentType: DocumentType.CNH,
          listener: this,
        );
  }

  void openCameraDocumentCNHFront() {
    _unicoCheck.build().openCameraDocument(
          documentType: DocumentType.CNH_FRENTE,
          listener: this,
        );
  }

  void openCameraDocumentCNHVerso() {
    _unicoCheck.build().openCameraDocument(
          documentType: DocumentType.CNH_VERSO,
          listener: this,
        );
  }

  void openCameraDocumentRGFront() {
    _unicoCheck.build().openCameraDocument(
          documentType: DocumentType.RG_FRENTE,
          listener: this,
        );
  }

  void openCameraDocumentRGVerso() {
    _unicoCheck.build().openCameraDocument(
          documentType: DocumentType.RG_VERSO,
          listener: this,
        );
  }

  void openCameraDocumentCPF() {
    _unicoCheck.build().openCameraDocument(
          documentType: DocumentType.CPF,
          listener: this,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teste"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text(
                'Bem-vindo a poc do unico | check !',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: Text(
                'Teste agora nossa tecnologia:',
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Camera para selfie',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCameraNormal,
                child: Text('Camera normal'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCamera,
                child: Text('Camera inteligente'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCameraSmartWithButton,
                child: Text('Camera smart button'),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Text(
                'Camera para documentos',
                style: TextStyle(fontSize: 15.0),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                  onPressed: openCameraDocumentCNH,
                  child: Text('Documentos CNH')),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCameraDocumentCNHFront,
                child: Text('Documentos CNH Frente'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCameraDocumentCNHVerso,
                child: Text('Documentos CNH Verso'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCameraDocumentRGFront,
                child: Text('Documentos RG Frente'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCameraDocumentRGVerso,
                child: Text('Documentos RG verso'),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: openCameraDocumentCPF,
                child: Text('Documentos CPF'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

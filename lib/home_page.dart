import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_cvmaker/utils/color_converter.dart';
import 'package:flutter_cvmaker/utils/loading.dart';
import 'package:flutter_cvmaker/config.dart';
import 'package:flutter_cvmaker/models/colors_model.dart';
import 'package:flutter_cvmaker/style.dart';
import 'package:flutter_cvmaker/utils/ads_helper.dart';
import 'package:flutter_cvmaker/utils/snackbar_widget.dart';
import 'package:flutter_cvmaker/widget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_cvmaker/data/colors_data.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

enum AppState { clear, picking, picked, cropped }

class _HomePageState extends State<HomePage> {
  List<ColorsModel> colorList = getMaterialColors();
  List<ColorsModel> avatarBgColorList = getMaterialColors();
  List<ColorsModel> avatarBorderColorList = getMaterialColors();
  List<ColorsModel> headerBgColorList = getMaterialColors();
  List<ColorsModel> headerNameColorList = getMaterialColors();
  List<ColorsModel> headerPositionColorList = getMaterialColors();
  List<ColorsModel> sideBgColorList = getMaterialColors();
  List<ColorsModel> sideSubjectBgColorList = getMaterialColors();
  List<ColorsModel> sideSubjectBorderColorList = getMaterialColors();
  List<ColorsModel> sideSubjectTextColorList = getMaterialColors();
  List<ColorsModel> sideTextColorList = getMaterialColors();
  List<ColorsModel> sideBulletColorList = getMaterialColors();

  List<ColorsModel> bodyBgColorList = getMaterialColors();
  List<ColorsModel> bodySubjectBgColorList = getMaterialColors();
  List<ColorsModel> bodySubjectBorderColorList = getMaterialColors();
  List<ColorsModel> bodySubjectTextColorList = getMaterialColors();
  List<ColorsModel> bodyTextColorList = getMaterialColors();

  late AppState state;
  final ImagePicker imagePicker = ImagePicker();
  late String fileName;
  CroppedFile? mainImageFile;
  int imageWidth = 80;
  int imageHeight = 80;

  bool showPanelAvatar = false;
  bool showPanelTheme = false;

  Color pickerColor = const Color(0xffffffff);

  TextEditingController textInputController = TextEditingController();

  bool isOverLay = false;
  String loadingText = 'Loading..';

  //Screen AspectRatio
  double defaultAspectRatio = 1 / 1.4142;

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  Color selectedColor = const Color(0xff443a49);

  //Ads
  late BannerAd _ad;
  bool _isAdLoaded = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  int loadInterstitialCount = 0;
  int maxloadInterstitialCount = 5;

  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  double screenWidth = 0.0;
  double screenHeight = 0.0;

  bool isShowTabHeader = true;
  bool isShowTabSide = false;
  bool isShowTabBody = false;
  bool isShowTabAvatar = false;

  bool isShowFloatingBtn = true;

  //Theme
  Color headerBgColor = defaultHeaderColor;
  Color headerNameColor = Colors.white;
  Color headerPositionColor = Colors.black87;
  Color bodyBgColor = Colors.white;
  Color bodySubjectBgColor = Colors.white;
  Color bodySubjectTextColor = defaultTextColor;
  Color bodyTextColor = defaultTextColor;
  Color bodySubjectBorderColor = defaultHeaderColor;
  Color sideBgColor = defaultSideBarColor;
  Color sideSubjectBgColor = defaultSideBarColor;
  Color sideSubjectBorderColor = Colors.white70;
  Color sideSubjectTextColor = Colors.white;
  Color sideTextColor = Colors.white;
  Color sideBulletColor = defaultProgressColor;
  Color avatarBgColor = Colors.white;
  Color avatarBorderColor = Colors.grey;
  bool isCircleAvatar = true;

  String firstName = 'JAMES';
  String lastName = 'CHRISTOPHER';
  String positionName = 'CREATIVE DESIGNER';
  String profileDetail =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s';
  List<List<String>> workListing = [
    [
      '2011 - 2014',
      'Graphic Designer',
      'Company Name',
      'Conduct day-to-day project coordination, planning, and implementation across multiple teams'
    ],
    [
      '2014 - 2016',
      'SR. Graphic Designer',
      'Company Name',
      'Managed complex projects from start to finish Collaborated with other designers'
    ],
    [
      '2016 - Present',
      'Creative Director',
      'Company Name',
      'Managed complex projects from start to finish Collaborated with other designers'
    ]
  ];
  List<List<String>> educationListing = [
    ['2004', 'Diploma in Graphic Design', 'University Of Name, US'],
    ['2008', 'Bachelor of Fine Arts', 'University Of Name, New York'],
  ];
  String contactPhone = '+012 456 7896';
  String contactEmail = 'person@domain.com';
  String contactAddress = '123 Dummy Street, New York';
  String infoNationality = 'English';
  String infoBirthDate = 'May 19, 1982';

  bool skillProgress = true;
  List<List<dynamic>> skillListing = [
    ['Photoshop', 90],
    ['Typography', 80],
    ['Indesign', 70],
    ['Illustrator', 85],
    ['Photography', 87],
    ['Graphic Design', 78],
  ];

  List<List<dynamic>> languageListing = [
    ['English', 3, 3, 3, 3],
    ['Spanish', 3, 3, 2, 2],
    ['French', 2, 2, 1, 1],
  ];
  //Reading, Writing, Listening, Speaking

  List<String> awardListing = [
    'Most Outstanding Employee of the Year, Pixelpoint Hive (2018)',
    'Best Mobile App Design, HGFZ Graduate Center (2016)'
  ];

  String? errorPhone;
  String? errorEmail;
  String? errorAddress;
  var phoneInputController = TextEditingController(text: '');
  var emailInputController = TextEditingController(text: '');
  var addressInputController = TextEditingController(text: '');

  String? errorBithdate;
  String? errorNationality;
  String? errorFirstname;
  String? errorLastname;
  String? errorPosition;
  String? errorProfile;
  var birthdateInputController = TextEditingController(text: '');
  var nationalityInputController = TextEditingController(text: '');
  var firstnameInputController = TextEditingController(text: '');
  var lastnameInputController = TextEditingController(text: '');
  var positionInputController = TextEditingController(text: '');
  var profileInputController = TextEditingController(text: '');

  TextEditingController award1InputController = TextEditingController(text: '');
  TextEditingController award2InputController = TextEditingController(text: '');
  TextEditingController award3InputController = TextEditingController(text: '');

  String? errorEdu1Year;
  String? errorEdu1Major;
  String? errorEdu1School;
  TextEditingController edu1YearInputController =
      TextEditingController(text: '');
  TextEditingController edu1SchoolInputController =
      TextEditingController(text: '');
  TextEditingController edu1MajorInputController =
      TextEditingController(text: '');
  TextEditingController edu2YearInputController =
      TextEditingController(text: '');
  TextEditingController edu2SchoolInputController =
      TextEditingController(text: '');
  TextEditingController edu2MajorInputController =
      TextEditingController(text: '');
  TextEditingController edu3YearInputController =
      TextEditingController(text: '');
  TextEditingController edu3SchoolInputController =
      TextEditingController(text: '');
  TextEditingController edu3MajorInputController =
      TextEditingController(text: '');

  String? errorWork1Year;
  String? errorWork1Position;
  String? errorWork1Company;
  String? errorWork1Detail;
  TextEditingController work1YearInputController =
      TextEditingController(text: '');
  TextEditingController work1PositionInputController =
      TextEditingController(text: '');
  TextEditingController work1CompanyInputController =
      TextEditingController(text: '');
  TextEditingController work1DetailInputController =
      TextEditingController(text: '');
  TextEditingController work2YearInputController =
      TextEditingController(text: '');
  TextEditingController work2PositionInputController =
      TextEditingController(text: '');
  TextEditingController work2CompanyInputController =
      TextEditingController(text: '');
  TextEditingController work2DetailInputController =
      TextEditingController(text: '');
  TextEditingController work3YearInputController =
      TextEditingController(text: '');
  TextEditingController work3PositionInputController =
      TextEditingController(text: '');
  TextEditingController work3CompanyInputController =
      TextEditingController(text: '');
  TextEditingController work3DetailInputController =
      TextEditingController(text: '');

  TextEditingController work4YearInputController =
      TextEditingController(text: '');
  TextEditingController work4PositionInputController =
      TextEditingController(text: '');
  TextEditingController work4CompanyInputController =
      TextEditingController(text: '');
  TextEditingController work4DetailInputController =
      TextEditingController(text: '');

  TextEditingController work5YearInputController =
      TextEditingController(text: '');
  TextEditingController work5PositionInputController =
      TextEditingController(text: '');
  TextEditingController work5CompanyInputController =
      TextEditingController(text: '');
  TextEditingController work5DetailInputController =
      TextEditingController(text: '');

  String? errorSkill1Title;
  String? errorSkill1Score;
  String? errorSkill2Score;
  String? errorSkill3Score;
  String? errorSkill4Score;
  String? errorSkill5Score;
  String? errorSkill6Score;
  String? errorSkill7Score;
  TextEditingController skill1TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill1ScoreInputController =
      TextEditingController(text: '');
  TextEditingController skill2TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill2ScoreInputController =
      TextEditingController(text: '');
  TextEditingController skill3TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill3ScoreInputController =
      TextEditingController(text: '');
  TextEditingController skill4TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill4ScoreInputController =
      TextEditingController(text: '');
  TextEditingController skill5TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill5ScoreInputController =
      TextEditingController(text: '');
  TextEditingController skill6TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill6ScoreInputController =
      TextEditingController(text: '');
  TextEditingController skill7TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill7ScoreInputController =
      TextEditingController(text: '');
  TextEditingController skill8TitleInputController =
      TextEditingController(text: '');
  TextEditingController skill8ScoreInputController =
      TextEditingController(text: '');

  String? errorLanguage1Title;
  String? errorLanguage1Reading;
  String? errorLanguage1Writing;
  String? errorLanguage1Listening;
  String? errorLanguage1Speaking;
  TextEditingController language1TitleInputController =
      TextEditingController(text: '');
  TextEditingController language1ReadingInputController =
      TextEditingController(text: '');
  TextEditingController language1WritingInputController =
      TextEditingController(text: '');
  TextEditingController language1ListeningInputController =
      TextEditingController(text: '');
  TextEditingController language1SpeakingInputController =
      TextEditingController(text: '');
  TextEditingController language2TitleInputController =
      TextEditingController(text: '');
  TextEditingController language2ReadingInputController =
      TextEditingController(text: '');
  TextEditingController language2WritingInputController =
      TextEditingController(text: '');
  TextEditingController language2ListeningInputController =
      TextEditingController(text: '');
  TextEditingController language2SpeakingInputController =
      TextEditingController(text: '');
  TextEditingController language3TitleInputController =
      TextEditingController(text: '');
  TextEditingController language3ReadingInputController =
      TextEditingController(text: '');
  TextEditingController language3WritingInputController =
      TextEditingController(text: '');
  TextEditingController language3ListeningInputController =
      TextEditingController(text: '');
  TextEditingController language3SpeakingInputController =
      TextEditingController(text: '');
  TextEditingController language4TitleInputController =
      TextEditingController(text: '');
  TextEditingController language4ReadingInputController =
      TextEditingController(text: '');
  TextEditingController language4WritingInputController =
      TextEditingController(text: '');
  TextEditingController language4ListeningInputController =
      TextEditingController(text: '');
  TextEditingController language4SpeakingInputController =
      TextEditingController(text: '');

  //screen config
  int sideFlex = 3;
  int bodyFlex = 5;
  double headerHeight = 100;
  double fontSizeName = 16;
  double fontSizePosition = 12;
  double avatarRatio = 1.0;
  double sideMarginTop = 10;
  double fontSizeLabel = 8;
  double fontSizeValue = 9;
  double fontSizeSubject = 12;
  double fontSizeIcon = 12;
  double fontSizeBodyValue = 10;
  double subjectMarginTop = 10;
  double lineMarginTop = 5;
  double bodyMargin = 10;

  bool showSelectLayout = false;
  int layoutId = 1;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdsHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              //_moveToHome();
            },
          );

          _isInterstitialAdReady = true;
          print('interstitial ad: ready');
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  void _loadBannerAd() {
    _ad = BannerAd(
      adUnitId: AdsHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
            print('Ad loaded');
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();

          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: AdsHelper.rewardAdUnitId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _loadRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAdFromSave() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      savingImage();
      return;
    } else {
      showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text(
                'View ads to save to image',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    saveImageFromDialog();
                    Navigator.of(context).pop(true);
                  },
                  style: confirmButtonStyle,
                  child: const Text('Yes'),
                ),
              ],
            );
          });
    }
  }

  void saveImageFromDialog() {
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _loadRewardedAd();
        savingImage();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _loadRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) async {
      print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      //savingImage();
    });
    _rewardedAd = null;
  }

  void savingImage() {
    setState(() {
      isOverLay = true;
      loadingText = 'Saving..';
    });
    screenshotController.capture().then((Uint8List? imageFile8List) async {
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = File(
          "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".png");
      await file.writeAsBytes(imageFile8List!);
      final result = await ImageGallerySaver.saveFile(file.path);
      SnackbarWidget.show(context,
          text: 'Save to gallery successfully', milliseconds: 2500);
      setState(() {
        isOverLay = false;
        loadingText = 'Loading.. image';
      });
      print(result);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future saveToPdf() async {
    setState(() {
      isOverLay = true;
      loadingText = 'Saving..to PDF';
    });

    screenshotController.capture().then((Uint8List? imageFile8List) async {
      pw.Document pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) {
            return pw.Expanded(
              child: pw.Image(pw.MemoryImage(imageFile8List!),
                  fit: pw.BoxFit.contain),
            );
          },
        ),
      );
      //String path = (await getTemporaryDirectory()).path;

      Directory directory = Directory("");
      if (Platform.isAndroid) {
        // Redirects it to download folder in android
        directory = Directory("/storage/emulated/0/Download");
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      String filePath = directory.path +
          "/" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          ".pdf";
      print('Save pdf :' + filePath);
      File pdfFile = await File(filePath).create();

      pdfFile.writeAsBytes(await pdf.save());
      SnackbarWidget.show(context,
          text: 'Save to ' + filePath + ' successfully', milliseconds: 2500);

      setState(() {
        isOverLay = false;
        loadingText = '';
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  Widget currentLayout() {
    if (layoutId == 1) {
      return layoutDefault();
    } else if (layoutId == 2) {
      return layoutHeadFloatingAvatarLeft();
    } else if (layoutId == 3) {
      return layoutHeadFloatingAvatarRight();
    } else if (layoutId == 4) {
      return layoutHeaderWhite();
    } else if (layoutId == 5) {
      return layoutHeaderWhiteUnderline();
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
    state = AppState.clear;
    isOverLay = false;

    loadData();

    if (isShowAds) {
      _loadInterstitialAd();
      _loadBannerAd();
      _loadRewardedAd();
    }

    bool isMobile = isPhone();
    setState(() {
      defaultAspectRatio = 2480 / 3508;
      sideFlex = isMobile ? 3 : 2;
      bodyFlex = isMobile ? 5 : 5;
      headerHeight =
          isMobile ? defaultAspectRatio * 120 : defaultAspectRatio * 200;
      fontSizeName = isMobile ? 18 : 28;
      fontSizePosition = isMobile ? 14 : 24;
      avatarRatio = isMobile ? 1.0 : 1.6;
      sideMarginTop = isMobile ? 10 : 20;
      fontSizeLabel = isMobile ? 8 : 14;
      fontSizeValue = isMobile ? 9 : 15;
      fontSizeSubject = isMobile ? 12 : 22;
      fontSizeIcon = isMobile ? 12 : 18;
      fontSizeBodyValue = isMobile ? 10 : 18;
      subjectMarginTop = isMobile ? 10 : 20;
      lineMarginTop = isMobile ? 5 : 10;
      bodyMargin = isMobile ? 15 : 25;
    });
  }

  void reset() {
    setState(() {
      hideAllPanel();
    });
  }

  Widget appTitleBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          //padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          // decoration: const BoxDecoration(
          //   color: Colors.black12,
          //   borderRadius: BorderRadius.all(Radius.circular(5)),
          // ),
          child: const Text(
            'CV MAKER',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(1.2, 1.2),
                  blurRadius: 1.0,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> actionMenu(BuildContext context) {
    return [
      IconButton(
        onPressed: () async {
          setState(() {
            showSelectLayout = true;
          });
        },
        icon: Icon(Icons.space_dashboard_outlined,
            color: isEditing() ? Colors.white : Colors.white54),
      ),
      IconButton(
        onPressed: () async {
          isEditing()
              ? _showRewardedAdFromSave()
              : SnackbarWidget.show(context,
                  text: 'Please place avatar and enter your info');
        },
        icon: Icon(Icons.image,
            color: isEditing() ? Colors.white : Colors.white54),
      ),
      IconButton(
        onPressed: () async {
          isEditing()
              ? saveToPdf()
              : SnackbarWidget.show(context,
                  text: 'Please place avatar and enter your info');
        },
        icon: Icon(Icons.picture_as_pdf,
            color: isEditing() ? Colors.white : Colors.white54),
      ),
      IconButton(
        onPressed: () async {
          isEditing()
              ? saveAll()
              : SnackbarWidget.show(context,
                  text: 'Please place avatar and enter your info');
        },
        icon: Icon(Icons.save,
            color: isEditing() ? Colors.white : Colors.white54),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    Future<bool> showExitPopup() async {
      FocusScope.of(context).unfocus();
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit an App?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                TextButton(
                  onPressed: () {
                    if (_isInterstitialAdReady) {
                      _interstitialAd?.show();
                    }
                    Navigator.of(context).pop(true);
                  },
                  style: confirmButtonStyle,
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false; //if showDialouge had returned null, then return false
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        appBar: AppBar(
          title: appTitleBar(),
          centerTitle: false,
          backgroundColor: primaryColor,
          elevation: 4,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, primaryLightColor],
                stops: [0.1, 1.0],
              ),
            ),
          ),
          actions: actionMenu(context),
        ),
        body: Container(
          color: backgroundColor,
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              if (_isAdLoaded)
                Container(
                  width: _ad.size.width.toDouble(),
                  height: 72.0,
                  alignment: Alignment.center,
                  child: AdWidget(ad: _ad),
                ),
              Expanded(
                child: Stack(
                  alignment: AlignmentDirectional.topCenter,
                  children: [
                    if (isEditing())
                      AspectRatio(
                        aspectRatio: defaultAspectRatio,
                        child: Screenshot(
                          controller: screenshotController,
                          child: currentLayout(),
                        ),
                      ),
                    Stack(
                      children: [
                        if (showPanelAvatar || showPanelTheme)
                          GestureDetector(
                            onTap: () {
                              hideAllPanel();
                            },
                            child: Container(
                              color: Colors.transparent,
                              alignment: Alignment.center,
                            ),
                          ),
                        panelAvatar(context),
                        panelTheme(context),
                      ],
                    ),
                    if (isOverLay)
                      Container(
                        color: Colors.black54,
                        child: showLoading(text: loadingText),
                      ),
                    if (showSelectLayout) selectLayout()
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: !isShowFloatingBtn
            ? Container()
            : SpeedDial(
                closedForegroundColor: Colors.black,
                openForegroundColor: Colors.white,
                closedBackgroundColor: primaryDarkColor,
                openBackgroundColor: primaryColor,
                labelsStyle: const TextStyle(color: Colors.white70),
                labelsBackgroundColor: Colors.black87,
                speedDialChildren: <SpeedDialChild>[
                  SpeedDialChild(
                    child: const Icon(Icons.account_box),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Avatar',
                    onPressed: () {
                      setState(() {
                        _pickImage(ImageSource.gallery);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.phone),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Contacts',
                    onPressed: () {
                      setState(() {
                        dialogContact(context);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.star_rounded),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Skills',
                    onPressed: () {
                      setState(() {
                        dialogSkills(context);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.g_translate_rounded),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Language',
                    onPressed: () {
                      setState(() {
                        dialogLanguage(context);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.emoji_events_rounded),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Awards',
                    onPressed: () {
                      setState(() {
                        dialogAward(context);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.subject_rounded),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Profile',
                    onPressed: () {
                      setState(() {
                        dialogProfile(context);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.domain_rounded),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Works',
                    onPressed: () {
                      setState(() {
                        dialogWorks(context);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.school_rounded),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Educations',
                    onPressed: () {
                      setState(() {
                        dialogEducation(context);
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.palette),
                    foregroundColor: buttonText,
                    backgroundColor: button1,
                    label: 'Theme',
                    onPressed: () {
                      setState(() {
                        setPanelTheme();
                      });
                    },
                    closeSpeedDialOnPressed: true,
                  ),
                ],
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget headerBox() {
    return Container(
        color: headerBgColor,
        alignment: Alignment.centerLeft,
        height: headerHeight,
        child: Container(
          margin: const EdgeInsets.only(left: 10, bottom: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstName,
                style: TextStyle(
                    color: headerNameColor,
                    fontSize: fontSizeName,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                lastName,
                style: TextStyle(
                    color: headerNameColor,
                    fontSize: fontSizeName,
                    fontWeight: FontWeight.w500),
              ),
              Container(
                margin: const EdgeInsets.only(top: 3),
                child: Text(
                  positionName,
                  style: TextStyle(
                      color: headerPositionColor,
                      fontSize: fontSizePosition,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ],
          ),
        ));
  }

  Widget profileBox({double marginTop = 0}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: bodySubjectBgColor,
            border: Border(
              bottom: BorderSide(
                color: bodySubjectBorderColor,
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: bodySubjectBgColor == bodyBgColor
              ? EdgeInsets.only(
                  left: 0, right: lineMarginTop, top: marginTop, bottom: 5)
              : EdgeInsets.all(lineMarginTop),
          child: Text(
            'PROFILE',
            style: TextStyle(
                color: bodySubjectTextColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeSubject),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: lineMarginTop),
          child: Text(
            profileDetail,
            style: TextStyle(fontSize: fontSizeValue, color: bodyTextColor),
          ),
        ),
      ],
    );
  }

  Widget workBox() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: subjectMarginTop),
          decoration: BoxDecoration(
            color: bodySubjectBgColor,
            border: Border(
              bottom: BorderSide(
                color: bodySubjectBorderColor,
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: bodySubjectBgColor == bodyBgColor
              ? EdgeInsets.only(
                  left: 0,
                  right: lineMarginTop,
                  top: lineMarginTop,
                  bottom: lineMarginTop)
              : EdgeInsets.all(lineMarginTop),
          child: Text(
            'WORK EXPERIENCE',
            style: TextStyle(
                color: bodySubjectTextColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeSubject),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: lineMarginTop),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var wk in workListing)
                Container(
                  margin: EdgeInsets.only(top: lineMarginTop),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wk[0],
                        style: TextStyle(
                            fontSize: fontSizeBodyValue,
                            color: bodyTextColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        wk[1].toUpperCase(),
                        style: TextStyle(
                            fontSize: fontSizeBodyValue,
                            color: bodyTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        wk[2].toUpperCase(),
                        style: TextStyle(
                            fontSize: fontSizeBodyValue, color: bodyTextColor),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        child: Text(
                          wk[3],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: fontSizeLabel, color: bodyTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget educationBox() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: subjectMarginTop),
          decoration: BoxDecoration(
            color: bodySubjectBgColor,
            border: Border(
              bottom: BorderSide(
                color: bodySubjectBorderColor,
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: bodySubjectBgColor == bodyBgColor
              ? EdgeInsets.only(
                  left: 0,
                  right: lineMarginTop,
                  top: lineMarginTop,
                  bottom: lineMarginTop)
              : EdgeInsets.all(lineMarginTop),
          child: Text(
            'EDUCATION',
            style: TextStyle(
                color: bodySubjectTextColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeSubject),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: lineMarginTop),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var wk in educationListing)
                Container(
                  margin: EdgeInsets.only(top: lineMarginTop),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wk[0],
                        style: TextStyle(
                            fontSize: fontSizeBodyValue,
                            color: bodyTextColor,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        wk[1].toUpperCase(),
                        style: TextStyle(
                            fontSize: fontSizeBodyValue,
                            color: bodyTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        wk[2].toUpperCase(),
                        style: TextStyle(
                            fontSize: fontSizeBodyValue, color: bodyTextColor),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget sideBox() {
    return Container(
      color: sideBgColor,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: sideBgColor,
              padding: EdgeInsets.all(lineMarginTop),
              margin: EdgeInsets.only(top: sideMarginTop),
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  avatarBox(),
                  infoBox(marginTop: subjectMarginTop),
                  contactBox(),
                  skillBox(),
                  languageBox(),
                  if (awardListing.isNotEmpty) awardBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget avatarBox({int borderSize = 100, int bgSize = 90}) {
    return Container(
      child: isCircleAvatar
          ? ClipRRect(
              borderRadius: BorderRadius.circular(100 * avatarRatio),
              child: Container(
                height: borderSize * avatarRatio,
                width: borderSize * avatarRatio,
                color: avatarBorderColor,
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90 * avatarRatio),
                  child: Container(
                    height: bgSize * avatarRatio,
                    width: bgSize * avatarRatio,
                    color: avatarBgColor,
                    padding: const EdgeInsets.all(2),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular((bgSize - 10) * avatarRatio),
                      child: Container(
                        color: avatarBgColor,
                        child: mainImageFile != null
                            ? GestureDetector(
                                onTap: () {
                                  setPanelAvatar();
                                },
                                child: Image.file(
                                  File(mainImageFile!.path),
                                  width: imageWidth * avatarRatio,
                                  height: imageHeight * avatarRatio,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Image.asset(
                                'assets/images/avatar.png',
                                width: imageWidth * avatarRatio,
                                height: imageHeight * avatarRatio,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                color: avatarBgColor,
                border: Border.all(
                    color: avatarBorderColor, width: 2 * avatarRatio),
              ),
              child: mainImageFile != null
                  ? GestureDetector(
                      onTap: () {
                        setPanelAvatar();
                      },
                      child: Image.file(
                        File(mainImageFile!.path),
                        width: imageWidth * avatarRatio + 20,
                        height: imageHeight * avatarRatio + 20,
                        fit: BoxFit.fill,
                      ),
                    )
                  : Image.asset(
                      'assets/images/avatar.png',
                      width: imageWidth * avatarRatio + 20,
                      height: imageHeight * avatarRatio + 20,
                      fit: BoxFit.fitWidth,
                    ),
            ),
    );
  }

  Widget infoBox({double marginTop = 0}) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: marginTop),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Date of Birth : ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: fontSizeLabel, color: sideTextColor),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' ${infoBirthDate}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: fontSizeValue, color: sideTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Nationality : ',
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: fontSizeLabel, color: sideTextColor),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        ' ${infoNationality}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: fontSizeValue, color: sideTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget contactBox() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: subjectMarginTop),
          decoration: BoxDecoration(
            color: sideSubjectBgColor,
            border: Border(
              bottom: BorderSide(
                color: sideSubjectBorderColor,
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: sideSubjectBgColor == sideBgColor
              ? EdgeInsets.only(
                  left: 0,
                  right: lineMarginTop,
                  top: lineMarginTop,
                  bottom: lineMarginTop)
              : EdgeInsets.all(lineMarginTop),
          child: Text(
            'CONTACTS',
            style: TextStyle(
                color: sideSubjectTextColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeSubject),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: lineMarginTop),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: lineMarginTop),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.phone,
                          size: fontSizeIcon,
                          color: sideBulletColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        contactPhone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: fontSizeValue, color: sideTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: lineMarginTop),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.email,
                          size: fontSizeIcon,
                          color: sideBulletColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        contactEmail,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: fontSizeValue, color: sideTextColor),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: lineMarginTop),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.location_on,
                          size: fontSizeIcon,
                          color: sideBulletColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Text(
                        contactAddress,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: fontSizeValue, color: sideTextColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget skillBox() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: subjectMarginTop),
          decoration: BoxDecoration(
            color: sideSubjectBgColor,
            border: Border(
              bottom: BorderSide(
                color: sideSubjectBorderColor,
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: sideSubjectBgColor == sideBgColor
              ? const EdgeInsets.only(left: 0, right: 5, top: 5, bottom: 5)
              : const EdgeInsets.all(5),
          child: Text(
            'SKILLS',
            style: TextStyle(
                color: sideSubjectTextColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeSubject),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (skillProgress)
                for (var rs in skillListing)
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              ' ${rs[0]}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: fontSizeLabel,
                                  color: sideTextColor),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: LinearPercentIndicator(
                              lineHeight: 5.0 * avatarRatio,
                              percent: rs[1] / 100,
                              backgroundColor: Colors.grey,
                              progressColor: sideBulletColor,
                            ),
                          ),
                        ],
                      )),
              if (!skillProgress)
                for (var rs in skillListing)
                  Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 6,
                            color: sideBulletColor,
                          ),
                          Text(
                            ' ${rs[0]}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: fontSizeLabel, color: sideTextColor),
                          ),
                        ],
                      )),
            ],
          ),
        ),
      ],
    );
  }

  Widget languageBox() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: subjectMarginTop),
          decoration: BoxDecoration(
            color: sideSubjectBgColor,
            border: Border(
              bottom: BorderSide(
                color: sideSubjectBorderColor,
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: sideSubjectBgColor == sideBgColor
              ? const EdgeInsets.only(left: 0, right: 5, top: 5, bottom: 5)
              : const EdgeInsets.all(5),
          child: Text(
            'LANGUAGE',
            style: TextStyle(
                color: sideSubjectTextColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeSubject),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text('',
                          style: TextStyle(
                              fontSize: fontSizeLabel, color: sideTextColor)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('R',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeLabel, color: sideTextColor)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('W',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeLabel, color: sideTextColor)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('L',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeLabel, color: sideTextColor)),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text('S',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: fontSizeLabel, color: sideTextColor)),
                    ),
                  ],
                ),
              ),
              for (var rs in languageListing)
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          ' ${rs[0]}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: fontSizeLabel, color: sideTextColor),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[1] > 0 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[1] > 1 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[1] > 2 ? sideBulletColor : Colors.grey),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[2] > 0 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[2] > 1 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[2] > 2 ? sideBulletColor : Colors.grey),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[3] > 0 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[3] > 1 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[3] > 2 ? sideBulletColor : Colors.grey),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[4] > 0 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[4] > 1 ? sideBulletColor : Colors.grey),
                            Icon(Icons.circle,
                                size: 4 * avatarRatio,
                                color:
                                    rs[4] > 2 ? sideBulletColor : Colors.grey),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget awardBox() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: subjectMarginTop),
          decoration: BoxDecoration(
            color: sideSubjectBgColor,
            border: Border(
              bottom: BorderSide(
                color: sideSubjectBorderColor,
                width: 1.0,
              ),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: sideSubjectBgColor == sideBgColor
              ? const EdgeInsets.only(left: 0, right: 5, top: 5, bottom: 5)
              : const EdgeInsets.all(5),
          child: Text(
            'AWARD',
            style: TextStyle(
                color: sideSubjectTextColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSizeSubject),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          alignment: Alignment.topLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var rs in awardListing)
                Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Text(
                      rs,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: fontSizeLabel, color: sideTextColor),
                    )),
            ],
          ),
        ),
      ],
    );
  }

  bool isEditing() {
    return true;
  }

  //Set Panel Visible
  void hideAllPanel() {
    setState(() {
      showPanelAvatar = false;
      showPanelTheme = false;
      isShowFloatingBtn = true;
    });
  }

  void setPanelAvatar() async {
    if (_isInterstitialAdReady) {
      _interstitialAd?.show();
    }
    setState(() {
      showPanelAvatar = !showPanelAvatar;
      showPanelTheme = false;
      isShowFloatingBtn = false;
    });
  }

  void setPanelTheme() async {
    if (_isInterstitialAdReady) {
      _interstitialAd?.show();
    }
    setState(() {
      showPanelAvatar = false;
      showPanelTheme = !showPanelTheme;
      isShowFloatingBtn = false;
    });
  }

  //Panel Widget
  Widget panelAvatar(BuildContext context) {
    return panelWidget(
      title: 'Avatar',
      height: showPanelAvatar ? 400 : 0,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: buttonMargin,
                        child: TextButton(
                            style: buttonStyleDefault,
                            onPressed: () {
                              setState(() {
                                _cropImage();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.crop),
                                Text(
                                  ' Crop Image',
                                ),
                              ],
                            )),
                      )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                        margin: buttonMargin,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: TextButton(
                                    style: isCircleAvatar
                                        ? buttonStyleDefault
                                        : buttonDisableStyle,
                                    onPressed: () {
                                      setState(() {
                                        isCircleAvatar = true;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.account_circle_outlined),
                                        Text(' Circle'),
                                      ],
                                    )),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                margin: const EdgeInsets.only(left: 5),
                                child: TextButton(
                                    style: !isCircleAvatar
                                        ? buttonStyleDefault
                                        : buttonDisableStyle,
                                    onPressed: () {
                                      setState(() {
                                        isCircleAvatar = false;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(Icons.account_box_outlined),
                                        Text(' Square'),
                                      ],
                                    )),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        child: const Text('Bg Color')),
                    Container(
                      padding: const EdgeInsets.all(0),
                      height: 50,
                      child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          children:
                              List.generate(avatarBgColorList.length, (index) {
                            return Container(
                              color: avatarBgColorList[index].isActive
                                  ? Colors.grey.shade200
                                  : Colors.transparent,
                              child: IconButton(
                                onPressed: () async {
                                  for (var rs in avatarBgColorList) {
                                    rs.isActive = false;
                                  }
                                  if (avatarBgColorList[index].isNone) {
                                    avatarBgColor = Colors.transparent;
                                    avatarBgColorList[index].isActive = false;
                                  } else if (avatarBgColorList[index]
                                      .isPicker) {
                                    dynamic result = await openColorPicker(
                                        context, avatarBgColor);
                                    if (result != null) {
                                      avatarBgColor = result;
                                    }
                                  } else {
                                    avatarBgColor =
                                        avatarBgColorList[index].color;
                                    avatarBgColorList[index].isActive = true;
                                  }
                                  setState(() {});
                                },
                                padding: EdgeInsets.zero,
                                icon: avatarBgColorList[index].icon,
                              ),
                            );
                          })),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        child: const Text('Border Color')),
                    Container(
                      padding: const EdgeInsets.all(0),
                      height: 50,
                      child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          scrollDirection: Axis.horizontal,
                          children: List.generate(avatarBorderColorList.length,
                              (index) {
                            return Container(
                              color: avatarBorderColorList[index].isActive
                                  ? Colors.grey.shade200
                                  : Colors.transparent,
                              child: IconButton(
                                onPressed: () async {
                                  for (var rs in avatarBorderColorList) {
                                    rs.isActive = false;
                                  }
                                  if (avatarBorderColorList[index].isNone) {
                                    avatarBorderColor = Colors.transparent;
                                    avatarBorderColorList[index].isActive =
                                        false;
                                  } else if (avatarBorderColorList[index]
                                      .isPicker) {
                                    dynamic result = await openColorPicker(
                                        context, avatarBgColor);
                                    if (result != null) {
                                      avatarBorderColor = result;
                                    }
                                  } else {
                                    avatarBorderColor =
                                        avatarBorderColorList[index].color;
                                    avatarBorderColorList[index].isActive =
                                        true;
                                  }
                                  setState(() {});
                                },
                                padding: EdgeInsets.zero,
                                icon: avatarBorderColorList[index].icon,
                              ),
                            );
                          })),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget panelTheme(BuildContext context) {
    return panelWidget(
      title: 'Theme',
      height: showPanelTheme ? 400 : 0,
      child: Container(
        margin: const EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            Container(
                height: 40,
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black12,
                      width: 1.0,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: TextButton(
                            onPressed: () async {
                              setState(() {
                                isShowTabHeader = true;
                                isShowTabSide = false;
                                isShowTabBody = false;
                                isShowTabAvatar = false;
                              });
                            },
                            child: Text(
                              'Header',
                              style: TextStyle(
                                  color: isShowTabHeader
                                      ? primaryDarkColor
                                      : Colors.black87,
                                  fontWeight: isShowTabHeader
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: TextButton(
                            onPressed: () async {
                              setState(() {
                                isShowTabHeader = false;
                                isShowTabSide = true;
                                isShowTabBody = false;
                                isShowTabAvatar = false;
                              });
                            },
                            child: Text(
                              'Side',
                              style: TextStyle(
                                  color: isShowTabSide
                                      ? primaryDarkColor
                                      : Colors.black87,
                                  fontWeight: isShowTabSide
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            )),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.all(2),
                        child: TextButton(
                            onPressed: () async {
                              setState(() {
                                isShowTabHeader = false;
                                isShowTabSide = false;
                                isShowTabBody = true;
                                isShowTabAvatar = false;
                              });
                            },
                            child: Text(
                              'Body',
                              style: TextStyle(
                                  color: isShowTabBody
                                      ? primaryDarkColor
                                      : Colors.black87,
                                  fontWeight: isShowTabBody
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            )),
                      ),
                    ),
                  ],
                )),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isShowTabHeader)
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Bg Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          headerBgColorList.length, (index) {
                                        return Container(
                                          color:
                                              headerBgColorList[index].isActive
                                                  ? Colors.grey.shade200
                                                  : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in headerBgColorList) {
                                                rs.isActive = false;
                                              }
                                              if (headerBgColorList[index]
                                                  .isNone) {
                                                headerBgColor =
                                                    Colors.transparent;
                                                headerBgColorList[index]
                                                    .isActive = false;
                                              } else if (headerBgColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context, headerBgColor);
                                                if (result != null) {
                                                  headerBgColor = result;
                                                }
                                              } else {
                                                headerBgColor =
                                                    headerBgColorList[index]
                                                        .color;
                                                headerBgColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: headerBgColorList[index].icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Name Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          headerNameColorList.length, (index) {
                                        return Container(
                                          color: headerNameColorList[index]
                                                  .isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in headerNameColorList) {
                                                rs.isActive = false;
                                              }
                                              if (headerNameColorList[index]
                                                  .isNone) {
                                                headerNameColor =
                                                    Colors.transparent;
                                                headerNameColorList[index]
                                                    .isActive = false;
                                              } else if (headerNameColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        headerNameColor);
                                                if (result != null) {
                                                  headerNameColor = result;
                                                }
                                              } else {
                                                headerNameColor =
                                                    headerNameColorList[index]
                                                        .color;
                                                headerNameColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon:
                                                headerNameColorList[index].icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Position Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          headerPositionColorList.length,
                                          (index) {
                                        return Container(
                                          color: headerPositionColorList[index]
                                                  .isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in headerPositionColorList) {
                                                rs.isActive = false;
                                              }
                                              if (headerPositionColorList[index]
                                                  .isNone) {
                                                headerPositionColor =
                                                    Colors.transparent;
                                                headerPositionColorList[index]
                                                    .isActive = false;
                                              } else if (headerPositionColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        headerPositionColor);
                                                if (result != null) {
                                                  headerPositionColor = result;
                                                }
                                              } else {
                                                headerPositionColor =
                                                    headerPositionColorList[
                                                            index]
                                                        .color;
                                                headerPositionColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: headerPositionColorList[index]
                                                .icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (isShowTabSide)
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Bg Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          sideBgColorList.length, (index) {
                                        return Container(
                                          color: sideBgColorList[index].isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs in sideBgColorList) {
                                                rs.isActive = false;
                                              }
                                              if (sideBgColorList[index]
                                                  .isNone) {
                                                sideBgColor =
                                                    Colors.transparent;
                                                sideBgColorList[index]
                                                    .isActive = false;
                                              } else if (sideBgColorList[index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context, sideBgColor);
                                                if (result != null) {
                                                  sideBgColor = result;
                                                }
                                              } else {
                                                sideBgColor =
                                                    sideBgColorList[index]
                                                        .color;
                                                sideBgColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: sideBgColorList[index].icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Subject Bg Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          sideSubjectBgColorList.length,
                                          (index) {
                                        return Container(
                                          color: sideSubjectBgColorList[index]
                                                  .isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in sideSubjectBgColorList) {
                                                rs.isActive = false;
                                              }
                                              if (sideSubjectBgColorList[index]
                                                  .isNone) {
                                                sideSubjectBgColor =
                                                    Colors.transparent;
                                                sideSubjectBgColorList[index]
                                                    .isActive = false;
                                              } else if (sideSubjectBgColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        sideSubjectBgColor);
                                                if (result != null) {
                                                  sideSubjectBgColor = result;
                                                }
                                              } else {
                                                sideSubjectBgColor =
                                                    sideSubjectBgColorList[
                                                            index]
                                                        .color;
                                                sideSubjectBgColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: sideSubjectBgColorList[index]
                                                .icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Subject Border Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          sideSubjectBorderColorList.length,
                                          (index) {
                                        return Container(
                                          color:
                                              sideSubjectBorderColorList[index]
                                                      .isActive
                                                  ? Colors.grey.shade200
                                                  : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in sideSubjectBorderColorList) {
                                                rs.isActive = false;
                                              }
                                              if (sideSubjectBorderColorList[
                                                      index]
                                                  .isNone) {
                                                sideSubjectBorderColor =
                                                    Colors.transparent;
                                                sideSubjectBorderColorList[
                                                        index]
                                                    .isActive = false;
                                              } else if (sideSubjectBorderColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        sideSubjectBorderColor);
                                                if (result != null) {
                                                  sideSubjectBorderColor =
                                                      result;
                                                }
                                              } else {
                                                sideSubjectBorderColor =
                                                    sideSubjectBorderColorList[
                                                            index]
                                                        .color;
                                                sideSubjectBorderColorList[
                                                        index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: sideSubjectBorderColorList[
                                                    index]
                                                .icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Subject Text Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          sideSubjectTextColorList.length,
                                          (index) {
                                        return Container(
                                          color: sideSubjectTextColorList[index]
                                                  .isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in sideSubjectTextColorList) {
                                                rs.isActive = false;
                                              }
                                              if (sideSubjectTextColorList[
                                                      index]
                                                  .isNone) {
                                                sideSubjectTextColor =
                                                    Colors.transparent;
                                                sideSubjectTextColorList[index]
                                                    .isActive = false;
                                              } else if (sideSubjectTextColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        sideSubjectTextColor);
                                                if (result != null) {
                                                  sideSubjectTextColor = result;
                                                }
                                              } else {
                                                sideSubjectTextColor =
                                                    sideSubjectTextColorList[
                                                            index]
                                                        .color;
                                                sideSubjectTextColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon:
                                                sideSubjectTextColorList[index]
                                                    .icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Text Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          sideTextColorList.length, (index) {
                                        return Container(
                                          color:
                                              sideTextColorList[index].isActive
                                                  ? Colors.grey.shade200
                                                  : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in sideTextColorList) {
                                                rs.isActive = false;
                                              }
                                              if (sideTextColorList[index]
                                                  .isNone) {
                                                sideTextColor =
                                                    Colors.transparent;
                                                sideTextColorList[index]
                                                    .isActive = false;
                                              } else if (sideTextColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context, sideTextColor);
                                                if (result != null) {
                                                  sideTextColor = result;
                                                }
                                              } else {
                                                sideTextColor =
                                                    sideTextColorList[index]
                                                        .color;
                                                sideTextColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: sideTextColorList[index].icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Bullet Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          sideBulletColorList.length, (index) {
                                        return Container(
                                          color: sideBulletColorList[index]
                                                  .isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in sideBulletColorList) {
                                                rs.isActive = false;
                                              }
                                              if (sideBulletColorList[index]
                                                  .isNone) {
                                                sideBulletColor =
                                                    Colors.transparent;
                                                sideBulletColorList[index]
                                                    .isActive = false;
                                              } else if (sideBulletColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        sideBulletColor);
                                                if (result != null) {
                                                  sideBulletColor = result;
                                                }
                                              } else {
                                                sideBulletColor =
                                                    sideBulletColorList[index]
                                                        .color;
                                                sideBulletColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon:
                                                sideBulletColorList[index].icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    if (isShowTabBody)
                      Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Bg Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          bodyBgColorList.length, (index) {
                                        return Container(
                                          color: bodyBgColorList[index].isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs in bodyBgColorList) {
                                                rs.isActive = false;
                                              }
                                              if (bodyBgColorList[index]
                                                  .isNone) {
                                                bodyBgColor =
                                                    Colors.transparent;
                                                bodyBgColorList[index]
                                                    .isActive = false;
                                              } else if (bodyBgColorList[index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context, bodyBgColor);
                                                if (result != null) {
                                                  bodyBgColor = result;
                                                }
                                              } else {
                                                bodyBgColor =
                                                    bodyBgColorList[index]
                                                        .color;
                                                bodyBgColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: bodyBgColorList[index].icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Subject Bg Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          bodySubjectBgColorList.length,
                                          (index) {
                                        return Container(
                                          color: bodySubjectBgColorList[index]
                                                  .isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in bodySubjectBgColorList) {
                                                rs.isActive = false;
                                              }
                                              if (bodySubjectBgColorList[index]
                                                  .isNone) {
                                                bodySubjectBgColor =
                                                    Colors.transparent;
                                                bodySubjectBgColorList[index]
                                                    .isActive = false;
                                              } else if (bodySubjectBgColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        bodySubjectBgColor);
                                                if (result != null) {
                                                  bodySubjectBgColor = result;
                                                }
                                              } else {
                                                bodySubjectBgColor =
                                                    bodySubjectBgColorList[
                                                            index]
                                                        .color;
                                                bodySubjectBgColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: bodySubjectBgColorList[index]
                                                .icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Subject Border Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          bodySubjectBorderColorList.length,
                                          (index) {
                                        return Container(
                                          color:
                                              bodySubjectBorderColorList[index]
                                                      .isActive
                                                  ? Colors.grey.shade200
                                                  : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in bodySubjectBorderColorList) {
                                                rs.isActive = false;
                                              }
                                              if (bodySubjectBorderColorList[
                                                      index]
                                                  .isNone) {
                                                bodySubjectBorderColor =
                                                    Colors.transparent;
                                                bodySubjectBgColorList[index]
                                                    .isActive = false;
                                              } else if (bodySubjectBorderColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        bodySubjectBorderColor);
                                                if (result != null) {
                                                  bodySubjectBorderColor =
                                                      result;
                                                }
                                              } else {
                                                bodySubjectBorderColor =
                                                    bodySubjectBorderColorList[
                                                            index]
                                                        .color;
                                                bodySubjectBorderColorList[
                                                        index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: bodySubjectBorderColorList[
                                                    index]
                                                .icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Subject Text Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          bodySubjectTextColorList.length,
                                          (index) {
                                        return Container(
                                          color: bodySubjectTextColorList[index]
                                                  .isActive
                                              ? Colors.grey.shade200
                                              : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in bodySubjectTextColorList) {
                                                rs.isActive = false;
                                              }
                                              if (bodySubjectTextColorList[
                                                      index]
                                                  .isNone) {
                                                bodySubjectTextColor =
                                                    Colors.transparent;
                                                bodySubjectBgColorList[index]
                                                    .isActive = false;
                                              } else if (bodySubjectTextColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context,
                                                        bodySubjectTextColor);
                                                if (result != null) {
                                                  bodySubjectTextColor = result;
                                                }
                                              } else {
                                                bodySubjectTextColor =
                                                    bodySubjectTextColorList[
                                                            index]
                                                        .color;
                                                bodySubjectTextColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon:
                                                bodySubjectTextColorList[index]
                                                    .icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(5),
                                    child: const Text('Text Color')),
                                Container(
                                  padding: const EdgeInsets.all(0),
                                  height: 50,
                                  child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.horizontal,
                                      children: List.generate(
                                          bodyTextColorList.length, (index) {
                                        return Container(
                                          color:
                                              bodyTextColorList[index].isActive
                                                  ? Colors.grey.shade200
                                                  : Colors.transparent,
                                          child: IconButton(
                                            onPressed: () async {
                                              for (var rs
                                                  in bodyTextColorList) {
                                                rs.isActive = false;
                                              }
                                              if (bodyTextColorList[index]
                                                  .isNone) {
                                                bodyTextColor =
                                                    Colors.transparent;
                                                bodySubjectBgColorList[index]
                                                    .isActive = false;
                                              } else if (bodyTextColorList[
                                                      index]
                                                  .isPicker) {
                                                dynamic result =
                                                    await openColorPicker(
                                                        context, bodyTextColor);
                                                if (result != null) {
                                                  bodyTextColor = result;
                                                }
                                              } else {
                                                bodyTextColor =
                                                    bodyTextColorList[index]
                                                        .color;
                                                bodyTextColorList[index]
                                                    .isActive = true;
                                              }
                                              setState(() {});
                                            },
                                            padding: EdgeInsets.zero,
                                            icon: bodyTextColorList[index].icon,
                                          ),
                                        );
                                      })),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future openColorPicker(BuildContext context, Color? currentColor) {
    Color pickedColor = const Color(0xff443a49);
    pickedColor = currentColor ?? pickedColor;
    dynamic result = showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 500,
              child: Column(
                children: [
                  ColorPicker(
                    pickerColor: currentColor ?? selectedColor,
                    paletteType: PaletteType.hsvWithHue,
                    portraitOnly: true,
                    enableAlpha: false,
                    showLabel: false,
                    hexInputBar: true,
                    onColorChanged: (color) {
                      setState(() {
                        pickedColor = color.withOpacity(1.0);
                      });
                    },
                  ),
                  Container(
                    width: double.infinity,
                    child: TextButton(
                        style: confirmButtonStyle,
                        onPressed: () {
                          Navigator.pop(context, pickedColor);
                        },
                        child: const Text('Ok')),
                  ),
                ],
              ),
            ),
          );
        });
    return result;
  }

  void dialogContact(BuildContext context) {
    phoneInputController.text = contactPhone;
    emailInputController.text = contactEmail;
    addressInputController.text = contactAddress;
    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              scrollable: true,
              title: const Text(
                'Enter your contacts',
              ),
              content: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: phoneInputController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorPhone, labelText: 'Phone'),
                    ),
                    TextFormField(
                      controller: emailInputController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorEmail, labelText: 'Email'),
                    ),
                    TextFormField(
                      controller: addressInputController,
                      minLines: 2,
                      maxLines: 2,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorAddress, labelText: 'Address'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      phoneInputController.text = '';
                      emailInputController.text = '';
                      addressInputController.text = '';
                      errorPhone = null;
                      errorEmail = null;
                      errorAddress = null;
                    });
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorPhone = null;
                      errorEmail = null;
                      errorAddress = null;
                    });
                    if (phoneInputController.text.isEmpty) {
                      stfSetState(() {
                        errorPhone = 'Please enter phone number';
                      });
                    } else if (emailInputController.text.isEmpty) {
                      stfSetState(() {
                        errorEmail = 'Please enter email';
                      });
                    } else if (addressInputController.text.isEmpty) {
                      stfSetState(() {
                        errorAddress = 'Please enter address';
                      });
                    } else {
                      setState(() {
                        contactPhone = phoneInputController.text;
                        contactEmail = emailInputController.text;
                        contactAddress = addressInputController.text;
                        phoneInputController.text = '';
                        emailInputController.text = '';
                        addressInputController.text = '';
                      });
                      Navigator.of(context).pop(true);
                    }
                  },
                  style: confirmButtonStyle,
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }

  void dialogProfile(BuildContext context) {
    birthdateInputController.text = infoBirthDate;
    nationalityInputController.text = infoNationality;
    firstnameInputController.text = firstName;
    lastnameInputController.text = lastName;
    positionInputController.text = positionName;
    profileInputController.text = profileDetail;
    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              scrollable: true,
              title: const Text(
                'Enter your profile',
              ),
              content: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: firstnameInputController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorFirstname, labelText: 'First name'),
                    ),
                    TextFormField(
                      controller: lastnameInputController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorLastname, labelText: 'Last name'),
                    ),
                    TextFormField(
                      controller: positionInputController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorPosition, labelText: 'Position'),
                    ),
                    TextFormField(
                      controller: profileInputController,
                      maxLength: 200,
                      minLines: 5,
                      maxLines: 5,
                      decoration: InputDecoration(
                          errorText: errorProfile, labelText: 'Profile detail'),
                    ),
                    TextFormField(
                      controller: birthdateInputController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorBithdate, labelText: 'Date of Birth'),
                    ),
                    TextFormField(
                      controller: nationalityInputController,
                      maxLength: 30,
                      decoration: InputDecoration(
                          errorText: errorNationality,
                          labelText: 'Nationality'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      birthdateInputController.text = '';
                      nationalityInputController.text = '';
                      firstnameInputController.text = '';
                      lastnameInputController.text = '';
                      positionInputController.text = '';
                      profileInputController.text = '';
                      errorBithdate = null;
                      errorNationality = null;
                      errorFirstname = null;
                      errorLastname = null;
                      errorPosition = null;
                      errorProfile = null;
                    });
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorBithdate = null;
                      errorNationality = null;
                      errorFirstname = null;
                      errorLastname = null;
                      errorPosition = null;
                      errorProfile = null;
                    });
                    if (birthdateInputController.text.isEmpty) {
                      stfSetState(() {
                        errorPhone = 'Please enter birthdate';
                      });
                    } else if (nationalityInputController.text.isEmpty) {
                      stfSetState(() {
                        errorEmail = 'Please enter nationality';
                      });
                    } else if (firstnameInputController.text.isEmpty) {
                      stfSetState(() {
                        errorFirstname = 'Please enter first name';
                      });
                    } else if (lastnameInputController.text.isEmpty) {
                      stfSetState(() {
                        errorLastname = 'Please enter last name';
                      });
                    } else if (positionInputController.text.isEmpty) {
                      stfSetState(() {
                        errorPosition = 'Please enter position';
                      });
                    } else if (profileInputController.text.isEmpty) {
                      stfSetState(() {
                        errorProfile = 'Please enter profile detail';
                      });
                    } else {
                      setState(() {
                        infoBirthDate = birthdateInputController.text;
                        infoNationality = nationalityInputController.text;
                        firstName = firstnameInputController.text;
                        lastName = lastnameInputController.text;
                        positionName = positionInputController.text;
                        profileDetail = profileInputController.text;
                        birthdateInputController.text = '';
                        nationalityInputController.text = '';
                        firstnameInputController.text = '';
                        lastnameInputController.text = '';
                        positionInputController.text = '';
                        profileInputController.text = '';
                      });
                      Navigator.of(context).pop(true);
                    }
                  },
                  style: confirmButtonStyle,
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }

  void dialogAward(BuildContext context) {
    if (awardListing.isNotEmpty) {
      award1InputController.text = awardListing[0];
    }
    if (awardListing.length > 1) {
      award2InputController.text = awardListing[1];
    }
    if (awardListing.length > 2) {
      award3InputController.text = awardListing[2];
    }
    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              scrollable: true,
              title: const Text(
                'Enter your awards',
              ),
              content: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: award1InputController,
                      maxLength: 80,
                      minLines: 3,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Award 1'),
                    ),
                    TextFormField(
                      controller: award2InputController,
                      maxLength: 80,
                      minLines: 3,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Award 2'),
                    ),
                    TextFormField(
                      controller: award3InputController,
                      maxLength: 80,
                      minLines: 3,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Award 3'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      award1InputController.text = '';
                      award2InputController.text = '';
                      award3InputController.text = '';
                    });
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      awardListing = [];
                      if (award1InputController.text.isNotEmpty) {
                        awardListing.add(award1InputController.text);
                      }
                      if (award2InputController.text.isNotEmpty) {
                        awardListing.add(award2InputController.text);
                      }
                      if (award3InputController.text.isNotEmpty) {
                        awardListing.add(award3InputController.text);
                      }
                      award1InputController.text = '';
                      award2InputController.text = '';
                      award3InputController.text = '';
                    });
                    Navigator.of(context).pop(true);
                  },
                  style: confirmButtonStyle,
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }

  void dialogEducation(BuildContext context) {
    if (educationListing.isNotEmpty) {
      edu1YearInputController.text = educationListing[0][0];
      edu1MajorInputController.text = educationListing[0][1];
      edu1SchoolInputController.text = educationListing[0][2];
    }

    if (educationListing.length > 1) {
      edu2YearInputController.text = educationListing[1][0];
      edu2MajorInputController.text = educationListing[1][1];
      edu2SchoolInputController.text = educationListing[1][2];
    }

    if (educationListing.length > 2) {
      edu3YearInputController.text = educationListing[2][0];
      edu3MajorInputController.text = educationListing[2][1];
      edu3SchoolInputController.text = educationListing[2][2];
    }

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              scrollable: true,
              title: const Text(
                'Enter your educations',
              ),
              content: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: edu1YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: '1) Year', errorText: errorEdu1Year),
                          ),
                          TextFormField(
                            controller: edu1MajorInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Major', errorText: errorEdu1Major),
                          ),
                          TextFormField(
                            controller: edu1SchoolInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Institute',
                                errorText: errorEdu1School),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: edu2YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: '2) Year'),
                          ),
                          TextFormField(
                            controller: edu2MajorInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Major'),
                          ),
                          TextFormField(
                            controller: edu2SchoolInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Institute'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: edu3YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: '3) Year'),
                          ),
                          TextFormField(
                            controller: edu3MajorInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Major'),
                          ),
                          TextFormField(
                            controller: edu3SchoolInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Institute'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      edu1YearInputController.text = '';
                      edu1MajorInputController.text = '';
                      edu1SchoolInputController.text = '';
                      edu2YearInputController.text = '';
                      edu2MajorInputController.text = '';
                      edu2SchoolInputController.text = '';
                      edu3YearInputController.text = '';
                      edu3MajorInputController.text = '';
                      edu3SchoolInputController.text = '';
                      errorEdu1Year = null;
                      errorEdu1Major = null;
                      errorEdu1School = null;
                    });
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorEdu1Year = null;
                      errorEdu1Major = null;
                      errorEdu1School = null;
                    });
                    if (edu1YearInputController.text.isEmpty) {
                      stfSetState(() {
                        errorEdu1Year = 'Please input year';
                      });
                    } else if (edu1MajorInputController.text.isEmpty) {
                      stfSetState(() {
                        errorEdu1Major = 'Please input major';
                      });
                    } else if (edu1SchoolInputController.text.isEmpty) {
                      stfSetState(() {
                        errorEdu1School = 'Please input institute';
                      });
                    } else {
                      setState(() {
                        educationListing = [];
                        if (edu1YearInputController.text.isNotEmpty &&
                            edu1MajorInputController.text.isNotEmpty &&
                            edu1SchoolInputController.text.isNotEmpty) {
                          educationListing.add([
                            edu1YearInputController.text,
                            edu1MajorInputController.text,
                            edu1SchoolInputController.text
                          ]);
                        }

                        if (edu2YearInputController.text.isNotEmpty &&
                            edu2MajorInputController.text.isNotEmpty &&
                            edu2SchoolInputController.text.isNotEmpty) {
                          educationListing.add([
                            edu2YearInputController.text,
                            edu2MajorInputController.text,
                            edu2SchoolInputController.text
                          ]);
                        }

                        if (edu3YearInputController.text.isNotEmpty &&
                            edu3MajorInputController.text.isNotEmpty &&
                            edu3SchoolInputController.text.isNotEmpty) {
                          educationListing.add([
                            edu3YearInputController.text,
                            edu3MajorInputController.text,
                            edu3SchoolInputController.text
                          ]);
                        }
                        edu1YearInputController.text = '';
                        edu1MajorInputController.text = '';
                        edu1SchoolInputController.text = '';
                        edu2YearInputController.text = '';
                        edu2MajorInputController.text = '';
                        edu2SchoolInputController.text = '';
                        edu3YearInputController.text = '';
                        edu3MajorInputController.text = '';
                        edu3SchoolInputController.text = '';
                      });
                      Navigator.of(context).pop(true);
                    }
                  },
                  style: confirmButtonStyle,
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }

  void dialogWorks(BuildContext context) {
    if (workListing.isNotEmpty) {
      work1YearInputController.text = workListing[0][0];
      work1PositionInputController.text = workListing[0][1];
      work1CompanyInputController.text = workListing[0][2];
      work1DetailInputController.text = workListing[0][3];
    }

    if (workListing.length > 1) {
      work2YearInputController.text = workListing[1][0];
      work2PositionInputController.text = workListing[1][1];
      work2CompanyInputController.text = workListing[1][2];
      work2DetailInputController.text = workListing[1][3];
    }

    if (workListing.length > 2) {
      work3YearInputController.text = workListing[2][0];
      work3PositionInputController.text = workListing[2][1];
      work3CompanyInputController.text = workListing[2][2];
      work3DetailInputController.text = workListing[2][3];
    }

    if (workListing.length > 3) {
      work4YearInputController.text = workListing[3][0];
      work4PositionInputController.text = workListing[3][1];
      work4CompanyInputController.text = workListing[3][2];
      work4DetailInputController.text = workListing[3][3];
    }

    if (workListing.length > 4) {
      work5YearInputController.text = workListing[4][0];
      work5PositionInputController.text = workListing[4][1];
      work5CompanyInputController.text = workListing[4][2];
      work5DetailInputController.text = workListing[4][3];
    }

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              scrollable: true,
              title: const Text(
                'Enter your works',
              ),
              content: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: work1YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: '1) Year',
                                errorText: errorWork1Year),
                          ),
                          TextFormField(
                            controller: work1PositionInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Position',
                                errorText: errorWork1Position),
                          ),
                          TextFormField(
                            controller: work1CompanyInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Company',
                                errorText: errorWork1Company),
                          ),
                          TextFormField(
                            controller: work1DetailInputController,
                            maxLength: 120,
                            minLines: 2,
                            maxLines: 2,
                            decoration: InputDecoration(
                                labelText: 'Detail',
                                errorText: errorWork1Detail),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: work2YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: '2) Year'),
                          ),
                          TextFormField(
                            controller: work2PositionInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Position'),
                          ),
                          TextFormField(
                            controller: work2CompanyInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Company'),
                          ),
                          TextFormField(
                            controller: work2DetailInputController,
                            maxLength: 120,
                            minLines: 2,
                            maxLines: 2,
                            decoration:
                                const InputDecoration(labelText: 'Detail'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: work3YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: '3) Year'),
                          ),
                          TextFormField(
                            controller: work3PositionInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Position'),
                          ),
                          TextFormField(
                            controller: work3CompanyInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Company'),
                          ),
                          TextFormField(
                            controller: work3DetailInputController,
                            maxLength: 120,
                            minLines: 2,
                            maxLines: 2,
                            decoration:
                                const InputDecoration(labelText: 'Detail'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: work4YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: '4) Year'),
                          ),
                          TextFormField(
                            controller: work4PositionInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Position'),
                          ),
                          TextFormField(
                            controller: work4CompanyInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Company'),
                          ),
                          TextFormField(
                            controller: work4DetailInputController,
                            maxLength: 120,
                            minLines: 2,
                            maxLines: 2,
                            decoration:
                                const InputDecoration(labelText: 'Detail'),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: work5YearInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: '5) Year'),
                          ),
                          TextFormField(
                            controller: work5PositionInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Position'),
                          ),
                          TextFormField(
                            controller: work5CompanyInputController,
                            maxLength: 80,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Company'),
                          ),
                          TextFormField(
                            controller: work5DetailInputController,
                            maxLength: 120,
                            minLines: 2,
                            maxLines: 2,
                            decoration:
                                const InputDecoration(labelText: 'Detail'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      work1YearInputController.text = '';
                      work1PositionInputController.text = '';
                      work1CompanyInputController.text = '';
                      work1DetailInputController.text = '';
                      work2YearInputController.text = '';
                      work2PositionInputController.text = '';
                      work2CompanyInputController.text = '';
                      work2DetailInputController.text = '';
                      work3YearInputController.text = '';
                      work3PositionInputController.text = '';
                      work3CompanyInputController.text = '';
                      work3DetailInputController.text = '';
                      work4YearInputController.text = '';
                      work4PositionInputController.text = '';
                      work4CompanyInputController.text = '';
                      work4DetailInputController.text = '';
                      work5YearInputController.text = '';
                      work5PositionInputController.text = '';
                      work5CompanyInputController.text = '';
                      work5DetailInputController.text = '';
                      errorWork1Year = null;
                      errorWork1Position = null;
                      errorWork1Company = null;
                      errorWork1Detail = null;
                    });
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorWork1Year = null;
                      errorWork1Position = null;
                      errorWork1Company = null;
                      errorWork1Detail = null;
                    });
                    if (work1YearInputController.text.isEmpty) {
                      stfSetState(() {
                        errorWork1Year = 'Please input year';
                      });
                    } else if (work1PositionInputController.text.isEmpty) {
                      stfSetState(() {
                        errorWork1Position = 'Please input position';
                      });
                    } else if (work1CompanyInputController.text.isEmpty) {
                      stfSetState(() {
                        errorWork1Company = 'Please input company';
                      });
                    } else if (work1DetailInputController.text.isEmpty) {
                      stfSetState(() {
                        errorWork1Detail = 'Please input detail';
                      });
                    } else {
                      setState(() {
                        workListing = [];
                        if (work1YearInputController.text.isNotEmpty &&
                            work1PositionInputController.text.isNotEmpty &&
                            work1CompanyInputController.text.isNotEmpty &&
                            work1DetailInputController.text.isNotEmpty) {
                          workListing.add([
                            work1YearInputController.text,
                            work1PositionInputController.text,
                            work1CompanyInputController.text,
                            work1DetailInputController.text
                          ]);
                        }
                        if (work2YearInputController.text.isNotEmpty &&
                            work2PositionInputController.text.isNotEmpty &&
                            work2CompanyInputController.text.isNotEmpty &&
                            work2DetailInputController.text.isNotEmpty) {
                          workListing.add([
                            work2YearInputController.text,
                            work2PositionInputController.text,
                            work2CompanyInputController.text,
                            work2DetailInputController.text
                          ]);
                        }
                        if (work3YearInputController.text.isNotEmpty &&
                            work3PositionInputController.text.isNotEmpty &&
                            work3CompanyInputController.text.isNotEmpty &&
                            work3DetailInputController.text.isNotEmpty) {
                          workListing.add([
                            work3YearInputController.text,
                            work3PositionInputController.text,
                            work3CompanyInputController.text,
                            work3DetailInputController.text
                          ]);
                        }

                        if (work4YearInputController.text.isNotEmpty &&
                            work4PositionInputController.text.isNotEmpty &&
                            work4CompanyInputController.text.isNotEmpty &&
                            work4DetailInputController.text.isNotEmpty) {
                          workListing.add([
                            work4YearInputController.text,
                            work4PositionInputController.text,
                            work4CompanyInputController.text,
                            work4DetailInputController.text
                          ]);
                        }

                        if (work5YearInputController.text.isNotEmpty &&
                            work5PositionInputController.text.isNotEmpty &&
                            work5CompanyInputController.text.isNotEmpty &&
                            work5DetailInputController.text.isNotEmpty) {
                          workListing.add([
                            work5YearInputController.text,
                            work5PositionInputController.text,
                            work5CompanyInputController.text,
                            work5DetailInputController.text
                          ]);
                        }
                        work1YearInputController.text = '';
                        work1PositionInputController.text = '';
                        work1CompanyInputController.text = '';
                        work1DetailInputController.text = '';
                        work2YearInputController.text = '';
                        work2PositionInputController.text = '';
                        work2CompanyInputController.text = '';
                        work2DetailInputController.text = '';
                        work3YearInputController.text = '';
                        work3PositionInputController.text = '';
                        work3CompanyInputController.text = '';
                        work3DetailInputController.text = '';

                        work4YearInputController.text = '';
                        work4PositionInputController.text = '';
                        work4CompanyInputController.text = '';
                        work4DetailInputController.text = '';

                        work5YearInputController.text = '';
                        work5PositionInputController.text = '';
                        work5CompanyInputController.text = '';
                        work5DetailInputController.text = '';
                      });
                      Navigator.of(context).pop(true);
                    }
                  },
                  style: confirmButtonStyle,
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }

  void dialogSkills(BuildContext context) {
    if (skillListing.isNotEmpty) {
      skill1TitleInputController.text = skillListing[0][0];
      skill1ScoreInputController.text = skillListing[0][1].toString();
    }
    if (skillListing.length > 1) {
      skill2TitleInputController.text = skillListing[1][0];
      skill2ScoreInputController.text = skillListing[1][1].toString();
    }
    if (skillListing.length > 2) {
      skill3TitleInputController.text = skillListing[2][0];
      skill3ScoreInputController.text = skillListing[2][1].toString();
    }
    if (skillListing.length > 3) {
      skill4TitleInputController.text = skillListing[3][0];
      skill4ScoreInputController.text = skillListing[3][1].toString();
    }
    if (skillListing.length > 4) {
      skill5TitleInputController.text = skillListing[4][0];
      skill5ScoreInputController.text = skillListing[4][1].toString();
    }
    if (skillListing.length > 5) {
      skill6TitleInputController.text = skillListing[5][0];
      skill6ScoreInputController.text = skillListing[5][1].toString();
    }
    if (skillListing.length > 6) {
      skill7TitleInputController.text = skillListing[6][0];
      skill7ScoreInputController.text = skillListing[6][1].toString();
    }

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              scrollable: true,
              title: const Text(
                'Enter your skills',
              ),
              content: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: skill1TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Title',
                                errorText: errorSkill1Title),
                          ),
                          TextFormField(
                            controller: skill1ScoreInputController,
                            minLines: 1,
                            maxLines: 1,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Score',
                                errorText: errorSkill1Score),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: skill2TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: skill2ScoreInputController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Score',
                                errorText: errorSkill2Score),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: skill3TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: skill3ScoreInputController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Score',
                                errorText: errorSkill3Score),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: skill4TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: skill4ScoreInputController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Score',
                                errorText: errorSkill4Score),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: skill5TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: skill5ScoreInputController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Score',
                                errorText: errorSkill5Score),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: skill6TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: skill6ScoreInputController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Score',
                                errorText: errorSkill6Score),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: skill7TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          TextFormField(
                            controller: skill7ScoreInputController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: InputDecoration(
                                labelText: 'Score',
                                errorText: errorSkill7Score),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      skill1TitleInputController.text = '';
                      skill1ScoreInputController.text = '';
                      skill2TitleInputController.text = '';
                      skill2ScoreInputController.text = '';
                      skill3TitleInputController.text = '';
                      skill3ScoreInputController.text = '';
                      skill4TitleInputController.text = '';
                      skill4ScoreInputController.text = '';
                      skill5TitleInputController.text = '';
                      skill5ScoreInputController.text = '';
                      skill6TitleInputController.text = '';
                      skill6ScoreInputController.text = '';
                      skill7TitleInputController.text = '';
                      skill7ScoreInputController.text = '';
                      errorSkill1Title = null;
                      errorSkill1Score = null;
                    });
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      errorSkill1Title = null;
                      errorSkill1Score = null;
                      errorSkill2Score = null;
                      errorSkill3Score = null;
                      errorSkill4Score = null;
                      errorSkill5Score = null;
                      errorSkill6Score = null;
                      errorSkill7Score = null;
                    });
                    if (skill1TitleInputController.text.isEmpty) {
                      stfSetState(() {
                        errorSkill1Title = 'Please input title';
                      });
                    } else if (skill1ScoreInputController.text.isEmpty ||
                        int.parse(skill1ScoreInputController.text) > 100) {
                      stfSetState(() {
                        errorSkill1Score = 'Please input score 0-100';
                      });
                    } else if (skill2ScoreInputController.text.isNotEmpty &&
                        int.parse(skill2ScoreInputController.text) > 100) {
                      stfSetState(() {
                        errorSkill2Score = 'Please input score 0-100';
                      });
                    } else if (skill3ScoreInputController.text.isNotEmpty &&
                        int.parse(skill3ScoreInputController.text) > 100) {
                      stfSetState(() {
                        errorSkill3Score = 'Please input score 0-100';
                      });
                    } else if (skill4ScoreInputController.text.isNotEmpty &&
                        int.parse(skill4ScoreInputController.text) > 100) {
                      stfSetState(() {
                        errorSkill4Score = 'Please input score 0-100';
                      });
                    } else if (skill5ScoreInputController.text.isNotEmpty &&
                        int.parse(skill5ScoreInputController.text) > 100) {
                      stfSetState(() {
                        errorSkill5Score = 'Please input score 0-100';
                      });
                    } else if (skill6ScoreInputController.text.isNotEmpty &&
                        int.parse(skill6ScoreInputController.text) > 100) {
                      stfSetState(() {
                        errorSkill6Score = 'Please input score 0-100';
                      });
                    } else if (skill7ScoreInputController.text.isNotEmpty &&
                        int.parse(skill7ScoreInputController.text) > 100) {
                      stfSetState(() {
                        errorSkill7Score = 'Please input score 0-100';
                      });
                    } else {
                      setState(() {
                        skillListing = [];
                        if (skill1TitleInputController.text.isNotEmpty &&
                            skill1ScoreInputController.text.isNotEmpty) {
                          skillListing.add([
                            skill1TitleInputController.text,
                            int.parse(skill1ScoreInputController.text),
                          ]);
                        }
                        if (skill2TitleInputController.text.isNotEmpty &&
                            skill2ScoreInputController.text.isNotEmpty) {
                          skillListing.add([
                            skill2TitleInputController.text,
                            int.parse(skill2ScoreInputController.text),
                          ]);
                        }
                        if (skill3TitleInputController.text.isNotEmpty &&
                            skill3ScoreInputController.text.isNotEmpty) {
                          skillListing.add([
                            skill3TitleInputController.text,
                            int.parse(skill3ScoreInputController.text),
                          ]);
                        }
                        if (skill4TitleInputController.text.isNotEmpty &&
                            skill4ScoreInputController.text.isNotEmpty) {
                          skillListing.add([
                            skill4TitleInputController.text,
                            int.parse(skill4ScoreInputController.text),
                          ]);
                        }
                        if (skill5TitleInputController.text.isNotEmpty &&
                            skill5ScoreInputController.text.isNotEmpty) {
                          skillListing.add([
                            skill5TitleInputController.text,
                            int.parse(skill5ScoreInputController.text),
                          ]);
                        }
                        if (skill6TitleInputController.text.isNotEmpty &&
                            skill6ScoreInputController.text.isNotEmpty) {
                          skillListing.add([
                            skill6TitleInputController.text,
                            int.parse(skill6ScoreInputController.text),
                          ]);
                        }
                        if (skill7TitleInputController.text.isNotEmpty &&
                            skill7ScoreInputController.text.isNotEmpty) {
                          skillListing.add([
                            skill7TitleInputController.text,
                            int.parse(skill7ScoreInputController.text),
                          ]);
                        }
                        skill1TitleInputController.text = '';
                        skill1ScoreInputController.text = '';
                        skill2TitleInputController.text = '';
                        skill2ScoreInputController.text = '';
                        skill3TitleInputController.text = '';
                        skill3ScoreInputController.text = '';
                        skill4TitleInputController.text = '';
                        skill4ScoreInputController.text = '';
                        skill5TitleInputController.text = '';
                        skill5ScoreInputController.text = '';
                        skill6TitleInputController.text = '';
                        skill6ScoreInputController.text = '';
                        skill7TitleInputController.text = '';
                        skill7ScoreInputController.text = '';
                      });
                      Navigator.of(context).pop(true);
                    }
                  },
                  style: confirmButtonStyle,
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }

  void dialogLanguage(BuildContext context) {
    if (languageListing.isNotEmpty) {
      language1TitleInputController.text = languageListing[0][0];
      language1ReadingInputController.text = languageListing[0][1].toString();
      language1WritingInputController.text = languageListing[0][2].toString();
      language1ListeningInputController.text = languageListing[0][3].toString();
      language1SpeakingInputController.text = languageListing[0][4].toString();
    }
    if (languageListing.length > 1) {
      language2TitleInputController.text = languageListing[1][0];
      language2ReadingInputController.text = languageListing[1][1].toString();
      language2WritingInputController.text = languageListing[1][2].toString();
      language2ListeningInputController.text = languageListing[1][3].toString();
      language2SpeakingInputController.text = languageListing[1][4].toString();
    }
    if (languageListing.length > 2) {
      language3TitleInputController.text = languageListing[2][0];
      language3ReadingInputController.text = languageListing[2][1].toString();
      language3WritingInputController.text = languageListing[2][2].toString();
      language3ListeningInputController.text = languageListing[2][3].toString();
      language3SpeakingInputController.text = languageListing[2][4].toString();
    }
    if (languageListing.length > 3) {
      language4TitleInputController.text = languageListing[3][0];
      language4ReadingInputController.text = languageListing[3][1].toString();
      language4WritingInputController.text = languageListing[3][2].toString();
      language4ListeningInputController.text = languageListing[3][3].toString();
      language4SpeakingInputController.text = languageListing[3][4].toString();
    }

    showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (stfContext, stfSetState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(20),
              scrollable: true,
              title: const Text(
                'Enter your language',
              ),
              content: Container(
                padding: const EdgeInsets.all(0),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: language1TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                                labelText: 'Title',
                                errorText: errorLanguage1Title),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language1ReadingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Reading',
                                    hintText: '1-3',
                                    errorText: errorLanguage1Reading,
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) > 3) {
                                      language1ReadingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language1WritingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Writing',
                                    hintText: '1-3',
                                    errorText: errorLanguage1Writing,
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) > 3) {
                                      language1WritingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language1ListeningInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Listening',
                                    hintText: '1-3',
                                    errorText: errorLanguage1Listening,
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) > 3) {
                                      language1ListeningInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language1SpeakingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Speaking',
                                    hintText: '1-3',
                                    errorText: errorLanguage1Speaking,
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language1SpeakingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: language2TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language2ReadingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: 'Reading', hintText: '1-3'),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language2ReadingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language2WritingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: 'Writing', hintText: '1-3'),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language2WritingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language2ListeningInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Listening',
                                    hintText: '1-3',
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language2ListeningInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language2SpeakingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Speaking',
                                    hintText: '1-3',
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language2SpeakingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: language3TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language3ReadingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: 'Reading', hintText: '1-3'),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language3ReadingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language3WritingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: 'Writing', hintText: '1-3'),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language3WritingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language3ListeningInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Listening',
                                    hintText: '1-3',
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language3ListeningInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language3SpeakingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Speaking',
                                    hintText: '1-3',
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language3SpeakingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade100,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          TextFormField(
                            controller: language4TitleInputController,
                            minLines: 1,
                            maxLines: 1,
                            decoration:
                                const InputDecoration(labelText: 'Title'),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language4ReadingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: 'Reading', hintText: '1-3'),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language4ReadingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language4WritingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                      labelText: 'Writing', hintText: '1-3'),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language4WritingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language4ListeningInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Listening',
                                    hintText: '1-3',
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language4ListeningInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: language4SpeakingInputController,
                                  minLines: 1,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  decoration: const InputDecoration(
                                    labelText: 'Speaking',
                                    hintText: '1-3',
                                  ),
                                  onChanged: (text) {
                                    if (int.parse(text) < 1 ||
                                        int.parse(text) > 3) {
                                      language4SpeakingInputController.text =
                                          '3';
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      language1TitleInputController.text = '';
                      language1ReadingInputController.text = '';
                      language1WritingInputController.text = '';
                      language1ListeningInputController.text = '';
                      language1SpeakingInputController.text = '';
                      language2TitleInputController.text = '';
                      language2ReadingInputController.text = '';
                      language2WritingInputController.text = '';
                      language2ListeningInputController.text = '';
                      language2SpeakingInputController.text = '';
                      language3TitleInputController.text = '';
                      language3ReadingInputController.text = '';
                      language3WritingInputController.text = '';
                      language3ListeningInputController.text = '';
                      language3SpeakingInputController.text = '';
                      language4TitleInputController.text = '';
                      language4ReadingInputController.text = '';
                      language4WritingInputController.text = '';
                      language4ListeningInputController.text = '';
                      language4SpeakingInputController.text = '';
                      errorLanguage1Title = null;
                      errorLanguage1Reading = null;
                      errorLanguage1Listening = null;
                      errorLanguage1Speaking = null;
                    });
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Close'),
                ),
                ElevatedButton(
                  onPressed: () {
                    errorLanguage1Title = null;
                    errorLanguage1Reading = null;
                    errorLanguage1Listening = null;
                    errorLanguage1Speaking = null;
                    if (language1TitleInputController.text.isEmpty) {
                      stfSetState(() {
                        errorLanguage1Title = 'Please input title';
                      });
                    } else {
                      setState(() {
                        languageListing = [];
                        if (language1TitleInputController.text.isNotEmpty &&
                            language1ReadingInputController.text.isNotEmpty &&
                            language1WritingInputController.text.isNotEmpty &&
                            language1ListeningInputController.text.isNotEmpty &&
                            language1SpeakingInputController.text.isNotEmpty) {
                          languageListing.add([
                            language1TitleInputController.text,
                            int.parse(language1ReadingInputController.text),
                            int.parse(language1WritingInputController.text),
                            int.parse(language1ListeningInputController.text),
                            int.parse(language1SpeakingInputController.text),
                          ]);
                        }

                        if (language2TitleInputController.text.isNotEmpty &&
                            language2ReadingInputController.text.isNotEmpty &&
                            language2WritingInputController.text.isNotEmpty &&
                            language2ListeningInputController.text.isNotEmpty &&
                            language2SpeakingInputController.text.isNotEmpty) {
                          languageListing.add([
                            language2TitleInputController.text,
                            int.parse(language2ReadingInputController.text),
                            int.parse(language2WritingInputController.text),
                            int.parse(language2ListeningInputController.text),
                            int.parse(language2SpeakingInputController.text),
                          ]);
                        }
                        if (language3TitleInputController.text.isNotEmpty &&
                            language3ReadingInputController.text.isNotEmpty &&
                            language3WritingInputController.text.isNotEmpty &&
                            language3ListeningInputController.text.isNotEmpty &&
                            language3SpeakingInputController.text.isNotEmpty) {
                          languageListing.add([
                            language3TitleInputController.text,
                            int.parse(language3ReadingInputController.text),
                            int.parse(language3WritingInputController.text),
                            int.parse(language3ListeningInputController.text),
                            int.parse(language3SpeakingInputController.text),
                          ]);
                        }
                        if (language4TitleInputController.text.isNotEmpty &&
                            language4ReadingInputController.text.isNotEmpty &&
                            language4WritingInputController.text.isNotEmpty &&
                            language4ListeningInputController.text.isNotEmpty &&
                            language4SpeakingInputController.text.isNotEmpty) {
                          languageListing.add([
                            language4TitleInputController.text,
                            int.parse(language4ReadingInputController.text),
                            int.parse(language4WritingInputController.text),
                            int.parse(language4ListeningInputController.text),
                            int.parse(language4SpeakingInputController.text),
                          ]);
                        }
                        language1TitleInputController.text = '';
                        language1ReadingInputController.text = '';
                        language1WritingInputController.text = '';
                        language1ListeningInputController.text = '';
                        language1SpeakingInputController.text = '';
                        language2TitleInputController.text = '';
                        language2ReadingInputController.text = '';
                        language2WritingInputController.text = '';
                        language2ListeningInputController.text = '';
                        language2SpeakingInputController.text = '';
                        language3TitleInputController.text = '';
                        language3ReadingInputController.text = '';
                        language3WritingInputController.text = '';
                        language3ListeningInputController.text = '';
                        language3SpeakingInputController.text = '';
                        language4TitleInputController.text = '';
                        language4ReadingInputController.text = '';
                        language4WritingInputController.text = '';
                        language4ListeningInputController.text = '';
                        language4SpeakingInputController.text = '';
                      });
                      Navigator.of(context).pop(true);
                    }
                  },
                  style: confirmButtonStyle,
                  child: const Text('Save'),
                ),
              ],
            );
          });
        });
  }

  void saveAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('layoutId', layoutId);
    await prefs.setString('headerBgColor', colorToHexString(headerBgColor));
    await prefs.setString('headerNameColor', colorToHexString(headerNameColor));
    await prefs.setString(
        'headerPositionColor', colorToHexString(headerPositionColor));
    await prefs.setString('bodyBgColor', colorToHexString(bodyBgColor));
    await prefs.setString(
        'bodySubjectBgColor', colorToHexString(bodySubjectBgColor));
    await prefs.setString(
        'bodySubjectTextColor', colorToHexString(bodySubjectTextColor));
    await prefs.setString('bodyTextColor', colorToHexString(bodyTextColor));
    await prefs.setString(
        'bodySubjectBorderColor', colorToHexString(bodySubjectBorderColor));
    await prefs.setString('sideBgColor', colorToHexString(sideBgColor));
    await prefs.setString(
        'sideSubjectBgColor', colorToHexString(sideSubjectBgColor));
    await prefs.setString(
        'sideSubjectBorderColor', colorToHexString(sideSubjectBorderColor));
    await prefs.setString(
        'sideSubjectTextColor', colorToHexString(sideSubjectTextColor));
    await prefs.setString('sideTextColor', colorToHexString(sideTextColor));
    await prefs.setString('sideBulletColor', colorToHexString(sideBulletColor));
    await prefs.setString('avatarBgColor', colorToHexString(avatarBgColor));
    await prefs.setString(
        'avatarBorderColor', colorToHexString(avatarBorderColor));
    await prefs.setBool('isCircleAvatar', isCircleAvatar);

    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('positionName', positionName);
    await prefs.setString('profileDetail', profileDetail);
    await prefs.setString('workListing', jsonEncode(workListing));
    await prefs.setString('educationListing', jsonEncode(educationListing));

    await prefs.setString('contactPhone', contactPhone);
    await prefs.setString('contactEmail', contactEmail);
    await prefs.setString('contactAddress', contactAddress);
    await prefs.setString('infoNationality', infoNationality);
    await prefs.setString('infoBirthDate', infoBirthDate);

    await prefs.setString('skillListing', jsonEncode(skillListing));
    await prefs.setString('languageListing', jsonEncode(languageListing));
    await prefs.setStringList('awardListing', awardListing);

    SnackbarWidget.show(context, text: 'Save successfully');
  }

  void loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      int? layoutIdTmp = prefs.getInt('layoutId');
      if (layoutIdTmp != null) {
        layoutId = layoutIdTmp;
      }

      String? headerBgColorX = prefs.getString('headerBgColor');
      if (headerBgColorX != null) {
        headerBgColor = hexStringToColor(headerBgColorX);
      }

      String? headerNameColorX = prefs.getString('headerNameColor');
      if (headerNameColorX != null) {
        headerNameColor = hexStringToColor(headerNameColorX);
      }

      String? headerPositionColorX = prefs.getString('headerPositionColor');
      if (headerPositionColorX != null) {
        headerPositionColor = hexStringToColor(headerPositionColorX);
      }

      String? bodyBgColorX = prefs.getString('bodyBgColor');
      if (bodyBgColorX != null) {
        bodyBgColor = hexStringToColor(bodyBgColorX);
      }

      String? bodySubjectBgColorX = prefs.getString('bodySubjectBgColor');
      if (bodySubjectBgColorX != null) {
        bodySubjectBgColor = hexStringToColor(bodySubjectBgColorX);
      }

      String? bodySubjectTextColorX = prefs.getString('bodySubjectTextColor');
      if (bodySubjectTextColorX != null) {
        bodySubjectTextColor = hexStringToColor(bodySubjectTextColorX);
      }

      String? bodyTextColorX = prefs.getString('bodyTextColor');
      if (bodyTextColorX != null) {
        bodyTextColor = hexStringToColor(bodyTextColorX);
      }

      String? bodySubjectBorderColorX =
          prefs.getString('bodySubjectBorderColor');
      if (bodySubjectBorderColorX != null) {
        bodySubjectBorderColor = hexStringToColor(bodySubjectBorderColorX);
      }

      String? sideBgColorX = prefs.getString('sideBgColor');
      if (sideBgColorX != null) {
        sideBgColor = hexStringToColor(sideBgColorX);
      }

      String? sideSubjectBgColorX = prefs.getString('sideSubjectBgColor');
      if (sideSubjectBgColorX != null) {
        sideSubjectBgColor = hexStringToColor(sideSubjectBgColorX);
      }

      String? sideSubjectBorderColorX =
          prefs.getString('sideSubjectBorderColor');
      if (sideSubjectBorderColorX != null) {
        sideSubjectBorderColor = hexStringToColor(sideSubjectBorderColorX);
      }

      String? sideSubjectTextColorX = prefs.getString('sideSubjectTextColor');
      if (sideSubjectTextColorX != null) {
        sideSubjectTextColor = hexStringToColor(sideSubjectTextColorX);
      }

      String? sideTextColorX = prefs.getString('sideTextColor');
      if (sideTextColorX != null) {
        sideTextColor = hexStringToColor(sideTextColorX);
      }

      String? sideBulletColorX = prefs.getString('sideBulletColor');
      if (sideBulletColorX != null) {
        sideBulletColor = hexStringToColor(sideBulletColorX);
      }

      String? avatarBgColorX = prefs.getString('avatarBgColor');
      if (avatarBgColorX != null) {
        avatarBgColor = hexStringToColor(avatarBgColorX);
      }

      String? avatarBorderColorX = prefs.getString('avatarBorderColor');
      if (avatarBorderColorX != null) {
        avatarBorderColor = hexStringToColor(avatarBorderColorX);
      }

      bool? isCircleAvatarX = prefs.getBool('isCircleAvatar');
      if (isCircleAvatarX != null) {
        isCircleAvatar = isCircleAvatarX;
      }

      String? firstNameX = prefs.getString('firstName');
      if (firstNameX != null) {
        firstName = firstNameX;
      }
      String? lastNameX = prefs.getString('lastName');
      if (lastNameX != null) {
        lastName = lastNameX;
      }
      String? positionNameX = prefs.getString('positionName');
      if (positionNameX != null) {
        positionName = positionNameX;
      }
      String? profileDetailX = prefs.getString('profileDetail');
      if (profileDetailX != null) {
        profileDetail = profileDetailX;
      }
      String? workListingX = prefs.getString('workListing');
      if (workListingX != null) {
        List workListingTmp = jsonDecode(workListingX);
        workListing = [];
        for (var rs in workListingTmp) {
          List<String> x = [];
          for (var y in rs) {
            x.add(y);
          }
          workListing.add(x);
        }
      }

      String? educationListingX = prefs.getString('educationListing');
      if (educationListingX != null) {
        List educationListingTmp = jsonDecode(educationListingX);
        educationListing = [];
        for (var rs in educationListingTmp) {
          List<String> x = [];
          for (var y in rs) {
            x.add(y);
          }
          educationListing.add(x);
        }
      }

      String? contactPhoneX = prefs.getString('contactPhone');
      if (contactPhoneX != null) {
        contactPhone = contactPhoneX;
      }
      String? contactEmailX = prefs.getString('contactEmail');
      if (contactEmailX != null) {
        contactEmail = contactEmailX;
      }
      String? contactAddressX = prefs.getString('contactAddress');
      if (contactAddressX != null) {
        contactAddress = contactAddressX;
      }
      String? infoNationalityX = prefs.getString('infoNationality');
      if (infoNationalityX != null) {
        infoNationality = infoNationalityX;
      }
      String? infoBirthDateX = prefs.getString('infoBirthDate');
      if (infoBirthDateX != null) {
        infoBirthDate = infoBirthDateX;
      }

      String? skillListingX = prefs.getString('skillListing');
      if (skillListingX != null) {
        List<dynamic> skillListingTmp = jsonDecode(skillListingX);
        skillListing = [];
        for (var rs in skillListingTmp) {
          List<dynamic> x = [];
          for (var y in rs) {
            x.add(y);
          }
          skillListing.add(x);
        }
      }

      String? languageListingX = prefs.getString('languageListing');
      if (languageListingX != null) {
        List<dynamic> languageListingTmp = jsonDecode(languageListingX);
        languageListing = [];
        for (var rs in languageListingTmp) {
          List<dynamic> x = [];
          for (var y in rs) {
            x.add(y);
          }
          languageListing.add(x);
        }
      }

      List<String>? awardListingX = prefs.getStringList('awardListing');
      if (awardListingX != null) {
        awardListing = awardListingX;
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_isInterstitialAdReady) {
      _interstitialAd?.show();
    }
    setState(() {
      isOverLay = true;
    });
    try {
      final picked = await imagePicker.pickImage(source: source);
      if (picked != null) {
        setState(() {
          mainImageFile = CroppedFile(picked.path);
          _getImageSize(File(mainImageFile!.path), AppState.picked);
        });
      }
    } catch (e) {
      setState(() {
        state = AppState.clear;
      });
    }
    setState(() {
      isOverLay = false;
    });
  }

  Future<void> _getImageSize(File imageFile, AppState currentState) async {
    setState(() {
      state = AppState.picking;
    });

    int maxWidth = 100;
    int maxHeight = 100;
    print('File size before : ' +
        (imageFile.lengthSync() / 1000).toString() +
        ' KB');

    //Find Size
    final Completer<Size> completer = Completer<Size>();
    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    int orgWidth = imageSize.width.toInt();
    int orgHeight = imageSize.height.toInt();
    double newWidth = orgWidth.toDouble();
    double newHeight = orgHeight.toDouble();
    if (orgWidth >= orgHeight) {
      int resultW = orgWidth > maxWidth ? maxWidth : orgWidth;
      newWidth = resultW.toDouble();
      newHeight = newWidth / imageSize.aspectRatio;
    } else if (orgHeight > orgWidth) {
      int resultH = orgHeight > maxHeight ? maxHeight : orgHeight;
      newHeight = resultH.toDouble();
      newWidth = newHeight * imageSize.aspectRatio;
    }

    //Resize
    final codec = await ui.instantiateImageCodec(
      imageFile.readAsBytesSync().buffer.asUint8List(),
      targetHeight: newWidth.toInt(),
      targetWidth: newHeight.toInt(),
    );
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image newImage = frameInfo.image;

    setState(() {
      state = AppState.clear;
    });
  }

  Future<void> _cropImage() async {
    setState(() {
      state = AppState.picking;
    });
    CroppedFile? croppedFile = await ImageCropper().cropImage(
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        sourcePath: mainImageFile!.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio16x9
              ]
            : [
                //CropAspectRatioPreset.original,
                CropAspectRatioPreset.square,
                //CropAspectRatioPreset.ratio3x2,
                //CropAspectRatioPreset.ratio4x3,
                //CropAspectRatioPreset.ratio5x3,
                //CropAspectRatioPreset.ratio5x4,
                //CropAspectRatioPreset.ratio7x5,
                //CropAspectRatioPreset.ratio16x9
              ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioLockEnabled: true,
          )
        ]);
    if (croppedFile != null) {
      mainImageFile = croppedFile;
      _getImageSize(File(mainImageFile!.path), AppState.picked);
    } else {
      setState(() {
        state = AppState.picked;
      });
    }
  }

  // Layouts
  Widget selectLayout() {
    return GestureDetector(
      onTap: () {
        setState(() {
          showSelectLayout = false;
        });
      },
      child: Container(
          color: Colors.black87,
          alignment: Alignment.center,
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        layoutId = 1;
                        showSelectLayout = false;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/template1.png',
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  layoutId = 1;
                                  showSelectLayout = false;
                                });
                              },
                              child: const Text(
                                'Select',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        layoutId = 2;
                        showSelectLayout = false;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/template2.png',
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  layoutId = 2;
                                  showSelectLayout = false;
                                });
                              },
                              child: const Text(
                                'Select',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        layoutId = 3;
                        showSelectLayout = false;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/template3.png',
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  layoutId = 3;
                                  showSelectLayout = false;
                                });
                              },
                              child: const Text(
                                'Select',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        layoutId = 4;
                        showSelectLayout = false;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/template4.png',
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  layoutId = 4;
                                  showSelectLayout = false;
                                });
                              },
                              child: const Text(
                                'Select',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        layoutId = 5;
                        showSelectLayout = false;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/template5.png',
                          width: 200,
                          fit: BoxFit.fitWidth,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: primaryColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  layoutId = 5;
                                  showSelectLayout = false;
                                });
                              },
                              child: const Text(
                                'Select',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget layoutDefault() {
    return Container(
      color: headerBgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: sideFlex,
            child: sideBox(),
          ),
          Expanded(
            flex: bodyFlex,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerBox(),
                Expanded(
                  child: Container(
                    color: bodyBgColor,
                    padding: EdgeInsets.only(
                        left: bodyMargin,
                        right: bodyMargin,
                        top: bodyMargin - 5,
                        bottom: bodyMargin - 5),
                    alignment: Alignment.topLeft,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          profileBox(marginTop: lineMarginTop),
                          workBox(),
                          educationBox(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget layoutHeadFloatingAvatarLeft() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: headerHeight + 30,
          child: Stack(
            children: [
              Container(
                color: sideBgColor,
                alignment: Alignment.topCenter,
                child: Row(children: [
                  Expanded(
                    flex: sideFlex,
                    child: Container(
                      color: sideBgColor,
                    ),
                  ),
                  Expanded(
                    flex: bodyFlex,
                    child: Container(
                      color: bodyBgColor,
                    ),
                  )
                ]),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    color: headerBgColor,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                avatarBox(borderSize: 80, bgSize: 70),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  firstName,
                                  style: TextStyle(
                                      color: headerNameColor,
                                      fontSize: fontSizeName,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    lastName,
                                    style: TextStyle(
                                        color: headerNameColor,
                                        fontSize: fontSizeName,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    positionName,
                                    style: TextStyle(
                                        color: headerPositionColor,
                                        fontSize: fontSizePosition,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: sideFlex,
                child: Container(
                  color: sideBgColor,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: sideBgColor,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              infoBox(),
                              contactBox(),
                              skillBox(),
                              languageBox(),
                              if (awardListing.isNotEmpty) awardBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: bodyFlex,
                child: Container(
                  color: bodyBgColor,
                  padding: EdgeInsets.only(
                      left: bodyMargin,
                      right: bodyMargin,
                      top: bodyMargin - 5,
                      bottom: bodyMargin - 5),
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileBox(),
                        workBox(),
                        educationBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget layoutHeadFloatingAvatarRight() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: headerHeight + 30,
          child: Stack(
            children: [
              Container(
                color: sideBgColor,
                alignment: Alignment.topCenter,
                child: Row(children: [
                  Expanded(
                    flex: sideFlex,
                    child: Container(
                      color: sideBgColor,
                    ),
                  ),
                  Expanded(
                    flex: bodyFlex,
                    child: Container(
                      color: bodyBgColor,
                    ),
                  )
                ]),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                    color: headerBgColor,
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(10),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  firstName,
                                  style: TextStyle(
                                      color: headerNameColor,
                                      fontSize: fontSizeName,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.white,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    lastName,
                                    style: TextStyle(
                                        color: headerNameColor,
                                        fontSize: fontSizeName,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  child: Text(
                                    positionName,
                                    style: TextStyle(
                                        color: headerPositionColor,
                                        fontSize: fontSizePosition,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                avatarBox(borderSize: 80, bgSize: 70),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: sideFlex,
                child: Container(
                  color: sideBgColor,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: sideBgColor,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              infoBox(),
                              contactBox(),
                              skillBox(),
                              languageBox(),
                              if (awardListing.isNotEmpty) awardBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: bodyFlex,
                child: Container(
                  color: bodyBgColor,
                  padding: EdgeInsets.only(
                      left: bodyMargin,
                      right: bodyMargin,
                      top: bodyMargin - 5,
                      bottom: bodyMargin - 5),
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileBox(),
                        workBox(),
                        educationBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget layoutHeaderWhite() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: headerHeight + 20,
            color: headerBgColor,
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: sideFlex,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        avatarBox(borderSize: 80, bgSize: 70),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: bodyFlex,
                    child: Container(
                      margin: EdgeInsets.only(left: bodyMargin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstName,
                            style: TextStyle(
                                color: headerNameColor,
                                fontSize: fontSizeName + 2,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: headerBgColor,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Text(
                              lastName,
                              style: TextStyle(
                                  color: headerNameColor,
                                  fontSize: fontSizeName + 3,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            child: Text(
                              positionName,
                              style: TextStyle(
                                  color: headerPositionColor,
                                  fontSize: fontSizePosition,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: sideFlex,
                    child: Container(
                      color: sideBgColor,
                      alignment: Alignment.topCenter,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: sideBgColor,
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              alignment: Alignment.topLeft,
                              child: Column(
                                children: [
                                  infoBox(),
                                  contactBox(),
                                  skillBox(),
                                  languageBox(),
                                  if (awardListing.isNotEmpty) awardBox(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: bodyFlex,
                    child: Container(
                      color: bodyBgColor,
                      padding: EdgeInsets.only(
                          left: bodyMargin,
                          right: bodyMargin,
                          top: bodyMargin - 5,
                          bottom: bodyMargin - 5),
                      alignment: Alignment.topLeft,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileBox(),
                            workBox(),
                            educationBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget layoutHeaderWhiteUnderline() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: headerHeight + 20,
          color: headerBgColor,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: headerBgColor,
                  width: 5.0,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: sideFlex,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      avatarBox(borderSize: 80, bgSize: 70),
                    ],
                  ),
                ),
                Expanded(
                  flex: bodyFlex,
                  child: Container(
                    margin: EdgeInsets.only(left: bodyMargin),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName,
                          style: TextStyle(
                              color: headerNameColor,
                              fontSize: fontSizeName + 2,
                              fontWeight: FontWeight.w600),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: headerBgColor,
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: Text(
                            lastName,
                            style: TextStyle(
                                color: headerNameColor,
                                fontSize: fontSizeName + 3,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 3),
                          child: Text(
                            positionName,
                            style: TextStyle(
                                color: headerPositionColor,
                                fontSize: fontSizePosition,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: sideFlex,
                child: Container(
                  color: sideBgColor,
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: sideBgColor,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          alignment: Alignment.topLeft,
                          child: Column(
                            children: [
                              infoBox(),
                              contactBox(),
                              skillBox(),
                              languageBox(),
                              if (awardListing.isNotEmpty) awardBox(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: bodyFlex,
                child: Container(
                  decoration: BoxDecoration(
                    color: bodyBgColor,
                    border: Border(
                      bottom: BorderSide(
                        color: headerBgColor,
                        width: 10.0,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.only(
                      left: bodyMargin,
                      right: bodyMargin,
                      top: bodyMargin - 5,
                      bottom: bodyMargin - 5),
                  alignment: Alignment.topLeft,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profileBox(),
                        workBox(),
                        educationBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

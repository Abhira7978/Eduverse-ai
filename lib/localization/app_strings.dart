import 'package:flutter/widgets.dart';

class AppStrings {
  final Locale locale;

  const AppStrings(this.locale);

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('or'),
    Locale('bn'),
    Locale('te'),
    Locale('ta'),
    Locale('mr'),
  ];

  static const Map<String, Map<String, String>> _values = {
    'en': {
      'language': 'English',
      'badge': 'AI-POWERED LEARNING',
      'welcome': 'Welcome to',
      'tagline': 'Learn Smarter, Grow Faster.\nAchieve More.',
      'description':
          'Your personalized AI-powered mentor, career advisor,\nand emotional support companion.',
      'getStarted': 'Get Started',
      'next': 'Next',
      'skip': 'Skip',
      'terms': 'By continuing, you agree to our Terms & Privacy Policy.',
      'personalized': 'Personalized Learning',
      'personalizedDesc':
          'Every lesson adapts to your learning speed, strengths, and areas for improvement.',
      'career': 'Career Guidance',
      'careerDesc':
          'Get roadmap, skill suggestions, internship tips, and placement preparation to achieve your career goals.',
      'emotional': 'Mental & Emotional Support',
      'emotionalDesc':
          'Get motivation, reduce stress, and stay focused with your AI companion — anytime, anywhere.',
    },
    'hi': {
      'language': 'हिन्दी',
      'badge': 'AI-संचालित शिक्षा',
      'welcome': 'आपका स्वागत है',
      'tagline': 'स्मार्ट तरीके से सीखें, तेज़ी से बढ़ें।\nऔर अधिक हासिल करें।',
      'description':
          'आपका व्यक्तिगत AI मेंटर, करियर सलाहकार,\nऔर भावनात्मक सहयोगी।',
      'getStarted': 'शुरू करें',
      'next': 'आगे',
      'skip': 'छोड़ें',
      'terms': 'जारी रखने पर आप हमारी शर्तों और गोपनीयता नीति से सहमत हैं।',
      'personalized': 'व्यक्तिगत शिक्षा',
      'personalizedDesc':
          'हर पाठ आपकी सीखने की गति, खूबियों और सुधार के क्षेत्रों के अनुसार बदलता है।',
      'career': 'करियर मार्गदर्शन',
      'careerDesc':
          'अपने करियर लक्ष्यों के लिए रोडमैप, कौशल सुझाव, इंटर्नशिप टिप्स और प्लेसमेंट तैयारी पाएं।',
      'emotional': 'मानसिक और भावनात्मक सहायता',
      'emotionalDesc':
          'प्रेरणा पाएं, तनाव कम करें और अपने AI साथी के साथ कभी भी ध्यान केंद्रित रखें।',
    },
    'or': {
      'language': 'ଓଡ଼ିଆ',
      'badge': 'AI-ଚାଳିତ ଶିକ୍ଷା',
      'welcome': 'ସ୍ୱାଗତ',
      'tagline': 'ସ୍ମାର୍ଟ ଭାବରେ ଶିଖନ୍ତୁ, ଶୀଘ୍ର ବଢ଼ନ୍ତୁ।\nଅଧିକ ସଫଳତା ପାଆନ୍ତୁ।',
      'description':
          'ଆପଣଙ୍କ ବ୍ୟକ୍ତିଗତ AI ମେଣ୍ଟର, କ୍ୟାରିୟର ପରାମର୍ଶଦାତା,\nଏବଂ ଭାବନାତ୍ମକ ସହଯୋଗୀ।',
      'getStarted': 'ଆରମ୍ଭ କରନ୍ତୁ',
      'next': 'ପରବର୍ତ୍ତୀ',
      'skip': 'ଛାଡ଼ନ୍ତୁ',
      'terms': 'ଜାରି ରଖିଲେ ଆପଣ ଆମର ନିୟମ ଏବଂ ଗୋପନୀୟତା ନୀତି ସହ ସହମତ।',
      'personalized': 'ବ୍ୟକ୍ତିଗତ ଶିକ୍ଷା',
      'personalizedDesc':
          'ପ୍ରତ୍ୟେକ ପାଠ ଆପଣଙ୍କ ଶିଖିବା ଗତି, ଦକ୍ଷତା ଏବଂ ସୁଧାର ଆବଶ୍ୟକତା ଅନୁଯାୟୀ ବଦଳେ।',
      'career': 'କ୍ୟାରିୟର ମାର୍ଗଦର୍ଶନ',
      'careerDesc':
          'ଆପଣଙ୍କ କ୍ୟାରିୟର ଲକ୍ଷ୍ୟ ପାଇଁ ରୋଡମ୍ୟାପ, ଦକ୍ଷତା ପରାମର୍ଶ, ଇଣ୍ଟର୍ନସିପ୍ ଟିପ୍ସ ଏବଂ ପ୍ଲେସମେଣ୍ଟ ପ୍ରସ୍ତୁତି ପାଆନ୍ତୁ।',
      'emotional': 'ମାନସିକ ଏବଂ ଭାବନାତ୍ମକ ସହାୟତା',
      'emotionalDesc':
          'ପ୍ରେରଣା ପାଆନ୍ତୁ, ଚାପ କମାନ୍ତୁ ଏବଂ AI ସାଥୀ ସହିତ ଯେକୌଣସି ସମୟରେ ଧ୍ୟାନ କେନ୍ଦ୍ରିତ ରଖନ୍ତୁ।',
    },
    'bn': {
      'language': 'বাংলা',
      'badge': 'AI-চালিত শিক্ষা',
      'welcome': 'স্বাগতম',
      'tagline': 'স্মার্টভাবে শিখুন, দ্রুত এগিয়ে যান।\nআরও অর্জন করুন।',
      'description':
          'আপনার ব্যক্তিগত AI মেন্টর, ক্যারিয়ার পরামর্শদাতা,\nএবং মানসিক সহায়তার সঙ্গী।',
      'getStarted': 'শুরু করুন',
      'next': 'পরবর্তী',
      'skip': 'এড়িয়ে যান',
      'terms': 'চালিয়ে গেলে আপনি আমাদের শর্তাবলি ও গোপনীয়তা নীতিতে সম্মত হচ্ছেন।',
      'personalized': 'ব্যক্তিগত শিক্ষা',
      'personalizedDesc':
          'প্রতিটি পাঠ আপনার শেখার গতি, শক্তি এবং উন্নতির ক্ষেত্র অনুযায়ী মানিয়ে যায়।',
      'career': 'ক্যারিয়ার নির্দেশনা',
      'careerDesc':
          'আপনার ক্যারিয়ার লক্ষ্যে রোডম্যাপ, দক্ষতার পরামর্শ, ইন্টার্নশিপ টিপস এবং প্লেসমেন্ট প্রস্তুতি পান।',
      'emotional': 'মানসিক ও আবেগীয় সহায়তা',
      'emotionalDesc':
          'অনুপ্রেরণা পান, চাপ কমান এবং আপনার AI সঙ্গীর সাথে যেকোনো সময় মনোযোগী থাকুন।',
    },
    'te': {
      'language': 'తెలుగు',
      'badge': 'AI ఆధారిత అభ్యాసం',
      'welcome': 'స్వాగతం',
      'tagline': 'తెలివిగా నేర్చుకోండి, వేగంగా ఎదగండి.\nమరిన్ని సాధించండి.',
      'description':
          'మీ వ్యక్తిగత AI మెంటర్, కెరీర్ సలహాదారు,\nమరియు భావోద్వేగ సహాయక సహచరుడు.',
      'getStarted': 'ప్రారంభించండి',
      'next': 'తదుపరి',
      'skip': 'దాటవేయి',
      'terms': 'కొనసాగడం ద్వారా మీరు మా నిబంధనలు మరియు గోప్యతా విధానానికి అంగీకరిస్తున్నారు.',
      'personalized': 'వ్యక్తిగత అభ్యాసం',
      'personalizedDesc':
          'ప్రతి పాఠం మీ అభ్యాస వేగం, బలాలు మరియు మెరుగుపరచాల్సిన ప్రాంతాలకు అనుగుణంగా మారుతుంది.',
      'career': 'కెరీర్ మార్గదర్శనం',
      'careerDesc':
          'మీ కెరీర్ లక్ష్యాలను చేరుకోవడానికి రోడ్‌మ్యాప్, నైపుణ్య సూచనలు, ఇంటర్న్‌షిప్ చిట్కాలు మరియు ప్లేస్‌మెంట్ సిద్ధత పొందండి.',
      'emotional': 'మానసిక మరియు భావోద్వేగ సహాయం',
      'emotionalDesc':
          'ప్రేరణ పొందండి, ఒత్తిడిని తగ్గించండి మరియు మీ AI సహచరుడితో ఎప్పుడైనా దృష్టి కేంద్రీకరించండి.',
    },
    'ta': {
      'language': 'தமிழ்',
      'badge': 'AI மூலம் இயங்கும் கற்றல்',
      'welcome': 'வரவேற்கிறோம்',
      'tagline': 'சிறப்பாகக் கற்றுக்கொள்ளுங்கள், வேகமாக வளருங்கள்.\nமேலும் சாதியுங்கள்.',
      'description':
          'உங்கள் தனிப்பட்ட AI வழிகாட்டி, தொழில் ஆலோசகர்,\nமற்றும் உணர்வுபூர்வ ஆதரவு துணை.',
      'getStarted': 'தொடங்குங்கள்',
      'next': 'அடுத்து',
      'skip': 'தவிர்',
      'terms': 'தொடர்வதன் மூலம் எங்கள் விதிமுறைகள் மற்றும் தனியுரிமைக் கொள்கையை ஏற்கிறீர்கள்.',
      'personalized': 'தனிப்பயன் கற்றல்',
      'personalizedDesc':
          'ஒவ்வொரு பாடமும் உங்கள் கற்றல் வேகம், திறன்கள் மற்றும் மேம்படுத்த வேண்டிய பகுதிகளுக்கு ஏற்ப மாறும்.',
      'career': 'தொழில் வழிகாட்டுதல்',
      'careerDesc':
          'உங்கள் தொழில் இலக்குகளை அடைய சாலைவரைபடம், திறன் ஆலோசனைகள், இன்டர்ன்ஷிப் குறிப்புகள் மற்றும் வேலைவாய்ப்பு தயாரிப்பைப் பெறுங்கள்.',
      'emotional': 'மன மற்றும் உணர்ச்சி ஆதரவு',
      'emotionalDesc':
          'ஊக்கம் பெறுங்கள், மன அழுத்தத்தைக் குறைக்குங்கள், உங்கள் AI துணையுடன் எப்போது வேண்டுமானாலும் கவனம் செலுத்துங்கள்.',
    },
    'mr': {
      'language': 'मराठी',
      'badge': 'AI-आधारित शिक्षण',
      'welcome': 'स्वागत आहे',
      'tagline': 'हुशारीने शिका, जलद प्रगती करा.\nअधिक साध्य करा.',
      'description':
          'तुमचा वैयक्तिक AI मार्गदर्शक, करिअर सल्लागार,\nआणि भावनिक आधार देणारा साथीदार.',
      'getStarted': 'सुरू करा',
      'next': 'पुढे',
      'skip': 'वगळा',
      'terms': 'पुढे सुरू ठेवून तुम्ही आमच्या अटी आणि गोपनीयता धोरणास सहमती देता.',
      'personalized': 'वैयक्तिक शिक्षण',
      'personalizedDesc':
          'प्रत्येक धडा तुमच्या शिकण्याच्या गती, कौशल्ये आणि सुधारण्याच्या क्षेत्रांनुसार बदलतो.',
      'career': 'करिअर मार्गदर्शन',
      'careerDesc':
          'तुमची करिअर उद्दिष्टे साध्य करण्यासाठी रोडमॅप, कौशल्य सूचना, इंटर्नशिप टिप्स आणि प्लेसमेंट तयारी मिळवा.',
      'emotional': 'मानसिक आणि भावनिक आधार',
      'emotionalDesc':
          'प्रेरणा मिळवा, ताण कमी करा आणि तुमच्या AI साथीदारासोबत कधीही लक्ष केंद्रित ठेवा.',
    },
  };

  String text(String key) {
    return _values[locale.languageCode]?[key] ??
        _values['en']![key] ??
        key;
  }

  String get language => text('language');
  String get badge => text('badge');
  String get welcome => text('welcome');
  String get tagline => text('tagline');
  String get description => text('description');
  String get getStarted => text('getStarted');
  String get next => text('next');
  String get skip => text('skip');
  String get terms => text('terms');
  String get personalized => text('personalized');
  String get personalizedDesc => text('personalizedDesc');
  String get career => text('career');
  String get careerDesc => text('careerDesc');
  String get emotional => text('emotional');
  String get emotionalDesc => text('emotionalDesc');

  static AppStrings of(BuildContext context) {
    return Localizations.of<AppStrings>(context, AppStrings) ??
        const AppStrings(Locale('en'));
  }
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) {
    return AppStrings.supportedLocales.any(
      (item) => item.languageCode == locale.languageCode,
    );
  }

  @override
  Future<AppStrings> load(Locale locale) async => AppStrings(locale);

  @override
  bool shouldReload(covariant AppStringsDelegate old) => false;
}
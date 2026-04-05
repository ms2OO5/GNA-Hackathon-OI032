import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;

import 'localization/localization.dart';

class GarbageProfile {
  final String displayName;
  final String useIdea;
  final String sellInfo;
  final String recycleInfo;
  final String impactInfo;
  final String speechText;

  const GarbageProfile({
    required this.displayName,
    required this.useIdea,
    required this.sellInfo,
    required this.recycleInfo,
    required this.impactInfo,
    required this.speechText,
  });
}

const Map<String, GarbageProfile> kGarbageProfiles = {
  'plastic_bottle': GarbageProfile(
    displayName: 'Plastic Bottle',
    useIdea: 'DIY planter, refill bottle',
    sellInfo: 'Local kabadi ≈ 2₹/kg',
    recycleInfo: 'Polymer / plastic recycling factory',
    impactInfo:
    'If dumped, stays for 400+ years and breaks into microplastics.',
    speechText:
    'नमस्ते, मैं एक प्लास्टिक बोतल हूँ। अगर तुम मुझे इधर‑उधर फेंकोगे तो मैं सैकड़ों साल तक मिट्टी में खत्म नहीं हो पाऊँगी और माइक्रोप्लास्टिक बन जाऊँगी। कृपया मुझे ब्लू रिसायकल बिन में डालो या गमले की तरह दुबारा इस्तेमाल करो।',
  ),
  'bio_degradable': GarbageProfile(
    displayName: 'Biodegradable Waste',
    useIdea: 'Compost at home or community pit',
    sellInfo: 'Can be sold/given to composting units',
    recycleInfo: 'Composting plant or biogas unit',
    impactInfo:
    'If treated well, turns into rich compost. In landfill, it creates methane gas.',
    speechText:
    'मैं बायोडिग्रेडेबल कचरा हूँ। अगर तुम मुझे कम्पोस्ट बनाओगे तो मैं मिट्टी के लिए बढ़िया खाद बन जाऊँगा। लेकिन जब तुम मुझे मिक्स कचरे में फेंकते हो, तब मैं मीथेन गैस बनाकर ग्लोबल वार्मिंग बढ़ाता हूँ।',
  ),
  'battery': GarbageProfile(
    displayName: 'Battery',
    useIdea: 'Store safely until e‑waste collection',
    sellInfo: 'Give to authorized e‑waste collector',
    recycleInfo: 'E‑waste recycling facility',
    impactInfo:
    'Contains heavy metals. If thrown in open, it can poison soil and water.',
    speechText:
    'मैं इस्तेमाल की हुई बैटरी हूँ। मैं छोटी दिखती हूँ, पर मेरे अंदर खतरनाक केमिकल हैं। मुझे आम कचरे के साथ मत फेंको, मुझे किसी ऑथराइज़्ड ई‑वेस्ट कलेक्शन सेंटर तक पहुँचाओ।',
  ),
  'cardboard': GarbageProfile(
    displayName: 'Cardboard',
    useIdea: 'Storage boxes, craft projects',
    sellInfo: 'Sell to kabadi, good resale value',
    recycleInfo: 'Paper/cardboard recycling unit',
    impactInfo:
    'Recycling cardboard saves trees and a lot of water used in paper making.',
    speechText:
    'मैं कार्डबोर्ड हूँ। अगर तुम मुझे रिसायकल करोगे तो कम पेड़ कटेंगे और पानी भी बचेगा। मुझे दबाकर साफ‑साफ अलग रखो और गीले कचरे के साथ मत मिलाओ।',
  ),
  'brown_glass': GarbageProfile(
    displayName: 'Brown Glass',
    useIdea: 'Decor bottles, planters (after cleaning)',
    sellInfo: 'Sell as glass scrap',
    recycleInfo: 'Glass recycling factory',
    impactInfo:
    'Glass can be recycled endlessly. In nature, it takes thousands of years to break.',
    speechText:
    'मैं ब्राउन ग्लास की बोतल हूँ। मुझे बार‑बार रिसायकल किया जा सकता है, मेरी क्वालिटी कम नहीं होती। कृपया मुझे सड़क पर तोड़ने की बजाय काँच रिसायकल प्लांट तक पहुँचाओ।',
  ),
  'green_glass': GarbageProfile(
    displayName: 'Green Glass',
    useIdea: 'DIY decor lights, vases',
    sellInfo: 'Sell as glass scrap to kabadi',
    recycleInfo: 'Glass recycling plant',
    impactInfo:
    'Recycling colored glass saves energy and mining of raw materials.',
    speechText:
    'मैं ग्रीन ग्लास हूँ। मुझे पिघला कर फिर से नई बोतल बनाया जा सकता है। अगर तुम मुझे रिसायकल करोगे तो बहुत सी एनर्जी और कच्चा माल बचेगा।',
  ),
  'white_glass': GarbageProfile(
    displayName: 'White Glass',
    useIdea: 'Storage jars, decor',
    sellInfo: 'Sell as clear glass scrap',
    recycleInfo: 'Glass recycling facility',
    impactInfo:
    'Clear glass is highly recyclable and valuable, but dangerous if broken in open.',
    speechText:
    'मैं सफेद काँच हूँ। मैं रिसायकल के लिए काफ़ी कीमती हूँ, लेकिन बाहर टूट जाऊँ तो जानवरों और इंसानों के लिए ख़तरा बन जाता हूँ। मुझे सुरक्षित तरीके से रिसायकल के लिए दो।',
  ),
  'cloths': GarbageProfile(
    displayName: 'Clothes / Fabric',
    useIdea: 'Upcycle as cleaning rags, DIY bags',
    sellInfo: 'Donate or sell to old‑cloth dealer',
    recycleInfo: 'Textile recycling / donation centers',
    impactInfo:
    'Fast fashion creates mountains of textile waste and microfibres in water.',
    speechText:
    'मैं पुराने कपड़े हूँ। मुझे फेंकने से पहले सोचो कि क्या कोई मुझे पहन सकता है या रीसायकल कर सकता है। टेक्सटाइल वेस्ट चुपचाप बहुत बड़ा प्रदूषण बन रहा है।',
  ),
  'metal': GarbageProfile(
    displayName: 'Metal Scrap',
    useIdea: 'Upcycle for DIY projects',
    sellInfo: 'Good resale value at kabadi',
    recycleInfo: 'Metal recycling / smelter',
    impactInfo:
    'Recycling metal saves huge energy compared to mining new ore.',
    speechText:
    'मैं मेटल स्क्रैप हूँ। अगर मुझे रिसायकल किया जाए तो नई मेटल की खान खोदने से कहीं ज़्यादा एनर्जी बचती है। इसलिए मुझे कबाड़ी या मेटल रिसायकल प्लांट तक पहुँचाओ।',
  ),
  'paper': GarbageProfile(
    displayName: 'Paper',
    useIdea: 'Reuse blank side, packing material',
    sellInfo: 'Sell as waste paper',
    recycleInfo: 'Paper recycling mill',
    impactInfo:
    'Recycling paper directly reduces tree cutting and landfill volume.',
    speechText:
    'मैं काग़ज़ हूँ। पहले मेरा खाली हिस्सा दुबारा इस्तेमाल करो, फिर मुझे रिसायकल के लिए बेच दो। ऐसा करने से पेड़ कम कटेंगे और लैंडफिल भी कम भरेंगे।',
  ),
  'plastic': GarbageProfile(
    displayName: 'Plastic Item',
    useIdea: 'Repurpose, avoid single‑use',
    sellInfo: 'Sell with plastic scrap',
    recycleInfo: 'Plastic recycling center',
    impactInfo:
    'Different plastics take 100–500 years to break down and can harm animals.',
    speechText:
    'मैं प्लास्टिक हूँ। कोशिश करो कि मुझे दुबारा‑दुबारा इस्तेमाल करो और फिर रिसायकल कर दो। अगर मैं समंदर या कूड़ेदान में पड़ा रहा तो जानवरों और पर्यावरण के लिए बहुत नुकसानदायक हो जाऊँगा।',
  ),
  'shoes': GarbageProfile(
    displayName: 'Shoes',
    useIdea: 'Donate if wearable, upcycle for planters',
    sellInfo: 'Old shoe collection / donation drives',
    recycleInfo: 'Specialized textile/rubber recyclers',
    impactInfo:
    'Shoe soles are usually non‑biodegradable and can release microplastics.',
    speechText:
    'मैं पुराने जूते हूँ। अगर अभी भी पहनने लायक हूँ तो मुझे दान कर दो। अगर नहीं, तो रीसायकल ड्राइव या कलेक्शन बॉक्स ढूँढो, मुझे जलाना या कहीं भी फेंकना ठीक नहीं है।',
  ),
  'trash': GarbageProfile(
    displayName: 'Mixed Trash',
    useIdea: 'Try to separate recyclables from me',
    sellInfo: 'Usually no resale value',
    recycleInfo: 'Engineered landfill / waste‑to‑energy',
    impactInfo:
    'Mixed trash is hardest to manage and usually ends up in landfills or nature.',
    speechText:
    'मैं मिक्स कचरा हूँ और संभालने में सबसे मुश्किल हूँ। ज़्यादातर मैं सीधे लैंडफिल या खुले में चला जाता हूँ। अगली बार मुझसे रिसायकल होने वाली चीज़ें अलग कर के ही फेंको।',
  ),
};

enum _FaceShapeType { rounded, bottle, box, slim }

enum _FaceMood { sad, neutral, worried, soft }

class VendorOffer {
  final String name;
  final String distance;
  final String exactPrice;
  final bool homePickup;
  final String eta;
  final String note;

  const VendorOffer({
    required this.name,
    required this.distance,
    required this.exactPrice,
    required this.homePickup,
    required this.eta,
    required this.note,
  });
}

class ScanScreen extends StatefulWidget {
  final AppLocalization loc;

  const ScanScreen({super.key, required this.loc});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final FlutterTts _tts = FlutterTts();
  final Random _random = Random();

  CameraController? _cameraController;
  Future<void>? _initCameraFuture;

  bool _isLoading = false;
  bool _hasDetection = false;
  bool _isSpeaking = false;

  XFile? _capturedImage;
  bool _showCaptured = false;

  String _detectedLabel = 'Plastic Bottle';
  double _confidence = 0.978;
  String _useIdea = 'DIY Planter, Refill';
  String _sellInfo = 'Local kabadi ≈ 2₹/kg';
  String _recycleInfo = 'Polymer Factory';
  String _impactInfo = 'Save soil, reduce landfill';
  String _speechText =
      'नमस्ते, मैं एक प्लास्टिक बोतल हूँ। अगर तुम मुझे इधर‑उधर फेंकोगे तो मैं सैकड़ों साल तक मिट्टी में खत्म नहीं हो पाऊँगी। कृपया मुझे ब्लू रिसायकल बिन में डालो या गमले की तरह दुबारा इस्तेमाल करो।';

  double _faceScale = 1.0;

  double _estimatedWeightKg = 0.04;
  String _itemCondition = 'Used but recyclable';
  String _materialType = 'Plastic';
  String _approxPriceRange = '₹2 - ₹6';
  bool _showSellPanel = false;

  List<VendorOffer> _vendorOffers = [];

  AppLocalization get loc => widget.loc;

  @override
  void initState() {
    super.initState();
    _initTts();
    _initCameraFuture = _initCamera();
    _generateVendorOffers();
  }

  Future<void> _initTts() async {
    await _tts.setLanguage('hi-IN');
    await _tts.setSpeechRate(0.4);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);
    await _tts.awaitSpeakCompletion(true);

    _tts.setCompletionHandler(() {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });

    _tts.setErrorHandler((msg) {
      if (mounted) {
        setState(() => _isSpeaking = false);
      }
    });
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final back = cameras.firstWhere(
            (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        back,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  @override
  void dispose() {
    _tts.stop();
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _onScanPressed() async {
    if (_isLoading ||
        _cameraController == null ||
        !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      setState(() => _isLoading = true);

      final XFile image = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = image;
        _showCaptured = true;
      });

      await _cameraController!.pausePreview();

      final success = await _classifyOnFlask(image);

      if (!success) {
        _applyRandomProfile();
      }

      setState(() {
        _hasDetection = true;
        _isLoading = false;
      });

      await _speakBottle();
    } catch (e) {
      debugPrint('Capture/classify error: $e');
      _applyRandomProfile();

      setState(() {
        _hasDetection = true;
        _showCaptured = true;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Scan failed, sample info dikha rahe hain.'),
          ),
        );
      }
    }
  }

  double _scaleForLabel(String label) {
    if (label.contains('battery')) return 0.8;
    if (label.contains('paper')) return 0.9;
    if (label.contains('plastic_bottle')) return 1.0;
    if (label.contains('plastic')) return 1.05;
    if (label.contains('cloth') || label.contains('shoes')) return 1.1;
    if (label.contains('trash')) return 1.15;
    return 1.0;
  }

  _FaceShapeType _shapeForLabel(String label) {
    if (label.contains('plastic_bottle') ||
        label.contains('brown_glass') ||
        label.contains('green_glass') ||
        label.contains('white_glass')) {
      return _FaceShapeType.bottle;
    }

    if (label.contains('cardboard') || label.contains('paper')) {
      return _FaceShapeType.box;
    }

    if (label.contains('battery') || label.contains('metal')) {
      return _FaceShapeType.slim;
    }

    return _FaceShapeType.rounded;
  }

  _FaceMood _moodForLabel(String label) {
    if (label.contains('trash') || label.contains('battery')) {
      return _FaceMood.worried;
    }
    if (label.contains('plastic') || label.contains('paper')) {
      return _FaceMood.sad;
    }
    if (label.contains('cloth') || label.contains('shoes')) {
      return _FaceMood.soft;
    }
    return _FaceMood.neutral;
  }

  void _updateSellEstimatesFromLabel(String label) {
    final key = label.toLowerCase().replaceAll(' ', '_');

    if (key.contains('plastic_bottle')) {
      _estimatedWeightKg = 0.04;
      _itemCondition = 'Used but recyclable';
      _materialType = 'Plastic';
      _approxPriceRange = '₹2 - ₹6';
    } else if (key.contains('plastic')) {
      _estimatedWeightKg = 0.12;
      _itemCondition = 'Mixed plastic item';
      _materialType = 'Plastic';
      _approxPriceRange = '₹3 - ₹10';
    } else if (key.contains('metal')) {
      _estimatedWeightKg = 0.80;
      _itemCondition = 'Scrap usable';
      _materialType = 'Metal';
      _approxPriceRange = '₹18 - ₹45';
    } else if (key.contains('paper')) {
      _estimatedWeightKg = 0.18;
      _itemCondition = 'Dry and reusable';
      _materialType = 'Paper';
      _approxPriceRange = '₹4 - ₹9';
    } else if (key.contains('cardboard')) {
      _estimatedWeightKg = 0.35;
      _itemCondition = 'Dry / foldable';
      _materialType = 'Paperboard';
      _approxPriceRange = '₹6 - ₹14';
    } else if (key.contains('battery')) {
      _estimatedWeightKg = 0.20;
      _itemCondition = 'Hazardous / sealed';
      _materialType = 'E-waste';
      _approxPriceRange = '₹8 - ₹20';
    } else if (key.contains('glass')) {
      _estimatedWeightKg = 0.45;
      _itemCondition = 'Breakable / recyclable';
      _materialType = 'Glass';
      _approxPriceRange = '₹5 - ₹15';
    } else if (key.contains('cloth') || key.contains('shoes')) {
      _estimatedWeightKg = 0.60;
      _itemCondition = 'Reusable / donation grade';
      _materialType = 'Textile';
      _approxPriceRange = '₹5 - ₹25';
    } else if (key.contains('bio_degradable') ||
        key.contains('biodegradable')) {
      _estimatedWeightKg = 0.55;
      _itemCondition = 'Wet organic waste';
      _materialType = 'Biodegradable';
      _approxPriceRange = 'Low resale / compost value';
    } else {
      _estimatedWeightKg = 0.25;
      _itemCondition = 'Mixed condition';
      _materialType = 'General recyclable';
      _approxPriceRange = '₹3 - ₹10';
    }
  }

  void _generateVendorOffers() {
    final material = _materialType.toLowerCase();

    if (material.contains('metal')) {
      _vendorOffers = const [
        VendorOffer(
          name: 'EcoKabadi Nearby',
          distance: '1.2 km',
          exactPrice: '₹38',
          homePickup: true,
          eta: 'Pickup in 25 mins',
          note: 'Best for iron / mixed metal scrap',
        ),
        VendorOffer(
          name: 'Green Scrap Buyer',
          distance: '2.8 km',
          exactPrice: '₹41',
          homePickup: true,
          eta: 'Pickup by evening',
          note: 'Higher quote for cleaner metal',
        ),
        VendorOffer(
          name: 'Urban Recycle Hub',
          distance: '3.5 km',
          exactPrice: '₹36',
          homePickup: false,
          eta: 'Drop-off only',
          note: 'Instant weighing at center',
        ),
      ];
    } else if (material.contains('plastic')) {
      _vendorOffers = const [
        VendorOffer(
          name: 'EcoKabadi Nearby',
          distance: '1.2 km',
          exactPrice: '₹5',
          homePickup: true,
          eta: 'Pickup in 25 mins',
          note: 'Pickup available above small quantity',
        ),
        VendorOffer(
          name: 'Green Scrap Buyer',
          distance: '2.8 km',
          exactPrice: '₹4',
          homePickup: true,
          eta: 'Pickup by evening',
          note: 'Sorted PET gets better price',
        ),
        VendorOffer(
          name: 'Urban Recycle Hub',
          distance: '3.5 km',
          exactPrice: '₹6',
          homePickup: false,
          eta: 'Drop-off only',
          note: 'Best if bottle is clean and dry',
        ),
      ];
    } else if (material.contains('paper')) {
      _vendorOffers = const [
        VendorOffer(
          name: 'PaperLoop Vendor',
          distance: '1.6 km',
          exactPrice: '₹9',
          homePickup: true,
          eta: 'Pickup in 40 mins',
          note: 'Dry newspapers / books accepted',
        ),
        VendorOffer(
          name: 'Green Scrap Buyer',
          distance: '2.3 km',
          exactPrice: '₹8',
          homePickup: true,
          eta: 'Same-day pickup',
          note: 'Wet paper not accepted',
        ),
        VendorOffer(
          name: 'Urban Recycle Hub',
          distance: '4.0 km',
          exactPrice: '₹10',
          homePickup: false,
          eta: 'Drop-off only',
          note: 'Bulk paper gets extra rate',
        ),
      ];
    } else if (material.contains('glass')) {
      _vendorOffers = const [
        VendorOffer(
          name: 'GlassCycle Point',
          distance: '2.1 km',
          exactPrice: '₹8',
          homePickup: true,
          eta: 'Pickup tomorrow morning',
          note: 'Unbroken glass gets better quote',
        ),
        VendorOffer(
          name: 'EcoKabadi Nearby',
          distance: '1.9 km',
          exactPrice: '₹7',
          homePickup: true,
          eta: 'Pickup by evening',
          note: 'Handle carefully during pickup',
        ),
        VendorOffer(
          name: 'Urban Recycle Hub',
          distance: '3.8 km',
          exactPrice: '₹9',
          homePickup: false,
          eta: 'Drop-off only',
          note: 'Sorted color glass preferred',
        ),
      ];
    } else if (material.contains('biodegradable')) {
      _vendorOffers = const [
        VendorOffer(
          name: 'Compost Partner',
          distance: '1.4 km',
          exactPrice: '₹2',
          homePickup: true,
          eta: 'Pickup tomorrow',
          note: 'Wet waste accepted separately',
        ),
        VendorOffer(
          name: 'BioGas Unit',
          distance: '3.2 km',
          exactPrice: '₹1',
          homePickup: true,
          eta: 'Scheduled pickup',
          note: 'Best for kitchen organic waste',
        ),
      ];
    } else {
      _vendorOffers = const [
        VendorOffer(
          name: 'EcoKabadi Nearby',
          distance: '1.8 km',
          exactPrice: '₹6',
          homePickup: true,
          eta: 'Pickup in 35 mins',
          note: 'General recyclable items accepted',
        ),
        VendorOffer(
          name: 'Urban Recycle Hub',
          distance: '3.3 km',
          exactPrice: '₹7',
          homePickup: false,
          eta: 'Drop-off only',
          note: 'Exact rate after weighing',
        ),
      ];
    }
  }

  Future<bool> _classifyOnFlask(XFile image) async {
    final uri = Uri.parse('http://192.168.137.121:5000/predict');

    try {
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath(
          'image',
          image.path,
        ));

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();
      final data = jsonDecode(body) as Map<String, dynamic>;

      if (data['status'] != 'success' || data['predictions'] == null) {
        return true;
      }

      final preds = data['predictions'] as List<dynamic>;
      if (preds.isEmpty) return false;

      final first = preds.first as Map<String, dynamic>;
      final rawLabel =
      (first['class'] as String? ?? 'plastic_bottle').toLowerCase();
      final normLabel = rawLabel.replaceAll(' ', '_');

      final confStr =
      (first['confidence'] as String? ?? '97.0%').replaceAll('%', '').trim();
      final confVal = double.tryParse(confStr) ?? 97.0;

      final profile = kGarbageProfiles[normLabel];

      setState(() {
        _confidence = confVal / 100.0;
        _faceScale = _scaleForLabel(normLabel);

        if (profile != null) {
          _detectedLabel = profile.displayName;
          _useIdea = profile.useIdea;
          _sellInfo = profile.sellInfo;
          _recycleInfo = profile.recycleInfo;
          _impactInfo = profile.impactInfo;
          _speechText = profile.speechText;
        } else {
          _detectedLabel = rawLabel.replaceAll('_', ' ');
          _useIdea = 'कोशिश करो कि इसे दोबारा इस्तेमाल या रिसायकल किया जाए।';
          _sellInfo = 'लोकल कबाड़ी या रिसायकल सेंटर से पूछो।';
          _recycleInfo = 'अपने शहर के सेफ डिस्पोज़ल गाइडलाइन फॉलो करो।';
          _impactInfo =
          'गलत तरीके से फेंकने से मिट्टी, हवा या पानी को नुकसान हो सकता है।';
          _speechText =
          'मैं $_detectedLabel हूँ। कृपया मुझे सुरक्षित तरीके से फेंको या रिसायकल करो, जैसा तुम्हारे शहर में सही तरीका हो।';
        }

        _updateSellEstimatesFromLabel(normLabel);
        _generateVendorOffers();
        _showSellPanel = false;
      });

      return true;
    } catch (e) {
      debugPrint('Flask call error: $e');
      return false;
    }
  }

  void _applyRandomProfile() {
    final keys = kGarbageProfiles.keys.toList();
    final profileKey = keys[_random.nextInt(keys.length)];
    final profile = kGarbageProfiles[profileKey]!;

    setState(() {
      _confidence = 0.6 + _random.nextDouble() * 0.35;
      _detectedLabel = profile.displayName;
      _useIdea = profile.useIdea;
      _sellInfo = profile.sellInfo;
      _recycleInfo = profile.recycleInfo;
      _impactInfo = profile.impactInfo;
      _speechText = profile.speechText;
      _faceScale = 0.9 + _random.nextDouble() * 0.3;

      _updateSellEstimatesFromLabel(profileKey);
      _generateVendorOffers();
      _showSellPanel = false;
    });
  }

  Future<void> _speakBottle() async {
    await _tts.stop();
    setState(() => _isSpeaking = true);

    final hindi = _speechText;
    final punjabi =
        ' अब पंजाबी में सुनो — main $_detectedLabel haan, kirpa karke menu sahi bin vich paa, taan jo saaf‑sutra mahol bane.';

    await _tts.speak('$hindi  $punjabi');
  }

  Future<void> _resetScan() async {
    setState(() {
      _hasDetection = false;
      _capturedImage = null;
      _showCaptured = false;
      _isSpeaking = false;
      _showSellPanel = false;
    });

    if (_cameraController != null &&
        _cameraController!.value.isInitialized &&
        !_cameraController!.value.isStreamingImages) {
      await _cameraController!.resumePreview();
    }
  }

  void _bookPickup(VendorOffer offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pickup requested from ${offer.name} • ${offer.exactPrice}',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final cameraHeight = screenWidth * 4 / 3;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottomSafe + 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF39D98A), Color(0xFF3CB371)],
                      ),
                    ),
                    child: const Icon(Icons.recycling, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    loc.t(LocKeys.appName),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.settings_outlined),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Scan & Listen',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Point at an item, tap scan, then listen to its story.',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.65),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: cameraHeight + (_hasDetection ? 125 : 40),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: cameraHeight,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(26),
                    child: FutureBuilder<void>(
                      future: _initCameraFuture,
                      builder: (context, snapshot) {
                        final ready = _cameraController != null &&
                            _cameraController!.value.isInitialized;

                        if (!ready) {
                          return Container(
                            color: const Color(0xFF151D26),
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 64,
                                color: Colors.white54,
                              ),
                            ),
                          );
                        }

                        Widget base;
                        if (_showCaptured && _capturedImage != null) {
                          base = TweenAnimationBuilder<double>(
                            tween: Tween(
                              begin: 1.0,
                              end: _hasDetection ? 1.03 : 1.0,
                            ),
                            duration: const Duration(milliseconds: 450),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Image.file(
                              File(_capturedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          base = CameraPreview(_cameraController!);
                        }

                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            base,
                            CustomPaint(painter: _GridOverlayPainter()),
                            if (_hasDetection &&
                                _showCaptured &&
                                _capturedImage != null)
                              _TalkingFace(
                                isSpeaking: _isSpeaking,
                                scale: _faceScale,
                                imageFile: File(_capturedImage!.path),
                                shapeType:
                                _shapeForLabel(_detectedLabel.toLowerCase()),
                                mood:
                                _moodForLabel(_detectedLabel.toLowerCase()),
                              ),
                            if (_isLoading)
                              Positioned(
                                bottom: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF39D98A),
                                    ),
                                  ),
                                ),
                              ),
                            if (!_isLoading && !_showCaptured)
                              Positioned(
                                bottom: 18,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: GestureDetector(
                                    onTap: _onScanPressed,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 22,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF39D98A),
                                            Color(0xFF13B6AA),
                                          ],
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.black.withOpacity(0.45),
                                            blurRadius: 10,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.camera_alt,
                                            size: 18,
                                            color: Colors.black,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Scan now',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (_hasDetection && _showCaptured && !_isLoading)
                              Positioned(
                                bottom: 18,
                                right: 18,
                                child: FloatingActionButton(
                                  heroTag: 'speak_again',
                                  backgroundColor:
                                  const Color(0xFF151D26).withOpacity(0.9),
                                  onPressed: _speakBottle,
                                  child: const Icon(
                                    Icons.volume_up_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                if (_hasDetection)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: cameraHeight - 72,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF050F19), Color(0xFF081521)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFF7AE5C0).withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'DETECTED: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF7AE5C0),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  _detectedLabel,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xFF102020).withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_circle,
                                      color: Color(0xFF7AE5C0),
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${(_confidence * 100).toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              _MiniInfoPill(
                                icon: Icons.emoji_emotions_outlined,
                                title: 'Emotions',
                                subtitle: 'Sad, ignored',
                              ),
                              SizedBox(width: 8),
                              _MiniInfoPill(
                                icon: Icons.warning_amber_outlined,
                                title: 'Disadvantages',
                                subtitle: 'Pollution, animal harm',
                              ),
                              SizedBox(width: 8),
                              _MiniInfoPill(
                                icon: Icons.delete_outline,
                                title: 'Where/How',
                                subtitle: 'Blue bin (recyclable)',
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
          const SizedBox(height: 16),
          if (_hasDetection)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF050F19),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _BulletRow(
                        emoji: '🪴',
                        label: 'Use idea',
                        value: _useIdea,
                      ),
                      _BulletRow(
                        emoji: '💰',
                        label: 'Sell',
                        value: _sellInfo,
                      ),
                      _BulletRow(
                        emoji: '♻️',
                        label: 'Recycle',
                        value: _recycleInfo,
                      ),
                      _BulletRow(
                        emoji: '🌱',
                        label: 'Impact',
                        value: _impactInfo,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF07141D),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.sell_outlined,
                            color: Color(0xFF7AE5C0),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Sell this item',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Approx weight: ${_estimatedWeightKg.toStringAsFixed(2)} kg',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Condition: $_itemCondition',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Material: $_materialType',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Approx price: $_approxPriceRange',
                        style: const TextStyle(
                          color: Color(0xFF7AE5C0),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF39D98A),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                setState(() => _showSellPanel = true);
                              },
                              child: const Text('Sell Now'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                setState(() => _showSellPanel = false);
                              },
                              child: const Text('Not Now'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (_showSellPanel) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF050F19),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: const Color(0xFF7AE5C0).withOpacity(0.22),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Nearby buyers with exact offers',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._vendorOffers.map(
                              (v) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.04),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.store_mall_directory_outlined,
                                  color: Color(0xFF7AE5C0),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        v.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Exact price: ${v.exactPrice}',
                                        style: const TextStyle(
                                          color: Color(0xFF7AE5C0),
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        'Distance: ${v.distance}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Text(
                                        v.homePickup
                                            ? 'Home pickup available • ${v.eta}'
                                            : 'No home pickup • ${v.eta}',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        v.note,
                                        style: const TextStyle(
                                          color: Colors.white54,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => _bookPickup(v),
                                  child: const Text('Book'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: _resetScan,
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF7AE5C0),
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Scan again'),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _TalkingFace extends StatefulWidget {
  final bool isSpeaking;
  final double scale;
  final File? imageFile;
  final _FaceShapeType shapeType;
  final _FaceMood mood;

  const _TalkingFace({
    required this.isSpeaking,
    required this.scale,
    required this.imageFile,
    required this.shapeType,
    required this.mood,
  });

  @override
  State<_TalkingFace> createState() => _TalkingFaceState();
}

class _TalkingFaceState extends State<_TalkingFace>
    with TickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final AnimationController _talkController;
  late final AnimationController _idleBobController;

  static const List<double> _talkPattern = [
    0.10,
    0.28,
    0.62,
    0.18,
    0.75,
    0.34,
    0.14,
    0.52,
    0.82,
    0.22,
    0.48,
    0.12,
  ];

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat();

    _talkController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _talkPattern.length * 90),
    );

    _idleBobController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    if (widget.isSpeaking) {
      _talkController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _TalkingFace oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSpeaking && !_talkController.isAnimating) {
      _talkController.repeat();
    } else if (!widget.isSpeaking && _talkController.isAnimating) {
      _talkController.stop();
    }
  }

  @override
  void dispose() {
    _blinkController.dispose();
    _talkController.dispose();
    _idleBobController.dispose();
    super.dispose();
  }

  double _blinkAmount(double t) {
    if (t < 0.80) return 0.0;
    final local = (t - 0.80) / 0.20;
    if (local < 0.5) {
      return local * 2;
    } else {
      return (1 - local) * 2;
    }
  }

  double _mouthValue() {
    if (!widget.isSpeaking) return 0.10;
    final progress = _talkController.value;
    final rawIndex = progress * _talkPattern.length;
    final index = rawIndex.floor().clamp(0, _talkPattern.length - 1);
    final next = (index + 1) % _talkPattern.length;
    final localT = rawIndex - index;
    return lerpDouble(_talkPattern[index], _talkPattern[next], localT)!;
  }

  BorderRadius _shapeRadius(double scale) {
    switch (widget.shapeType) {
      case _FaceShapeType.bottle:
        return BorderRadius.only(
          topLeft: Radius.circular(30 * scale),
          topRight: Radius.circular(30 * scale),
          bottomLeft: Radius.circular(18 * scale),
          bottomRight: Radius.circular(18 * scale),
        );
      case _FaceShapeType.box:
        return BorderRadius.circular(14 * scale);
      case _FaceShapeType.slim:
        return BorderRadius.circular(18 * scale);
      case _FaceShapeType.rounded:
        return BorderRadius.circular(24 * scale);
    }
  }

  Size _shapeSize(double scale) {
    switch (widget.shapeType) {
      case _FaceShapeType.bottle:
        return Size(130 * scale, 66 * scale);
      case _FaceShapeType.box:
        return Size(146 * scale, 58 * scale);
      case _FaceShapeType.slim:
        return Size(118 * scale, 54 * scale);
      case _FaceShapeType.rounded:
        return Size(138 * scale, 68 * scale);
    }
  }

  double _browAngle(bool isLeft) {
    switch (widget.mood) {
      case _FaceMood.sad:
        return isLeft ? -0.30 : 0.30;
      case _FaceMood.worried:
        return isLeft ? -0.12 : 0.12;
      case _FaceMood.soft:
        return isLeft ? -0.22 : 0.22;
      case _FaceMood.neutral:
        return isLeft ? -0.20 : 0.20;
    }
  }

  double _browYOffset() {
    switch (widget.mood) {
      case _FaceMood.worried:
        return -2;
      case _FaceMood.sad:
        return 1;
      case _FaceMood.soft:
        return 0;
      case _FaceMood.neutral:
        return 0;
    }
  }

  Color _blinkLidColor() {
    switch (widget.shapeType) {
      case _FaceShapeType.bottle:
        return const Color(0xFF8BAEA5);
      case _FaceShapeType.box:
        return const Color(0xFF9C8B73);
      case _FaceShapeType.slim:
        return const Color(0xFF7D8A92);
      case _FaceShapeType.rounded:
        return const Color(0xFF7FA59C);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _blinkController,
        _talkController,
        _idleBobController,
      ]),
      builder: (context, child) {
        final blink = _blinkAmount(_blinkController.value);
        final mouthOpen = _mouthValue();
        final bob = sin(_idleBobController.value * pi * 2) * 2.0;

        return Transform.translate(
          offset: Offset(0, widget.isSpeaking ? bob : bob * 0.5),
          child: _buildFace(blink, mouthOpen),
        );
      },
    );
  }

  Widget _buildFace(double blink, double mouthOpen) {
    final scale = widget.scale;
    final size = _shapeSize(scale);
    final stripWidth = size.width;
    final stripHeight = size.height;
    final radius = _shapeRadius(scale);

    final eyeTop = stripHeight * 0.33;
    final browTop = stripHeight * 0.14 + _browYOffset();
    final mouthBottom = 7.0 * scale;

    return Align(
      alignment: const Alignment(0, 0.04),
      child: SizedBox(
        width: stripWidth,
        height: stripHeight + 24 * scale,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: stripWidth,
              height: stripHeight,
              decoration: BoxDecoration(
                borderRadius: radius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.34),
                    blurRadius: 14 * scale,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (widget.imageFile != null)
                      Transform.scale(
                        scale:
                        widget.shapeType == _FaceShapeType.slim ? 3.2 : 2.8,
                        child: Image.file(
                          widget.imageFile!,
                          fit: BoxFit.cover,
                          alignment: widget.shapeType == _FaceShapeType.bottle
                              ? const Alignment(0, 0.10)
                              : const Alignment(0, 0.18),
                        ),
                      )
                    else
                      Container(color: const Color(0xFF18B6AA)),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.10),
                            Colors.transparent,
                            Colors.black.withOpacity(0.16),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: radius,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.14),
                          width: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 6 * scale,
              left: 16 * scale,
              right: 16 * scale,
              child: Container(
                height: 4.5 * scale,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: Colors.white.withOpacity(0.14),
                ),
              ),
            ),
            Positioned(
              top: browTop,
              left: stripWidth * 0.18,
              child: _eyebrow(
                isLeft: true,
                scale: scale,
                shapeType: widget.shapeType,
                angle: _browAngle(true),
              ),
            ),
            Positioned(
              top: browTop,
              right: stripWidth * 0.18,
              child: _eyebrow(
                isLeft: false,
                scale: scale,
                shapeType: widget.shapeType,
                angle: _browAngle(false),
              ),
            ),
            Positioned(
              top: eyeTop,
              left: 22 * scale,
              right: 22 * scale,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _eye(scale, blink, mouthOpen),
                  _eye(scale, blink, mouthOpen),
                ],
              ),
            ),
            Positioned(
              bottom: mouthBottom,
              left: stripWidth * 0.29,
              right: stripWidth * 0.29,
              child: _RealMouth(
                openness: mouthOpen,
                scale: scale,
                mood: widget.mood,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _eye(double scale, double blink, double mouthOpen) {
    final outer = 23.0 * scale;
    final iris = 11.5 * scale;
    final pupil = 6.0 * scale;
    final pupilDx = widget.isSpeaking ? (mouthOpen - 0.4) * 1.2 : 0.0;

    return SizedBox(
      width: outer,
      height: outer,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: outer,
              height: outer,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 4 * scale,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Transform.translate(
                  offset: Offset(pupilDx, 0),
                  child: Container(
                    width: iris,
                    height: iris,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Color(0xFF245C57),
                          Color(0xFF102E2A),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: const Alignment(0.08, 0.18),
                      children: [
                        Container(
                          width: pupil,
                          height: pupil,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          left: 2,
                          child: Container(
                            width: 3.2 * scale,
                            height: 3.2 * scale,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (blink > 0)
            ClipRRect(
              borderRadius: BorderRadius.circular(outer / 2),
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: blink.clamp(0.0, 1.0),
                child: Container(
                  width: outer,
                  height: outer,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        _blinkLidColor().withOpacity(0.95),
                        _blinkLidColor().withOpacity(0.82),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _eyebrow({
    required bool isLeft,
    required double scale,
    required _FaceShapeType shapeType,
    required double angle,
  }) {
    final width = shapeType == _FaceShapeType.slim ? 20 * scale : 26 * scale;
    final height = 3.6 * scale;

    return Transform.rotate(
      angle: angle,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(99),
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.78),
              Colors.black.withOpacity(0.35),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.06),
              blurRadius: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _RealMouth extends StatelessWidget {
  final double openness;
  final double scale;
  final _FaceMood mood;

  const _RealMouth({
    required this.openness,
    required this.scale,
    required this.mood,
  });

  @override
  Widget build(BuildContext context) {
    final mouthHeight = lerpDouble(3.5 * scale, 18 * scale, openness)!;
    final lipHeight = lerpDouble(2.0 * scale, 3.8 * scale, openness)!;
    final mouthWidth = lerpDouble(32 * scale, 26 * scale, openness)!;
    final cornerDrop =
    mood == _FaceMood.sad || mood == _FaceMood.worried ? 2.0 : 0.0;

    return SizedBox(
      height: mouthHeight + 8 * scale,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            bottom: 0,
            child: Container(
              width: mouthWidth,
              height: mouthHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF2A0E12),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10 * scale),
                  topRight: Radius.circular(10 * scale),
                  bottomLeft: Radius.circular((14 + cornerDrop) * scale),
                  bottomRight: Radius.circular((14 + cornerDrop) * scale),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.24),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: mouthWidth + 2 * scale,
              height: lipHeight,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          if (openness > 0.28)
            Positioned(
              bottom: 2 * scale,
              child: Container(
                width: mouthWidth * 0.68,
                height: max(2.5 * scale, mouthHeight * 0.18),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.22),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
          if (openness > 0.46)
            Positioned(
              bottom: 1.8 * scale,
              child: Container(
                width: mouthWidth * 0.40,
                height: mouthHeight * 0.28,
                decoration: BoxDecoration(
                  color: const Color(0xFFD16A7A).withOpacity(0.88),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GridOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.18)
      ..strokeWidth = 1;

    final thirdW = size.width / 3;
    final thirdH = size.height / 3;

    canvas.drawLine(Offset(thirdW, 0), Offset(thirdW, size.height), paint);
    canvas.drawLine(
      Offset(2 * thirdW, 0),
      Offset(2 * thirdW, size.height),
      paint,
    );
    canvas.drawLine(Offset(0, thirdH), Offset(size.width, thirdH), paint);
    canvas.drawLine(
      Offset(0, 2 * thirdH),
      Offset(size.width, 2 * thirdH),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MiniInfoPill extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _MiniInfoPill({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF101821),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: Colors.white),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _BulletRow({
    super.key,
    required this.emoji,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
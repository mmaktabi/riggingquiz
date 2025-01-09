'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "9c70015c1b122b46725d706b1c90391c",
"assets/AssetManifest.bin.json": "5fcaf64ecf90d872137946a448c59e2d",
"assets/AssetManifest.json": "b3c9cc9ceffeaac72a2d43802b769c61",
"assets/assets/app_logo.png": "13204c4a7392d8d99bf78b5ce5fc6eca",
"assets/assets/app_logo_leer.png": "56dec7f516ec6178fbd9bd51598cd416",
"assets/assets/app_logo_man.png": "723a89e83e95885cd6317f5b952631c9",
"assets/assets/avatars/avatar.svg": "f76b58eee5c6f317e262e24fffd38fe5",
"assets/assets/avatars/avatar_2.svg": "175594609b2a8cfb79a68aa74d9ebb1b",
"assets/assets/avatars/avatar_3.svg": "f26c05d1550cb82e9693defc14f0f83d",
"assets/assets/avatars/leaderboard_1.svg": "61195196595af32ab0aa3c285c219759",
"assets/assets/avatars/leaderboard_2.svg": "caf85d23a3766332c508dc23f18a7627",
"assets/assets/avatars/leaderboard_3.svg": "1ef9af99faf7b661321cd81a0a1473f7",
"assets/assets/avatars/leaderboard_4.svg": "f7b15c5c415fc1720154e8ce639810f3",
"assets/assets/avatars/leaderboard_5.svg": "331f4ca8a56d274c10880ac6bc7a0141",
"assets/assets/avatars/leaderboard_6.svg": "a5f563a4455833ab33d59d7115a74459",
"assets/assets/backgrounds/background_1.png": "599210130f53f15995fb44de54b0f90b",
"assets/assets/badges/badge_1.png": "1b8bebf267e1c0a70bd0eefb5242c8ff",
"assets/assets/badges/badge_1.svg": "16551a644752f1cd80f6979add3424e2",
"assets/assets/badges/badge_2.png": "f44991f45e025ead060d3cf3d08666ca",
"assets/assets/badges/badge_3.png": "10ee6362801fbfe38dc7db43b66f9339",
"assets/assets/badges/badge_4.png": "33776a7c5634220e6db7eddd7b0a73bb",
"assets/assets/badges/badge_5.png": "04a7c7bb4d02bb79326f4aba0f0d572f",
"assets/assets/badges/badge_6.png": "d3ac4012783fa0fb563fe6cdb79fb9ed",
"assets/assets/flags/canada.png": "b61c590b33b014abf1d84ef9fc07dbdd",
"assets/assets/flags/czech.png": "27e271c77d916ff4bf9d757234643f74",
"assets/assets/flags/france.png": "7263e477e9f7badbfab7f7c0dca62206",
"assets/assets/flags/hungary.png": "91121260550193b94e073e6382e126e4",
"assets/assets/flags/italy.png": "e2f55cdbfb4ba53e636f95b95d283c6c",
"assets/assets/flags/portugal.png": "495bf3b259d309ade796f2ed3a112778",
"assets/assets/icons/active_slider_indicator.svg": "cf3907e1c7ad8621c2b0d921acaa576d",
"assets/assets/icons/add_cover_icon.svg": "9f31746f9670c852356c12173a790e7f",
"assets/assets/icons/app_logo.png": "6e7d199054c3e788da46bd332e652411",
"assets/assets/icons/app_logo.svg": "c4043cc012918d92ebe0ef09d83f5fa3",
"assets/assets/icons/arrow_bottom.svg": "0aac0965401c3fc6c4e7e50183af3fdc",
"assets/assets/icons/art_icon.svg": "aa35d8ce2b3d18f0a152134f4af206bc",
"assets/assets/icons/back_arrow_icon.svg": "46f7575dcbc9cdae7e9d975919be0ce1",
"assets/assets/icons/button_icon.svg": "12678d9c9a44fa6f4d9f8e0fc9453229",
"assets/assets/icons/clock_icon.svg": "6ad018f095ba0b395d83a6af35667c4b",
"assets/assets/icons/curve_line.svg": "d839b21a570fd016f05458de7abec718",
"assets/assets/icons/curve_line_2.png": "aa5133345ea797adc36784189920d923",
"assets/assets/icons/curve_line_2.svg": "49cfae32cf03b58e3374421abbd064bc",
"assets/assets/icons/curve_line_3.svg": "eb6e3597dd335fe8104cefda3a740b9f",
"assets/assets/icons/duplicate_icon.svg": "74a4ecad6328c35df0d016d47e476dbe",
"assets/assets/icons/favicon.png": "6e7d199054c3e788da46bd332e652411",
"assets/assets/icons/fb_icon.svg": "dbe4893484805f556886b9f0c970477d",
"assets/assets/icons/flag.png": "b69b45be91060cf8dd6f7eba687025b7",
"assets/assets/icons/flag.svg": "f6b03d6fd0381b5295e88e25a6342bf6",
"assets/assets/icons/globe.svg": "b2c03cd41ea065dbebc43a60797be6f5",
"assets/assets/icons/google_icon.svg": "051fe8d03dbea0d5269ccc166cbdfd7d",
"assets/assets/icons/headphone.svg": "3c44eae9959865f178c5096ef8bcdfe9",
"assets/assets/icons/history_icon.svg": "c915bc0b1b4c462d30daee6af0d54054",
"assets/assets/icons/icon_mic.svg": "aa55358977f4b7d2605e029d6079c4ae",
"assets/assets/icons/icon_puzzle.svg": "d38169fbcde094d7833eaed6588f3d8f",
"assets/assets/icons/icon_puzzle_only.svg": "f1eab297912015f2323be231bf02ba19",
"assets/assets/icons/icon_question_mark.svg": "9090e44022d5412ca9c9c1d557d3ccc7",
"assets/assets/icons/icon_share.svg": "70cb210f9ee20af16dc02d3919e7935a",
"assets/assets/icons/jigsaw.svg": "411d1368654f65200697e23417b36a32",
"assets/assets/icons/local_rank_icon.svg": "bea6eef387536a7c1dac3c75ea5177d4",
"assets/assets/icons/logo_only.png": "03e534ffdeecc79abc7d614cd79f7a49",
"assets/assets/icons/man1.svg": "d0dd13b3c7f95acff68dfa31861b5113",
"assets/assets/icons/man2.svg": "35d33d4fb3eedd7cbb991078b6113e9f",
"assets/assets/icons/math_icon.svg": "c2dfd20e04991d4c05d921e338ff9aea",
"assets/assets/icons/medal_bronze.svg": "5feee5eef030baff8e1d741d055f53b4",
"assets/assets/icons/medal_gold.svg": "a81790e4d4f315c7334c1d09b9ed9fd1",
"assets/assets/icons/medal_silver.svg": "f0ff67f368c777d78f0394a8bb785013",
"assets/assets/icons/music_icon.svg": "de123cd59a326c002e8c22df1425861c",
"assets/assets/icons/oval_big.svg": "1fe2f0227519d32af313eb3381d085d0",
"assets/assets/icons/oval_home_screen.svg": "b3bec309203863428810e285e33e288c",
"assets/assets/icons/oval_mini.svg": "e9da8815e7440be2e682d6ab5842355c",
"assets/assets/icons/oval_outline_bottom.svg": "15d99d098959e8f5d99b1eef2f43a4c6",
"assets/assets/icons/oval_outline_bottom_onboarding.svg": "75db96df15b9cf74346dafde214fa415",
"assets/assets/icons/oval_outline_top.svg": "3b3343690571b023541c4ce1eaa01e70",
"assets/assets/icons/oval_outline_top_onboarding.svg": "c86933f7bcf55b8111d6e1473ea972b6",
"assets/assets/icons/oval_review_quiz.svg": "e239a88900d628f0a77c562d2939a19d",
"assets/assets/icons/oval_two_big.png": "0e77b5dbf1cfa42cc9887b2887c4bafb",
"assets/assets/icons/pencil.svg": "a38dc22843c2e7ee7f639b394a07bbc8",
"assets/assets/icons/play_button.svg": "0f281c36f5b0095cc5420be58d27b9ef",
"assets/assets/icons/plus_icon.svg": "3bfe7ad2efb00ee4fa2f2c5776a90ad3",
"assets/assets/icons/quiz_checkbox.svg": "43cad811a164d18bb35d622d612e18e9",
"assets/assets/icons/quiz_multiple.svg": "8035c9cac08f321a0d456edc3646cbbd",
"assets/assets/icons/quiz_puzzle.svg": "fec66058c4bda1539d1d484a6498d0bf",
"assets/assets/icons/quiz_true_false.svg": "fa4082327e9972f3e729830d27f94690",
"assets/assets/icons/quiz_type.svg": "62647ae3b063c625894cddad2444e89f",
"assets/assets/icons/quiz_voice.svg": "d7d06c8367a4ce715e16eef5e535e189",
"assets/assets/icons/rank_1.png": "1a705849808e8244c621fa9df0670149",
"assets/assets/icons/rank_2.png": "4751349ac1d5812330114e3c8578f5f3",
"assets/assets/icons/rank_3.png": "41cb7a2ca4ee72975eadd0050726f13c",
"assets/assets/icons/rigging_quiz.png": "13204c4a7392d8d99bf78b5ce5fc6eca",
"assets/assets/icons/science_icon.svg": "1d38c9db47ac2c27f89dc5e3e2fa546e",
"assets/assets/icons/search.svg": "0f429e0bf7eca3c87e690aec1df9f5b7",
"assets/assets/icons/slider_indicator.svg": "d08ae9f81558578ac311485b41af30ae",
"assets/assets/icons/sport_icon.svg": "8cf6d6200d81df2af04fd785fc3aa992",
"assets/assets/icons/star.svg": "a263085eeb3a322c8584459c72f39045",
"assets/assets/icons/tech_icon.svg": "7d5904b54977af1052ffcbf20647504f",
"assets/assets/icons/three_dots_icon.svg": "18afe133ec806fafdd580c9f27d2f899",
"assets/assets/icons/trash_icon.svg": "76fe722896fba72eb8c211eb97f49176",
"assets/assets/icons/travel_icon.svg": "0734b5cb3e0c59d7e0c858c66e1169ab",
"assets/assets/icons/voice_note.png": "1760dd6e51015119084daa3b7ec3d367",
"assets/assets/icons/voice_note.svg": "53d19490d0b24eb1949389a29e01b545",
"assets/assets/icons/youtube.svg": "ab53d6df62c8d6b617e671aba8c8b851",
"assets/assets/illustrations/1.svg": "c05c0521d9001ef452062ecf5f604904",
"assets/assets/illustrations/2.svg": "b6b4bbe313a85413a625132fb626053c",
"assets/assets/illustrations/3.svg": "c2c15ea419b7297a3aa3646bcdf57db3",
"assets/assets/illustrations/chart.svg": "1a089f0c0201f77a179701e6200896b4",
"assets/assets/illustrations/football_team.svg": "e6d6627a0ecbbd5cd3469b9b475009cd",
"assets/assets/illustrations/Illustration_drone.svg": "bb5f8de20335ce0be45c62bee7a14e2e",
"assets/assets/illustrations/Illustration_key.svg": "58d11f863442e90d8a7d7238a08aba55",
"assets/assets/illustrations/illustration_line_chart.png": "490817f32e6d2fb62041fcc957a38bb0",
"assets/assets/illustrations/illustration_line_chart.svg": "b02129411b75d59b4b01a4e0daa89651",
"assets/assets/illustrations/illustration_onboarding_1.svg": "07e96058a20822a9ad63795341b0bb72",
"assets/assets/illustrations/illustration_onboarding_2.svg": "b6ddb87f47e4a1ae5715c2b9e8b5944c",
"assets/assets/illustrations/illustration_onboarding_3.svg": "c2c15ea419b7297a3aa3646bcdf57db3",
"assets/assets/illustrations/integers.svg": "af5f5bc056321d67cf3c5a5ca5fac854",
"assets/assets/illustrations/music-festival.svg": "5e280c761776acf676125768cdced07a",
"assets/assets/illustrations/musicFestival.svg": "bd731d588d6745b6fbc7dab52b1fdeac",
"assets/assets/illustrations/person.svg": "5d3f98b39d1553e64929a09fe4afb4fa",
"assets/assets/illustrations/person_2.svg": "6e816957a610385cb863cef02e58b885",
"assets/assets/illustrations/person_3.svg": "4a88fbfd32d01b00072565c2af14c305",
"assets/assets/illustrations/quiz_review.svg": "579333ec5f1d96fe04586d6194f263bd",
"assets/assets/illustrations/trophy.png": "bd7500f224b83a67d1948678d2e06b5e",
"assets/assets/images/box.png": "88ff3df2cc9c2a47839bb9cf00a498fa",
"assets/assets/images/coin.png": "8788729a4eadac496b23523062d2d037",
"assets/assets/images/diamond.png": "5390a365c67af6c22810cd63fd80eba8",
"assets/assets/images/done.png": "845bd87359435e61163163976a58e702",
"assets/assets/images/extra_life.png": "5f08ed94a6269fd031a9b4717b524a66",
"assets/assets/images/gem_box.png": "6ff89f23df0042e3efca198c5bd72a62",
"assets/assets/images/life.png": "9a7809fafb7f4928d78b9195820b29f8",
"assets/assets/images/Music%2520festival-bro.png": "15dce59ad019db2129f1a6109b487075",
"assets/assets/images/ques_mark.png": "c005ebe373aac08d410a2ba54bc733d0",
"assets/assets/rigging/app_logo.png": "6e7d199054c3e788da46bd332e652411",
"assets/assets/rigging/DALL_E_2024-10-05_00.24.02_-_An_icon_idea_featuring_a_mixing_console_with_sliders_and_knobs__a_microphone__or_a_speaker_symbol_emitting_sound_waves__representing_various_aspects_o-removebg-preview.png": "337367110986b8dd69225659278f6789",
"assets/assets/rigging/DALL_E_2024-10-05_00.24.06_-_An_icon_idea_featuring_a_spotlight_or_moving_head_with_beams_of_light_coming_out__possibly_combined_with_colored_light_cones__representing_the_creativ-removebg-preview-rem.png": "67d918391d0b67bcd3f250e3c03e121a",
"assets/assets/rigging/DALL_E_2024-10-05_00.24.06_-_An_icon_idea_featuring_a_spotlight_or_moving_head_with_beams_of_light_coming_out__possibly_combined_with_colored_light_cones__representing_the_creativ-removebg-preview.png": "344ee0a67d0fb76bd345d912045d9615",
"assets/assets/rigging/DALL_E_2024-10-05_00.24.09_-_An_icon_idea_featuring_a_stylized_aluminum_truss_with_connecting_elements_or_a_wrench_engaging_with_the_truss__highlighting_the_assembly_aspect._The_d__1_-removebg-preview.png": "14aa7642f107c29f6eaf47a900000a0f",
"assets/assets/rigging/enthusiastic-amico.svg": "077dc07bbc7fa7be25d093f810f73c28",
"assets/assets/rigging/Enthusiastic-pana.svg": "ace42f2ebbce0f3e5f3c622d4222cd88",
"assets/assets/rigging/saftyIcon.png": "6e84663e3e755e9a9664f7f1b5943696",
"assets/assets/rigging/schaekel.png": "1d7ce9a2fd63af234c3d74a3590c6050",
"assets/assets/sounds/alert.mp3": "00ba96d19651ccc05a04b3da938bf4cf",
"assets/assets/sounds/bubble_pop.mp3": "640be347b3d51c5fcbd7dcec1ce13c0f",
"assets/assets/sounds/click_button.mp3": "5bf372053a5226ce6a47006e44a704ea",
"assets/assets/sounds/correct.mp3": "a99df4a47864e4f2ea3133182aded068",
"assets/assets/sounds/level_completed.mp3": "046668fd7677e3d62d7cda4b48b885ef",
"assets/assets/sounds/level_failed.mp3": "9a6ebd59266412d4c124ef83f578c7cd",
"assets/assets/sounds/selector.mp3": "8e385bd901a3ff7c4361cee9af2f94a2",
"assets/assets/sounds/wrong_answer.mp3": "1506875cd2b698b595dcfcfa73fcd3b5",
"assets/assets/vectors/invite_friend_cloud.svg": "afa228a3fa3f446f4dd0627dafe0ed58",
"assets/assets/vectors/invite_friend_round.svg": "942b618a0edba2703fb48e888463c1c7",
"assets/assets/vectors/leaderboard_oval.svg": "0523aac4b3541b1cc090b8730e19428a",
"assets/assets/vectors/leaderboard_white_container.svg": "12f7a1f2dd4e561af52ad20db9309977",
"assets/assets/vectors/quiz_purple_container.svg": "afe8725bce0e708edd2d8a7e57174efe",
"assets/assets/vectors/quiz_white_container.svg": "ccd6515a67d7b1b79c02027b22b85f8a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "89cec07b402373069770b11402d0ff71",
"assets/NOTICES": "b92261798e270d163fbf32a3e0330b21",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"favicon.png": "f481bdc7e8d093e53fc42e5fddacef71",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"flutter_bootstrap.js": "63075f0d37aac1637c5645d1e8272a14",
"icons/Icon-192.png": "437f76df353890fd705f4f18cc8eac88",
"icons/Icon-512.png": "de6e607ab534b21dd47636aa9ae40146",
"icons/Icon-maskable-192.png": "f481bdc7e8d093e53fc42e5fddacef71",
"icons/Icon-maskable-512.png": "f481bdc7e8d093e53fc42e5fddacef71",
"index.html": "5adaa8df0b523371f7e0d22e1c390052",
"/": "5adaa8df0b523371f7e0d22e1c390052",
"main.dart.js": "43c2a1dbbd58b92141cd169bdd341381",
"manifest.json": "a1314b2d11dc8c42873198b2b2376d0b",
"version.json": "0ec328e9256d825898dfd9b5b50e0f61"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}

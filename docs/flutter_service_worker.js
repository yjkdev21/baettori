'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "ef8b16c2180288e4118140ce1ec6d18d",
"version.json": "817ba4a4db85c17dd57f0a6a0dffdd05",
"index.html": "a03bd2f8636998b81471818b43217514",
"/": "a03bd2f8636998b81471818b43217514",
"main.dart.js": "641de1d72ae285e06868e73b21ed486d",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "4411d88b48bde320a45cddd22127cd0e",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "991b9538c27ac6cf15249e3caf5b5e7a",
"assets/AssetManifest.json": "3e532a04fc69232c3b5e9a77852211e3",
"assets/NOTICES": "1b0a645b7ce14f8e5c9d26f7ad5efa12",
"assets/FontManifest.json": "fc2ac3061e6e95ebc02b7994c706a9dd",
"assets/AssetManifest.bin.json": "4d0454644b08469b3106e37feb836d23",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "8120c1146d9ae24fa1342fb78fb035c8",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/assets/images/banner_volt.png": "4626506a60f2d7e97456b9b6712fe3e7",
"assets/assets/images/person.png": "7bdff9f9dc67d2ad10c2a4a8315218ce",
"assets/assets/images/logo.png": "4271fdc01aca117038bae8303d2183bc",
"assets/assets/images/logo-w.png": "4e97ba8b2eaaf844cc49f077406f707e",
"assets/assets/images/banner_group.png": "cda479372bafccc9de3efde19b516d9b",
"assets/assets/images/person_another.png": "6a40f63119182860db1f955456019fbb",
"assets/assets/images/example.png": "fbdc4574d4f14345d9d400edbad0e683",
"assets/assets/icons/ic_pen.svg": "fd2999f7ff65bb6bc9025a95bd33da15",
"assets/assets/icons/ic_bolt-b.svg": "641f15921d480e9883e2d0620ab407f2",
"assets/assets/icons/ic_lookup-g.svg": "f3d46fdc5621d5c10e8fe6455995b1ab",
"assets/assets/icons/ic_chat-g.svg": "fabf5cf58d2603c18e96799366aee864",
"assets/assets/icons/ic_heart.svg": "ffff6cd69aa628f0ca73d9c8afc78161",
"assets/assets/icons/ic_camera.svg": "7643b829d6a9cfd41d8dd3985b0b4529",
"assets/assets/icons/ic_noti-w.svg": "1cea01d3a9ddf8aae2294c076910efbf",
"assets/assets/icons/ic_profile-b2.svg": "153ba0f3125ae7b7c9240c1233bb22eb",
"assets/assets/icons/ic_home-w.svg": "f7936fe927e4dd2faf97f73c1ff12250",
"assets/assets/icons/ic_place-dg.svg": "19bd93e8a8b4536120ede9d693b34b6c",
"assets/assets/icons/ic_place-g.svg": "399ad05242cf52e9f00c2dbfe08d3389",
"assets/assets/icons/ic_article-b2.svg": "bbd3df7e01627d9a74ffc6735704dda7",
"assets/assets/icons/ic_heart-lg.svg": "2134ebe45d0a62548b2c42fc3bf072f8",
"assets/assets/icons/ic_group-b.svg": "ee75b92977a8df7635c656739234e683",
"assets/assets/icons/ic_warning-error.svg": "e1d705cab24fb5fa384a433ff03409ee",
"assets/assets/icons/ic_home-fill.svg": "c232d3a21a16d9467bc54b801bbeb984",
"assets/assets/icons/ic_chat-fill.svg": "5d5175b3223c16532fe877be93960027",
"assets/assets/icons/ic_camera-g.svg": "ddee887fb0776e5baa054ba0987a53de",
"assets/assets/icons/ic_search-w.svg": "ef760de97172c00ef89c6ddc889eab6c",
"assets/assets/icons/ic_profile-fill.svg": "33a59fd806a25c5f670db83377c11ab1",
"assets/assets/icons/ic_right-w.svg": "c90daae5b344b7e0d738bdb60fcbd120",
"assets/assets/icons/ic_home-b2.svg": "ebf40711fff6f2da80d07801c1b7d717",
"assets/assets/icons/ic_warning-g.svg": "b06f73eb42146d63e732de92e5f95e58",
"assets/assets/icons/ic_add-b2.svg": "6bdf505c46e71636194d16fec0e62498",
"assets/assets/icons/ic_close-b.svg": "9469f3ed1f404623f82101f7a3c6ffad",
"assets/assets/icons/ic_add-fill.svg": "daac03c66c7946d550be701366a81fc8",
"assets/assets/icons/ic_check.svg": "a211ccd0699908adc4e94b6cb6d6f048",
"assets/assets/icons/ic_right-g.svg": "64bc8497084b26967db3465125dcc237",
"assets/assets/icons/ic_heart-fill.svg": "25339627b58186b4c69c19271b711fd7",
"assets/assets/icons/ic_close-w.svg": "89f317ec2f16f13c3e6666fc37b86252",
"assets/assets/icons/ic_left-w.svg": "1e1691fc7e6b444dd655d2d47c0820c5",
"assets/assets/icons/ic_send.svg": "41a3baecb7d870be25f5dae3d58a689f",
"assets/assets/icons/ic_heart-g.svg": "5924115153b4896da13a1b67b256b93e",
"assets/assets/icons/ic_chat-b2.svg": "cb5528199af19ae3c4f102a28b23c597",
"assets/assets/icons/ic_left-b.svg": "52e8ed93d06c16d273da58fbff45df8c",
"assets/assets/icons/ic_search.svg": "b9a88543566f5ad4c944d810a7b68ffc",
"assets/assets/icons/ic_chat-fill-w.svg": "25c736e487ae99cec4a5fe1517e54936",
"assets/assets/icons/ic_article-fill.svg": "46cd2beb9242619b6baa1d47a5c5963a",
"assets/assets/icons/ic_menu-w.svg": "db2a270c93efbfb12ed73792e432361c",
"assets/assets/icons/ic_letter.svg": "62de9954948189d5b819f0fa29895e82",
"assets/assets/fonts/Pretendard-Medium.ttf": "7305f90c923d4409825ec2f4380b63d6",
"assets/assets/fonts/Pretendard-Black.ttf": "51c73880d5964b36e6373b3fe31f3058",
"assets/assets/fonts/Pretendard-Regular.ttf": "d6e0de06bff8b7fda2db4682168e3ddf",
"assets/assets/fonts/Pretendard-Thin.ttf": "8b65a9299b173e635e6acac200e80257",
"assets/assets/fonts/Pretendard-ExtraLight.ttf": "2f39a307ce00aa5e734137d4cee3b5c1",
"assets/assets/fonts/Pretendard-SemiBold.ttf": "459eff7ba5380583ccd6eda49c846c85",
"assets/assets/fonts/Pretendard-ExtraBold.ttf": "332e9b673b0c1709e93fee01e4543f1d",
"assets/assets/fonts/Pretendard-Bold.ttf": "dfb614ebecd405875f50a918ca11c17c",
"assets/assets/fonts/Pretendard-Light.ttf": "77ecd2ca94928e38ff7c68bb255324f7",
"assets/assets/fonts/HSSanTokki.ttf": "0e2c3e7b6554ba8614535f073fd3a963",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
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

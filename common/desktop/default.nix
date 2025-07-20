{ config, pkgs, ... }:

{
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # mesa graphics library
    graphics.enable = true;
  };

  # audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # CUPS
  services.printing.enable = true;

  # enable native wayland in chromium/electron
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = with pkgs; [
    bitwarden
    krita
    gpu-screen-recorder-gtk
    vlc
  ];

  # hard coded since i don't know a way to easily check a package's existence
  home-manager.users.wo2w.home.file = {
    ".local/share/applications/com.dec05eba.gpu_screen_recorder.desktop".text = ''
      [Desktop Entry]
      Categories=AudioVideo;Recorder;
      Comment[en_US]=A gpu based screen recorder / streaming program
      Comment=A gpu based screen recorder / streaming program
      Exec=nvidia-offload gpu-screen-recorder-gtk
      GenericName[en_US]=Screen recorder
      GenericName=Screen recorder
      Icon=com.dec05eba.gpu_screen_recorder
      Keywords=gpu-screen-recorder;screen recorder;streaming;twitch;replay;
      MimeType=
      Name[en_US]=GPU Screen Recorder
      Name=GPU Screen Recorder
      Path=
      StartupNotify=true
      Terminal=false
      TerminalOptions=
      Type=Application
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';

    ".local/share/applications/vlc.desktop".text = ''
      [Desktop Entry]
      Categories=AudioVideo;Player;Recorder;
      Comment[en_US]=Read, capture, broadcast your multimedia streams
      Comment=Read, capture, broadcast your multimedia streams
      Comment[af]=Lees, vang, send u multimediastrome
      Comment[am]=የ እርስዎን በርካታ መገናኛ ማንበቢያ: መያዣ ማስተላለፊያ
      Comment[ar]=اقرأ ، التقط ، و بث تدفقات وسائطك المتعددة
      Comment[as_IN]=আপোনাৰ মাল্টিমিডিয়া ষ্ট্ৰীমসমূহ পঢ়ক, কেপচাৰ কৰক, সম্প্ৰচাৰ কৰক
      Comment[ast]=Llei, captura y emiti fluxos multimedia
      Comment[az]=Multinedia axınlarını oxudun, yazın və yayımlayın
      Comment[be]=Чытаць, лавіць і трансляваць мультымедыйныя патокі
      Comment[bg]=Прочитане, прихващане и излъчване на мултимедийни потоци.
      Comment[bn_BD]=আপনার মাল্টিমিডিয়া স্ট্রীম পড়ুন, ধরে রাখুন এবং ছড়িয়ে দিন
      Comment[br]=Lenn, enrollañ, skignañ ho froudoù liesvedia
      Comment[ca]=Reproduïu, captureu i emeteu fluxos multimèdia
      Comment[co]=Leghje, cattura, diffonde i vostri flussi multimedia
      Comment[cs]=Čtěte, zachytávejte, a vysílejte své multimediální proudy
      Comment[cy]=Darllen, cipio a darlledu dy ffrydiau aml-gyfrwng
      Comment[da]=Læs, indspil, transmittér dine multimediestreams
      Comment[de]=Wiedergabe, Aufnahme und Verbreitung Ihrer Multimedia-Streams
      Comment[el]=Διαβάστε, καταγράψτε, μεταδώστε τα πολυμέσα σας
      Comment[en_GB]=Read, capture, broadcast your multimedia streams
      Comment[es]=Lea, capture y emita sus contenidos multimedia
      Comment[es_MX]=Lea, capture, emita sus transmisiones multimedia
      Comment[et]=Multimeediafailide ja -voogude taasesitamine, lindistamine ja edastamine
      Comment[eu]=Irakurri, hartu, igorri zure multimedia jarioak
      Comment[fi]=Toista, tallenna ja lähetä multimediaa
      Comment[fr]=Lit, capture, diffuse vos flux multimédias
      Comment[fy]=Jo multimedia-streams lêze, opnimme en útstjoere
      Comment[ga]=Léigh, gabh, craol do shruthanna ilmheán
      Comment[gd]=Leugh, glac is craol sruthan ioma-mheadhain
      Comment[gl]=Lea, capture e emita os seus fluxos multimedia
      Comment[he]=קריאה, לכידה ושידור של תזרימי המולטימדיה שלך
      Comment[hi]=अपनी मल्टीमीडिया स्ट्रीम को पढ़ें, रिकॉर्ड करें, प्रसारित करें
      Comment[hu]=Multimédia adatfolyamok olvasása, felvétele és továbbítása
      Comment[id]=Baca, tangkap, pancarkan/broadcast aliran multimedia
      Comment[ie]=Leer, registrar e difuser vor fluvies multimedia
      Comment[is]=Lesa, taka upp og útvarpa margmiðlunarstreymi
      Comment[it]=Leggi, cattura, trasmetti i tuoi flussi multimediali
      Comment[ja]=マルチメディアストリームの読み込み、キャプチャー、ブロードキャスト
      Comment[ka]=გახსენით, გადაიღეთ, გაუშვით მედიაფაილები ეთერში
      Comment[kab]=Ɣeṛ, ṭṭef agdil, suffeɣ-d isuddam n umidya-ik
      Comment[km]=អាន ចាប់យក ប្រកាស​ស្ទ្រីម​ពហុមេឌៀ​របស់​អ្នក
      Comment[ko]=당신의 멀티미디어 스트림을 캡쳐 및 방송 할 수 있습니다
      Comment[lt]=Groti, įrašyti, siųsti įvairialypės terpės kūrinius
      Comment[lv]=Lasiet, tveriet un apraidiet savas multimediju straumes
      Comment[ml]=നിങ്ങളുടെ മൾട്ടിമീഡിയ സ്ട്രീമുകൾ റീഡ് ചെയ്യുക, ക്യാപ്‌ചർ ചെയ്യുക, പ്രക്ഷേപണം ചെയ്യുക
      Comment[mn]=Таны дамжуулгын урсгалыг унших, бичиж авах, цацах
      Comment[mr]=आपले मल्टीमिडिया प्रवाह बघा, हस्तगत करा, प्रसारित करा
      Comment[ms]=Baca, tangkap, siarkan strim multimedia anda
      Comment[my]=သင်၏ မာတီမီဒီယာ တိုက်ရိုက်လွှင့်ပြ စီးကြောင်းများကို ဖတ်၊ ဖမ်းယူ၊ ထုတ်လွင့်ခြင်း
      Comment[nb]=Innless, ta opp, og kringkast dine multimediastrømmer
      Comment[ne]=पढ्नुहोस्, क्याप्चर गर्नुहोस्, तपाईंका मल्टिमिडिया स्ट्रिमहरू प्रसारण गर्नुहोस्
      Comment[nl]=Uw multimedia-streams lezen, opnemen en uitzenden
      Comment[nn]=Spel av, ta opp og send ut multimedia
      Comment[oc]=Legissètz, capturatz, difusatz vòstres fluxes multimèdia
      Comment[pa]=ਆਪਣੀ ਮਲਟੀਮੀਡਿਆ ਸਟਰੀਮ ਪੜ੍ਹੋ, ਕੈਪਚਰ ਤੇ ਬਰਾਡਕਾਸਟ ਕਰੋ
      Comment[pl]=Odczytywanie, przechwytywanie i nadawanie strumieni multimedialnych
      Comment[pt_BR]=Reproduza, capture e transmita os seus transmissões multimídia
      Comment[pt_PT]=Ler, capturar, transmitir as suas emissões de multimédia
      Comment[ro]=Citește, capturează, difuzează fluxurile multimedia
      Comment[ru]=Универсальный проигрыватель видео и аудио
      Comment[sc]=Leghe, catura, trasmite sos flussos multimediales tuos
      Comment[sk]=Načítavajte, zaznamenávajte, vysielajte svoje multimediálne streamy
      Comment[sl]=Berite, zajemite, oddajajte vaše večpredstavne pretoke
      Comment[sq]=Lexoni, kapni dhe transmetoni transmetimet tuaja multimedia
      Comment[sr]=Читај, хватај, емитуј своје мултимедијалне токове
      Comment[sv]=Läs, fånga, sänd dina multimediaströmmar
      Comment[te]=మీ బహుళమాధ్యమ ప్రవాహాలను చదువు, బంధించు మరియు ప్రసారం చేయి
      Comment[th]=อ่าน จับ และถ่ายทอดสตรีมมัลติมีเดียของคุณ
      Comment[tr]=Çoklu ortam akışlarınızı okuyun, yakalayın, yayınlayın
      Comment[uk]=Читання, захоплення та поширення ваших мультимедійних потоків
      Comment[vi]=Đọc, chụp, phát các luồng đa phương tiện của bạn
      Comment[wa]=Lét, egaloye, evoye vos floûs multimedia
      Comment[zh_CN]=读取、捕获、广播您的多媒体流
      Comment[zh_TW]=讀取、擷取與廣播您的多媒體串流
      Exec=env QT_SCALE_FACTOR=1.4 __NV_PRIME_RENDER_OFFLOAD=1 __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only /nix/store/kd85dylgr1pj6h696qs553miaffhhp6n-vlc-3.0.21/bin/vlc --started-from-file %U
      GenericName[en_US]=Media player
      GenericName=Media player
      GenericName[af]=Mediaspeler
      GenericName[am]=የ መገናኛ ማጫወቻ
      GenericName[ar]=مشغل الوسائط
      GenericName[as_IN]=মিডিয়া প্লেয়াৰ
      GenericName[ast]=Reproductor multimedia
      GenericName[az]=Media pleyeri
      GenericName[be]=Медыяпрайгравальнік
      GenericName[bg]=Медиен плейър
      GenericName[bn_BD]=মিডিয়া প্লেয়ার
      GenericName[br]=Lenner mediaoù
      GenericName[ca]=Reproductor multimèdia
      GenericName[co]=Lettore multimedia
      GenericName[cs]=Multimediální přehrávač
      GenericName[cy]=Chwaraeydd cyfryngau
      GenericName[da]=Medieafspiller
      GenericName[de]=Medienwiedergabe
      GenericName[el]=Αναπαραγωγός πολυμέσων
      GenericName[en_GB]=Media player
      GenericName[es]=Reproductor multimedia
      GenericName[es_MX]=Reproductor multimedia
      GenericName[et]=Meediaesitaja
      GenericName[eu]=Multimedia irakurgailua
      GenericName[fi]=Mediasoitin
      GenericName[fr]=Lecteur multimédia
      GenericName[fy]=Mediaspiler
      GenericName[ga]=Seinnteoir meán
      GenericName[gd]=Cluicheadair mheadhanan
      GenericName[gl]=Reprodutor multimedia
      GenericName[he]=נגן מדיה
      GenericName[hi]=मीडिया प्लेयर
      GenericName[hu]=Médialejátszó
      GenericName[id]=Pemutar Media
      GenericName[ie]=Reproductor de media
      GenericName[is]=Margmiðlunarspilari
      GenericName[it]=Lettore multimediale
      GenericName[ja]=メディアプレイヤー
      GenericName[ka]=მედიაფაილების დამკვრელი
      GenericName[kab]=Imeɣri n umidya
      GenericName[km]=កម្មវិធី​ចាក់​មេឌៀ
      GenericName[ko]=미디어 플레이어
      GenericName[lt]=Leistuvė
      GenericName[lv]=Mediju atskaņotājs
      GenericName[ml]=മീഡിയ പ്ലെയർ
      GenericName[mn]=Дамжуулга тоглуулагч
      GenericName[mr]=मीडिया प्लेअर
      GenericName[ms]=Pemain media
      GenericName[my]=မီဒီယာ ပြစက်
      GenericName[nb]=Mediespiller
      GenericName[ne]=मिडिया प्लेयर
      GenericName[nl]=Mediaspeler
      GenericName[nn]=Mediespelar
      GenericName[oc]=Lector multimèdia
      GenericName[pa]=ਮੀਡਿਆ ਪਲੇਅਰ
      GenericName[pl]=Odtwarzacz multimedialny
      GenericName[pt_BR]=Reprodutor de Mídias
      GenericName[pt_PT]=Reprodutor de multimédia
      GenericName[ro]=Redor media
      GenericName[ru]=Медиаплеер
      GenericName[sc]=Leghidore multimediale
      GenericName[sk]=Prehrávač médií
      GenericName[sl]=Predvajalnik predstavnih vsebin
      GenericName[sq]=Lexues Media
      GenericName[sr]=Медијски плејер
      GenericName[sv]=Mediaspelare
      GenericName[te]=మాధ్యమ ప్రదర్శకం
      GenericName[th]=โปรแกรมเล่นสื่อ
      GenericName[tr]=Ortam oynatıcısı
      GenericName[uk]=Медіапрогравач
      GenericName[vi]=Trình phát Media
      GenericName[wa]=Djouweu d' media
      GenericName[zh_CN]=媒体播放器
      GenericName[zh_TW]=媒體播放器
      Icon=vlc
      Keywords=Player;Capture;DVD;Audio;Video;Server;Broadcast;
      MimeType=x-content/video-vcd;x-content/video-svcd;x-content/video-dvd;x-content/audio-player;x-content/audio-cdda;video/x-theora+ogg;video/x-theora+ogg;video/x-ogm+ogg;video/x-ogm+ogg;video/x-nsv;video/x-ms-wmv;video/x-matroska;video/x-flv;video/x-flv;video/x-flv;video/x-flic;video/x-flic;video/x-anim;video/webm;video/vnd.rn-realvideo;video/vnd.mpegurl;video/vnd.avi;video/vnd.avi;video/vnd.avi;video/vnd.avi;video/vnd.avi;video/vnd.avi;video/quicktime;video/ogg;video/mpeg;video/mpeg;video/mpeg;video/mpeg;video/mpeg;video/mp4;video/mp4;video/mp4;video/mp2t;video/dv;video/3gpp2;video/3gpp2;video/3gpp;video/3gpp;video/3gpp;text/x-google-video-pointer;text/x-google-video-pointer;image/vnd.rn-realpix;audio/x-xm;audio/x-wavpack;audio/x-vorbis+ogg;audio/x-vorbis+ogg;audio/x-vorbis+ogg;audio/x-tta;audio/x-speex;audio/x-scpls;audio/x-scpls;audio/x-s3m;audio/x-musepack;audio/x-ms-wma;audio/x-ms-asx;audio/x-ms-asx;audio/x-ms-asx;audio/x-mpegurl;audio/x-mpegurl;audio/x-mod;audio/x-matroska;audio/x-it;audio/x-gsm;audio/x-ape;audio/x-aiff;audio/x-adpcm;audio/webm;audio/vnd.wave;audio/vnd.wave;audio/vnd.rn-realaudio;audio/vnd.rn-realaudio;audio/vnd.dts.hd;audio/vnd.dts;audio/ogg;audio/mpeg;audio/mpeg;audio/mpeg;audio/mpeg;audio/mpeg;audio/mp4;audio/mp4;audio/mp4;audio/mp2;audio/mp2;audio/midi;audio/flac;audio/flac;audio/basic;audio/AMR-WB;audio/AMR;audio/ac3;audio/aac;audio/aac;application/xspf+xml;application/x-shorten;application/x-quicktime-media-link;application/x-quicktime-media-link;application/x-matroska;application/vnd.rn-realmedia;application/vnd.rn-realmedia;application/vnd.ms-wpl;application/vnd.ms-asf;application/vnd.ms-asf;application/vnd.ms-asf;application/vnd.ms-asf;application/vnd.efi.iso;application/vnd.apple.mpegurl;application/vnd.adobe.flash.movie;application/sdp;application/ram;application/ogg;application/ogg;application/mxf;
      Name[en_US]=VLC media player
      Name=VLC media player
      Name[af]=VLC-mediaspeler
      Name[am]=የ ቪኤልሲ መገናኛ ማጫወቻ
      Name[ar]=مشغل الوسائط VLC
      Name[as_IN]=VLC মিডিয়া প্লেয়াৰ
      Name[ast]=Reproductor multimedia VLC
      Name[az]=VLC media pleyeri
      Name[be]=Медыяпрайгравальнік VLC
      Name[bg]=Медиен плейър VLC
      Name[bn_BD]=VLC মিডিয়া প্লেয়ার
      Name[br]=VLC lenner mediaoù
      Name[ca]=Reproductor multimèdia VLC
      Name[co]=Lettore multimedia VLC
      Name[cs]=Multimediální přehrávač VLC
      Name[cy]=Chwaraeydd VLC
      Name[da]=VLC media player
      Name[de]=VLC Media Player
      Name[el]=Αναπαραγωγός πολυμέσων VLC
      Name[en_GB]=VLC media player
      Name[es]=Reproductor multimedia VLC
      Name[es_MX]=Reproductor multimedia VLC
      Name[et]=VLC meediaesitaja
      Name[eu]=VLC multimedia-erreproduzigailua
      Name[fi]=VLC-mediasoitin
      Name[fr]=Lecteur multimédia VLC
      Name[fy]=VLC media player
      Name[ga]=Seinnteoir meán VLC
      Name[gd]=Cluicheadair mheadhanan VLC
      Name[gl]=Reprodutor multimedia VLC
      Name[he]=נגן המדיה VLC
      Name[hi]=वीएलसी मीडिया प्लेयर
      Name[hu]=VLC médialejátszó
      Name[id]=Pemutar media VLC
      Name[ie]=Reproductor de media VLC
      Name[is]=VLC spilarinn
      Name[it]=Lettore multimediale VLC
      Name[ja]=VLCメディアプレイヤー
      Name[ka]=VLC მედიადამკვრელი
      Name[kab]=Imeɣri n umidya VLC
      Name[km]=កម្មវិធី​ចាក់​មេឌៀ VLC
      Name[ko]=VLC 미디어 플레이어
      Name[lt]=VLC leistuvė
      Name[lv]=VLC mediju atskaņotājs
      Name[ml]=VLC മീഡിയ പ്ലെയർ
      Name[mn]=VLC дамжуулга тоглуулагч
      Name[mr]=VLC मीडिया प्लेअर
      Name[ms]=Pemain media VLC
      Name[my]=VLC မီဒီယာ ပြစက်
      Name[nb]=VLC media player
      Name[ne]=VLC मिडिया प्लेयर
      Name[nl]=VLC media player
      Name[nn]=VLC mediespelar
      Name[oc]=Lector multimèdia VLC
      Name[pa]=VLC ਮੀਡਿਆ ਪਲੇਅਰ
      Name[pl]=VLC media player
      Name[pt_BR]=Reprodutor de Mídias VLC
      Name[pt_PT]=VLC media player
      Name[ro]=Redor media VLC
      Name[ru]=Медиаплеер VLC
      Name[sc]=Leghidore multimediale VLC
      Name[sk]=VLC media player
      Name[sl]=Predvajalnik VLC
      Name[sq]=VLC lexues media
      Name[sr]=ВЛЦ медијски плејер
      Name[sv]=VLC media player
      Name[te]=VLC మాధ్యమ ప్రదర్శకం
      Name[th]=โปรแกรมเล่นสื่อ VLC
      Name[tr]=VLC ortam oynatıcısı
      Name[uk]=Медіапрогравач VLC
      Name[vi]=Trình phát media VLC
      Name[wa]=Djouweu d' media VLC
      Name[zh_CN]=VLC 媒体播放器
      Name[zh_TW]=VLC 媒體播放器
      Path=
      StartupNotify=true
      Terminal=false
      TerminalOptions=
      TryExec=/nix/store/kd85dylgr1pj6h696qs553miaffhhp6n-vlc-3.0.21/bin/vlc
      Type=Application
      Version=1.0
      X-KDE-Protocols=ftp,http,https,mms,rtmp,rtsp,sftp,smb
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
  };
}
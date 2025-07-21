{ inputs, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../common
    ../../common/desktop
    ../../modules/common
    ../../modules/nixos

    inputs.nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
  ];

  # pin the latest nvidia driver that works because they are so awesome in releasing an update that broke opengl for my 1050ti
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "570.144";
    sha256_64bit = "sha256-wLjX7PLiC4N2dnS6uP7k0TI9xVWAJ02Ok0Y16JVfO+Y=";
    sha256_aarch64 = "sha256-6kk2NLeKvG88QH7/YIrDXW4sgl324ddlAyTybvb0BP0=";
    openSha256 = "sha256-PATw6u6JjybD2OodqbKrvKdkkCFQPMNPjrVYnAZhK/E=";
    settingsSha256 = "sha256-VcCa3P/v3tDRzDgaY+hLrQSwswvNhsm93anmOhUymvM=";
    persistencedSha256 = "sha256-hx4w4NkJ0kN7dkKDiSOsdJxj9+NZwRsZEuhqJ5Rq3nM=";
  };

  environment.systemPackages = with pkgs; [
    # necessary to make the camera not look like the sun
    cameractrls
    # for key replacement macros
    xautomation
  ];

  home-manager.users.wo2w =
  let
    ifHomeProgramEnable =
      name:
      if config.programs.${name}.enable then true else false;
  in {
    imports = [
      ../../modules/home
    ];

    home.file = {
      # yubikey config
      ".config/Yubico/u2f_keys".text = "wo2w:aKYaBOjCImRE58XcYJCqxpY0vABEIYWbk2Lvx4UqnN3M/A1uyr3boV4FZLkfxUwmlfBdMDm4caSaX1/SrNoNgw==,zruscj30G6zEt8xmlvTXBBEKIzg+fPCSq/FvhZO3X0HyP2uBLsWSXqCyRKXM8H9F/GJwJWBpyoHj/dhkxj7eZg==,es256,+presence";

      ".local/share/applications/kitty.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=kitty
        GenericName=Terminal emulator
        Comment=Fast, feature-rich, GPU based terminal
        TryExec=kitty
        StartupNotify=true
        Exec=kitty
        Icon=kitty
        Categories=System;TerminalEmulator;
        X-TerminalArgExec=--
        X-TerminalArgTitle=--title
        X-TerminalArgAppId=--class
        X-TerminalArgDir=--working-directory
        X-TerminalArgHold=--hold
      '';

      ".local/share/applications/librewolf.desktop".text = ''
        [Desktop Entry]
        Actions=new-private-window;new-window;profile-manager-window
        Categories=Network;WebBrowser
        Exec=nvidia-offload librewolf --name librewolf %U
        GenericName=Web Browser
        Icon=librewolf
        MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;x-scheme-handler/http;x-scheme-handler/https
        Name=LibreWolf
        StartupNotify=true
        StartupWMClass=librewolf
        Terminal=false
        Type=Application
        Version=1.4

        [Desktop Action new-private-window]
        Exec=nvidia-offload librewolf --private-window %U
        Name=New Private Window

        [Desktop Action new-window]
        Exec=nvidia-offload librewolf --new-window %U
        Name=New Window

        [Desktop Action profile-manager-window]
        Exec=nvidia-offload librewolf --ProfileManager
        Name=Profile Manager
      '';

      ".local/share/applications/steam.desktop".text = ''
        [Desktop Entry]
        Name=Steam
        Comment=Application for managing and playing games on Steam
        Comment[pt_BR]=Aplicativo para jogar e gerenciar jogos no Steam
        Comment[bg]=Приложение за ръководене и пускане на игри в Steam
        Comment[cs]=Aplikace pro spravování a hraní her ve službě Steam
        Comment[da]=Applikation til at håndtere og spille spil på Steam
        Comment[nl]=Applicatie voor het beheer en het spelen van games op Steam
        Comment[fi]=Steamin pelien hallintaan ja pelaamiseen tarkoitettu sovellus
        Comment[fr]=Application de gestion et d'utilisation des jeux sur Steam
        Comment[de]=Anwendung zum Verwalten und Spielen von Spielen auf Steam
        Comment[el]=Εφαρμογή διαχείρισης παιχνιδιών στο Steam
        Comment[hu]=Alkalmazás a Steames játékok futtatásához és kezeléséhez
        Comment[it]=Applicazione per la gestione e l'esecuzione di giochi su Steam
        Comment[ja]=Steam 上でゲームを管理＆プレイするためのアプリケーション
        Comment[ko]=Steam에 있는 게임을 관리하고 플레이할 수 있는 응용 프로그램
        Comment[no]=Program for å administrere og spille spill på Steam
        Comment[pt_PT]=Aplicação para organizar e executar jogos no Steam
        Comment[pl]=Aplikacja do zarządzania i uruchamiania gier na platformie Steam
        Comment[ro]=Aplicație pentru administrarea și jucatul jocurilor pe Steam
        Comment[ru]=Приложение для игр и управления играми в Steam
        Comment[es]=Aplicación para administrar y ejecutar juegos en Steam
        Comment[sv]=Ett program för att hantera samt spela spel på Steam
        Comment[zh_CN]=管理和进行 Steam 游戏的应用程序
        Comment[zh_TW]=管理並執行 Steam 遊戲的應用程式
        Comment[th]=โปรแกรมสำหรับจัดการและเล่นเกมบน Steam
        Comment[tr]=Steam üzerinden oyun oynama ve düzenleme uygulaması
        Comment[uk]=Програма для керування іграми та запуску ігор у Steam
        Comment[vi]=Ứng dụng để quản lý và chơi trò chơi trên Steam
        Exec=nvidia-offload steam %U
        Icon=steam
        Terminal=false
        Type=Application
        Categories=Network;FileTransfer;Game;
        MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
        Actions=Store;Community;Library;Servers;Screenshots;News;Settings;BigPicture;Friends;
        PrefersNonDefaultGPU=true
        X-KDE-RunOnDiscreteGpu=true

        [Desktop Action Store]
        Name=Store
        Name[pt_BR]=Loja
        Name[bg]=Магазин
        Name[cs]=Obchod
        Name[da]=Butik
        Name[nl]=Winkel
        Name[fi]=Kauppa
        Name[fr]=Magasin
        Name[de]=Shop
        Name[el]=ΚΑΤΑΣΤΗΜΑ
        Name[hu]=Áruház
        Name[it]=Negozio
        Name[ja]=ストア
        Name[ko]=상점
        Name[no]=Butikk
        Name[pt_PT]=Loja
        Name[pl]=Sklep
        Name[ro]=Magazin
        Name[ru]=Магазин
        Name[es]=Tienda
        Name[sv]=Butik
        Name[zh_CN]=商店
        Name[zh_TW]=商店
        Name[th]=ร้านค้า
        Name[tr]=Mağaza
        Name[uk]=Крамниця
        Name[vi]=Cửa hàng
        Exec=nvidia-offload steam steam://store

        [Desktop Action Community]
        Name=Community
        Name[pt_BR]=Comunidade
        Name[bg]=Общност
        Name[cs]=Komunita
        Name[da]=Fællesskab
        Name[nl]=Community
        Name[fi]=Yhteisö
        Name[fr]=Communauté
        Name[de]=Community
        Name[el]=Κοινότητα
        Name[hu]=Közösség
        Name[it]=Comunità
        Name[ja]=コミュニティ
        Name[ko]=커뮤니티
        Name[no]=Samfunn
        Name[pt_PT]=Comunidade
        Name[pl]=Społeczność
        Name[ro]=Comunitate
        Name[ru]=Сообщество
        Name[es]=Comunidad
        Name[sv]=Gemenskap
        Name[zh_CN]=社区
        Name[zh_TW]=社群
        Name[th]=ชุมชน
        Name[tr]=Topluluk
        Name[uk]=Спільнота
        Name[vi]=Cộng đồng
        Exec=nvidia-offload steam steam://url/SteamIDControlPage

        [Desktop Action Library]
        Name=Library
        Name[pt_BR]=Biblioteca
        Name[bg]=Библиотека
        Name[cs]=Knihovna
        Name[da]=Bibliotek
        Name[nl]=Bibliotheek
        Name[fi]=Kokoelma
        Name[fr]=Bibliothèque
        Name[de]=Bibliothek
        Name[el]=Συλλογή
        Name[hu]=Könyvtár
        Name[it]=Libreria
        Name[ja]=ライブラリ
        Name[ko]=라이브러리
        Name[no]=Bibliotek
        Name[pt_PT]=Biblioteca
        Name[pl]=Biblioteka
        Name[ro]=Colecţie
        Name[ru]=Библиотека
        Name[es]=Biblioteca
        Name[sv]=Bibliotek
        Name[zh_CN]=库
        Name[zh_TW]=收藏庫
        Name[th]=คลัง
        Name[tr]=Kütüphane
        Name[uk]=Бібліотека
        Name[vi]=Thư viện
        Exec=nvidia-offload steam steam://open/games

        [Desktop Action Servers]
        Name=Servers
        Name[pt_BR]=Servidores
        Name[bg]=Сървъри
        Name[cs]=Servery
        Name[da]=Servere
        Name[nl]=Servers
        Name[fi]=Palvelimet
        Name[fr]=Serveurs
        Name[de]=Server
        Name[el]=Διακομιστές
        Name[hu]=Szerverek
        Name[it]=Server
        Name[ja]=サーバー
        Name[ko]=서버
        Name[no]=Tjenere
        Name[pt_PT]=Servidores
        Name[pl]=Serwery
        Name[ro]=Servere
        Name[ru]=Серверы
        Name[es]=Servidores
        Name[sv]=Servrar
        Name[zh_CN]=服务器
        Name[zh_TW]=伺服器
        Name[th]=เซิร์ฟเวอร์
        Name[tr]=Sunucular
        Name[uk]=Сервери
        Name[vi]=Máy chủ
        Exec=nvidia-offload steam steam://open/servers

        [Desktop Action Screenshots]
        Name=Screenshots
        Name[pt_BR]=Capturas de tela
        Name[bg]=Снимки
        Name[cs]=Snímky obrazovky
        Name[da]=Skærmbilleder
        Name[nl]=Screenshots
        Name[fi]=Kuvankaappaukset
        Name[fr]=Captures d'écran
        Name[de]=Screenshots
        Name[el]=Φωτογραφίες
        Name[hu]=Képernyőmentések
        Name[it]=Screenshot
        Name[ja]=スクリーンショット
        Name[ko]=스크린샷
        Name[no]=Skjermbilder
        Name[pt_PT]=Capturas de ecrã
        Name[pl]=Zrzuty ekranu
        Name[ro]=Capturi de ecran
        Name[ru]=Скриншоты
        Name[es]=Capturas
        Name[sv]=Skärmdumpar
        Name[zh_CN]=截图
        Name[zh_TW]=螢幕擷圖
        Name[th]=ภาพหน้าจอ
        Name[tr]=Ekran Görüntüleri
        Name[uk]=Скріншоти
        Name[vi]=Ảnh chụp
        Exec=nvidia-offload steam steam://open/screenshots

        [Desktop Action News]
        Name=News
        Name[pt_BR]=Notícias
        Name[bg]=Новини
        Name[cs]=Zprávy
        Name[da]=Nyheder
        Name[nl]=Nieuws
        Name[fi]=Uutiset
        Name[fr]=Actualités
        Name[de]=Neuigkeiten
        Name[el]=Νέα
        Name[hu]=Hírek
        Name[it]=Notizie
        Name[ja]=ニュース
        Name[ko]=뉴스
        Name[no]=Nyheter
        Name[pt_PT]=Novidades
        Name[pl]=Aktualności
        Name[ro]=Știri
        Name[ru]=Новости
        Name[es]=Noticias
        Name[sv]=Nyheter
        Name[zh_CN]=新闻
        Name[zh_TW]=新聞
        Name[th]=ข่าวสาร
        Name[tr]=Haberler
        Name[uk]=Новини
        Name[vi]=Tin tức
        Exec=nvidia-offload steam steam://open/news

        [Desktop Action Settings]
        Name=Settings
        Name[pt_BR]=Configurações
        Name[bg]=Настройки
        Name[cs]=Nastavení
        Name[da]=Indstillinger
        Name[nl]=Instellingen
        Name[fi]=Asetukset
        Name[fr]=Paramètres
        Name[de]=Einstellungen
        Name[el]=Ρυθμίσεις
        Name[hu]=Beállítások
        Name[it]=Impostazioni
        Name[ja]=設定
        Name[ko]=설정
        Name[no]=Innstillinger
        Name[pt_PT]=Definições
        Name[pl]=Ustawienia
        Name[ro]=Setări
        Name[ru]=Настройки
        Name[es]=Parámetros
        Name[sv]=Inställningar
        Name[zh_CN]=设置
        Name[zh_TW]=設定
        Name[th]=การตั้งค่า
        Name[tr]=Ayarlar
        Name[uk]=Налаштування
        Name[vi]=Thiết lập
        Exec=nvidia-offload steam steam://open/settings

        [Desktop Action BigPicture]
        Name=Big Picture
        Exec=nvidia-offload steam steam://open/bigpicture

        [Desktop Action Friends]
        Name=Friends
        Name[pt_BR]=Amigos
        Name[bg]=Приятели
        Name[cs]=Přátelé
        Name[da]=Venner
        Name[nl]=Vrienden
        Name[fi]=Kaverit
        Name[fr]=Amis
        Name[de]=Freunde
        Name[el]=Φίλοι
        Name[hu]=Barátok
        Name[it]=Amici
        Name[ja]=フレンド
        Name[ko]=친구
        Name[no]=Venner
        Name[pt_PT]=Amigos
        Name[pl]=Znajomi
        Name[ro]=Prieteni
        Name[ru]=Друзья
        Name[es]=Amigos
        Name[sv]=Vänner
        Name[zh_CN]=好友
        Name[zh_TW]=好友
        Name[th]=เพื่อน
        Name[tr]=Arkadaşlar
        Name[uk]=Друзі
        Name[vi]=Bạn bè
        Exec=nvidia-offload steam steam://open/friends
      '';

      ".local/applications/vesktop.desktop".text = ''
        [Desktop Entry]
        Categories=Network;InstantMessaging;Chat
        Comment[en_US]=
        Comment=
        Exec=nvidia-offload vesktop %U
        GenericName[en_US]=Internet Messenger
        GenericName=Internet Messenger
        Icon=vesktop
        Keywords=discord;vencord;electron;chat
        Name[en_US]=Vesktop
        Name=Vesktop
        Path=
        StartupNotify=true
        StartupWMClass=Vesktop
        Terminal=false
        TerminalOptions=
        Type=Application
        Version=1.4
        X-KDE-SubstituteUID=false
        X-KDE-Username=
        MimeType=x-scheme-handler/discord;
      '';

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

    home.stateVersion = "25.05";
  };

  system.stateVersion = "24.11";
}
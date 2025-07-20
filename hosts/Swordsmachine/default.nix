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
      ".local/share/applications/kitty.desktop" = {
        enable = ifHomeProgramEnable "kitty";
        text = ''
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
      };

      ".local/share/applications/librewolf.desktop" = {
        enable = ifHomeProgramEnable "librewolf";
        text = ''
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
      };

      ".local/share/applications/steam.desktop" = {
        enable = true;
        text = ''
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
      };

      ".local/applications/vesktop.desktop" = {
        enable = ifHomeProgramEnable "vesktop";
        text = ''
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
      };
    };

    home.stateVersion = "25.05";
  };

  system.stateVersion = "24.11";
}
{ config, ... }:

{
  programs.vesktop = {
    enable = true;
    vencord.settings = {
      themeLinks = [ "https://raw.githubusercontent.com/refact0r/system24/refs/heads/main/theme/flavors/system24-tokyo-night.theme.css" ];
      enabledThemes = [ "system24-tokyo-night.theme.css" ];
      plugins = {
        ChatInputButtonAPI.enabled = true;
        CommandsAPI.enabled = true;
        DynamicImageModalAPI.enabled = true;
        MessageAccessoriesAPI.enabled = true;
        MessageEventsAPI.enabled = true;
        MessagePopoverAPI.enabled = true;
        MessageUpdaterAPI.enabled = true;
        UserSettingsAPI.enabled = true;
        BetterGifPicker.enabled = true;
        BetterUploadButton.enabled = true;
        BiggerStreamPreview.enabled = true;
        CallTimer = {
          enabled = true;
          format = "stopwatch";
        };
        ClearURLs.enabled = true;
        CopyFileContents.enabled = true;
        CrashHandler.enabled = true;
        Experiments = {
          enabled = true;
          toolbarDevMenu = false;
        };
        FakeNitro = {
          enabled = true;
            enableStickerBypass = true;
            enableStreamQualityBypass = true;
            enableEmojiBypass = true;
            transformEmojis = true;
            transformStickers = true;
            transformCompoundSentence = false;
            stickerSize = 160;
            hyperLinkText = "{{NAME}}";
            useHyperLinks = true;
            disableEmbedPermissionCheck = false;
            emojiSize = 48;
        };
        FixYoutubeEmbeds.enabled = true;
        MessageLogger = {
          enabled = true;
          collapseDeleted = false;
          deleteStyle = "overlay";
          ignoreBots = false;
          ignoreSelf = false;
          ignoreUsers = "";
          ignoreChannels = "";
          ignoreGuilds = "";
          logEdits = true;
          logDeletes = true;
          inlineEdits = true;
        };
        OpenInApp = {
          enabled = true;
          spotify = false;
          steam = true;
          epic = false;
          tidal = false;
          itunes = false;
        };
        PreviewMessage.enabled = true;
        RelationshipNotifier = {
          enabled = true;
          notices = true;
          offlineRemovals = true;
          friends = true;
          friendRequestCancels = true;
          servers = true;
          groups = true;
        };
        ReplaceGoogleSearch = {
          enabled = true;
          customEngineName = "DuckDuckGo";
          customEngineURL = "https://duckduckgo.com/&q=";
        };
        ReverseImageSearch.enabled = true;
        ServerInfo.enabled = true;
        ShowHiddenChannels = {
          enabled = true;
          showMode = 0;
          hideUnreads = true;
          defaultAllowedUsersAndRolesDropdownState = true;
        };
        SpotifyCrack = {
          enabled = true;
          noSpotifyAutoPause = true;
          keepSpotifyActivityOnIdle = false;
        };
        Translate = {
          enabled = true;
          showChatBarButton = true;
          service = "google";
          deeplApiKey = "";
          autoTranslate = false;
          showAutoTranslateTooltip = true;
        };
        ValidReply.enabled = true;
        ValidUser.enabled = true;
        VoiceDownload.enabled = true;
        VoiceMessages.enabled = true;
        VolumeBooster = {
          enabled = true;
          multiplier = 5;
        };
        WebKeybinds.enabled = true;
        WebScreenShareFixes.enabled = true;
        YoutubeAdblock.enabled = true;
        BadgeAPI.enabled = true;
        NoTrack = {
          enabled = true;
          disableAnalytics = true;
        };
        WebContextMenus = {
          enabled = true;
          addBack = true;
        };
        Settings = {
          enabled = true;
          settingsLocation = "aboveNitro";
        };
        SupportHelper.enabled = true;
        DisableDeepLinks.enabled = true;
      };
    };
  };
}
{ ... }:

{
  services.flameshot = {
    enable = true;
    settings.General = {
      buttons = ''@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\xe\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x5\0\0\0\x6\0\0\0\x12\0\0\0\xf\0\0\0\x13\0\0\0\b\0\0\0\n\0\0\0\v\0\0\0\x17\0\0\0\xe)'';
      startupLaunch = true;
      showDesktopNotification = false;
      showStartupLaunchMessage = false;
      userColors = "picker, #FF0000, #E700FF, #05AFFF, #00FF00";
      disabledGrimWarning = true;
      useGrimAdapter = true;
    };
  };
}

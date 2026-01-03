{ inputs, ... }:

{
  imports = [ inputs.zen-browser.homeModules.beta ];

  programs.zen-browser = {
    enable = true;

    policies =
      let
        mkExtensionSettings = builtins.mapAttrs (
          _: pluginId: {
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${pluginId}/latest.xpi";
            installation_mode = "force_installed";
          }
        );
      in
      {
        ExtensionSettings = mkExtensionSettings {
          "{446900e4-71c2-419f-a6a7-df9c091e268b}" = "bitwarden-password-manager";
          "addon@darkreader.org" = "darkreader";
          "sponsorBlocker@ajay.app" = "sponsorblock";
          "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = "styl-us";
          "{036a55b4-5e72-4d05-a06c-cba2dfcc134a}" = "traduzir-paginas-web";
          "uBlock0@raymondhill.net" = "ublock-origin";
          "{aecec67f-0d10-4fa7-b7c7-609a2db280cf}" = "violentmonkey";
          "wappalyzer@crunchlabz.com" = "wappalyzer";
          "{cf3dba12-a848-4f68-8e2d-f9fadc0721de}" = "google-lighthouse";
        };

        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        OfferToSaveLogins = false;

        Preferences = {
          "browser.aboutConfig.showWarning" = false;
          "widget.use-xdg-desktop-portal.file-picker" = 1;
        };
      };

    profiles.default = {
      isDefault = true;
      userChrome = ''
        .zen-current-workspace-indicator { display: none !important; }
      '';

      containersForce = false;
      spacesForce = true;
      spaces = {
        main = {
          id = "{e2954c5d-e2ab-483d-8917-bf0d2e3089f1}";
          icon = "chrome://browser/skin/zen-icons/selectable/circle.svg";
          theme.opacity = 1.0;
          theme.colors = [
            {
              red = 32;
              green = 42;
              blue = 70;
            }
            {
              red = 73;
              green = 26;
              blue = 75;
            }
          ];
          position = 1000;
        };
        dev = {
          id = "{7b74381d-17da-40e4-9c06-cb07aabab837}";
          icon = "chrome://browser/skin/zen-icons/selectable/code.svg";
          position = 2000;
        };
      };

      pinsForce = true;
      pins = {
        gmail = {
          id = "{12fca17c-d0c1-424e-9fed-63cf5baf7000}";
          url = "https://mail.google.com/mail/u/0/#inbox";
          isEssential = true;
          position = 1000;
        };
        bsky = {
          id = "{e17ce84f-5c52-49a4-9d29-a1dc9d51c485}";
          url = "https://bsky.app/";
          isEssential = true;
          position = 2000;
        };
        calendar = {
          id = "{9b175da2-3a0e-4b84-ae19-8fa10158d4bb}";
          url = "https://calendar.google.com/calendar/u/0/r?pli=1";
          isEssential = true;
          position = 3000;
        };
        spotify = {
          id = "{b6ad7e46-5a39-44d5-965d-cfd344e9ad20}";
          url = "https://open.spotify.com/";
          isEssential = true;
          position = 4000;
        };
        messages = {
          id = "{f53f53f5-3f53-f53f-53f5-3f53f53f53f5}";
          url = "https://messages.google.com/web/conversations";
          isEssential = true;
          position = 5000;
        };
        keep = {
          id = "{d088645b-617b-47e0-8faf-cbdc689872d8}";
          url = "https://keep.google.com/";
          isEssential = true;
          position = 6000;
        };
      };

      search = {
        default = "unduck";
        engines.unduck = {
          name = "unduck";
          urls = [
            {
              template = "https://unduck.link";
              params = [
                {
                  name = "q";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
        };
        force = true;
      };
    };
  };
}

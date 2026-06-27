require "hyprconf/appearance"
require "hyprconf/environmentVariables"
require "hyprconf/keybinds"
require "hyprconf/windowRules"

local hostname <const> = os.getenv("HOSTNAME")
if hostname then require("host/" .. hostname) end

hl.config {
    master = { new_status = "master" },
}

; (function()
    for _, name in pairs({
        "logitech-g-pro--1",
        "logitech-g-pro-wireless-gaming-mouse",
    }) do hl.device({ name = name, sensitivity = -0.8 }) end

    -- TODO: -0.1 for cassietop's trackpad
end)()

hl.on("hyprland.start", function()
    for _, cmd in pairs({
        "hyprpaper",
        "wl-paste --watch cliphist store",
        "quickshell -d -n",
        "hyprwhspr-rs",
    }) do hl.exec_cmd(cmd) end
end)

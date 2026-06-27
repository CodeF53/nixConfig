hl.monitor {
    output = "HDMI-A-1",
    mode = "highres",
    position = "0x0",
    bitdepth = 10,
}
hl.monitor {
    output = "DP-3",
    mode = "highres",
    position = "auto-down",
    bitdepth = 10,
}

-- touching screenpad should have cursor on screenpad
hl.device {
    name = "elan9009:00-04f3:2c23",
    output = "DP-3",
}

-- todo: add ` silent` to monitor rules after this gets closed https://github.com/hyprwm/Hyprland/discussions/15246
hl.on("hyprland.start", function()
    hl.exec_cmd("kitty -e btop", {
        monitor = "1",
        workspace = "r~1 silent",
    })
    hl.exec_cmd("discord", {
        monitor = "1",
        workspace = "r~1 silent",
    })
end)

hl.monitor {
    output = "HDMI-A-1",
    mode = "1920x1080@60",
    position = "0x0",
}
hl.monitor {
    output = "DP-1",
    mode = "1920x1080@100",
    position = "1920x0",
}
hl.monitor {
    output = "DP-3",
    mode = "1920x1080@60",
    position = "3840x0",
}

-- todo: add ` silent` to monitor rules after this gets closed https://github.com/hyprwm/Hyprland/discussions/15246
hl.on("hyprland.start", function()
    hl.exec_cmd("kitty -e btop", {
        monitor = "0",
        workspace = "r~1 silent",
    })
    hl.exec_cmd("discord", {
        monitor = "2",
        workspace = "r~1 silent",
    })
end)

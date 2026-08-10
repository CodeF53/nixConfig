hl.monitor {
    output = "desc:Dell Inc. DELL S2415H 5J1MP7135P4L",
    mode = "1920x1080@60",
    position = "-1080x0",
    transform = 1,
}
hl.monitor {
    output = "desc:Dell Inc. AW2725Q 29Q05B4",
    mode = "3840x2160@239.99",
    position = "0x320",
    scale = 2,
    bitdepth = 10,
    -- automatically switches to HDR when HDR content is fullscreen
}
hl.monitor {
    output = "desc:Xiaomi Corporation P24FBA-RAGL 5438720001679",
    mode = "1920x1080@100",
    position = "1920x0",
    transform = 3,
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

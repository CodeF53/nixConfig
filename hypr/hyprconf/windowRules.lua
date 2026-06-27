hl.window_rule {
    name = "zenpip",
    match = {
        class = "^(zen-beta)$",
        title = "^(Picture-in-Picture)$",
    },
    float = true,
    pin = true,
    size = { 400, 225 },
}

hl.window_rule {
    name = "zenfocus",
    match = { class = "^(zen-beta)$" },
    focus_on_activate = true,
}

hl.window_rule {
    name = "flameshot",
    match = { title = "flameshot" },

    no_anim = true,
    float = true,
    pin = true,
    move = { 0, 0 },
    no_initial_focus = true,
    monitor = 0, -- change to "0 silent" when https://github.com/hyprwm/Hyprland/discussions/15246 is closed
}

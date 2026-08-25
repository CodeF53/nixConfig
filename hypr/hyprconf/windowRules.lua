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

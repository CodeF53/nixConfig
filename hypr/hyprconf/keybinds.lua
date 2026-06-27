hl.bind("SUPER + Q", hl.dsp.exec_cmd "kitty")
hl.bind("SUPER + C", hl.dsp.window.kill())
hl.bind("SUPER + M", hl.dsp.exit())
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd "XDG_CURRENT_DESKTOP=sway flameshot gui")
hl.bind("SUPER + SHIFT + F", hl.dsp.window.float({ mode = "toggle" }))
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("SUPER + V", hl.dsp.global("quickshell:clipboardHistory"))
-- hacky fix for global dispatch not working `hl.bind("SUPER + SUPER_L", hl.dsp.global("quickshell:launcher"), { release = true })`
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd([[hyprctl dispatch "hl.dsp.global(\"quickshell:launcher\")"]]), { release = true })
-- prevent `r` from being spammed into textbox while holding my hyprwhspr bind (super+r)
hl.bind("SUPER + R", hl.dsp.exec_cmd("cat :3"), { release = true })

hl.bind("SUPER + left", hl.dsp.focus { direction = "l" })
hl.bind("SUPER + right", hl.dsp.focus { direction = "r" })
hl.bind("SUPER + up", hl.dsp.focus { direction = "u" })
hl.bind("SUPER + down", hl.dsp.focus { direction = "d" })

for i = 1, 9 do
    hl.bind("SUPER + " .. i, hl.dsp.focus { workspace = "r~" .. i, on_current_monitor = true })
    hl.bind("SUPER + SHIFT + " .. i, hl.dsp.window.move { workspace = "r~" .. i })
end
for i = 1, 3 do hl.bind("SUPER + ALT + " .. i, hl.dsp.window.move { monitor = i }) end

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { repeating = true, locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { repeating = true, locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%+", { repeating = true, locked = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%-", { repeating = true, locked = true })

hl.bind("code:248", hl.dsp.exec_cmd "toggle_screenpad", { locked = true })

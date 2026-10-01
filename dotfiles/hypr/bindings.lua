-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Shortcuts for preinstalled apps I've removed (see packages/remove.txt and webapps-remove.txt)
hl.unbind("SUPER + SHIFT + P")          -- Google Photos
hl.unbind("SUPER + SHIFT + CTRL + G")   -- Google Messages
hl.unbind("SUPER + SHIFT + ALT + G")    -- WhatsApp
hl.unbind("SUPER + SHIFT + X")          -- X
hl.unbind("SUPER + SHIFT + ALT + X")    -- X Post
hl.unbind("SUPER + SHIFT + Y")          -- YouTube
hl.unbind("SUPER + SHIFT + E")          -- HEY email
hl.unbind("SUPER + SHIFT + ALT + E")    -- HEY new email
hl.unbind("SUPER + SHIFT + C")          -- HEY calendar
hl.unbind("SUPER + SHIFT + A")          -- ChatGPT
hl.unbind("SUPER + SHIFT + ALT + A")    -- Grok
hl.unbind("SUPER + SHIFT + O")          -- Obsidian

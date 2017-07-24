local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")

-- Handle startup errors that resulted in config fallback
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Startup Error",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Runtime Error",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Keys
modkey = "Mod4"

-- Variables
terminal = "termite"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Theme
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Autostart
local function run_once(cmd)
   findme = cmd
   firstspace = cmd:find(" ")
   if firstspace then
      findme = cmd:sub(0, firstspace -1)
   end
   awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

run_once("nm-applet")
run_once("volumeicon")
run_once("cbatticon")

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
      awful.layout.suit.tile,
      awful.layout.suit.spiral,
      awful.layout.suit.max,
      awful.layout.suit.floating,
   }

-- Menu
menubar.utils.terminal = terminal

launcher = awful.widget.launcher({ image = beautiful.awesome_icon,
      menu = awful.menu({
            items = {
               {
                  "System", {
                     { "Suspend", function () awful.spawn("systemctl suspend") end },
                     { "Hibernate", function () awful.spawn("systemctl hibernate") end },
                     { "Reboot", function () awful.spawn("systemctl reboot") end },
                     { "Poweroff", function () awful.spawn("systemctl poweroff") end }
                  }
               },
               {
                  "Awesome", {
                     { "Hotkeys", function () return false, hotkeys_popup.show_help end },
                     { "Gtk3 Config", "lxappearance" },
                     { "Restart", awesome.restart },
                     { "Quit", function () awesome.quit() end }
                  }
               },
               { "Terminal", terminal },
               { "Browser", "google-chrome-stable" },
               { "Passwords", "keepass" }
            }
         })
   })

-- Wibar
local taglist_buttons = gears.table.join(
      awful.button({ }, 1, function (t) t:view_only() end),
      awful.button({ modkey }, 1,
         function (t)
            if client.focus then
               client.focus:toggle_tag(t)
            end
         end)
   )

local tasklist_buttons = gears.table.join(
      awful.button({ }, 1,
         function (c)
            if c == client.focus then
               c.minimized = true
            else
               c.minimized = false
               if not c:isvisible() and c.first_tag then
                  c.first_tag:view_only()
               end
               client.focus = c
               c:raise()
            end
         end)
   )


-- Create clock and calendar popup
textclock = wibox.widget.textclock("%F %H:%M")
calendar_popup = awful.widget.calendar_popup.month()
calendar_popup:attach(textclock)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Setup each screen
awful.screen.connect_for_each_screen(function (s)
   -- Wallpaper
   -- set_wallpaper(s)

   -- Separator
   s.separator = wibox.widget.textbox(" ")

   -- Each screen has it's own tag table
   awful.tag({ "main" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.promptbox = awful.widget.prompt()

    -- Create a layoutbox per screen.
   s.layoutbox = awful.widget.layoutbox(s)
   s.layoutbox:buttons(gears.table.join(
      awful.button({ }, 1, function () awful.layout.inc(1) end),
      awful.button({ }, 3, function () awful.layout.inc(-1) end)
   ))

   -- Create a taglist widget
   s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

   -- Create a tasklist widget
   s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

   -- Create the wibox
   s.wibox = awful.wibar({ position = "top", screen = s })
   s.wibox:setup {
      layout = wibox.layout.align.horizontal,
      {
         -- Left widgets
         layout = wibox.layout.fixed.horizontal,
         launcher,
         s.separator,
         -- s.taglist,
         -- s.separator,
         s.promptbox,
         s.separator
      },
      -- Middle widgets
      s.tasklist,
      {
         -- Right widgets
         layout = wibox.layout.fixed.horizontal,
         s.separator,
         wibox.widget.systray(),
         s.separator,
         textclock,
         s.separator,
         s.layoutbox
      },
   }
end)

-- Mouse bindings
local client_buttons = gears.table.join(
       awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
       awful.button({ modkey }, 1, awful.mouse.client.move),
       awful.button({ modkey }, 3, awful.mouse.client.resize)
    )

-- Key bindings
local global_keys = gears.table.join(
      -- launch programs
      awful.key({ modkey }, "r", function () awful.screen.focused().promptbox:run() end,
                {description = "run prompt", group = "awesome: launcher"}),
       awful.key({ modkey }, "Return", function () awful.spawn(terminal) end,
                 { description = "open a terminal", group = "launcher" }),
      -- focus windows
      awful.key({ modkey }, "h", function () awful.client.focus.bydirection("left") end,
                { description = "Focus the window the the left", group = "awesome: focus" }),
      awful.key({ modkey }, "j", function () awful.client.focus.bydirection("down") end,
                { description = "Focus the window the the down", group = "awesome: focus" }),
      awful.key({ modkey }, "k", function () awful.client.focus.bydirection("up") end,
                { description = "Focus the window the the up", group = "awesome: focus" }),
      awful.key({ modkey }, "l", function () awful.client.focus.bydirection("right") end,
                { description = "Focus the window the the right", group = "awesome: focus" }),
      -- move windows
      awful.key({ modkey, "Shift" }, "h", function () awful.client.swap.bydirection("left") end,
                { description = "Swap with window to the left", group = "awesome: layout" }),
      awful.key({ modkey, "Shift" }, "j", function () awful.client.swap.bydirection("down") end,
                { description = "Swap with window below", group = "awesome: layout" }),
      awful.key({ modkey, "Shift" }, "k", function () awful.client.swap.bydirection("up") end,
                { description = "Swap with window above", group = "awesome: layout" }),
      awful.key({ modkey, "Shift" }, "l", function () awful.client.swap.bydirection("right") end,
                { description = "Swap with window to the right", group = "awesome: layout" })
   )

root.keys(global_keys)

local client_keys = gears.table.join(
      -- window control
      awful.key(
         { modkey }, "f",
         function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
         end,
         { description = "Toggle fullscreen", group = "awesome: client" }),
      awful.key(
         { modkey }, "c", function (c) c:kill() end,
         { description = "Close window", group = "awesome: client" }),
      awful.key(
         { modkey }, "space", awful.client.floating.toggle,
         { description = "Toggle floating", group = "awesome: client" }),
      awful.key(
         { modkey }, "m",
         function (c)
            c.maximized = not c.maximized
            c:raise()
         end,
         { description = "(un)Maximize", group = "awesome: client" }),
      awful.key(
         { modkey }, "n",
         function (c)
            c.minimized = true
         end,
         { description = "Minimize", group = "awesome: client" }),
      awful.key(
         { modkey }, "v",
         function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
         end,
         { description = "Vertically (un)maximize", group = "awesome: client" })
   )

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
   -- All clients will match this rule.
   {
      rule = { },
      properties = {
         border_width = beautiful.border_width,
         border_color = beautiful.border_normal,
         focus = awful.client.focus.filter,
         raise = true,
         keys = client_keys,
         buttons = client_buttons,
         screen = awful.screen.preferred,
         placement = awful.placement.no_overlap+awful.placement.no_offscreen
      }
   },

   -- Floating clients.
   -- {
   --    rule_any = { },
   --    properties = { floating = true }
   -- },

   -- Add titlebars to normal clients and dialogs
   -- {
   --    rule_any = { },
   --    properties = { titlebars_enabled = false }
   -- },

   -- Set Firefox to always map on the tag named "2" on screen 1.
   -- {
   --    rule = { class = "Firefox" },
   --    properties = { screen = 1, tag = "2" }
   -- },
}

-- Prevent clients from being unreachable after screen count changes.
client.connect_signal("manage", function (c)
    if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function (c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function ()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function ()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function (c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function (c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function (c) c.border_color = beautiful.border_normal end)

-- Standard awesome library
require("awful")
require("awful.autofocus")
require("awful.rules")
require("awful.widget.progressbar")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")
require("calendar")

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
theme_path = "/home/sdoerner/.config/awesome/theme.lua"

-- Actually load theme
beautiful.init(theme_path)

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = "vim"
editor_cmd = terminal .. " -e " .. editor
filemanager = "pcmanfm"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating
}
-- }}}

-- {{{ Tags
-- Define tags table.
tags = {}
tagKeys = { 1, 2, 3, 'q', 'w', 'e', 'a', 's', 'd' } -- also used later for keyBinding
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag(tagKeys, s, layouts[1])
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
networkmenu =
{
  { "Firefox", "firefox", "/usr/lib/mozilla-firefox/chrome/icons/default/default16.png" },
  { "Thunderbird", "thunderbird", "/usr/share/pixmaps/thunderbird-icon.png" },
  { "Kopete", "kopete", "/usr/share/icons/hicolor/16x16/apps/kopete.png" },
  { "VNC Viewer", "vncviewer", "/usr/share/pixmaps/vncviewer.png" }
}

officemenu =
{
  { "OO Writer", "lowriter", "/usr/share/icons/hicolor/16x16/apps/libreoffice-writer.png" },
  { "OO Calc", "localc", "/usr/share/icons/hicolor/16x16/apps/libreoffice-calc.png" },
  { "OO Impress", "loimpress", "/usr/share/icons/hicolor/16x16/apps/libreoffice-impress.png" },
  { "OO Base", "lobase", "/usr/share/icons/hicolor/16x16/apps/libreoffice-base.png" },
  { "OO Math", "lomath", "/usr/share/icons/hicolor/16x16/apps/libreoffice-math.png" },
  { "Maple 11", "env WINEPREFIX='/home/sdoerner/.wine' wine 'C:\\Programme\\Maple 11\\bin.win\\maplew.exe'" }
}

graphicsmenu =
{
  { "Gwenview", "gwenview", "/usr/share/icons/hicolor/16x16/apps/gwenview.png" },
  { "GIMP", "gimp", "/usr/share/icons/hicolor/16x16/apps/gimp.png" },
  { "OO Draw", "oodraw", "/usr/share/pixmaps/ooo-draw.png" },
  { "Okular", "okular", "/usr/share/icons/hicolor/16x16/apps/okular.png" },
}

multimediamenu =
{
  { "Amarok", "amarok", "/usr/share/icons/hicolor/16x16/apps/amarok.png" },
  { "VLC", "vlc", "/usr/share/icons/hicolor/16x16/apps/vlc.png" },
  { "KSnapShot", "ksnapshot", "/usr/share/icons/hicolor/16x16/apps/ksnapshot.png" },
}

awesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

mainmenu = awful.menu.new( { items = {
    { "Grafik", graphicsmenu, "/usr/share/icons/gnome/16x16/categories/applications-graphics.png" },
    { "Multimedia", multimediamenu , "/usr/share/icons/hicolor/16x16/apps/amarok.png" },
    { "Netzwerk", networkmenu,"/usr/share/icons/gnome/16x16/categories/applications-internet.png" },
    { "Office", officemenu},
    { "Eclipse", "eclipse-3.5 -nosplash","/usr/lib/eclipse-3.5/icon.xpm" },
    { "awesome", awesomemenu, beautiful.awesome_icon },
    { "Kcalc", "kcalc" , "/usr/share/icons/oxygen/22x22/apps/accessories-calculator.png" },
    { "Files", filemanager },
    { "open terminal", terminal }
    } })

-- }}}

-- {{{ Wibox
-- create a battery box
mybatterybox = widget({ type = "textbox" })

-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" })
mytextclock:add_signal("mouse::enter", function() calendar.add(0) end)
mytextclock:add_signal("mouse::leave", calendar.remove)

mylauncher = awful.widget.launcher({ image = image(beautiful.awesome_icon),
                                     menu = mainmenu })

-- Create a systray
mysystray = widget({ type = "systray" })

-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                      awful.button({ }, 1, awful.tag.viewonly),
                      awful.button({ modkey }, 1, awful.client.movetotag),
                      awful.button({ }, 3, awful.tag.viewtoggle),
                      awful.button({ modkey }, 3, awful.client.toggletag),
                      awful.button({ }, 4, awful.tag.viewnext),
                      awful.button({ }, 5, awful.tag.viewprev)
                      )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                      awful.button({ }, 1, function (c)
                                          if not c:isvisible() then
                                              awful.tag.viewonly(c:tags()[1])
                                          end
                                          client.focus = c
                                          c:raise()
                                      end),
                       awful.button({ }, 3, function ()
                                              if instance then
                                                instance:hide()
                                              end
                                              instance = awful.menu.clients({ width=250 }) end),
                       awful.button({ }, 4, function ()
                                          awful.client.focus.byidx(1)
                                          if client.focus then client.focus:raise() end
                                      end),
                       awful.button({ }, 5, function ()
                                          awful.client.focus.byidx(-1)
                                          if client.focus then client.focus:raise() end
                                      end)
                      )
volumewidget = awful.widget.progressbar()
  volumewidget:set_width(25)
  volumewidget:set_height(10)
  volumewidget:set_vertical(false)
  volumewidget:set_background_color('black')
  volumewidget:set_color('#ffff00ff')
  volumewidget:set_max_value(100)
  volumewidget:set_value(50)

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
               awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
               awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
               awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
               awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)
              ))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                            return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Create a table with widgets that go to the right
    right_aligned = {
      layout = awful.widget.layout.horizontal.rightleft
    }
    table.insert(right_aligned, mytextclock)
    if s == 1 then table.insert(right_aligned, mysystray) end
    if  s == 1 then table.insert(right_aligned, mybatterybox) end
    if  s == 1 then table.insert(right_aligned, volumewidget.widget) end
    table.insert(right_aligned, mylayoutbox[s])

    -- Add widgets to the wibox - order matters
    mywibox[s].widgets =
    {
      mylauncher,
      mytaglist[s],
      mypromptbox[s],
      right_aligned,
      mytasklist[s],
      layout = awful.widget.layout.horizontal.leftright,
      height = mywibox[s].height
    }
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({}, "XF86PowerOff", function ()
               awful.util.spawn("sudo /sbin/halt")
               end),
    awful.key({}, "XF86Launch1", function ()
               awful.util.spawn("sudo /usr/local/sbin/backlight.sh toggle")
               end),
    awful.key({}, "XF86MonBrightnessDown", function ()
               awful.util.spawn("sudo /usr/local/sbin/backlight.sh down")
               end),
    awful.key({}, "XF86MonBrightnessUp", function ()
               awful.util.spawn("sudo /usr/local/sbin/backlight.sh up")
               end),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    --awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    -- Prompt
    awful.key({ modkey }, "r", function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
        function ()
            awful.prompt.run({ prompt = "Run Lua code: " },
            mypromptbox[mouse.screen].widget,
            awful.util.eval, nil,
            awful.util.getdir("cache") .. "/history_eval")
        end),
    --Dynamic tagging
    --[[
       [awful.key({ modkey, "Shift" }, "n", --move
       [  function() awful.tag.move(awful.tag.getidx() - 1) end),
       [awful.key({ modkey, "Shift" }, "m",
       [  function() awful.tag.move(awful.tag.getidx() + 1) end),
       [awful.key({ modkey,           }, "i", function() --add
       [    local scr = mouse.screen
       [    prefix = #screen[scr]:tags() + 1 .. ":"
       [    awful.prompt.run(
       [        {text = prefix},
       [        mypromptbox[mouse.screen].widget,
       [        function(name)
       [            if name == nil or #name == 0 then return end;
       [            awful.tag.viewonly(
       [                awful.tag.add(name,
       [                {screen = mouse.screen,
       [                layout = awful.layout.suit.tile,
       [                mwfact = 0.55}))
       [        end)
       [    end),
       [awful.key({ modkey, "Shift" }, "o", function() --delete
       [  local t = awful.tag.selected(1)
       [  for _,v in ipairs(tags[1]) do
       [    if v == t then
       [    -- don't allow deletion of standard tags, as this destroys the key mappings
       [      return
       [    end
       [  end
       [  awful.tag.delete(t, tags[1][1])
       [end),
       [awful.key({ modkey,           }, "b", function() --rename
       [    local tag = awful.tag.selected(1)
       [    local prefix = tag.name
       [    awful.prompt.run(
       [        {text = prefix},
       [        mypromptbox[mouse.screen].widget,
       [        function(name)
       [            if name == nil or #name == 0 then return end;
       [            tag.name = name
       [        end)
       [    end),
       ]]
    --My Bindings
    awful.key({ modkey }, "F12", function () awful.util.spawn("slock") end),
    awful.key({ modkey, "Shift" }, "f", function () awful.util.spawn("firefox") end),
    awful.key({ modkey, "Shift" }, "x", function () awful.util.spawn("chromium") end),
    awful.key({ modkey, "Shift" }, "t", function () awful.util.spawn("thunderbird") end),
    --awful.key({ modkey, "Shift" }, "a", function () awful.util.spawn("amarok") end),
    awful.key({ modkey, "Shift" }, "i", function () awful.util.spawn("kopete") end),
    --awful.key({ modkey, "Shift" }, "e", function () awful.util.spawn("eclipse-3.5 -nosplash") end),
    awful.key({ modkey, "Shift" }, "o", function () awful.util.spawn("oowriter") end),
    awful.key({ modkey, "Shift" }, "b", function () awful.util.spawn(filemanager) end),
  awful.key({} ,"XF86AudioLowerVolume", function()
  awful.util.spawn("amixer -c 0 set Master 5%-")
  get_vol()
  end),
  awful.key({} ,"XF86AudioRaiseVolume", function()
  awful.util.spawn("amixer -c 0 set Master 5%+")
  get_vol()
  end)
)

-- Client awful tagging: this is useful to tag some clients and then do stuff like move to tag on them
clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = not c.minimized    end),
    awful.key({ modkey }, "t", awful.client.togglemarked),
    awful.key({ modkey }, "F10",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
        end),
    awful.key({ modkey }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, tagKeys[i],
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, tagKeys[i],
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, tagKeys[i],
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, tagKeys[i],
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

-- Set keys
root.keys(globalkeys)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))
-- }}}

-- {{{ Rules
awful.rules.rules =  {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
  { rule =
    { class = "Plasma" },
    properties = { floating = true } },
  { rule =
    { class = "URxvt" },
    properties = { tag=tags[1][1], switchtotag = true, size_hints_honor = false } },
  { rule =
    { class = "Gitk" },
    properties = { maximized_horizontal = true, maximized_vertical = true } },
  { rule =
    { class = "Pcmanfm" },
    properties = { tag=tags[1][3], switchtotag = true } },
  { rule =
    { class = "Konversation" },
    properties = { tag=tags[1][8]} },
  { rule =
    { class = "Quasselclient" },
    properties = { tag=tags[1][8]} },
  { rule =
    { name = "Ordnererstellung" },
    properties = { floating = true, tag=tags[1][3], switchtotag = true } },
  { rule =
    { name = "Verschiebevorgang" },
    properties = { floating = true, tag=tags[1][3], switchtotag = true } },
  { rule =
    { name = "Kopiervorgang" },
    properties = { floating = true, tag=tags[1][3], switchtotag = true } },
  { rule =
    { class = "pinentry" },
    properties = { floating = true  } },
  { rule =
    { class = "nepomukservicestub" },
    properties = { floating = true  } },
  { rule =
    { class = "Gimp" },
    properties = { tag=tags[1][5]  } },
  { rule =
    { class = "Download" },
    properties = { floating = true  } },
  { rule =
    { class = "Choqok" },
    properties = { tag=tags[1][9], floating = true  } },
  { rule =
    { class = "Skype" },
    properties = { floating = true  } },
  { rule =
    { class = "kio_uiserver" }, --KDE copy window
    properties = { floating = true  } },
  { rule =
    { class = "Otrdecoder-gui" },
    properties = { floating = true  } },
  { rule =
    { instance = "Extension" },
    properties = { floating = true  } },
  { rule =
    { instance = "Places" },
    properties = { floating = true  } },
  { rule =
    { instance = "Plasma" },
    properties = { floating = true  } },
  { rule =
    { instance = "kcalc" },
    properties = { floating = true  } },
  { rule =
    { instance = "kmix" },
    properties = { floating = true  } },
  { rule =
    { class = "Firefox" },
    properties = { tag = tags[1][2] } },
  { rule =
    { class = "Chrome" },
    properties = { tag = tags[1][2] } },
  { rule =
    { class = "Thunderbird" },
    properties = { tag = tags[1][4] } },
  { rule =
    { class = "libreoffice-writer" },
    properties = { tag = tags[1][5] } },
  { rule =
    { class = "libreoffice-calc" },
    properties = { tag = tags[1][5] } },
  { rule =
    { class = "libreoffice-base" },
    properties = { tag = tags[1][5] } },
  { rule =
    { class = "libreoffice-impress" },
    properties = { tag = tags[1][5] } },
  { rule =
    { class = "OpenOffice.org 3.2" },
    properties = { tag = tags[1][5] } },
  { rule =
    { class = "Kdevelop" },
    properties = { tag = tags[1][6] } },
  { rule =
    { class = "Assistant" },
    properties = { tag = tags[1][7] } },
  { rule =
    { class = "Eclipse" },
    properties = { tag = tags[1][6] } },
  { rule =
    { class = "SDL_App" }, -- android emulator
    properties = { tag = tags[1][7] } },
  { rule =
    { class = "maple.exe" },
    properties = { tag = tags[1][8] } },
  { rule =
    { class = "Otrverwaltung" },
    properties = { tag = tags[1][8] } },
  { rule =
    { class = "tvbrowser-TVBrowser" },
    properties = { tag = tags[1][8] } },
  { rule =
    { class = "Kopete" },
    properties = { tag = tags[1][9], maximized_vertical = true } },
  { rule =
    { class = "Amarok" },
    properties = { tag = tags[1][9] } },
  { rule =
    { class = "Gobby" },
    properties = { tag = tags[1][8] } },
}

-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.add_signal("manage", function (c, startup)
    -- Add a titlebar
    -- awful.titlebar.add(c, { modkey = modkey })

    -- Enable sloppy focus
    c:add_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
  -- move .tex-edits in vim to tag 7
  if c.class == "URxvt" then
    c:add_signal("property::name", function(c,p)
        local prefix = string.match(c.name,"vim%s(.+)\.tex$")
        local ctags = c:tags()
        local isOnRightTag = ctags[1] == tags[1][7]
        if prefix ~= nil and not isOnRightTag then
          awful.client.movetotag(tags[1][7],c)
          awful.tag.viewonly(tags[1][7])
        end
        end)
  end
end)

client.add_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.add_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
client.add_signal("manage", function(c,b)
  if string.match(c.class, "[oO]kular") then
     awful.client.setslave(c)
     awful.tag.setmwfact(0.4)
  end
end)

function get_vol()
  local vol = awful.util.pread('amixer -c 0 get Master | grep % | cut -d "[" -f2  | cut -d "%" -f1')
  volumewidget:set_value(vol)
end

get_vol()

function battery()
  -- file containing all battery-related information we need
  FILE = '/sys/class/power_supply/BAT1/uevent'
  -- read file
  local file = io.open(FILE, 'r')
  if file == nil then
    return "AC"
  end
  local data = file:read('*all')
  file:close()
  -- extract information from read file
  local status = data:match("POWER_SUPPLY_STATUS=(%a+)")
  local now = tonumber(data:match("POWER_SUPPLY_CHARGE_NOW=(%d+)"))
  local full = tonumber(data:match("POWER_SUPPLY_CHARGE_FULL=(%d+)"))

  --distinguish status
  if status == "Full" then
    out = "AC"
  elseif status == "Discharging" then
    out = "D"
  elseif status == "Charging" then
    out = "C"
  else
    out = status
  end
  out = out .." : "

  -- get the percentage and format the output
  local percent = now / full * 100
  percentf = string.format('%.0f', percent)
  out = out .. percentf ..'%'
  return out
  end
  
  mytimer = timer({ timeout = 60 })
  mytimer:add_signal("timeout", function() mybatterybox.text = " | " .. battery() end)
  mytimer:start()


-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=2:tabstop=2:softtabstop=2:extwidth=80

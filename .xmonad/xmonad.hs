-- IMPORTS

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.SpawnOnce 
import XMonad.Util.Run 
import XMonad.Hooks.ManageDocks
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig
import Data.Maybe (fromJust)
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.Promote
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Tuple (fst,snd)

import XMonad.Util.NamedScratchpad

myTerminal :: String
myTerminal      = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

--- Border Config ---

-- Width in pixels.
myBorderWidth :: Dimension
myBorderWidth   = 2

myNormalBorderColor :: String
myNormalBorderColor  = "#dddddd"

myFocusedBorderColor :: String
myFocusedBorderColor = "#43cd80"

------------------


myWorkspaces :: [String]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14"]

myWorkspaceIndices :: M.Map String Int
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)


windowCount :: X (Maybe String)
windowCount = gets $ Just . (\s -> "<icon=win.xpm/> " ++ s) . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

--- Keys ---

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask


myKeys = \c -> mkKeymap c $ [
          ("M-p", spawn "sudo poweroff")  -- Recompiles xmonad
        , ("M-S-p", spawn "sudo reboot")  -- Recompiles xmonad
    -- KB_GROUP Xmonad
        --, ("M-S-r", spawn "xmonad --recompile; killall xmobar;xmonad --restart")  -- Recompiles xmonad
        , ("M-S-r", (restart "/home/david/.xmonad/xmonad-x86_64-linux" True))  -- Recompiles xmonad
        , ("M-c", spawn "google-chrome-stable")    -- Restarts xmonad

    -- KB_GROUP spawn Programs
        , ("M-d", spawn "rofi -modi drun,run -show drun") -- Dmenu
        , ("M-S-<Return>", namedScratchpadAction myScratchPads "terminal")
        , ("M-<Return>", spawn myTerminal)
        , ("M-b", spawn "bwmenu -c 20 --auto-lock 1800")
        , ("M-C-t", namedScratchpadAction myScratchPads "top")
        , ("C-<Space>", spawn "dunstctl close")
        , ("M-n", spawn "networkmanager_dmenu")
        , ("M-r", spawn "$SCRIPTS/rofi-randr")
        , ("M-l", spawn "$SCRIPTS/lock")
        , ("C-ö", spawn "copyq show 'Zwis&chenablage'")

    -- KB_GROUP Kill windows
        , ("M-S-q", kill)     -- Kill the currently focused client
        , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- KB_GROUP Workspaces
        , ("M-C-<Right>", nextScreen)  -- Switch focus to next monitor
        , ("M-C-<Left>", prevScreen)  -- Switch focus to prev monitor
        --, ("M-S-<Right>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        --, ("M-S-<Left>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- KB_GROUP Floating windows
        , ("M-S-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- KB_GROUP Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-<Down>", windows W.focusDown)    -- Move focus to the next window
        , ("M-<Up>", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
        , ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack

    -- KB_GROUP Layouts
        , ("M-<Tab>", sendMessage NextLayout)           -- Switch to next layout

    -- KB_GROUP Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

    -- KB_GROUP Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        --, ("M-l", sendMessage Expand)                   -- Expand horiz window width
        --, ("M-S-j", sendMessage MirrorShrink)          -- Shrink vert window width
        --, ("M-S-k", sendMessage MirrorExpand)          -- Expand vert window width

    -- KB_GROUP Multimedia Keys
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
        , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
        , ("<Print>", spawn "flameshot gui")
        , ("M-C-9", spawn "notify-send itWorks")
        --, ("M-C-", windows $ W.greedyView "13")
        ]

        ++
        [ ("M-" ++ k, windows $ W.greedyView i) | (i, k) <- zip (myWorkspaces) (map show ([1 .. 9] ++ [0] :: [Int]))]
        ++
        [ ("M-S-" ++ k, windows $ W.shift i) | (i, k) <- zip (myWorkspaces) (map show ([1 .. 9] ++ [0] :: [Int]))]
        ++
        [ ("M-C-" ++ k, windows $ W.greedyView i) | (i, k) <- zip (drop 10 $ myWorkspaces) (map show ([1 .. 9] :: [Int]))]
        ++
        [ ("M-C-" ++ k, windows $ W.shift i) | (i, k) <- zip (drop 10 $ myWorkspaces) (map show ([1 .. 9] :: [Int]))]

        --where
        --  altHack n
        --      | n > 10 = "C-" ++ (show n)
        --      | n == 10 = "0"
        --      | otherwise = (show n)
-- END_KEYS

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-r') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = avoidStruts(tiled ||| Mirror tiled ||| Full ||| threeCol)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
     threeCol = ThreeColMid nmaster delta ratio

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "Pavucontrol"        --> doCenterFloat
    , className =? "sun-tools-jconsole-JConsole" --> doCenterFloat
    , className =? "copyq"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , title =? "Google Chrome"     --> doShift ( myWorkspaces !! 0 )
    , className =? "Slack"     --> doShift ( myWorkspaces !! 5 )
    , title =? "Slack call with" --> doFloat
    , className =? "Microsoft Teams-Benachrichtigung" --> doFloat
    , className =? "Microsoft Teams - Preview" --> doShift ( myWorkspaces !! 4 )
    , className =? "obsidian" --> doShift ( myWorkspaces !! 9 )
    ]  <+> namedScratchpadManageHook myScratchPads






myScratchPads :: [NamedScratchpad]
myScratchPads = [ 
                NS "terminal" spawnTerm findTerm manageTerm
                , NS "top" spawnTop findTop manageTop
                ]
  where
    spawnTerm  = myTerminal ++ " -t scratchpad"
    findTerm   = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w
    spawnTop  = myTerminal ++ " -t top -e 'bpytop'"
    findTop   = title =? "top"
    manageTop = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = dynamicLogWithPP $ xmobarPP

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = spawnOnce "feh --bg-scale ~/.bg/background &" >>
                spawnOnce "pkill picom; picom --config='$HOME/.config/picom/config.conf'" >>
                spawnOnce "autorandr -c" >>
                spawnOnce "copyq --start-server" >>
                -- start Applications to Workspaces
                spawnOnOnce "5" "teams" >>
                spawnOnOnce "1" "google-chrome-stable" >>
                spawnOnOnce "6" "slack" >>
                spawnOnOnce "10" "obsidian" >>
                -- fix Java Applications (intellij Bug)
                setWMName "LG3D"
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

clickable ws = "<action=xdotool key super+"++i++">"++ws++"</action>"
    where
      i  = modKey $ fixTen $ fromJust $ M.lookup ws myWorkspaceIndices
      modKey y = if y > 10 then "Control_L+" ++ show (mod y 10) else show y
      fixTen x = if x == 10 then (0::Int) else x



-- Run xmonad with the settings you specify. No need to modify this.
--
main :: IO ()
main = do
        xmprocT0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobar-top"
        --xmprocB0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xmobar-bottom"
        xmprocT1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobar-top"
        --xmprocB1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xmobar-bottom"
        xmonad $  ewmhFullscreen . ewmh . docks $ def {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,--myKeysBasic,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook <+> manageDocks,
        --handleEventHook    = myEventHook,
        logHook            = dynamicLogWithPP $ xmobarPP
                                           -- the following variables beginning with 'pp' are settings for xmobar.
                                           { ppOutput = \x -> hPutStrLn xmprocT0 x                          -- xmobar on monitor 1 Top
                                           --                >> hPutStrLn xmprocB0 x                          -- xmobar on monitor 1 Bottom
                                                           >> hPutStrLn xmprocT1 x                          -- xmobar on monitor 2 Top
                                           --                >> hPutStrLn xmprocB1 x                          -- xmobar on monitor 2 Bottom
                                           , ppCurrent = xmobarColor "#43cd80" "" . wrap "<box type=Bottom width=2 mb=2 color=#43cd80>" "</box>"         -- Current workspace
                                           , ppVisible = xmobarColor "#256641" "" . clickable              -- Visible but not current workspace
                                           , ppHidden = xmobarColor "#bababa" "" . wrap "<box type=Bottom width=2 mt=2b color=#bababa>" "</box>" . clickable -- Hidden workspaces
                                           , ppHiddenNoWindows = xmobarColor "#696969" ""  . clickable     -- Hidden workspaces (no windows)
                                           , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
                                           , ppSep =  " <icon=seperators/seperator.xpm/> "                    -- Separator character
                                           , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
                                           , ppExtras  = [windowCount]                                     -- # of windows current workspace
                                           , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
                                           },

        startupHook        = myStartupHook
    }

-- IMPORTS
{-# LANGUAGE PartialTypeSignatures #-}
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
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Prompt.AppLauncher
import XMonad.Prompt.Layout
import XMonad.Prompt.RunOrRaise

import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
--import XMonad.Prompt.Theme research :)
import XMonad.Prompt.Man
import XMonad.Prompt (promptBorderWidth, defaultText, alwaysHighlight, height, font)
import XMonad.Layout.LayoutModifier
import XMonad.Util.NamedScratchpad
import Data.List
import GHC.IO.Handle.Types

import XMonad.Actions.OnScreen

import XMonad.Layout.Renamed
import XMonad.Layout.Tabbed
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing

import XMonad.Layout.LayoutModifier
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(FULL, NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Hooks.DebugStack
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
import XMonad.Actions.MouseResize
import XMonad.Hooks.WindowSwallowing
import XMonad.Actions.UpdatePointer
import XMonad.Util.Hacks (windowedFullscreenFixEventHook)

-- To use the xmonad-dbus program and communicate with it
import qualified Codec.Binary.UTF8.String as UTF8
import qualified XMonad.DBus as D
import qualified DBus.Client as DC

myTerminal :: String
myTerminal = "alacritty"

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = True

--- Border Config ---

-- Width in pixels.
myBorderWidth :: Dimension
myBorderWidth   = 2

myNormalBorderColor :: String
myNormalBorderColor  = "#808080"

myFocusedBorderColor :: String
myFocusedBorderColor = "#4ed4b0"

myWorkspaces :: [String]
myWorkspaces    = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14"]


myWorkspaceIndices :: M.Map String Int
myWorkspaceIndices = M.fromList $ zip myWorkspaces [1..] -- (,) == \x y -> (x,y)

-- Count the current windows on the focused Workspace
windowCount :: X (Maybe String)
windowCount = gets $ Just . withColor . viewCount . length . W.integrate' . W.stack . W.workspace . W.current . windowset
            where
              withColor s = wrap ("%{F" ++ myFocusedBorderColor ++"}") "%{F-}" s
              viewCount c = if c > 1 then
                            "\62162  " ++ show c ++ ""
                            else
                              "\62160 "

myFont :: [Char]
myFont = "xft:Mononoki Nerd Font:size=12"


-- Colours
aqua       = "#8ec07c"
gray      = "#7F7F7F"
red       = "#900000"
blue      = "#2E9AFE"
slightlyDifferentMainColor = "#2D7966"


---Prompts
myPromptConfig:: XPConfig
myPromptConfig = def
      {   font              = myFont
        , bgColor           = "#292d3e"
        , fgColor           = "#d0d0d0"
        , bgHLight          = "#c792ea"
        , fgHLight          = "#000000"
        , borderColor       = "#535974"
        , promptBorderWidth = 1
        --, promptKeymap      = dtXPKeymap
        , position          = Top
        , height            = 20
        , historySize       = 256
        , historyFilter     = id
        , defaultText       = []
        , autoComplete      = Nothing --Just 100000    -- set Just 100000 for .1 sec
        , showCompletionOnTab = False --True
        , searchPredicate   = isPrefixOf
        , alwaysHighlight   = True
        , maxComplRows      = Just 5    -- set to Just 5 for 5 rows
        }

--- Keys ---

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask :: KeyMask
myModMask = mod4Mask


myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys c = mkKeymap c $ [
          ("M-p", spawn "poweroff")  -- Recompiles xmonad
        , ("M-S-p", spawn "reboot")  -- Recompiles xmonad
    -- KB_GROUP Xmonad
        , ("M-S-r", spawn "~/.local/bin/myxmonad --recompile" >> restart "/home/david/.local/bin/myxmonad" True >> spawn "notify-send 'XMonad is restarted!'" >> spawn "systemctl --user restart polybar.slice")  -- Recompiles xmoad
        , ("M-c", spawn "google-chrome-stable --force-dark-mode")

    -- KB_GROUP spawn Programs
        , ("M-d", spawn "rofi -modi drun,run -show drun") -- Dmenu
        , ("M-C-5", runOrRaisePrompt myPromptConfig)
        , ("M-<ALT_L>-9", layoutPrompt myPromptConfig)
        , ("M-C-v", spawn "globalprotect launch-ui")

        , ("M-S-<Return>", namedScratchpadAction myScratchPads "terminal")
        , ("M-<Return>", spawn myTerminal)
        --, ("M-b", spawn "bwmenu -c 20 --auto-lock 1800 -theme arch")
        --, ("M-b", spawn "~/scripts/my-bw-dmenu work")
        --, ("M-C-b", spawn "~/scripts/my-bw-dmenu privat")
        , ("M-C-b", spawn "DMENU_PATH=~/.config/bitwarden_dmenu/rofi_dmenu bitwarden-dmenu --session-timeout 100000")
        
        , ("M-C-t", namedScratchpadAction myScratchPads "top")
        , ("C-<Space>", spawn "dunstctl close")
        , ("M-n", spawn "networkmanager_dmenu")
        , ("M-r", spawn "$SCRIPTS/rofi-randr")
        , ("M-l", spawn "$SCRIPTS/lock")
        , ("M-a", spawn "$SCRIPTS/changeDefaultAudio")
        , ("C-ö", spawn "copyq show 'clipboard'")

    -- KB_GROUP Kill windows
        , ("M-S-q", kill)     -- Kill the currently focused client
        , ("M-S-a", killAll)   -- Kill all windows on current workspace

    -- KB_GROUP Workspaces
        , ("M-C-<Right>", nextScreen)  -- Switch focus to next monitor
        , ("M-C-<Left>", prevScreen)  -- Switch focus to prev monitor
        , ("M-S-<Right>", shiftTo Next nonNSP >> moveTo Next nonNSP)       -- Shifts focused window to next ws
        , ("M-S-<Left>", shiftTo Prev nonNSP >> moveTo Prev nonNSP)  -- Shifts focused window to prev ws

    -- KB_GROUP Floating windows
        , ("M-S-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- KB_GROUP Windows navigation
        , ("M-f", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
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

        --, ("M-C-<Right>", spawn "xdotool mousemove_relative 15 0")
        --, ("M-C-<Left>", spawn "xdotool mousemove_relative -15 0")
        --, ("M-C-<Down>", spawn "xdotool mousemove_relative 0 15")
        --, ("M-C-<Up>", spawn "xdotool mousemove_relative 0 -15")
--        , ("M-<Return>", spawn "xdotool mousemove_relative 0 -15")
    -- Multimedia Keys
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")
        , ("<XF86AudioPrev>", spawn "playerctl previous")
        , ("C-<XF86AudioPrev>", spawn "playerctld unshift")
        , ("<XF86AudioNext>", spawn "playerctl next")
        , ("C-<XF86AudioNext>", spawn "playerctld shift")
        , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
        , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -10%")
        , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +10%")
        , ("<XF86MonBrightnessUp>", spawn "xbacklight -inc 10")
        , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
        , ("<Print>", spawn "flameshot gui")
        ]

        ++
        [ ("M-" ++ k, windows $ W.greedyView i) | (i, k) <- zip myWorkspaces (map show ([1 .. 9] ++ [0] :: [Int]))]
        ++
        [ ("M-S-" ++ k, windows $ W.shift i) | (i, k) <- zip myWorkspaces (map show ([1 .. 9] ++ [0] :: [Int]))]
        ++
        [ ("M-C-" ++ k, windows $ W.greedyView i) | (i, k) <- zip (drop 10 myWorkspaces) (map show ([1 .. (Data.List.length (drop 10 myWorkspaces))] :: [Int]))]
        ++
        [ ("M-C-S-" ++ k, windows $ W.shift i) | (i, k) <- zip (drop 10 myWorkspaces) (map show ([1 .. (Data.List.length (drop 10 myWorkspaces))] :: [Int]))]
        where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
-- END_KEYS

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--

myMouseBindings :: XConfig l -> M.Map (KeyMask, Button) (Window -> X ())
myMouseBindings XConfig {XMonad.modMask = modm} = M.fromList [ ((modm, button1), \w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster)

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster)

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
-- setting colors for tabs layout and tabs sublayout.



colorBack = "#282c34"
color08 = "#202328"
color16 = "#dfdfdf"


myTabTheme :: Theme
myTabTheme = def { fontName            = myFont
                 , activeColor         = myFocusedBorderColor
                 , inactiveColor       = color08
                 , activeBorderColor   = myFocusedBorderColor
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }


--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
magnifyLayout  = renamed [Replace "magnify"]
           $ noBorders.smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ magnifier
           $ limitWindows 12
           $ mySpacing 8
           $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 20 Full
floats   = renamed [Replace "floats"]
           $ smartBorders
           $ limitWindows 20 simplestFloat
grid     = renamed [Replace "grid"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 8
           $ mkToggle (single MIRROR)
           $ Grid (16/10)
spirals  = renamed [Replace "spirals"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ mySpacing' 8
           $ spiral (6/7)
threeCol = renamed [Replace "threeCol"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           $ ThreeCol 1 (3/100) (1/2)
threeRow = renamed [Replace "threeRow"]
           $ smartBorders
           $ windowNavigation
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 7
           -- Mirror takes a layout and rotates it by 90 degrees.
           -- So we are applying Mirror to the ThreeCol layout.
           $ Mirror
           $ ThreeCol 1 (3/100) (1/2)
tabs     = renamed [Replace "tabs"]
           -- I cannot add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme
tallAccordion  = renamed [Replace "tallAccordion"] Accordion
wideAccordion  = renamed [Replace "wideAccordion"]
           $ Mirror Accordion

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
             where
               myDefaultLayout =     withBorder myBorderWidth tall
                                 ||| noBorders monocle
                                 ||| noBorders tabs
                                 ||| grid
                                 ||| spirals
                                 ||| threeCol
                                 ||| threeRow



myLayout :: XMonad.Layout.LayoutModifier.ModifiedLayout AvoidStruts (Choose Tall (Choose (Mirror Tall) (Choose Full ThreeCol))) a
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
myManageHook :: Query (Endo WindowSet)
myManageHook = composeAll
    [ className =? "Pavucontrol"        --> doCenterFloat
    , className =? "sun-tools-jconsole-JConsole" --> doCenterFloat
    , className =? "Blueman-manager" --> doCenterFloat
    , className =? "f5vpn" --> doCenterFloat
    , className =? "copyq"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore 
    , title =? "Google Chrome"     --> doShift ( head myWorkspaces )
    , className =? "firefox"     --> doShift ( head myWorkspaces )
    , title =? "Picture-in-Picture"  --> doCenterFloat
    , className =? "Slack"     --> doShift ( myWorkspaces !! 5 )
    , title =? "Slack call with" --> doFloat
    , className =? "Microsoft Teams-Benachrichtigung" --> doFloat
    , className =? "Microsoft Teams - Preview" --> doShift ( myWorkspaces !! 4 )
    , className =? "obsidian" --> doShift ( myWorkspaces !! 9 )
    , className =? "YouTube Music" --> doShift ( myWorkspaces !! 6 )
    , title =? "win0" --> doFloat
    ,isFullscreen --> doFullFloat
    ]
    <+> namedScratchpadManageHook myScratchPads
    <+> manageDocks


myHandleEventHook :: Event -> X All
myHandleEventHook = swallowEventHook (className =? "Alacritty" <||> className =? "Termite") (return True)

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
    spawnTop  = myTerminal ++ " -t top -e 'top'"
    findTop   = title =? "top"
    manageTop = customFloating $ W.RationalRect l t w h
               where
                 h = 0.9
                 w = 0.9
                 t = 0.95 -h
                 l = 0.95 -w

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
myStartupHook :: X ()
myStartupHook = spawnOnce "copyq --start-server" >>
                -- start Applications to Workspaces
                spawnOnce "systemctl --user restart my-graphical-setup.target" >>
                spawnOnOnce "5" "teams" >>
                spawnOnOnce "1" "google-chrome-stable" >>
                spawnOnOnce "10" "obsidian" >>
                -- fix Java Applications (intellij Bug)
                setWMName "LG3D"

                --windows (greedyViewOnScreen 0 "6") >>
                --windows (greedyViewOnScreen 1 (head myWorkspaces)) >>
                --windows (greedyViewOnScreen 2 "5")
------------------------------------------------------------------------

 -- Override the PP values as you would like (see XMonad.Hooks.DynamicLog documentation)
myBarConfig :: DC.Client -> PP
myBarConfig dbus = def { ppOutput = D.send dbus,
                          ppCurrent = wrap ("%{F" ++ myFocusedBorderColor ++ "} ") " %{F-}",
                          ppVisible = wrap ("%{F" ++ slightlyDifferentMainColor ++ "} ") " %{F-}",
                          ppUrgent = wrap ("%{F" ++ red ++ "} ") " %{F-}",
                          ppHidden = wrap ("%{F" ++ gray ++ "} ") " %{F-}",
                          ppTitle = wrap ("%{F" ++ aqua ++ "} ") " %{F-}",
                          ppExtras  = [windowCount],
                          ppSep = "  |  ",
                          ppOrder  = \(ws:layout:title:extras) -> [layout]++extras
                        }

mylogHook :: DC.Client -> X ()
mylogHook dbus = dynamicLogWithPP (myBarConfig dbus) >> updatePointer (0.5, 0.5) (0, 0)


main :: IO ()
main = do
       --Connect to DBus
       dbus <- D.connect
       -- Request access (needed when sending messages to xmonad-dbus)
       D.requestAccess dbus
       -- start xmonad
       xmonad $ ewmhFullscreen $ ewmh $ docks $ def {
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
                                                keys               = myKeys,--myKeysBasic,y
                                                mouseBindings      = myMouseBindings,

                                              -- hooks, layouts
                                                layoutHook         = myLayoutHook,
                                                manageHook         = myManageHook,
                                                logHook = mylogHook dbus,
                                                handleEventHook = myHandleEventHook,
                                                startupHook        = myStartupHook
                                            }



import XMonad
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.List (isSuffixOf)

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName
import XMonad.Util.XSelection
import XMonad.Util.Run

import Control.Exception (bracket)
import System.IO

import qualified XMonad.Actions.Search as S
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleDecoration
import XMonad.Hooks.UrgencyHook

import XMonad.Layout.Gaps
import XMonad.Layout.ResizableTile

import XMonad.ManageHook
import XMonad.Util.NamedScratchpad

scratchpads = [
    NS "notes" "gvim --role notes ~/notes.txt" (role =? "notes") nonFloating
  , NS "sqldeveloper" "sqldeveloper" (className =? "oracle-ide-boot-Launcher") nonFloating
  , NS "eclipse" "eclipse" (className =? "EPP PHP Package") nonFloating
  , NS "visualvm" "visualvm" (name =? "VisualVM 1.2.1") nonFloating
  , NS "hipchat" "/opt/HipChat/bin/HipChat" (className =? "HipChat") nonFloating
  , NS "intellij" "idea.sh" (name `endsWith` "IntelliJ IDEA 9.0.3") nonFloating
  , NS "phpstorm" "phpstorm.sh" (name `endsWith` "JetBrains PhpStorm 1.0.1") nonFloating
  , NS "unequal" "/usr/games/unequal" (name =? "Unequal") nonFloating
  ] where role = stringProperty "WM_WINDOW_ROLE"
          name = stringProperty "WM_NAME"
          iconName = stringProperty "WM_ICON_NAME"

endsWith :: (Eq a) => Query [a] -> [a] -> Query Bool
endsWith q s = q >>= \x -> return (s `isSuffixOf` x)

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "gnome-terminal --hide-menubar"

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod4Mask

-- The mask for the numlock key. Numlock status is "masked" from the
-- current modifier status, so the keybindings will work with numlock on or
-- off. You may need to change this on some systems.
--
-- You can find the numlock modifier by running "xmodmap" and looking for a
-- modifier with Num_Lock bound to it:
--
-- > $ xmodmap | grep Num
-- > mod2        Num_Lock (0x4d)
--
-- Set numlockMask = 0 if you don't have a numlock key, or want to treat
-- numlock status separately.
--
myNumlockMask   = mod2Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- launch a terminal
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modMask,               xK_p     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

    -- launch gmrun
    -- , ((modMask .|. shiftMask, xK_p     ), spawn "gmrun")

    -- launch firefox
    , ((modMask .|. shiftMask, xK_f     ), spawn "firefox")

    , ((modMask .|. shiftMask, xK_g     ), spawn "firefox -no-remote -ProfileManager")

    -- launch google chrome
    , ((modMask .|. shiftMask, xK_h     ), spawn "/opt/google/chrome/google-chrome")

    -- close focused window ; touch
    , ((modMask .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modMask,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modMask .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modMask,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modMask,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modMask,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modMask,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modMask,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modMask,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modMask .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modMask .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modMask,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modMask,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modMask,               xK_t     ), withFocused $ windows . W.sink)

    -- Increment the number of windows in the master area
    , ((modMask              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modMask              , xK_period), sendMessage (IncMasterN (-1)))

    -- toggle the status bar gap
    -- TODO, update this binding with avoidStruts , ((modMask              , xK_b     ),

    -- Quit xmonad
    , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modMask              , xK_q     ), restart "xmonad" True)

    -- Search command
    , ((modMask .|. shiftMask, xK_s     ), S.selectSearch S.google)

    -- Shrink and expand
    , ((modMask,               xK_a     ), sendMessage MirrorShrink)
    , ((modMask,               xK_z     ), sendMessage MirrorExpand)

    , ((modMask .|. controlMask .|. shiftMask, xK_n), namedScratchpadAction scratchpads "notes")
    , ((modMask .|. controlMask .|. shiftMask, xK_s), namedScratchpadAction scratchpads "sqldeveloper")
    , ((modMask .|. controlMask .|. shiftMask, xK_e), namedScratchpadAction scratchpads "phpstorm")
    , ((modMask .|. controlMask .|. shiftMask, xK_v), namedScratchpadAction scratchpads "visualvm")
    , ((modMask .|. controlMask .|. shiftMask, xK_c), namedScratchpadAction scratchpads "hipchat")
    , ((modMask .|. controlMask .|. shiftMask, xK_i), namedScratchpadAction scratchpads "intellij")
    , ((modMask .|. controlMask .|. shiftMask, xK_g), namedScratchpadAction scratchpads "unequal")
    ]
    ++

    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_e, xK_w, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
-- myLayout = ewmhDesktopsLayout $ avoidStruts $ tiled ||| Mirror tiled ||| noBorders Full
-- myLayout = ewmhDesktopsLayout $ avoidStruts $ (tiled ||| Mirror tiled ||| noBorders Full ||| simpleDeco shrinkText defaultTheme tiled ||| simpleDeco shrinkText defaultTheme (Mirror tiled))
-- myLayout = avoidStruts $ (tiled ||| Mirror tiled ||| noBorders Full ||| simpleDeco shrinkText defaultTheme tiled ||| simpleDeco shrinkText defaultTheme (Mirror tiled))
myLayout = gaps [(U, 24)] $ avoidStruts $ (tiled ||| Mirror tiled ||| noBorders Full)
-- myLayout = (tiled ||| Mirror tiled ||| noBorders Full ||| simpleDeco shrinkText defaultTheme tiled ||| simpleDeco shrinkText defaultTheme (Mirror tiled))
  where
     -- default tiling algorithm partitions the screen into two panes
     -- tiled   = Tall nmaster delta ratio
     tiled   = ResizableTall nmaster delta ratio []

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

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
myManageHook = manageDocks <+> composeAll
    [ className =? "MPlayer"           --> doFloat
    , className =? "Gimp"              --> doFloat
    , className =? "Unity-2d-panel"    --> doIgnore
    , className =? "Unity-2d-launcher" --> doIgnore
    , resource  =? "desktop_window"    --> doIgnore
    , resource  =? "kdesktop"          --> doIgnore ]

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True


------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'DynamicLog' extension for examples.
--
-- To emulate dwm's status bar
--
-- > logHook = dynamicLogDzen
--
myLogHook = ewmhDesktopsLogHook
--touch

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = setWMName "LG3D"
 
------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad $ withUrgencyHook dzenUrgencyHook { args = ["-bg", "darkgreen", "-xs", "1"] }
              $ defaults

-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will 
-- use the defaults defined in xmonad/XMonad/Config.hs
-- 
-- No need to modify this.
--
defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        -- numlockMask        = myNumlockMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

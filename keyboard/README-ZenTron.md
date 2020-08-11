
# ZenTron - _the fastest keyboard layout in the world_
_An optimal ergonomic keyboard character layout for all keyboards - the fastest keyboard layout
in the world for touch typists._

The stable and __Oh So Official™©®__ _ZenTron_ layout for ErgoDox class keyboards, including
bonus Qwerty-LFO and Colemak-LFO layers provided for those in transition, can be seen here in
the elegant Oryx keyboard layout configurator (JavaScript required, or [see some plain
screenshots below](#user-content-screenshots-and-links)):

https://configure.ergodox-ez.com/ergodox-ez/layouts/nmR7W/latest/0

(On that Oryx page, click "Play layout tour" near the bottom left for the HTML/JS linked tour.)

Here is a ~134KiB reduced and cropped [photo of the ErgoDox-EZ (Glow)](ErgoDox-EZ--ZenTron_physical-1920x669.jpg)
where you can see the home row keys (and thumb "home" keys) are gold-painted keycaps; just note
that not all keycaps match the actual ZenTron layout (R should be "N", Q should be "I", the
arrow keys are T, H, O and R respectively, and the RHS thumb key labelled "W" in the photo, is
actually (as per Maltron) a space bar key).  For reference, the EZ in this photo is flanked by
two Logitech Trackman Marble trackballs, which are simply the most awesome mice in the world!

If you wish to go cold turkey on ZenTron (as the author did), then you might set aside a few
days, and you may prefer the author's daily use layout which ditches the Qwerty and Colemak
layers, and has a few other customizations which you may find preferable, YMMV:

https://configure.ergodox-ez.com/ergodox-ez/layouts/QaRAV/latest

Here's a Reddit thread:

https://www.reddit.com/r/ergodox/comments/i27st2/zentron_the_fastest_keyboard_layout_in_the_world/

ZenTron is intended to be **_Cyrillic ready_** with a full __9__ yet to be assigned keys - if you
speak Russian, please send your suggestions for a "Cyrillic LFO" ergonomic layer mapping to the
ZenTron ergo layout, and the author shall whip up a custom XOrg Cyrillic keyboard layout for
download.

So that those who come after us might find them more easily, please send your suggestions for
links, improvements and additions to:

	ergo@freedbms.net


__TOC:__

 1. [Overview](#user-content-overview)
 1. [Summary](#user-content-summary)
 1. [Features](#user-content-features)
 1. [Screenshots and links](#user-content-screenshots-and-links)
 1. [Application and Window Manager configuration suggestions](#user-content-app-and-window-manager-config-suggestions)
 1. [Addenda](#user-content-addenda)



----
## Overview

ZenTron is a mostly inverted _Maltron_ layout, with the little finger columns offset down one
row, and keyboard layers (thank you [QMK keyboard firmware](https://docs.qmk.fm/#/)) for
numbers, function keys and navigation, which is of course an example from which you may
liberally pirate.

This particular combination of keyboard layout and layers, is getting close to the fastest
achievable keyboard layout for maximising typing speed on any planar (two dimensional, single
physical layer, and not curved) keyboard.  The Maltron layout may be able to be improved upon a
little, but at the least this would have to account for overall key frequencies and not just
letters, or letters and numbers etc, as well as the Little Finger length discrepancy vis à vis
every other keyboard layout today (for "July 2020" values of today), _and_ the typing speed
gains achieved by overloading the home row (and nearby) keys for a numeric keypad for example;
properly analysing precise relative key positions in relation to finger lengths could also help.

Keep in mind that _typing speed_ is largely synonymous with _ergonomic_ and with _reducing RSI_.

So until tomorrow, this is it :)



----
## Summary

 - At heart ZenTron is an inverted [_Maltron_](http://xahlee.info/kbd/Maltron_keyboard.html)
   layout - which feels better and faster to type on than plain Maltron.  The exception is that
   the RHS (right hand side) little finger column is not inverted.

   Xah Lee [highlights conclusively that](http://xahlee.info/kbd/maltron_vs_dvorak_layout.html)
   Maltron is inherently better than all other layouts today (it adds a home row key on the left
   thumb).

   On top of this we add a Little Finger Offset modification (__LFO mod__) where the pinky
   finger columns are offset downwards by one row, which is faster again, as this actually
   aligns the pinky fingers with the actual keys they are supposed to press!

   LFO just by itself is a huge improvement which can be applied to most other keyboard layouts
   depending only on the limitations of your physical keyboard.

 - This LFO mod also means that for most typing, you can now rest your wrist, whilst you type,
   for longer periods of time, just watch out for RSI from twisting your wrist and/or little
   fingers if you do that, simply lift your wrist when needed so as to not unnecessarily strain
   your delicate pinky.

 - Punctuation, Tab, Escape and meta keys, are all optimized for programmers and
   command line use - although this can be quite a personal thing so YMMV.

 - The numeric keypad, punctuation, FnKey and
   Navigation layers are symmetrical, which also provides for alternating which hand is used in
   order to minimize RSI.

 - The "standard" layout (layer set) includes both Qwerty and Colemak (with LFO mod) layers that
   you can trivially swap between whilst transitioning (using the _Layout-Home_ key).

 - The base layer has no 'usual' number row; numbers are accessed by an evolved numeric keypad
   layer providing much faster and easier number entry for all but single digits - this
   combination of layers is very hard to beat in the Speed Typing stakes (which is the goal
   here after all if we wish to minimize RSI).

 - Finally, since the usual top number row is gone, the home row (i.e. the entire layout) could
   be moved up by one row, which default ZenTron does.

   On the ErgoDox, this means that for our underused thumbs, instead of thumbs having easy
   access to 2 keys and 2 additional thumb keys at a stretch, we now have 4 immediate thumb
   keys, 2 additional just a little beyond, and 4 extra thumb keys at a stretch.



-------
## Features

 - ZenTron is a mostly inverted (top and bottom rows swapped) Maltron keyboard layout.  Maltron
   is for keyboards with at least two thumb keys.

 - As with standard Maltron, the left thumb is __E__ and right thumb is __Space__.

 - Additional thumb keys are dedicated to minus (hyphen) and plus, underscore, extra Enter and
   Space keys, and _Alt-CapsLock_ for use as a "switch language" key - if you're mathematically
   inclined, it can be useful and fun to add _Greek_ in your OS keyboard language settings.

 - The little finger columns are offset downwards by one row - the __LFO Mod__.  This results in
   the shorter little fingers, resting naturally on their correct keys, further reducing finger,
   wrist and arm movements when typing.

 - Using 4 fingers for cursor motion (and also PgUp, PgDn, Home and End) in the traditional Vim
   or gaming style (on Qwerty layouts, the H J K L, or A S D F key groups, respectively), is
   _inherently_ faster than the more common 3-finger cursor motion cluster found on most
   'standard' keyboards today where both _Up_ and _Down_ are pressed using the same finger,
   since with only 3 fingers, the middle finger (usually) must extend or contract when you need
   to swap from the _Up_ key to the _Down_ key or vice versa.

   - This inherently faster "4 finger" cursor key cluster layout design element is used in all
	 cases in the ZenTron-LFO layout.

 - The Qwerty-LFO (standard Qwerty with LFO mod) and Colemak-LFO layers are single key presses
   away.

 - Ready access to a numeric keypad, function keys, and (e.g. Vim) "Nav"igation layer - thank
   you QMK layers.

 - Stable thumb clusters and meta key (Shift, Ctrl, Alt, Enter, Tab, Esc, Backspace) placement
   across most/all layers, and no gratuitous placement changes - all placements are to optimize
   ergonomics, functionality, consistency between layers, or some combination of those three.

 - __Single handed numpad operation__ using symmetrical numpad access _dual-fun_ keys, and a
   Numpad layer toggle key for comfortable extended number entry sessions.

   - Numpad is designed to be used at any time without ever involving the left hand!  This is
	 thanks to ErgoDox/QMK dual-function LayerToggle feature - just don't do this too much, or
	 it could cause _worse_ RSI.
   - Numpad can also (naturally) be toggled, for extended number entry sessions.
   - Numpad includes Tab, ESC, Enter, Backspace and brackets.
   - The RHS numpad's ESC, \*, /, Backspace, Enter, period, $ and =, are all in the same spot as
	 on the base layer.

 - For command line and tab completion, the _Tab_ key opposes (is on the other hand to) the
   period (full stop '.') and forward slash ('/') keys.

 - The ZenTron, Qwerty-LFO and Colemak-LFO layers are swappable (i.e. they each contain the full
   set of keys required on a base layer), which allows for easy switching of the default layer
   (on startup/ turning on the computer/ plugging in the keyboard) - if for some reason you want
   that :)



----
## Screenshots and links

(Note that some keys are as yet not assigned.)

Here is [ZenTron.00-US.en: ZenTron, Qwerty + Colemak LFO, Numpad, Fn,
Nav](https://configure.ergodox-ez.com/ergodox-ez/layouts/nmR7W/latest/2), the Qwerty-LFO layer
in Oryx (Javascript required) of the stable version with all layers including Qwerty-LFO and
Colemak-LFO, Numpad, FnKeys and Navigation etc.  Click on the ZenTron tab in Oryx to see the
ZenTron (base) layer to compare it with the Qwerty-LFO layer.

Here is a [plain low resolution screenshot - Qwerty_LFO-872x326.png (69KiB)](Qwerty_LFO-872x326.png) -
of just the Qwerty-LFO layer, and here is [a higher resolution screenshot of the full Oryx UI -
Qwerty_LFO-1228x845.png (159KiB)](Qwerty_LFO-Oryx_full-1228x845.png), and here's an [Oryx UI
screenshot of layer zero "0" (160K)](ZenTron-Oryx_full-1228x845.png).


Your incredibly humble author's "scratch pad" (and daily use) layout which has a small number of quirky
changes and also has the Qwerty-LFO and Colemak-LFO layers removed, can be found [in Oryx
here](https://configure.ergodox-ez.com/ergodox-ez/layouts/QaRAV/latest).

Here are "keyboard only" screenshots of the primary layers (the 3 caps lock lighting layers not
included) - just note that the NumPad layer screenshot is out of date, the latest stable version
has moved to the LHS and RHS being symmetrical, with extra punctuation now on one layer above:
 - Layer 0 [ZenTron-1210x452.png](ZenTron-1210x452.png) (96K)
 - Layer 2 [Qwerty_LFO-1210x452.png](Qwerty_LFO-1210x452.png) (96K)
 - Layer 4 [Colemak_LFO-1210x452.png](Colemak_LFO-1210x452.png) (95K)
 - Layer 8 [NumpadRH-1210x452.png](NumpadRH-1210x452.png) (95K)
 - Layer 10 [FnKeys-1210x452.png](FnKeys-1210x452.png) (87K)
 - Layer 11 [Nav-1210x452.png](Nav-1210x452.png) (102K)



----
## App and Window Manager config suggestions

Every new keyboard layout has effects upon "standard" keyboard shortcuts for all the
applications that you use.  Here are a collection of suggestions grouped by application, which
the ZenTron layout author uses.  ZenTron is very young and can use a few more...

Please send additions and all suggestions to ```ergo@freedbms.net``` to have them included here
for others.

Note that the initial author of this document was only familiar with a US style keyboard, so
users of other keyboards will likely need some different config mods - please send your
suggestions for such variations to ```ergo@freedbms.net``` so others may more easily find them.


### Window manager

	Ctrl + Alt + <Arrow Key>           # Move to the desktop which is next to the current desktop.
	Ctrl + Alt + Shift + <Arrow Key>   # Move current window to the desktop which is next to the current desktop.

	Alt + F10                          # [Un-] Maximise current window.
	Alt + F11                          # [Un-] Fullscreen current window.

	Ctrl + Alt + Shift + F14           # [Un-] Maximize window vertically.
	Ctrl + Alt + Shift + F15           # [Un-] Maximize window horizontally.


### Tmux

Map Ctrl-PgUp and Ctrl-PgDn to previous Window and next Window, so that cycling through them
works the same as cycling through browser tabs:

	bind -n C-PPage select-window -t:-
	bind -n C-NPage select-window -t:+

Example other "standard" tmux bindings (and see also https://github.com/tmux/tmux/issues/754 ):

	set -g prefix F12               # F12 was/is the std prefix in the old Gnu Screen
	bind F12 send-prefix
	bind F12 select-window -t:!     # This + the line(s) above makes an F12 "double tap" swap tmux windows
	unbind C-b
	set -g mode-keys vi

	bind -n F10 new-window


### Vim

Map arrow keys to cursor movement (these days, this might be default anyway).

Swap ";" and ":" - with this config, saving a file at any time becomes a real pleasure which
feels natural and efficient, since ";" (which is otherwise not used in command mode) is ":" but
without having to hold Shift at the same time:

	nnoremap ; :
	nnoremap : ;

For function key junkies, or those who want to become one, insert ISO date time stamps:

	nnoremap <F4> "=strftime("%Y%m%d-%H:%M:%S")<CR>P


### Mutt, NeoMutt etc

For those used to J and K to move down and up in the index, consider adding mappings of W for
down, which on Maltron layouts is to the left of K, and backtick ("`") for up - in the ZenTron
layout, this gives ready single handed prev/next, for both left and right hand:

	bind pager,index w next-entry
	bind pager,index \` previous-entry



----
## Addenda


### URLs

 - This is the author's "scratch" layout which has a few changes from the official ZenTron
   layout, and which may change at any time:
   https://configure.ergodox-ez.com/ergodox-ez/layouts/QaRAV/latest/0

 - http://xahlee.info/kbd/char_frequency_counter.html

 - http://xahlee.info/comp/computer_language_char_distribution.html

 - http://xahlee.info/kbd/dvorak_vs_colemak_vs_workman.html

 - http://xahlee.info/kbd/Maltron_keyboard.html

 - https://colemakmods.github.io/mod-dh/


### Background

Being able to type on qwerty at ~40 words per minute is reasonably quick for most work, but the
Qwerty layout is not the best if you want to minimize or reduce RSI (repetitive strain injury).
A benefit of improving the character layout to reduce RSI, i.e. using a so-called ergonomic
layout, is to minimize arm, wrist and finger movements and therefore to maximise potential
typing speed.

There are many ergonomic keyboard character layouts which (at least attempt to) improve on
Qwerty, or to improve on other ergonomic layouts since Qwerty such as Dvorak, Colemak, Workman
and Maltron.

The author resolved to learn an ergonomic layout earlier this year (2020) when he was fortunate
enough to be provided an ErgoDox-EZ Glow and had decided on _Colemak Mod-DHm_.

Having used a TrulyErgonomic for a few years, which continues to be an excellent ortholinear
keyboard, and an MS Natural keyboard for many years before that, and a user of Gnu Bash, Tmux,
Vim, Mutt and Java without an IDE, the opportunity to explore easy keyboard layout tinkering was
seized.

Having thus resolved to learn a new layout, why learn more than one?  Why not just learn the
best?

It turns out that as of 2020 at least, the 1970s Maltron layout has apparently stood the test of
time - it is still statistically better than all newer layouts that have come since!
See here: http://xahlee.info/kbd/maltron_vs_dvorak_layout.html

Trying Maltron on the ErgoDox for an hour felt suboptimal and clunky, it just didn't seem right
(despite obviously being a completely foreign/new layout), so I checked the character frequency
charts (see Xah Lee's links above) and it seemed apparent that Maltron was upside down.  So I
inverted the layout and experienced instant noticeable improvement.

Right around the same time and due to thinking about minimizing finger movement, I also offset
the little finger "pinky" column down one row (relative to the three other fingers).  This made
a further immediate and positive improvement again - when resting the hands above the Ergodox,
the little fingers were for __the first time ever__ finally above their correct keys, and not a
row or more below.

When taking a guilty little peek at one's outstretched fingers, and comparing the difference in
their lengths, it's obvious there is MORE than one whole key difference in length from the pinky
to the ring finger - about a key and a half!  This LFO is such a huge improvement to reducing
arm movement forwards and backwards, you can now literally type continuously with your wrists
firmly planted on the wrist rests - just watch you now lift your wrists when needed to avoid
_worse_ RSI due to excessive wrist twist due to a "stuck" wrist resting!

The final 'big' change was a day or so later, after using a single-handed 'numeric keypad' layer
and never the traditional top row of numbers, when the top row was ditched altogether and the
rest of the rows were moved up a full row: type happily ever after with abundant thumb keys and
the consequent _awesome_ layout flexibility :)

Having 10 extra physical keys (from the removed number row) also gives even more layout
flexibility, and the ability to reduce the number of keys with overlapping functions (for
example, cursor movement keys) if you so choose - which after much testing I resolved to put on
a separate layer anyway, to maximize symmetry and consistency of usage patterns - ultimately
some of such choices will always come down to a personal preference, and wrote learnt muscle
memory will kick in soon enough.

Also note that besides its known firmware bugs, the Maltron is concave (like a bowl) and that is
an obvious "physical ergonomic" improvement which the ErgoDox does not have - one must look to
something like the Dactyl for that.

Happy typing :)

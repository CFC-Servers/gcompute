# GCompute: In-Game Lua IDE
### Revived and maintained by CFC-Servers
Please note, all changes were made in a harshly opinionated manner, to serve our own goals specifically.

While we think you'll appreciate most of these changes too, don't be surprised if you see things like Spaces being preferred over Tabs, font size changes, etc.

## Installation
You will need to install the following addons additionally:
- https://github.com/CFC-Servers/glib
- https://github.com/CFC-Servers/gooey
- https://github.com/CFC-Servers/vfs

## Usage
- First, set `is_gcompute_user 1` and rejoin _(This prevents glib/gcompute files being sent to clients that will never use it)_
- If you want GCompute to load on every join, set `glib_autoload_enabled 1`
- If you only want to load it as-needed, you have to run `glib_request_pack` before running GCompute
- To open GCompute, use the console command: `gcompute_show_ide`
- To adjust the font size in GCompute, use the `gcompute_default_fontsize` convar

## Changes from the original
- Loading is now done asynchronously, preventing your game from entirely locking up _(may still happen [if the server has lots of legacy addons](https://github.com/Facepunch/garrysmod-issues/issues/5674))_
- Increased font size across the board, and added font size configuration
- Prevent the insertion of the ` character when opening the console with GCompute open
- Removed a ton of niche/dead code, makes the editor focus exclusively on running GLua
- Use spaces instead of tabs when auto-indenting in the editor
- Removed all uses of `debug.getregistry` so that it actually works
- GLib Namecache improvements - ignore more tables from modern addons _(makes loading faster)_

## IDE Features
- Draggable and dockable views - the workspace can be arranged any way you want
- Console views for evaluating lua expressions locally, on the server or on any connected client
- File browser
- Code output redirected to output log in IDE
- Ability to execute code, on the server or any connected client
- Code views not associated with a file are saved across sessions

## Editor Features
- Code completion
- Token highlighting
- Bracket highlighting
- Multiple tabs
- Undo / redo


## Screenshots
![](https://dl.dropboxusercontent.com/u/7290193/Screenshots/Garrysmod/GCompute/1.png)

Autocompletion:
![](https://i.minus.com/iwcm9pQstP58J.png)

Console views:

![](https://dl.dropboxusercontent.com/u/7290193/Screenshots/Garrysmod/GCompute/Console/Console5.png)

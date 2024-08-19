home = os.getenv("HOME");
base_dir = home .. '/dotfiles/wezterm/';

package.path = base_dir .. '?.lua;' .. package.path;

local wezterm = require(base_dir..'wezterm');
return wezterm;

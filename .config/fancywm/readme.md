# FancyWM
FancyWM is a Dynamic Tiling Window Manager for Windows.
It can be installed from the Microsoft Store.

Repository: https://github.com/FancyWM/fancywm

Configurations are saved into a `settings.json` file
(the program itself has a GUI support to modify this file)

The can be found in `%localappdata%\Packages\2203VeselinKaraganev.FancyWM_9x2ndwrcmyd2c\LocalCache\Roaming\FancyWM`,
or simply by going to **Settings > General** in the program itself, which should contain a link to the file.

Simply create a link on a new system to import this configuration,
```sh
mklink "%LOCALAPPDATA%\Packages\2203VeselinKaraganev.FancyWM_9x2ndwrcmyd2c\LocalCache\Roaming\FancyWM\settings.json" "%USERPROFILE%\.config\fancywm\settings.json"
```

> Be sure that you are running `mklink` with elevated permissions as %LOCALAPPDATA% is a privileged directory.


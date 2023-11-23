To install plugins:
```
git submodule add --name {abitrary-name} {https://github.com/.../plugin.git} {pack/{abitrary-pkg-name}/{start|opt}/{repo-root-directory}}
```

To clone to another machine (including all submodules)
```
git clone --recursive git@github.com:ye-chuan/nvim.git
```

or alternatively
```
git clone git@github.com:ye-chuan/nvim.git
git submodule init    # Updates the .git/config with information from .gitmodules, can selectively choose with `git submodule init submodule1 submodule2`
git submodule update  # Actually pulls the submodules in .git/config into local directory
```

Remember to generate helptags in nvim with
```
:helptags ALL
```

To Update All Plugins
Make sure to be in root nvim\ (config directory)
```
git submodule foreach git pull origin master
```

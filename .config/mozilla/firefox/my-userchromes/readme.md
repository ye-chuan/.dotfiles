# Firefox Customization

Customising Firefox requires quite a bit of manual tinkering.

The main customisation we will be doing is to apply my modified version of the open-source userChrome: *Firefox Cascade*.

1. Symlink the `chrome/` directory
    - This includes a Catppuccin Mocha integration.
2. "Customize Toolbar" and remove any unnecessary icons from the toolbar (especially the **flexible space** which might cause the URL bar to seem smaller than expected).
3. To remove the sidebar, set `sidebar.revamp=false` in `about:config`.
4. Install Catppuccin Userstyles
    - `https://userstyles.catppuccin.com/`
    - Keep `patchCsp` disabled in general
5. Tabliss import configuration from `~/.exported-config/tabliss`


# nchat
A nice TUI program with Telegram and Whatsapp support.

## Changes to Default Keybindings
`*` refer to keys that are not really in use (can be mapped to something else if possible)

Note that in most terminals, ESC is basically the same as ALT.

ext_edit=`\33\145` (ESC-E) -> `\33\166` (ESC-V)
edit_msg=`KEY_CTRLZ` -> `\33\145`
paste=`\33\166` (ESC-V) -> `KEY_CTRLV`
open=`KEY_CTRLV` -> `KEY_CTRLO`
other_commands_help=`KEY_CTRLO` -> `KEY_CTRLZ`

next_chat=`KEY_TAB` -> `KEY_DOWN`
goto_chat=`KEY_CTRLN` -> `KEY_TAB`
toggle_top=`KEY_CTRLP` -> `KEY_BTAB` *
prev_chat=`KEY_BTAB` -> `KEY_UP`
up=`KEY_UP` -> `KEY_CTRLP`
down=`KEY_DOWN` -> `KEY_CTRLN`

backward_kill_word=`\33\177` * (ESC-BS Not Working) -> `KEY_CTRLW`
open_link=`KEY_CTRLW` -> `\33\154` (ESC-L)

delete_msg=`KEY_CTRLD` -> `KEY_DC`
save=`KEY_CTRLR` * -> `KEY_CTRLD`

linebreak=`KEY_RETURN` -> `\33\15` (ALT + Enter after setting linefeed_on_enter=0)
send_msg=`KEY_CTRLX` * -> `KEY_RETURN`

toggle_help=`KEY_CTRLG` * -> `KEY_CTRLH`

forward_msg=`\33\162` (ESC-R) -> `\33\146` (ESC-F)
react=`\33\163` (ESC-S) * -> `\33\162` (ESC-R)

open_msg=`\33\167` (ESC-W) * -> `\33\157` (ESC-O)

## Attribution
Icon from [Flaticon](https://www.flaticon.com/free-icons/comments).

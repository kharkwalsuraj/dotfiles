# Line and word navigation. Fish already binds all of these by default (kitty passes them through unchanged);
# they are written out so they are visible and survive a changed default.
status is-interactive; or return

bind ctrl-a beginning-of-line # Start of line (default)
bind ctrl-e end-of-line       # End of line (default)
bind alt-b backward-word      # One word back (default)
bind alt-f forward-word       # One word forward (default)
bind ctrl-left backward-word  # One word back (default)
bind ctrl-right forward-word  # One word forward (default)
bind home beginning-of-line   # Start of line (default)
bind end end-of-line          # End of line (default)

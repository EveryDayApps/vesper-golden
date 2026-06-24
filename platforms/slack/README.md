# Vesper Golden: Slack

Slack sidebar port. Slack themes only the left sidebar, not the message pane, so this is a single line of eight hex values rather than a built package. Ships dark and light variants. Colors derive from the repo-root `palette.json`.

To test: open Slack, go to **Preferences > Themes**, scroll to the bottom and click **Create a custom theme** (or the "Copy and paste theme values" field), then paste one line from [`theme.txt`](theme.txt).

The eight values, in order, are: Column BG, Menu BG Hover, Active Item, Active Item Text, Hover Item, Text Color, Active Presence, Mention Badge.

There is nothing to build. The strings in `theme.txt` are the deliverable.

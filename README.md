# pvplot
produce Rstudio-server plots from pv feed in.

Plots use R and shiny-server. Invoke as:

sudo shiny-server plotting/today/today.conf

[require sudo to get permissions for port 80]

This build was built to explore the use of IPv6 + shiny.

Requires:
Shiny Server v1.4.0.0
Node.js v0.10.21

Shiny-server built with this commit: 67e6e9fdf5c8c4

The IPv6 code made it into shiny-server 4.0, but that's 64 bit only.

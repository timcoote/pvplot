# pvplot
Produce Shiny Server from pv feed in, using Aurora Inverter query tool from `http://www.curtronics.com/Solar/AuroraData.html`.

This repo is a non-parameterised chunk of code that's packaged and configured into a couple of systemd service elsewhere using rpm.

Tested with `shiny-server-1.5.14.948-1.x86_64`, `aurora-1.9.3.tar.gz` on Fedora 32.

Works with IPv6.

Beware R modifications as Tidyverse is evolving and introducing some breakages (notably https://bit.ly/30sfAeg)


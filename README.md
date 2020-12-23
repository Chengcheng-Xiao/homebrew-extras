Homebrew-extras
===============
__DEPRECATED, PLEASE USE MACPORTS__
Formulae for Homebrew.

How do I install these formulae?
--------------------------------
Just `brew tap Chengcheng-Xiao/extras` and then `brew install <formula>`.


(first install [Homebrew](http://brew.sh))

Docs
----
`brew help`, `man brew`, or the Homebrew [wiki][].

[wiki]:http://wiki.github.com/Homebrew/homebrew

# IMPORTANT
keg-only version of pango cannot be correctly detected by gtk+2, links needed for gtk+ compilation:
```
ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/Pango-1.0.gir      /usr/local/share/gir-1.0/Pango-1.0.gir
ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/PangoCairo-1.0.gir /usr/local/share/gir-1.0/PangoCairo-1.0.gir
ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/PangoFT2-1.0.gir   /usr/local/share/gir-1.0/PangoFT2-1.0.gir
ln -s /usr/local/Cellar/pango@99/1.42.4_99/share/gir-1.0/PangoXft-1.0.gir   /usr/local/share/gir-1.0/PangoXft-1.0.gir
```
update 2020-12-20
v_sim, more specifically cairo cannot be installed with x11. solution needed.

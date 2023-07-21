# [WSS23] Efficient discovery of halting paths in aggregation system multiway graphs

This project was developed during the [Wolfram Summer School 2023](https://education.wolfram.com/summer-school), in Science and Tech track (even though it is much related to NKS).
Special thanks to Robert Nachbar, for mentoring the development, and Stephen Wolfram, for proposing this theme/project.

We study halting conditions for totalistic aggregation systems on minimal initial states, through empirical test/search and mathematical analysis. See the live community post of the project for complete information: https://community.wolfram.com/groups/-/m/t/2959726

This repository contains:
 - The community post [notebook file](community_final.nb)
 - Simulator application source code - developed with [LÖVE](https://love2d.org/) and [Lua](https://www.lua.org/) - [simulator](simulator)
 - Simulator game source code - developed with [LÖVE](https://love2d.org/) and [Lua](https://www.lua.org/) - [simulator_game](simulator_game)

We also provide live-web versions for the simulators:
 - [Simulator](https://64b20f7729229943fe0679da--silly-meerkat-94c163.netlify.app/)
 - [Simulator puzzle game](https://64b44c2e0268126a2c39e855--gleaming-sfogliatella-32aaaa.netlify.app/)

# Simulator
You can refer on [Love wiki](https://love2d.org/wiki/Game_Distribution) to see how to build. We provide Windows executable files on releases.

## Operation/command instructions
 - Escape key: reset/clear canvas
#### Manual cell control
 - Mouse right click: force-add a cell
 - Mouse left click: add an eligible cell (only works for pink cells)
 - Keys 1-8: toggle on/off bits of rules (it does not update already added cells)
#### Viewport control
 - Mouse wheel: zoom in/out
 - Mouse wheel click and drag: pan/translate
#### Automatic/random aggregation
 - R key: add one random cell from set of pink cells
 - Spacebar key: toggles ON/OFF automatic insertion of cells
 - Up/Down arrows: increase/decreases speed of adding cells

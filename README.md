# Introduction

This project aims to allow rapid prototyping of game ideas across multiple platforms.

By using [mruby](https://github.com/mruby/mruby/) this project will allow the developer to maximise code re-use across projects.
Performance sensitive components can still be written in any of asm, c, c++, or objc and integrated to be called through the ruby interface.

# Installation

    gem install qgame

# Useage

Create a new project

	qgame new <PROJECT_NAME>

Run the game

	qgame run

Run the game on a specific platform

	qgame run --PLATFORM=iOS

Profile the game (currently just displays some basic information about object allocation)

	qgame profile

# Notes

This project is still in heavy development, please use it at your own caution!

# Examples

A basic example can be found in [game](https://github.com/Archytaus/qgame/tree/master/game)

# Supported Platforms

* MacOSX
* iOS

Coming Soon

* Windows
* Linux

# License

This project is distributed under the MIT License. See LICENSE for further details.

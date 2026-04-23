# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Ruphy Studio is a Rapid Application Development (RAD) desktop application for Rails, inspired by Delphi. It is built with [Glimmer DSL for SWT](https://github.com/AndyObtiva/glimmer-dsl-swt) running on JRuby. The goal is a drag-and-drop IDE that generates and manages real Rails 7.1.x applications. Currently in POC stage.

## Toolchain Setup

This project requires JRuby (not MRI Ruby) and a JDK. The toolchain is managed via [mise](https://mise.jdx.dev/).

```bash
mise install          # installs jruby-9.4.13.0 and qdns
jruby -S bundle install
```

## Running the App

```bash
jruby app/main.rb
```

## Architecture

The app is a single JRuby desktop process — no web server, no Rails. It uses the SWT widget toolkit (via Java/JVM) through the Glimmer DSL.

- `app/main.rb` — entry point; instantiates and starts `RuphinoWindow`
- `app/ui/ruphino_window.rb` — the main window using Glimmer DSL for SWT; currently a transparent, borderless, draggable mascot window (128×128px)

The intended future architecture: the desktop shell will provide a visual designer that generates Rails app scaffolding and orchestrates deployment via Kamal (MRI Ruby in production, JRuby only for the IDE).

## Key Constraints

- **Must run on JRuby**, not MRI Ruby — SWT requires the JVM.
- SWT uses Java's AWT/Swing integration on macOS; a JDK must be installed and `JAVA_HOME` set.
- The Gemfile is intentionally minimal; `glimmer-dsl-swt` pulls in SWT jars transitively.
- There are no tests yet (POC stage).

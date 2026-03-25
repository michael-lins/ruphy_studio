# Ruphy Studio ™
> _Drag and Drop your Rails project from Idea to IPO_

Ruphy Studio ™ is a Rapid Application Development (RAD) platform for Ruby on Rails with a Delphi-inspired experience.

It is my love letter to my 20-years-ago self.

---

## Vision

> _Keep the wheel running from a new perspective — not reinventing it._

Ruphy Studio aims to:

- Create Rails applications from scratch
- Attach them to remote Git repositories
- Provide a Drag & Drop WYSIWYG experience, powered by [Hotwire](https://hotwire.dev) and ready to be deployed to remote servers using [Kamal](https://kamal-deploy.org)
- Use a seamless UI component system, RuphyCL, powered by [Css-Zero](https://csszero.lazaronixon.com) and later on [Ruby UI](https://github.com/ruby-ui/ruby_ui) [components](https://rubyui.com/docs/introduction)
- Stay 100% Rails-compatible
- Support remote deployment via Kamal (through a remote deployer)

The goal is not to replace Rails —  
it is to elevate the Rails experience.

---

## Architecture (Current POC State)

Ruphy Studio is a hybrid Desktop/Web application:

- Desktop shell powered by Glimmer DSL for SWT
- Running on **JRuby**
- Generates real **Rails 7.1.x** applications
- Uses JDBC adapters for cross-platform SQLite support
- Designed to deploy via MRI + Kamal (remote deployer model)

### Runtime Strategy

**Local Development**
- JRuby 9.4.x
- Rails 7.1.x
- `activerecord-jdbcsqlite3-adapter`
- No native compilation required
- Cross-platform: macOS / Linux / Windows

**Deployment**
- MRI Ruby
- Standard `sqlite3` gem
- Kamal executed remotely

This keeps development friction-free while preserving production compatibility.

---

## Rails Seed Project Design

Generated Rails apps:

- Rails 7.1.x
- SQLite database
- JDBC adapter under JRuby
- Native `sqlite3` under MRI
- No Docker
- No local Kamal dependency

The project remains fully compatible with standard Rails workflows.

---

## Install

### Install mise

https://github.com/jdx/mise

---

### Install Java (JDK recommended)

https://openjdk.org/install/

JRuby requires a working Java runtime.

---

### Install Toolchain

From project root:

```bash
mise install
```

### Install ruby gems (using jruby)
```bash
jruby -S bundle install
```

## Run the development version

### Run it locally
```bash
jruby app/main.rb
```
## Build the distribution version

### Build it using Glimmer


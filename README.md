# Ruphy Studio &trade;
> ### _Drag and Drop your Rails project from Idea to IPO_

Ruphy Studio &trade; is a Rapid Application Development (RAD) platform for Ruby on Rails projects with a [Delphi](https://en.wikipedia.org/wiki/History_of_Delphi_(software)) experience flavor in mind. This is simply my love letter for myself (my 20-years-ago self).

## Main Goal
> ### _That's the goal: to keep the wheel running from a new perspective, not reinventing it._

The idea is to allow Ruby on Rails projects to be created from scratch (and attach them to remote Git repositories) and provide a new Drag and Drop experience to build WYSIWYG views using [Css-Zero](https://csszero.lazaronixon.com) and later on [Ruby UI](https://github.com/ruby-ui/ruby_ui) [components](https://rubyui.com/docs/introduction).

Users will also check their work using the Live Preview feature to later on deploy it to a remote server using [Kamal](https://kamal-deploy.org).

We'll leverage experience with [Hotwire](https://hotwired.dev) to boost the UX with innovative and impactful approaches for developers (or just my) happiness. 

## Install

Install mise-en-place
> https://github.com/jdx/mise

Install tools
```
mise - firstall
```

Install dependencies
```
bun install
```

### (Linux)
Install webkit2gtk-4.1

On Arch Linux / Manjaro:
```
sudo pacman -S webkit2gtk-4.1
```

On Debian / Ubuntu:
```
sudo apt install libwebkit2gtk-4.1-dev
```

On Fedora:
```
sudo dnf install webkit2gtk4.1-devel
```

## Run 
Run it locally
```
npm run tauri dev
```

Build it for distribution
```
npm run tauri build

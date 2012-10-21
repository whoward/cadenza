[![Build Status](https://secure.travis-ci.org/whoward/cadenza.png?branch=master)](http://travis-ci.org/whoward/cadenza)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/whoward/cadenza)

# Description

Cadenza is a template parsing and rendering library for Ruby.  The syntax is very
similar to other template languages like Django (Python), Smart (PHP), or Liquid (Ruby).

In addition to the usual template language features, Cadenza features:

- template inheritance
- extendable syntax
- interchangeable lexers, parsers, loaders and renderers
- much more

# Installation

```bash
   gem install cadenza
```

# Usage

To learn how to both write Cadenza templates and use Cadenza in your Ruby 
projects have a look at the [Cadenza Manual](http://cadenza-manual.heroku.com/)

To learn how to extend Cadenza with custom Lexers, Parsers, Loaders and Renderers
visit the [Yard Documentation](http://rubydoc.info/github/whoward/Cadenza/)

# Roadmap

See: [Pivotal Tracker Project](https://www.pivotaltracker.com/projects/211737)

# Contributing

See: [CONTRIBUTING.md](http://github.com/whoward/cadenza/tree/master/CONTRIBUTING.md)

# Supported Ruby Versions

- Ruby 1.8.7
- Ruby 1.9.2
- Ruby 1.9.3
- Ruby Enterprise Edition
- Rubinius 2.0 (1.8 mode)
- Rubinius 2.0 (1.9 mode)

Unforunately JRuby does not seem to work with Racc because of issues with it's native extension "cparse"

# License

Cadenza is released under the MIT license

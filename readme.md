[![Gem Version](https://badge.fury.io/rb/cadenza.png)](http://badge.fury.io/rb/cadenza)
[![Build Status](https://secure.travis-ci.org/whoward/cadenza.png?branch=master)](http://travis-ci.org/whoward/cadenza)
[![Code Climate](https://codeclimate.com/github/whoward/cadenza.png)](https://codeclimate.com/github/whoward/cadenza)

# Description

Cadenza is a template parsing and rendering library for Ruby.  The syntax is very
similar to other template languages like Django (Python), Smarty (PHP), or Liquid (Ruby).

In addition to the usual template language features, Cadenza features:

- template inheritance
- extendable syntax
- interchangeable lexers, parsers, loaders and renderers

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

If you have any ideas or suggestions please let me know! I love ideas. You can open an Issue to discuss it.

# Contributing

See: [CONTRIBUTING.md](http://github.com/whoward/cadenza/tree/master/CONTRIBUTING.md)

# Supported Ruby Versions

- Ruby 1.8.7
- Ruby 1.9.2
- Ruby 1.9.3
- Ruby 2.0.0*
- Ruby Enterprise Edition
- Rubinius 2.0 (1.8 mode)*
- Rubinius 2.0 (1.9 mode)*
- JRuby (1.8 mode)
- JRuby (1.9 mode)

(*) Some supported ruby interpreters are not officially released yet (such as Rubinius or Ruby 2.0), these
are a special case for support:

> If you are using Cadenza from Rubygems then we will ensure that the build is passing on that interpreter 
> at the point we are releasing.
>
> If you are using Cadenza from the master branch however, be sure to check our Travis CI page for current 
> build status.  No guarantees.

# License

Cadenza is released under the MIT license

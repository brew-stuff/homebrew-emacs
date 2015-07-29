# FIRST THINGS FIRST THANK YOU

Keeping everything up-to-date is a lot of work, so I appreciate the
help!  There are really only a few guidelines to keep in mind:

Formulae in this tap look a little different than those in the
core Homebrew repository.  The first couple lines of an Emacs formula
will look like this:

```ruby
require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AcHtml < EmacsFormula
```

The first line loads `./Homebrew/emacs_formula.rb`, which gives us
access to `EmacsFormula`.  `EmacsFormula` is an extension of the
`Formula` class that lets us do things like byte-compile Emacs Lisp
files during the installation.

# Naming a new formula

If you’re submitting a new formula, it’s tempting to just use whatever
name ELPA or MELPA uses.  Unfortunately we can’t always do that.  When
you only have to deal with Emacs packages it’s fine to name your Emacs
DocBook viewer “docbook,” but the formula in this tap have to co-exist
with the rest of the Homebrew formula and we have
[the real DocBook](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/docbook.rb)
in the core repository.  So here’s the pattern used in this tap:

- If the package is primarily for a major or minor mode, suffix the
  name with `-mode`.

- If the package has a distinctive name and doesn’t conflict with
  formula in core repository or official taps, the original name can
  be used.

- Otherwise, suffix the name with `-emacs`.

# Some packages are options of other packages

One of the biggest advantages of using Homebrew instead of
`package.el` and MELPA is customizability.  It’s very easy with
Homebrew to switch between stable, development, and HEAD builds of a
package, and to build with or without certain options.  For that
reason, some packages which are distributed separately in MELPA do not
have their own formulae in this tap.  `markdown-mode+` and
`markdown-toc`, for example, can both by installed by passing options
to `brew install markdown-mode`:

```shell
brew install markdown-mode --with-plus # installs markdown-mode and
                                       # the markdown-mode+ extension
```

```shell
brew install markdown-mode --with-toc # installs markdown-mode and
                                      # markdown-toc
```

If you’re adding a package that improves or augments an existing
formula, consider adding it as an option to that existing formula.

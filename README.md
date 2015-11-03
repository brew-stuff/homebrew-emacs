homebrew-emacs
==============

homebrew-emacs is a [Homebrew](http://brew.sh) tap for Emacs packages.

It enables you to install [Emacs](https://gnu.org/s/emacs/) packages
like [flycheck][], [company][] and [markdown-mode][] using `brew
install`.

[flycheck]: http://www.flycheck.org
[company]: https://company-mode.github.io
[markdown-mode]: http://jblevins.org/projects/markdown-mode/

It’s an alternative to the built-in `package.el` system introduced in
Emacs 24.  Advantages include more customizable builds and (arguably)
a better interface.  The disadvantage is that there are currently many
fewer packages than are available through MELPA (but
[you can help fix that!](#where-is-___)).

Install
-------

You can install any of the packages in `./Formula` by prefixing them
with the tap name, `homebrew/emacs`:

```
brew install homebrew/emacs/helm
```

That will automatically “tap” the repository (which you can do
manually with `brew tap homebrew/emacs`), so then you can install formula
without prefixing:

```
brew install web-mode
```

`brew update` will then update formulae in your taps as well as those
in the core repository.

Configuration
-------------

Add this to your init file to make sure Emacs can find packages
installed by Homebrew:

```elisp
(let ((default-directory "/usr/local/share/emacs/site-lisp/"))
  (normal-top-level-add-subdirs-to-load-path))
```

If you installed Homebrew in a non-standard location (run `brew
--prefix` to check), replace `/usr/local` with the correct Homebrew
prefix.

"Where is ___?"
---------------

- **Magit** is in the core repository: `brew install magit`

- **AucTeX** is in the TeX tap: `brew install homebrew/tex/auctex`

- **That Neat New Package** can be added by you: `brew emacs
  neat-new-package` to get started.  Pull requests are always welcome!

Uninstall
---------

To uninstall homebrew-emacs, you just need to “untap” it:

```
brew untap homebrew/emacs
```

All files installed from this tap will still exist, but the formulae
will no longer be updated.

About
-----

This tap was originally created by
[Eric Davis](https://github.com/edavis), and is currently maintained
by [Alex Dunn](https://github.com/dunn).

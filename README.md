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
with the tap name, `dunn/emacs`:

```
brew install dunn/emacs/helm
```

That will automatically “tap” the repository (which you can do
manually with `brew tap dunn/emacs`), so then you can install formula
without prefixing:

```
brew install web-mode
```

`brew update` will then update formulae in your taps as well as those
in the core repository.

"Where is ___?"
---------------

- **AucTeX** is in the TeX tap: `brew install homebrew/tex/auctex`

- **ESS** is in the Science tap: `brew install homebrew/science/ess`

- **That Neat New Package** can be added by you: `brew emacs
  neat-new-package` to get started.  Pull requests are always welcome!

Uninstall
---------

To uninstall homebrew-emacs, you just need to “untap” it:

```
brew untap dunn/emacs
```

All files installed from this tap will still exist, but the formulae
will no longer be updated.

License
-------

Code is under the [BSD 2-clause "Simplified" License](https://github.com/Homebrew/homebrew-emacs/tree/master/LICENSE).

About
-----

This tap was originally created by [Eric Davis](https://github.com/edavis).

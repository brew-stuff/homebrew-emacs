homebrew-emacs
==============

homebrew-emacs is a [Homebrew](http://brew.sh) tap for Emacs packages.

It enables you to install [Emacs](https://gnu.org/s/emacs/) packages
like [flycheck][], [org-mode][] and [markdown-mode][] using `brew
install`.

Like [Eric Davis](https://github.com/edavis), who I forked this from,
I'm trying to use it as an alternative to the
[builtin ELPA package manager][elpa] that ships with Emacs 24.  The
advantage is more customizable builds and a much better interface.
Those who have many more packages will probably not find those
considerations compelling.

[flycheck]: http://www.flycheck.org
[elpa]: http://www.gnu.org/software/emacs/manual/html_node/emacs/Packages.html#Packages
[org-mode]: http://orgmode.org/
[markdown-mode]: http://jblevins.org/projects/markdown-mode/

Install
-------

You can install any of the packages in `./Formula` by prefixing them
with the tap name, `dunn/emacs`:

```
brew install dunn/emacs/smex
```

That will automatically "tap" the repository, so then you can install
formula without prefixing:

```
brew install flycheck
```

You can manually tap (and untap) as well:

```
brew tap dunn/emacs
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

Contributions
-------------

If there's a package you use that isn't included here, please consider
opening a pull request!

Once you've tapped this repository, you'll have an
[external command](https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/External-Commands.md)
`brew emacs <new-formula>` that will create a template to get you
started adding more Emacs packages.

Uninstall
---------

To uninstall homebrew-emacs, you just need to "untap" it:

```bash
$ brew untap dunn/emacs
```

All files installed from this tap will still exist, but the formulae
will no longer be updated.

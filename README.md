homebrew-emacs
==============

homebrew-emacs is a Homebrew tap for Emacs packages.

Install
-------

```bash
$ brew tap edavis/emacs
```

If a package in here also exists in the default repo, you must prefix
the name with `edavis/emacs/<pkg>` so it can be found.

For example:

```bash
$ brew install magit # default magit
$ brew install edavis/emacs/magit # this tap's magit
```

If a package only exists in here, you don't need to prefix it.

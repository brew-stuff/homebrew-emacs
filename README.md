homebrew-emacs
==============

homebrew-emacs is a Homebrew tap for Emacs packages.

Install
-------

```bash
$ brew tap edavis/emacs
```

Once tapped, use the `edavis/emacs/<pkg>` prefix whenever you need to
install a package:

```bash
$ brew install edavis/emacs/org-mode
$ brew install --HEAD edavis/emacs/magit
```

Configuration
-------------

By default, files are installed into
`/usr/local/share/emacs/site-lisp`. Make sure to add this directory to
your `load-path`:

```elisp
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp")
```

If a package has a lot of files, I install it into a sub-directory of
the above path. You'll need to add this sub-directory to your
`load-path` before anything will work.

Reading the formula should help if you run into any problems. If
something is particularly confusing, please open a issue or PR.

homebrew-emacs
==============

homebrew-emacs is a Homebrew tap for Emacs packages.

It enables you to install [Emacs](https://gnu.org/s/emacs/) packages
(e.g., [magit][], [org-mode][], [markdown-mode][], etc.) via
[Homebrew](http://brew.sh/).

It is an alternative to the [builtin ELPA package manager][elpa] that
ships with Emacs 24.

I started this project as I didn't want to have to learn another
package manager when I already use Homebrew for everything else.

[elpa]: http://www.gnu.org/software/emacs/manual/html_node/emacs/Packages.html#Packages
[magit]: https://github.com/magit/magit
[org-mode]: http://orgmode.org/
[markdown-mode]: http://jblevins.org/projects/markdown-mode/

Install
-------

You must "tap" homebrew-emacs before it can be used. This imports all
the formulae and makes them available for the `brew` command.

```bash
$ brew tap edavis/emacs
```

This only needs to be done once. Once tapped, "brew update" is enough
to update it.

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

Contributions
-------------

Right now this tap is mostly just packages I personally use.

But if there is a package you use that isn't included, please feel
free to request it by creating a new issue or submitting a pull request.

Uninstall
---------

To remove homebrew-emacs, you "untap" it:

```bash
$ brew untap edavis/emacs
```

All files installed from this tap will still exist, just the tap will
no longer be updated.

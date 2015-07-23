require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ApplescriptMode < EmacsFormula
  desc "Emacs major mode for editing AppleScript"
  homepage "http://macemacsjp.osdn.jp/documents/applescript-mode/"
  url "http://osdn.jp/projects/macemacsjp/scm/svn/blobs/580/applescript-mode/trunk/applescript-mode.el?export=raw"
  version "580"
  sha256 "5467537854486f75c686f09f3889b8f53e0011c2ab5a63d7879a73ebfad9d1a9"

  head "http://svn.osdn.jp/svnroot/macemacsjp/applescript-mode/trunk"

  depends_on :emacs

  def install
    byte_compile "applescript-mode.el"
    (share/"emacs/site-lisp/applescript-mode").install "applescript-mode.el",
                                                       "applescript-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'applescript-mode)
    (add-to-list 'auto-mode-alist '("\\.applescript$" . applescript-mode))
    (add-to-list 'interpreter-mode-alist '("osascript" . applescript-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "applescript-mode")
      (print (as-mode-version))
    EOS
    assert_match version.to_s, shell_output("emacs -batch -l #{testpath}/test.el 2>&1")
  end
end

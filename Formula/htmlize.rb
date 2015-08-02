require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Htmlize < EmacsFormula
  desc "Emacs package for converting text to HTML"
  homepage "http://www.us.xemacs.org/People/hrvoje.niksic/"
  url "http://fly.srk.fer.hr/~hniksic/emacs/htmlize.git",
      :tag => "release/1.47",
      :revision => "aa6e2f6dba6fdfa200c7c55efe29ff63380eac8f"

  head "http://fly.srk.fer.hr/~hniksic/emacs/htmlize.git"

  depends_on :emacs => "22.1"

  def install
    byte_compile "htmlize.el"
    (share/"emacs/site-lisp/htmlize").install "htmlize.el", "htmlize.elc"
    doc.install "NEWS"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/htmlize")
      (load "htmlize")
      (print htmlize-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

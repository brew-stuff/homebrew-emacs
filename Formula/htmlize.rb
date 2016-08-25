require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Htmlize < EmacsFormula
  desc "Emacs package for converting text to HTML"
  homepage "http://www.us.xemacs.org/People/hrvoje.niksic/"
  url "https://github.com/dunn/htmlize-mirror.git",
      :tag => "release/1.47",
      :revision => "aa6e2f6dba6fdfa200c7c55efe29ff63380eac8f"

  head "https://github.com/dunn/htmlize-mirror.git"

  depends_on :emacs => "22.1"

  def install
    byte_compile "htmlize.el"
    elisp.install "htmlize.el", "htmlize.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "htmlize")
      (print htmlize-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

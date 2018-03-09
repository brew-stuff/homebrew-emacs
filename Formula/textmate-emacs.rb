require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TextmateEmacs < EmacsFormula
  desc "Textmate-inspired minor mode"
  homepage "https://github.com/defunkt/textmate.el"
  url "https://github.com/defunkt/textmate.el/archive/v1.tar.gz"
  sha256 "1ce4475d4e80eed145a5055f25912d66e93b4ca10306679b09e9cc722f5bcec2"
  head "https://github.com/defunkt/textmate.el.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "15528cfd245976e10b7fde8aaa9d98a1fd99a93df3ccf69968fe2bc7fc145388" => :sierra
    sha256 "15528cfd245976e10b7fde8aaa9d98a1fd99a93df3ccf69968fe2bc7fc145388" => :el_capitan
    sha256 "15528cfd245976e10b7fde8aaa9d98a1fd99a93df3ccf69968fe2bc7fc145388" => :yosemite
  end

  depends_on EmacsRequirement

  def install
    byte_compile "textmate.el"
    elisp.install "textmate.el", "textmate.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "textmate")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

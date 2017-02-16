require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SuggestEmacs < EmacsFormula
  desc "Emacs package for discovering functions"
  homepage "https://github.com/Wilfred/suggest.el"
  url "https://github.com/Wilfred/suggest.el/archive/0.2.tar.gz"
  sha256 "02e2f87c00da1a95cdb436ba104d7fdffc1197207c38259318cd2026a1282b41"
  head "https://github.com/Wilfred/suggest.el.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca6e60e49dd5e5bcec7510577f16335d3d55083213eda37e176765d728ee0a86" => :sierra
    sha256 "ca6e60e49dd5e5bcec7510577f16335d3d55083213eda37e176765d728ee0a86" => :el_capitan
    sha256 "ca6e60e49dd5e5bcec7510577f16335d3d55083213eda37e176765d728ee0a86" => :yosemite
  end

  depends_on :emacs => "24.4"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/f-emacs"
  depends_on "dunn/emacs/loop-emacs"
  depends_on "dunn/emacs/s-emacs"

  def install
    byte_compile "suggest.el"
    elisp.install "suggest.el", "suggest.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/f-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/loop-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/s-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "suggest")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

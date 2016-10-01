require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FEmacs < EmacsFormula
  desc "Emacs filesystem API"
  homepage "https://github.com/rejeep/f.el"
  url "https://github.com/rejeep/f.el/archive/v0.19.0.tar.gz"
  sha256 "3abf449393f5b26a68520a7ebaa7823995868dfaedd83e3d4646710f902d2914"
  head "https://github.com/rejeep/f.el.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf38575bd6c720968b2d219fded449db08415a4579c115b5141d6e9641a3b44d" => :sierra
    sha256 "bf38575bd6c720968b2d219fded449db08415a4579c115b5141d6e9641a3b44d" => :el_capitan
    sha256 "bf38575bd6c720968b2d219fded449db08415a4579c115b5141d6e9641a3b44d" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/s-emacs"

  def install
    byte_compile "f.el"
    elisp.install "f.el", "f.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/s-emacs"].opt_elisp}")
      (load "f")
      (print (f-this-file))
    EOS
    assert_equal "\"#{testpath}/test.el\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

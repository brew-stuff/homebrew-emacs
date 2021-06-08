require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Swiper < EmacsFormula
  desc "Emacs isearch with an overview"
  homepage "https://github.com/abo-abo/swiper"
  url "https://github.com/abo-abo/swiper/archive/0.10.0.tar.gz"
  sha256 "b507579202e438103f2bd1925b4a5ddb9dccb85efdca5faf786d07f58521816e"
  head "https://github.com/abo-abo/swiper.git"

  depends_on EmacsRequirement => "24.3"

  def install
    system "make", "compile"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "swiper")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

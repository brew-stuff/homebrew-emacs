require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Swiper < EmacsFormula
  desc "Emacs isearch with an overview"
  homepage "https://github.com/abo-abo/swiper"
  url "https://github.com/abo-abo/swiper/archive/0.9.1.tar.gz"
  sha256 "3274d705c8bfe0347f548a560ba4dd6a4d3019a418f54b7def8e6725770e71a9"
  head "https://github.com/abo-abo/swiper.git"

  depends_on :emacs => "24.3"

  def install
    system "make", "compile"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "swiper")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

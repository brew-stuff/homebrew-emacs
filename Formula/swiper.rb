require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Swiper < EmacsFormula
  desc "Emacs isearch with an overview"
  homepage "https://github.com/abo-abo/swiper"
  url "https://github.com/abo-abo/swiper/archive/0.9.0.tar.gz"
  sha256 "963b9be7494981266793f202fdbe246e040ad4a5c647e3c9d77ac47518a2c9c6"
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

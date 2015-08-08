require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Swiper < EmacsFormula
  desc "Emacs isearch with an overview"
  homepage "https://github.com/abo-abo/swiper"
  url "https://github.com/abo-abo/swiper/archive/0.6.0.tar.gz"
  sha256 "ebe53ad7a55a63295ddb29bd5aca2c12ed74f5e21066c325f0cedabb0ba2a199"
  head "https://github.com/abo-abo/swiper.git"

  option "with-helm", "Use helm as the backend instead of ivy"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/helm" if build.with? "helm"

  resource "swiper-helm" do
    url "https://github.com/abo-abo/swiper-helm/archive/0.1.0.tar.gz"
    sha256 "8db4b0d7835cd71f17ae7fcc2642208270b332c38cc06f44fca5f7b3e674d8ab"
  end

  def install
    system "make", "compile"
    system "make", "test"
    (share/"emacs/site-lisp/swiper").install Dir["*.el"], Dir["*.elc"]
    doc.install "README.md"

    if build.with? "helm"
      resource("swiper-helm").stage do
        (share/"emacs/site-lisp/swiper").install "swiper-helm.el"
        doc.install "README.md" => "README-helm.md"
      end
    end
  end

  def caveats
    helm = build.with?("helm") ? "-helm" : ""
    <<-EOS.undent
      Add the following to your init file:

      (require 'swiper#{helm})
      (global-set-key "\\C-s" 'swiper#{helm})
      (global-set-key "\\C-r" 'swiper#{helm})
    EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/swiper")
      (load "swiper")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

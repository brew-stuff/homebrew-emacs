require File.expand_path("../../Homebrew/emacs-formula", __FILE__)

class Hydra < EmacsFormula
  desc "Emacs package for grouping commands under a common prefix"
  homepage "https://github.com/abo-abo/hydra"
  url "https://github.com/abo-abo/hydra/archive/0.13.0.tar.gz"
  sha256 "93023bd90722cf5e12134c2cfa6b9fd640224641e8afde41ea47caf1a89cd6a7"
  head "https://github.com/abo-abo/hydra.git"

  depends_on :emacs => "24.1"

  def install
    system "make", "test"
    # `make compile` is interactive and deletes compiled files afterward
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/hydra").install Dir["*.el"], Dir["*.elc"]
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "hydra")
      (defhydra hydra-zoom (global-map "<f2>")
        "zoom"
        ("g" text-scale-increase "in")
        ("l" text-scale-decrease "out"))
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

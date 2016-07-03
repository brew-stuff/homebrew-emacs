require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HydraEmacs < EmacsFormula
  desc "Group Emacs commands under a common prefix"
  homepage "https://github.com/abo-abo/hydra"
  url "https://github.com/abo-abo/hydra/archive/0.13.6.tar.gz"
  sha256 "800e3954c61aa5cbc0274afd246b334446c1aef12d117dca2da33e5410dce514"
  head "https://github.com/abo-abo/hydra.git"

  depends_on :emacs => "24.1"

  def install
    system "make", "test"
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "hydra")
      (defhydra hydra-zoom (global-map "<f2>")
        "zoom"
        ("g" text-scale-increase "in")
        ("l" text-scale-decrease "out"))
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

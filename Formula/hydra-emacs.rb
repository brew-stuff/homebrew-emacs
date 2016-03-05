require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HydraEmacs < EmacsFormula
  desc "Group Emacs commands under a common prefix"
  homepage "https://github.com/abo-abo/hydra"
  url "https://elpa.gnu.org/packages/hydra-0.13.5.tar"
  sha256 "c898c82946efdab48f162980a6f86b947ea0d78bed6f00d78cab3583bdbc016f"
  head "https://github.com/abo-abo/hydra.git"

  depends_on :emacs => "24.1"

  def install
    system "make", "test" if build.head?
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HydraEmacs < EmacsFormula
  desc "Group Emacs commands under a common prefix"
  homepage "https://github.com/abo-abo/hydra"
  head "https://github.com/abo-abo/hydra.git"

  stable do
    url "https://github.com/abo-abo/hydra/archive/0.13.3.tar.gz"
    sha256 "dd6b8fcb633e0a9100b7a46f0d94dd71e9f52d526cbacd48ee4c80ad1b9091b6"

    # fix `make test` on Emacs 25
    patch do
      url "https://github.com/abo-abo/hydra/commit/0712176e9b0cbab178e2d20aeab7711188ce8ee7.diff"
      sha256 "a82c092c640d7b8be8652b43ecfb7bfbdb10e20f78f5ec80e7161bff29779a64"
    end
  end

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

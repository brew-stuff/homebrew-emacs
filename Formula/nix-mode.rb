require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class NixMode < EmacsFormula
  desc "Major mode for editing Nix files"
  homepage "https://github.com/NixOS/nix-mode"
  url "https://github.com/NixOS/nix-mode/archive/v1.2.1.tar.gz"
  sha256 "a555cc180b3134063aa515a834407295c168b1934f25df9cf8da84dbce636637"
  version_scheme 1
  head "https://github.com/NixOS/nix.git"

  bottle :disable

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/mmm-mode"

  def install
    if build.stable?
      byte_compile Dir["*.el"]
    else
      system "make", "test"
      system "make", "compile"
    end
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "nix-mode")
      (nix-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

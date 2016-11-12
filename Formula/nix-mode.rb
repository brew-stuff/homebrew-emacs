require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class NixMode < EmacsFormula
  desc "Major mode for editing Nix files"
  homepage "https://github.com/NixOS/nix/tree/master/misc/emacs"
  url "https://github.com/NixOS/nix/archive/1.11.4.tar.gz"
  sha256 "b0591965aa2478e4969ce30baaa298a3e1a85ec2efd4bf4581f5f3f1d36f5cb6"
  head "https://github.com/NixOS/nix.git"

  depends_on :emacs => "24.1"

  def install
    cd "misc/emacs" do
      byte_compile "nix-mode.el"
      elisp.install "nix-mode.el", "nix-mode.elc"
      prefix.install "README"
    end
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

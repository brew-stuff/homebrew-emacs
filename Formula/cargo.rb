require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Cargo < EmacsFormula
  desc "Emacs Minor Mode for Cargo, Rust's Package Manager."
  homepage "https://github.com/kwrooijen/cargo.el"
  url "https://github.com/kwrooijen/cargo.el/archive/0.2.0.tar.gz"
  sha256 "e4e966615db86d51e3f3a7dcfca24d21d4725bac4d9a1a9ef61bddcf6e95100b"
  head "https://github.com/kwrooijen/cargo.el.git"

  depends_on :emacs => "24.3"
  depends_on "rust-mode"

  def install
    byte_compile "cargo.el", "cargo-process.el"
    elisp.install "cargo.el", "cargo.elc", "cargo-process.el", "cargo-process.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/rust-mode"].opt_elisp}")
      (load "cargo")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

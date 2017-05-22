require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Cargo < EmacsFormula
  desc "Emacs Minor Mode for Cargo, Rust's Package Manager."
  homepage "https://github.com/kwrooijen/cargo.el"
  url "https://melpa.org/packages/cargo-20160525.519.tar"
  sha256 "1bfa9cf6e07fc0890304b598f33a4e01c768627dbd42ab4672439a1a1a4a5086"
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
      (load "cargo")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

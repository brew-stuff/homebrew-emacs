require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CargoMode < EmacsFormula
  desc "Emacs Minor Mode for Cargo, Rust's Package Manager."
  homepage "https://github.com/kwrooijen/cargo.el"
  url "https://github.com/kwrooijen/cargo.el/archive/0.4.0.tar.gz"
  sha256 "78bfeb12b224199517e7e154af5e877f83a0220526738798422afebaeb11fc51"
  head "https://github.com/kwrooijen/cargo.el.git"

  bottle :disable

  depends_on :emacs => "24.3"
  depends_on "rust-mode"

  def install
    byte_compile "cargo.el", "cargo-process.el"
    elisp.install "cargo.el", "cargo.elc",
                  "cargo-process.el", "cargo-process.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/rust-mode"].opt_elisp}")
      (load "cargo")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

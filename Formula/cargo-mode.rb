require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CargoMode < EmacsFormula
  desc "Emacs Minor Mode for Cargo, Rust's Package Manager."
  homepage "https://github.com/kwrooijen/cargo.el"
  url "https://github.com/kwrooijen/cargo.el/archive/0.4.1.tar.gz"
  sha256 "d15b810a00fb2d4340abe833501554dbd8fd28679dcb02a09d82d82865934d01"
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

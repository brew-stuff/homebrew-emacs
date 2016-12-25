require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RustMode < EmacsFormula
  desc "Emacs major mode for editing Rust code"
  homepage "https://github.com/rust-lang/rust-mode"
  url "https://github.com/rust-lang/rust-mode/archive/0.3.0.tar.gz"
  sha256 "6ec0c86eb9a19b850d6e4a42db56f80ff9586cc2013d8b2f9a652fc5f0e7be45"
  head "https://github.com/rust-lang/rust-mode.git"

  depends_on :emacs => "24"

  def install
    ENV["EMACS"] = which "emacs"
    system "./run_rust_emacs_tests.sh"
    byte_compile "rust-mode.el"
    (share/"emacs/site-lisp/rust-mode").install "rust-mode.el",
                                                "rust-mode.elc"
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/rust-mode")
      (load "rust-mode")
      (rust-mode)
      (rust-mode-reload)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

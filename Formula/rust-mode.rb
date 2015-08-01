require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RustMode < EmacsFormula
  desc "Emacs major mode for editing Rust code"
  homepage "https://github.com/rust-lang/rust-mode"
  head "https://github.com/rust-lang/rust-mode.git"

  depends_on :emacs => "23.1"

  def install
    ENV["EMACS"] = which "emacs"
    system "./run_rust_emacs_tests.sh"
    byte_compile "rust-mode.el"
    (share/"emacs/site-lisp/rust-mode").install "rust-mode.el",
                                                "rust-mode.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (autoload 'rust-mode "rust-mode" nil t)
    (add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "rust-mode")
      (rust-mode)
      (rust-mode-reload)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

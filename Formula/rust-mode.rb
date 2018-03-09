require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RustMode < EmacsFormula
  desc "Emacs major mode for editing Rust code"
  homepage "https://github.com/rust-lang/rust-mode"
  url "https://github.com/rust-lang/rust-mode/archive/0.3.0.tar.gz"
  sha256 "6ec0c86eb9a19b850d6e4a42db56f80ff9586cc2013d8b2f9a652fc5f0e7be45"
  head "https://github.com/rust-lang/rust-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eefadd0a60b20e5c553892418e0c20b7b9a5d67a33b2516c83fcc128ea6f0db" => :sierra
    sha256 "f8ab2b552e3323c0c87ebfec39f25d3988f7586f90792001b7518848373a0083" => :el_capitan
    sha256 "f8ab2b552e3323c0c87ebfec39f25d3988f7586f90792001b7518848373a0083" => :yosemite
  end

  depends_on EmacsRequirement => "24"

  def install
    ENV["EMACS"] = which "emacs"
    system "./run_rust_emacs_tests.sh"
    byte_compile "rust-mode.el"
    (share/"emacs/site-lisp/rust-mode").install "rust-mode.el",
                                                "rust-mode.elc"
    doc.install "README.md"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/rust-mode")
      (load "rust-mode")
      (rust-mode)
      (rust-mode-reload)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

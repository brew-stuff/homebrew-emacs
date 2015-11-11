require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class BundlerEmacs < EmacsFormula
  desc "Bundler helpers for Emacs"
  homepage "https://github.com/tobiassvn/bundler.el"
  head "https://github.com/tobiassvn/bundler.el.git"

  stable do
    url "https://github.com/tobiassvn/bundler.el/archive/v1.1.0.tar.gz"
    sha256 "c67b505de738db713334f8a5590ad64826d4f58fdd2d3a3b314e6871f33d178a"

    patch do
      url "https://github.com/tobiassvn/bundler.el/commit/8adfeecc1f110b41a62a85643cd30ff9e721c203.diff"
      sha256 "078590331ffebad76b02202c40d38753e17783f57316f35b7ddc7ef59fb32963"
    end
  end

  depends_on :emacs
  depends_on "homebrew/emacs/inf-ruby"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    byte_compile "bundler.el"
    elisp.install "bundler.el", "bundler.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/inf-ruby"].opt_elisp}")
      (load "bundler")
      (print (minibuffer-prompt-width))
    EOS

    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

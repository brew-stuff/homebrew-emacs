require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LoadDir < EmacsFormula
  desc "Package for loading all Emacs Lisp files in a directory"
  homepage "https://elpa.gnu.org/packages/load-dir.html"
  url "https://elpa.gnu.org/packages/load-dir-0.0.5.el"
  sha256 "85dd17294a44706c8a3fce056e4224f8eeb00feb74c1e7cbfadf9612ec8de594"

  bottle :disable

  depends_on :emacs => "24.3"

  def install
    mv "load-dir-#{version}.el", "load-dir.el"
    byte_compile "load-dir.el"
    elisp.install "load-dir.el", "load-dir.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "load-dir")
      (load-dir-one "#{elisp}")
      (print load-dir-loaded)
    EOS
    assert_equal "(\"#{elisp}/load-dir\")",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

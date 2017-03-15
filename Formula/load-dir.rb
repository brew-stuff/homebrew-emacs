require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LoadDir < EmacsFormula
  desc "Package for loading all Emacs Lisp files in a directory"
  homepage "https://elpa.gnu.org/packages/load-dir.html"
  url "https://elpa.gnu.org/packages/load-dir-0.0.4.el"
  sha256 "440549cc97aedb1488cd30d2b09baaaeba10d357d8389292fdaf4affa20fa913"

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
      (require 'cl-extra)
      (load "load-dir")
      (load-dir-one "#{elisp}")
      (print load-dir-loaded)
    EOS
    assert_equal "(\"#{elisp}/load-dir\")",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

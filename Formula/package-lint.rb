require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PackageLint < EmacsFormula
  desc "Linting library for elisp package metadata"
  homepage "https://github.com/purcell/package-lint"
  url "https://github.com/purcell/package-lint/archive/0.5.tar.gz"
  sha256 "ee79cca86c23ba8bb817a5eb3dbd4c62a0ae0e3beaa3443b3a74b6d5777dc61a"
  head "https://github.com/purcell/package-lint.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    # https://github.com/purcell/package-lint/blob/master/run-tests.sh#L31-L33
    ENV["EMACS_LINT_IGNORE"] = "1" if Emacs.version < Version.create("24.3")
    system "./run-tests.sh"
    byte_compile "package-lint.el"
    elisp.install "package-lint.el", "package-lint.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "package-lint")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

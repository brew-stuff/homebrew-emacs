require File.expand_path("../Homebrew/emacs_formula", __dir__)

class ExecPathFromShell < EmacsFormula
  desc "Import environment variables into Emacs"
  homepage "https://github.com/purcell/exec-path-from-shell"
  url "https://github.com/purcell/exec-path-from-shell/archive/1.11.tar.gz"
  sha256 "75861413984557c02cca01c4484b9b17a4c237cd66778e5a58847637f7c3f8ab"
  head "https://github.com/purcell/exec-path-from-shell.git"

  depends_on EmacsRequirement

  def install
    byte_compile "exec-path-from-shell.el"
    elisp.install "exec-path-from-shell.el", "exec-path-from-shell.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "exec-path-from-shell")
      (print (exec-path-from-shell-copy-env "HOME"))
    EOS
    assert_equal "\"#{testpath}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

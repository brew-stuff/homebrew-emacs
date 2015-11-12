require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class ExecPathFromShell < EmacsFormula
  desc "Import environment variables into Emacs"
  homepage "https://github.com/purcell/exec-path-from-shell"
  url "https://github.com/purcell/exec-path-from-shell/archive/1.10.tar.gz"
  sha256 "83e465e1deab6ad0d1c3f6ba83dcb8bd4d38ed32588c1c2ca9ba3f77b0dacd98"
  head "https://github.com/purcell/exec-path-from-shell.git"

  depends_on :emacs

  def install
    byte_compile "exec-path-from-shell.el"
    elisp.install "exec-path-from-shell.el", "exec-path-from-shell.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "exec-path-from-shell")
      (print (exec-path-from-shell-copy-env "HOME"))
    EOS
    assert_equal "\"#{testpath}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

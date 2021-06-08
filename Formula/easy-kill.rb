require File.expand_path("../Homebrew/emacs_formula", __dir__)

class EasyKill < EmacsFormula
  desc "Replacement for kill-ring-save in Emacs"
  homepage "https://github.com/leoliu/easy-kill"
  url "https://github.com/leoliu/easy-kill/archive/0.9.3.tar.gz"
  sha256 "4dcac3a01c2d4194c4907e2248e1685ef4b47556de98e7809a40244da3d3eb42"
  head "https://github.com/leoliu/easy-kill.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    system "make", "test"
    (share/"emacs/site-lisp/easy-kill").install "easy-kill.el",
                                                "easy-kill.elc"
    doc.install "README.rst"
  end

  def caveats
    <<~EOS
      Add the following to your init file:

      (require 'easy-kill)
      (global-set-key [remap kill-ring-save] 'easy-kill)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/easy-kill")
      (load "easy-kill")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

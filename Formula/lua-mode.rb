require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LuaMode < EmacsFormula
  desc "Emacs major mode for Lua"
  homepage "https://immerrr.github.io/lua-mode"
  url "https://github.com/immerrr/lua-mode/archive/v20140514.tar.gz"
  sha256 "eed3ee2841ac1c5a563fc30425a26def91b1d44f1862d2d5e10fe7f769d61aea"
  head "https://github.com/immerrr/lua-mode.git"

  depends_on :emacs

  def install
    byte_compile "lua-mode.el"
    (share/"emacs/site-lisp/lua-mode").install "lua-mode.el",
                                               "lua-mode.elc"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (autoload 'lua-mode "lua-mode" "Lua editing mode." t)
    (add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))
    (add-to-list 'interpreter-mode-alist '("lua" . lua-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/lua-mode")
      (load "lua-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

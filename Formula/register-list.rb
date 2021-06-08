require File.expand_path("../Homebrew/emacs_formula", __dir__)

class RegisterList < EmacsFormula
  desc "Emacs functions to view and edit registers"
  homepage "http://elpa.gnu.org/packages/register-list.html"
  url "http://elpa.gnu.org/packages/register-list-0.1.el"
  sha256 "506a53515bca5e4bf512484f7a4451ed21195df8cb557a315ee2c2ed4975efab"

  depends_on EmacsRequirement

  def install
    mv "register-list-#{version}.el", "register-list.el"
    byte_compile "register-list.el"
    (share/"emacs/site-lisp/register-list").install "register-list.el",
                                                    "register-list.elc"
  end

  def caveats
    <<~EOS
      Add the following to your init file:

      (require 'register-list)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/register-list")
      (load "register-list")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class DbusCodegen < EmacsFormula
  desc "Lisp code generation for D-Bus"
  homepage "http://elpa.gnu.org/packages/dbus-codegen.html"
  url "http://elpa.gnu.org/packages/dbus-codegen-0.1.el"
  sha256 "fc571aa29a09063995e1df525e001b1196f5193b8bbb1f007c141a9b0d9327be"
  head "https://github.com/ueno/dbus-codegen-el.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "dbus-codegen-#{version}.el", "dbus-codegen.el" if build.stable?
    byte_compile "dbus-codegen.el"
    (share/"emacs/site-lisp/dbus-codegen").install "dbus-codegen.el",
                                                   "dbus-codegen.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/dbus-codegen")
      (load "dbus-codegen")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

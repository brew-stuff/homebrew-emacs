require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Timerfunctions < EmacsFormula
  desc "Enhanced version of timer.el"
  homepage "http://elpa.gnu.org/packages/timerfunctions.html"
  url "http://elpa.gnu.org/packages/timerfunctions-1.4.2.el"
  sha256 "854bc3716a77db2bc5f7f264166f6156e7a3b3c3296e1adface15f04b6455888"

  depends_on EmacsRequirement

  def install
    mv "timerfunctions-#{version}.el", "timerfunctions.el"
    byte_compile "timerfunctions.el"
    (share/"emacs/site-lisp/timerfunctions").install "timerfunctions.el",
                                                      "timerfunctions.elc"
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (require 'timerfunctions)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/timerfunctions")
      (load "timerfunctions")
      (print timerfunctions-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

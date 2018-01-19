require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Windresize < EmacsFormula
  desc "Interactively resize windows in Emacs"
  homepage "http://elpa.gnu.org/packages/windresize.html"
  url "http://elpa.gnu.org/packages/windresize-0.1.el"
  sha256 "7d448781cc2a717127c2f905494e9bf5a95b43ded8bd5f803e775a838c76ab2c"

  depends_on EmacsRequirement

  def install
    mv "windresize-#{version}.el", "windresize.el"
    byte_compile "windresize.el"
    (share/"emacs/site-lisp/windresize").install "windresize.el",
                                                 "windresize.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'windresize)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/windresize")
      (load "windresize")
      (print windresize-version)
    EOS
    assert_match version.to_s, shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

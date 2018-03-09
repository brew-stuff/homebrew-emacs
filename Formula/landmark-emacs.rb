require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LandmarkEmacs < EmacsFormula
  desc "Neural-network robot that learns landmarks"
  homepage "http://elpa.gnu.org/packages/landmark.html"
  url "http://elpa.gnu.org/packages/landmark-1.0.el"
  sha256 "64b7a0cfcb6926ea36a248c14cf39d1d0dce2cf29449f2a07c6fdbc07ea2e157"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    mv "landmark-#{version}.el", "landmark.el"
    byte_compile "landmark.el"
    (share/"emacs/site-lisp/landmark").install "landmark.el",
                                               "landmark.elc"
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (require 'landmark)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/landmark")
      (load "landmark")
      (landmark-test-run)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

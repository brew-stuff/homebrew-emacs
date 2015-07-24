require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class EpochView < EmacsFormula
  desc "Emacs minor mode to convert Unix epoch times"
  homepage "http://elpa.gnu.org/packages/epoch-view.html"
  url "http://elpa.gnu.org/packages/epoch-view-0.0.1.el"
  sha256 "dd6d15ce3d847af00102aab889e1d7353d7323bfa27a8907dac4a5e77d2ec2f3"

  depends_on :emacs

  def install
    mv "epoch-view-#{version}.el", "epoch-view.el"
    byte_compile "epoch-view.el"
    (share/"emacs/site-lisp/epoch-view").install "epoch-view.el",
                                                 "epoch-view.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'epoch-view)
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "epoch-view")
      (epoch-view-turn-on)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

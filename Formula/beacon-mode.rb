require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class BeaconMode < EmacsFormula
  desc "Highlight the cursor when an Emacs window scrolls"
  homepage "https://github.com/Malabarba/beacon"
  url "http://elpa.gnu.org/packages/beacon-1.2.1.el"
  sha256 "a68688398cd281022f396894f4dac1a16e06336173d966fe9564cef9d5b92002"
  head "https://github.com/Malabarba/beacon.git"

  depends_on :emacs
  depends_on "homebrew/emacs/seq" if Emacs.version < 25

  def install
    mv "beacon-#{version}.el", "beacon.el" if build.stable?

    byte_compile "beacon.el"
    elisp.install "beacon.el", "beacon.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/seq"].opt_elisp}")
      (load "beacon")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

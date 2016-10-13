require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class BeaconMode < EmacsFormula
  desc "Highlight the cursor when an Emacs window scrolls"
  homepage "https://github.com/Malabarba/beacon"
  url "https://elpa.gnu.org/packages/beacon-1.3.2.el"
  sha256 "f62c7c19129def3e2942e6fbaf9e65222c707787eb088750a936da9c3b52b251"
  head "https://github.com/Malabarba/beacon.git"

  depends_on :emacs
  depends_on "homebrew/emacs/seq" if Emacs.version < Version.create("25")

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

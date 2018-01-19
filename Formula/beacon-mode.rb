require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class BeaconMode < EmacsFormula
  desc "Highlight the cursor when an Emacs window scrolls"
  homepage "https://github.com/Malabarba/beacon"
  url "https://elpa.gnu.org/packages/beacon-1.3.3.el"
  sha256 "026894f050904a91f0f4ef05966b2247ad3ff579a55e668bc5c1b18bdc752483"
  head "https://github.com/Malabarba/beacon.git"

  bottle :disable

  depends_on EmacsRequirement
  depends_on "dunn/emacs/seq" if Emacs.version < Version.create("25")

  def install
    mv "beacon-#{version}.el", "beacon.el" if build.stable?

    byte_compile "beacon.el"
    elisp.install "beacon.el", "beacon.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/seq"].opt_elisp}")
      (load "beacon")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TnfaEmacs < EmacsFormula
  desc "Tagged non-deterministic finite-state automata"
  homepage "http://www.dr-qubit.org/Emacs_data_structure_packages.html"
  url "https://elpa.gnu.org/packages/tNFA-0.1.1.el"
  sha256 "ba691bbbed5328939ca3a562a9231640502dd657f99c2f68295338f428bac406"

  bottle do
    cellar :any_skip_relocation
    sha256 "22f3bc230e6877a5df9f11eb6f737b83737229780185a5495d07e6be2803f06f" => :sierra
    sha256 "22f3bc230e6877a5df9f11eb6f737b83737229780185a5495d07e6be2803f06f" => :el_capitan
    sha256 "22f3bc230e6877a5df9f11eb6f737b83737229780185a5495d07e6be2803f06f" => :yosemite
  end

  depends_on :emacs
  depends_on "homebrew/emacs/queue-emacs"

  def install
    mv "tNFA-#{version}.el", "tNFA.el"
    byte_compile "tNFA.el"
    elisp.install "tNFA.el", "tNFA.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["queue-emacs"].opt_elisp}")
      (load "tNFA")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

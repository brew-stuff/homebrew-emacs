require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LedgerMode < EmacsFormula
  desc "Emacs Lisp files for interacting with the C++Ledger accounting system"
  homepage "https://github.com/ledger/ledger-mode"
  url "http://melpa-stable.milkbox.net/packages/ledger-mode-3.1.1.tar"
  sha256 "dd0260ebdbd25eda2e4c193332030f8e6602e599d100dcf136ad5b4bc8b0abf3"
  head "https://github.com/ledger/ledger-mode.git"

  depends_on :emacs => "22.1"

  def install
    byte_compile "ledger-mode.el"
    elisp.install "ledger-mode.el", "ledger-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "ledger-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

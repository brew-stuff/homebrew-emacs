require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class LedgerMode < EmacsFormula
  desc "Emacs major mode for Ledger, the command-line accounting system"
  homepage "https://github.com/ledger/ledger-mode"
  url "https://github.com/ledger/ledger-mode/archive/v3.1.1.tar.gz"
  sha256 "cb1087bf89beb3e38d51c621604c67ec2995fada6e819904ef5276231140cf74"
  head "https://github.com/ledger/ledger-mode.git"

  depends_on :emacs
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    elisp.install Dir["*.el"], Dir["*.elc"]
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

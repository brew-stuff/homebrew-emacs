require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class VlfMode < EmacsFormula
  desc "Emacs minor mode for viewing very large files"
  homepage "https://github.com/m00natic/vlfi"
  url "https://github.com/m00natic/vlfi/archive/1.7.tar.gz"
  sha256 "098c5d438b31c5b83a51ffed09d47c4eead2733dc68fd9bb7d5eebe56450f899"
  head "https://github.com/m00natic/vlfi.git"

  depends_on EmacsRequirement => "23.1"

  def install
    byte_compile Dir["*.el"]
    (share/"emacs/site-lisp/vlf").install Dir["*.el"], Dir["*.elc"]
    doc.install "README.org"
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (require 'vlf-setup)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/vlf")
      (load "vlf-setup")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

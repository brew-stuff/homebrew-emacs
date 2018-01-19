require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HeapEmacs < EmacsFormula
  desc "Emacs implementation of the ternary heap data structure"
  homepage "http://www.dr-qubit.org/emacs_data-structures.html"
  url "https://elpa.gnu.org/packages/heap-0.5.el"
  sha256 "afe7cf0129833682bf7042ff5fae7dfa669353199b1ecf6441eca0e806071b8f"

  bottle :disable

  depends_on EmacsRequirement

  def install
    mv "heap-#{version}.el", "heap.el"
    byte_compile "heap.el"
    elisp.install "heap.el", "heap.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "heap")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

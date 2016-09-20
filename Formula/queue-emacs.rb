require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class QueueEmacs < EmacsFormula
  desc "Emacs implementation of the queue data structure"
  homepage "http://www.dr-qubit.org/Emacs_data_structure_packages.html"
  url "https://elpa.gnu.org/packages/queue-0.1.1.el"
  sha256 "210daf744931abd007e2ad0caae0990ecfa09b6509402b9c6238398bbb23824b"

  depends_on :emacs

  def install
    mv "queue-#{version}.el", "queue.el"
    byte_compile "queue.el"
    elisp.install "queue.el", "queue.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "queue")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

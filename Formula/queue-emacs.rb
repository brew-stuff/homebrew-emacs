require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class QueueEmacs < EmacsFormula
  desc "Emacs implementation of the queue data structure"
  homepage "http://www.dr-qubit.org/emacs_data-structures.html"
  url "https://elpa.gnu.org/packages/queue-0.2.el"
  sha256 "6be60aa5f429e0e3e2c000563356855e3edb7f5378ebf8499ed35aac1141a233"

  bottle :disable

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

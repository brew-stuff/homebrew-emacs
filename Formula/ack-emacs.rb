require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AckEmacs < EmacsFormula
  desc "Emacs interface to Ack-like tools"
  homepage "https://github.com/leoliu/ack-el"
  url "http://elpa.gnu.org/packages/ack-1.5.tar"
  sha256 "395172b1b930eed0ea61911f6036a9b46ad29dd0b267e05b3ce213e223d4926a"
  head "https://github.com/leoliu/ack-el.git"

  depends_on EmacsRequirement => "24.1"

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "ack")
      (ack-skel-file)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

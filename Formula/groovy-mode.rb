require File.expand_path("../Homebrew/emacs_formula", __dir__)

class GroovyMode < EmacsFormula
  desc "Modes for Groovy and Groovy-related technology"
  homepage "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes"
  url "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes/archive/1.0.2.tar.gz"
  sha256 "4888b6ec93bec53a4b6fd4e706dec209679c0d17ba3371fc5e4cd4fea28861e1"
  head "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes.git"

  depends_on EmacsRequirement => "22.1"

  def install
    el_array = %w[groovy-mode.el groovy-electric.el inf-groovy.el]
    byte_compile el_array
    elisp.install el_array, Dir["*.elc"]

    prefix.install "gpl-3.0.txt"
  end

  def caveats
    <<~EOS
      Grails mode was not installed, as it currently has additional dependencies
      not available in Homebrew.
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "groovy-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

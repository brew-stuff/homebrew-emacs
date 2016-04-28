require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GroovyMode < EmacsFormula
  desc "Modes for Groovy and Groovy-related technology"
  homepage "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes"
  head "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes.git"

  stable do
    url "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes/archive/v-1.0.0.tar.gz"
    sha256 "601444423056310f5b043c8f6006cec936f2092226ea45717a648b9bf05e4615"

    patch do
      url "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes/commit/792b0c5a72f7500c8e07f37b77b96fd1f91ac61b.diff"
      sha256 "163a42603f7c4e178359b4310ce1fa7d9e9011304f2b2f32d4e884d3ed16f0a8"
    end
  end

  depends_on :emacs => "22.1"

  def install
    el_array = %w[groovy-mode.el groovy-electric.el inf-groovy.el]
    byte_compile el_array
    elisp.install el_array, Dir["*.elc"]

    prefix.install "gplv2.txt"
  end

  def caveats; <<-EOS.undent
    Grails mode was not installed, as it currently has additional dependencies
    not available in Homebrew.
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "groovy-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

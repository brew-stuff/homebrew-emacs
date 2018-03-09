require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class MemoryUsageEmacs < EmacsFormula
  desc "Tools for analyzing Emacs' memory usage"
  homepage "http://elpa.gnu.org/packages/memory-usage.html"
  url "http://elpa.gnu.org/packages/memory-usage-0.2.el"
  sha256 "92bf00d1f12cde4367ccd85ed6afddfc0642a185f0bcb1fb5601b67cf5591c0f"

  depends_on EmacsRequirement

  def install
    mv "memory-usage-#{version}.el", "memory-usage.el"
    byte_compile "memory-usage.el"
    (share/"emacs/site-lisp/memory-usage").install "memory-usage.el",
                                                   "memory-usage.elc"
  end

  def caveats; <<~EOS
    Add the following to your init file:

    (require 'memory-usage)
  EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/memory-usage")
      (load "memory-usage")
      (memory-usage)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

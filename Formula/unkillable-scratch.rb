require File.expand_path("../Homebrew/emacs_formula", __dir__)

class UnkillableScratch < EmacsFormula
  desc "Prevent *scratch* etc. from being killed"
  homepage "https://github.com/EricCrosson/unkillable-scratch"
  url "https://github.com/EricCrosson/unkillable-scratch/archive/v0.1.tar.gz"
  sha256 "9e3ade0a2a1041d63e558de51d4f0f519377f292125feaf623e33ddac331ee4f"
  head "https://github.com/EricCrosson/unkillable-scratch.git"

  depends_on EmacsRequirement => "22.1"

  def install
    byte_compile "unkillable-scratch.el"
    (share/"emacs/site-lisp/unkillable-scratch").install Dir["*.el"],
                                                         Dir["*.elc"]
    doc.install "README.md"
  end

  def caveats
    <<~EOS
      Add the following to your init file:

      (require 'unkillable-scratch)
      (unkillable-scratch 1)
    EOS
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{share}/emacs/site-lisp/unkillable-scratch")
      (load "unkillable-scratch")
      (unkillable-scratch 1)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

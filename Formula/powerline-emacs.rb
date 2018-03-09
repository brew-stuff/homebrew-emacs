require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PowerlineEmacs < EmacsFormula
  desc "Emacs version of the Vim powerline"
  homepage "https://github.com/milkypostman/powerline"
  url "https://github.com/milkypostman/powerline/archive/2.4.tar.gz"
  sha256 "cb4fff38648913f865c7085c9ab9708468940c3d05a8aee1b1d77fb96630c0c5"
  head "https://github.com/milkypostman/powerline.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "powerline")
      (powerline-default-theme)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

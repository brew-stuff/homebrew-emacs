require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Vdiff < EmacsFormula
  desc "Visual diff tool for Emacs, similar to vimdiff"
  homepage "https://github.com/justbur/emacs-vdiff"
  url "https://elpa.gnu.org/packages/vdiff-0.2.3.el"
  sha256 "1fa7ec822092f92ce631cd15eccd28c4d1a1dd6fc08d47f7766b8a0affd7fca4"
  head "https://github.com/justbur/emacs-vdiff.git"

  depends_on EmacsRequirement => "24.4"
  depends_on "hydra-emacs"
  depends_on "magit" => :optional

  resource "vdiff-magit" do
    url "https://github.com/justbur/emacs-vdiff-magit/archive/v0.3.1.tar.gz"
    sha256 "c979548115a018dbe8f30b335ca452435ad8b6c220ac53019d5136608bdeb553"
  end

  def install
    mv "vdiff-#{version}.el", "vdiff.el"

    if build.with? "magit"
      resource("vdiff-magit").stage do
        byte_compile "vdiff-magit.el"
        elisp.install "vdiff-magit.el", "vdiff-magit.elc"
      end
    end

    byte_compile "vdiff.el"
    elisp.install "vdiff.el", "vdiff.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{Formula["dunn/emacs/hydra-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "vdiff")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

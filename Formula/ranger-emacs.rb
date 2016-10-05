require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RangerEmacs < EmacsFormula
  desc "Alternate file navigation for Emacs"
  homepage "https://github.com/ralesi/ranger.el"
  head "https://github.com/ralesi/ranger.el.git"

  stable do
    url "https://github.com/ralesi/ranger.el/archive/v0.9.8.4.tar.gz"
    sha256 "7b4d1f6473e25074123520bef7251a6da1dfcc3ba10c16c723188c8ba7c4f459"

    # Keymap bug that prevented compiling; remove with next release
    patch do
      url "https://github.com/ralesi/ranger.el/commit/584e4ae8cce1c54a44b40dd4c77fbb2f06d73ecb.diff"
      sha256 "0b1fda31e264614c988570643b1fc80c2b96fbb2796221978fb08aff467ba102"
    end
  end

  depends_on :emacs => "24.4"

  def install
    system "make", "compile"
    elisp.install "ranger.el", "ranger.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "ranger")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

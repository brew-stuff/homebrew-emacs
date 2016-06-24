require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Js2Mode < EmacsFormula
  desc "Improved major mode for editing JavaScript in Emacs"
  homepage "https://github.com/mooz/js2-mode"
  head "https://github.com/mooz/js2-mode.git"

  stable do
    url "https://github.com/mooz/js2-mode/archive/20160623.tar.gz"
    sha256 "65e1321fdd042a105dd80318347beb41a68333cb2be0bbc44c4f3a21a21ffc16"

    # Prevent `make test` from loading old js2-mode from site-lisp;
    # remove in next release
    patch do
      url "https://github.com/mooz/js2-mode/commit/68db1f586eb2cd20a08e47aa7becdbee368ea22f.diff"
      sha256 "e4caccaa170e748519e8fd2471e68ed8a6e5449ea288eb6fdc1dca27721d17d3"
    end
  end

  depends_on :emacs => "24.1"

  def install
    system "make", "all"
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "js2-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

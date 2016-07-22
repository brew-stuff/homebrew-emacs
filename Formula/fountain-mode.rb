require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FountainMode < EmacsFormula
  desc "Major mode for the Fountain screenwriting syntax"
  homepage "https://github.com/rnkn/fountain-mode"
  url "https://github.com/rnkn/fountain-mode/archive/v2.1.3.tar.gz"
  sha256 "99aec3adb0c0d6b56feebd958f2b9e6fa2e3bb54311042b9ed1c0323029af111"
  head "https://github.com/rnkn/fountain-mode.git"

  depends_on :emacs => "24.4"

  def install
    byte_compile "fountain-mode.el"
    elisp.install "fountain-mode.el", "fountain-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "fountain-mode")
      (print fountain-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

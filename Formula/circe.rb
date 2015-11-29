require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Circe < EmacsFormula
  desc "Emacs IRC client"
  homepage "https://github.com/jorgenschaefer/circe"
  url "https://github.com/jorgenschaefer/circe/archive/v2.1.tar.gz"
  sha256 "b70b550f6fcc01616e0ca9f9884b6726a07c4a0359f7dbdbd86ce963eb375718"
  head "https://github.com/jorgenschaefer/circe.git"

  depends_on :emacs
  depends_on "cask"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < 24.3

  def install
    system "scripts/compile"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "circe")
      (print circe-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

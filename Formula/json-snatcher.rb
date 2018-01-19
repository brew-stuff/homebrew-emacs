require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class JsonSnatcher < EmacsFormula
  desc "Get the path to a JSON element in Emacs"
  homepage "https://github.com/Sterlingg/json-snatcher"
  url "https://github.com/Sterlingg/json-snatcher/archive/1.0.0.tar.gz"
  sha256 "cb31a87db5efe5f2c04adaaa8260d9d9d9cc00b5e7289c17053fb6eba2e6d1d9"
  head "https://github.com/Sterlingg/json-snatcher.git"

  depends_on EmacsRequirement => "24.1"

  def install
    byte_compile "json-snatcher.el"
    elisp.install "json-snatcher.el", "json-snatcher.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "json-snatcher")
      (print (jsons-is-number "808"))
    EOS
    assert_equal "t", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

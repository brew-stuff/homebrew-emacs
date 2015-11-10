require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class JsonMode < EmacsFormula
  desc "Emacs major mode for editing JSON"
  homepage "https://github.com/joshwnj/json-mode"
  url "https://github.com/joshwnj/json-mode/archive/1.6.0.tar.gz"
  sha256 "778916c34c270bd8888c603fafe732a2d0050bdef674ab5231ed18fb6ed291c2"
  head "https://github.com/joshwnj/json-mode.git"

  depends_on :emacs
  depends_on "homebrew/emacs/json-reformat"
  depends_on "homebrew/emacs/json-snatcher"

  def install
    byte_compile "json-mode.el"
    elisp.install "json-mode.el", "json-mode.elc"
  end

  test do
    (testpath/"test.json").write '{ "home": "brew" }'

    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/json-reformat"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/json-snatcher"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "json-mode")
      (find-file "#{testpath}/test.json")
      (json-mode-beautify)
      (print (buffer-string))
    EOS
    assert_equal "\"{\n    \\\"home\\\": \\\"brew\\\"\n}\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

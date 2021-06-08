require File.expand_path("../Homebrew/emacs_formula", __dir__)

class JsonMode < EmacsFormula
  desc "Emacs major mode for editing JSON"
  homepage "https://github.com/joshwnj/json-mode"
  url "https://github.com/joshwnj/json-mode/archive/v1.7.0.tar.gz"
  sha256 "e537a936ecfc0374e9bbbf6319bd7fc5f36258585f44acd3bcc71ccbc82d041a"
  head "https://github.com/joshwnj/json-mode.git"

  depends_on EmacsRequirement
  depends_on "dunn/emacs/json-reformat"
  depends_on "dunn/emacs/json-snatcher"

  def install
    byte_compile "json-mode.el"
    elisp.install "json-mode.el", "json-mode.elc"
  end

  test do
    (testpath/"test.json").write '{ "home": "brew" }'

    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{Formula["dunn/emacs/json-reformat"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/json-snatcher"].opt_elisp}")
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

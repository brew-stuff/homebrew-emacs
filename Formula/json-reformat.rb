require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class JsonReformat < EmacsFormula
  desc "JSON reformatting tool for Emacs"
  homepage "https://github.com/gongo/json-reformat"
  url "https://github.com/gongo/json-reformat/archive/0.0.5.tar.gz"
  sha256 "bb2cbd407e4c284678963612a354bc46624974a473e696842eb71a2b53dbce70"
  head "https://github.com/gongo/json-reformat.git"

  depends_on :emacs => "23.1"

  def install
    byte_compile "json-reformat.el"
    elisp.install "json-reformat.el", "json-reformat.elc"
  end

  test do
    (testpath/"test.json").write '{ "home": "brew" }'

    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "json-reformat")
      (find-file "#{testpath}/test.json")
      (json-reformat-region (point-min) (point-max))
      (print (buffer-string))
    EOS
    assert_equal "\"{\n    \\\"home\\\": \\\"brew\\\"\n}\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

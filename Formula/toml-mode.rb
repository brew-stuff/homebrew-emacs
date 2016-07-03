require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

SOURCE = "toml-mode-20150818.120.el".freeze

class TomlMode < EmacsFormula
  desc "Emacs Mojor mode for editing TOML files"
  homepage "https://github.com/dryman/toml-mode.el"
  url "https://melpa.org/packages/#{SOURCE}"
  sha256 "1201bb3d91336f04f597aeb50119a209992205cde30d4d52c4da43606aeafa4c"
  head "https://github.com/dryman/toml-mode.el.git"

  depends_on :emacs => "22.1"

  def install
    mv SOURCE, "toml-mode.el"
    byte_compile "toml-mode.el"
    elisp.install "toml-mode.el", "toml-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "toml-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

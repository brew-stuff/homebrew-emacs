require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class YamlMode < EmacsFormula
  desc "Emacs major mode for editing YAML files"
  homepage "https://github.com/yoshiki/yaml-mode"
  url "https://github.com/yoshiki/yaml-mode/archive/v0.0.12.tar.gz"
  sha256 "f294ed0e2f77081c2e77fd9bd9b496346d5812b240613c5c9aee2dc6abfa5ca1"
  head "https://github.com/yoshiki/yaml-mode.git"

  depends_on :emacs

  def install
    (share/"emacs/site-lisp/yaml-mode").mkpath
    system "make", "install", "PREFIX=#{prefix}",
           "INSTALLLIBDIR=#{share}/emacs/site-lisp/yaml-mode"
    doc.install "README"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'yaml-mode)
    (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/yaml-mode")
      (load "yaml-mode")
      (print (yaml-mode-version))
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

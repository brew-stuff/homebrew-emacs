# coding: utf-8
require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class YamlMode < EmacsFormula
  desc "Emacs major mode for editing YAML files"
  homepage "https://github.com/yoshiki/yaml-mode"
  url "https://github.com/yoshiki/yaml-mode/archive/v0.0.11.tar.gz"
  sha256 "6d2226a4ecd5f3c2fd6ca8a469a2124c4888405a5f4e1552ca05bb1912e2506a"
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
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "yaml-mode")
      (print (yaml-mode-version))
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

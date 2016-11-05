require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class YamlMode < EmacsFormula
  desc "Emacs major mode for editing YAML files"
  homepage "https://github.com/yoshiki/yaml-mode"
  head "https://github.com/yoshiki/yaml-mode.git"

  stable do
    url "https://github.com/yoshiki/yaml-mode/archive/v0.0.13.tar.gz"
    sha256 "c547b1ec62e6b39fd3e95e28b8d3918958d4f00391c471485532dbc6cc3dcab8"

    # Remove for > 0.0.13
    # Upstream commit "update yaml-mode-version"
    patch do
      url "https://github.com/yoshiki/yaml-mode/commit/5abb2f4.patch"
      sha256 "e339db2f453cf980fd7baf6d387b2d2339d76d4ba0f2aff7e7607bb5bf2fef2b"
    end
  end

  depends_on :emacs => "24.1"

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

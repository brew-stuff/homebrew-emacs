require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PuppetMode < EmacsFormula
  desc "Emacs major mode for editing Puppet files"
  homepage "https://github.com/lunaryorn/puppet-mode"
  url "https://github.com/lunaryorn/puppet-mode/archive/0.3.tar.gz"
  sha256 "71ebcb4bf518f9aca404260186b97556fb52060bc56edb77ab1881d64543174d"
  head "https://github.com/lunaryorn/puppet-mode.git"

  depends_on :emacs

  def install
    system "make", "install", "PREFIX=#{prefix}"
    doc.install "README.md"
  end

  def caveats; <<-EOS.undent
    Add the following lines to your configuration's file:

    (autoload 'puppet-mode "puppet-mode" t)
    (add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
    EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{share}/emacs/site-lisp/puppet-mode")
      (load "puppet-mode")
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PuppetMode < EmacsFormula
  desc "Emacs major mode for editing Puppet files"
  homepage "https://github.com/lunaryorn/puppet-mode"
  url "https://github.com/lunaryorn/puppet-mode/archive/0.3.tar.gz"
  sha256 "71ebcb4bf518f9aca404260186b97556fb52060bc56edb77ab1881d64543174d"
  head "https://github.com/lunaryorn/puppet-mode.git"

  depends_on :emacs => "24"

  def install
    byte_compile "puppet-mode.el"
    elisp.install "puppet-mode.el", "puppet-mode.elc"
  end

  def caveats; <<-EOS.undent
    Add the following to your init file:

    (require 'puppet-mode)
    (add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))
    EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (require 'puppet-mode)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

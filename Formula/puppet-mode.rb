require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PuppetMode < EmacsFormula
  desc "Emacs major mode for editing Puppet files"
  homepage "https://github.com/rockyluke/puppet-syntax-emacs"
  url "https://github.com/rockyluke/puppet-syntax-emacs/archive/v1.0.tar.gz"
  sha256 "9b2d240b4979c37ac55e873628d680a3e47fdc04d5ecfdbe5db26b71ddb9cd4f"
  head "https://github.com/rockyluke/puppet-syntax-emacs.git"

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

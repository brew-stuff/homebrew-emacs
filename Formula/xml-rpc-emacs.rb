require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class XmlRpcEmacs < EmacsFormula
  desc "XML-RPC client for Emacs"
  homepage "https://launchpad.net/xml-rpc-el"
  url "https://launchpad.net/xml-rpc-el/trunk/1.6.8/+download/xml-rpc.el"
  version "1.6.8"
  sha256 "ebd4e582f66df200a01344cd89af428d1ae75878c2057c76c65c66e841721045"
  head "lp:xml-rpc-el", :using => :bzr

  depends_on EmacsRequirement

  def install
    byte_compile "xml-rpc.el"
    elisp.install "xml-rpc.el", "xml-rpc.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "xml-rpc")
      (print xml-rpc-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

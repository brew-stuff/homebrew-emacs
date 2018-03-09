require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebServerEmacs < EmacsFormula
  desc "Emacs Lisp webserver"
  homepage "https://eschulte.github.io/emacs-web-server/"
  url "http://elpa.gnu.org/packages/web-server-0.1.1.tar"
  sha256 "5690e943312b312b4be3f419a3c292b73d2ccfe6f045da988f84aac23174a1e0"
  head "https://github.com/eschulte/emacs-web-server.git"

  depends_on EmacsRequirement => "24.3"

  def install
    if build.stable?
      byte_compile "web-server.el"
    else
      # `make doc` currently fails
      system "make", "src"
      system "make", "check"
      doc.install Dir["doc/*"], "examples"
    end
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "web-server")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

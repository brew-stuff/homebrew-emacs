require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebsocketEmacs < EmacsFormula
  desc "Emacs Lisp WebSocket library"
  homepage "https://github.com/ahyatt/emacs-websocket"
  url "http://elpa.gnu.org/packages/websocket-1.5.tar"
  sha256 "5e4b760912f141dc0049397477026b0181350ee4a6f50cdfc22c096115628f5e"
  head "https://github.com/ahyatt/emacs-websocket.git"

  depends_on :emacs

  def install
    if build.head?
      ert_run_tests "websocket-test.el"
      # the functional test opens an emacs buffer on completion
      # system "emacs", %W[--batch -Q -L #{buildpath} -l websocket-functional-test.el]
    end
    byte_compile "websocket.el"
    (share/"emacs/site-lisp/websocket").install Dir["*.el"],
                                                Dir["*.elc"]
    doc.install "README.org"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (load "websocket")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -batch -l #{testpath}/test.el").strip
  end
end

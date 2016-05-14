require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class WebsocketEmacs < EmacsFormula
  desc "Emacs Lisp WebSocket library"
  homepage "https://github.com/ahyatt/emacs-websocket"
  url "https://elpa.gnu.org/packages/websocket-1.6.tar"
  sha256 "aa284016d7cdf25bd2e413b78f8beed7363f2fc62c9b321e0d78bec050103526"
  head "https://github.com/ahyatt/emacs-websocket.git"

  depends_on :emacs => "23.1"

  def install
    # the functional test requires a running Tornado web server
    # https://github.com/ahyatt/emacs-websocket/blob/f18bfea59b843ea67bc0a3381783d6e083d33640/websocket-functional-test.el#L22-L24
    ert_run_tests "websocket-test.el" if build.head?
    byte_compile "websocket.el"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "websocket")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

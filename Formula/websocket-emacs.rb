require File.expand_path("../Homebrew/emacs_formula", __dir__)

class WebsocketEmacs < EmacsFormula
  desc "Emacs Lisp WebSocket library"
  homepage "https://github.com/ahyatt/emacs-websocket"
  url "https://elpa.gnu.org/packages/websocket-1.8.tar"
  sha256 "a9b1c4c725e85f809d9532b273e91c809b179410684d7b98deec7c54adad9d35"
  head "https://github.com/ahyatt/emacs-websocket.git"

  depends_on EmacsRequirement => "23.1"

  def install
    # the functional test requires a running Tornado web server
    # https://github.com/ahyatt/emacs-websocket/blob/f18bfea59b843ea67bc0a3381783d6e083d33640/websocket-functional-test.el#L22-L24
    ert_run_tests "websocket-test.el" if build.head?
    byte_compile "websocket.el"
    elisp.install "websocket.el", "websocket.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "websocket")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

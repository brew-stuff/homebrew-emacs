require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AgEmacs < EmacsFormula
  desc "Emacs front-end to ag (the silver searcher)"
  homepage "http://agel.readthedocs.org/en/latest/"
  url "https://github.com/Wilfred/ag.el/archive/0.47.tar.gz"
  sha256 "5951a28a112a7adeb2276d12bb9543e5ea4a42ca27fcd50c7a0e436fb9b995e6"
  head "https://github.com/Wilfred/ag.el.git"

  depends_on :emacs => "23.4"
  depends_on "the_silver_searcher"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/s-emacs"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile "ag.el"
    elisp.install "ag.el", "ag.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/s-emacs"].opt_elisp}")
      (load "ag")
      (print (buffer-name (ag "#{elisp}" "#{testpath}")))
    EOS
    assert_equal "\"*ag search text:#{elisp} dir:#{testpath}*\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

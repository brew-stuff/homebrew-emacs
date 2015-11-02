require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class SvgClock < EmacsFormula
  desc "Analog SVG clocks in Emacs"
  homepage "http://elpa.gnu.org/packages/svg-clock.html"
  url "http://elpa.gnu.org/packages/svg-clock-0.5.el"
  sha256 "f77585ea5e3b3172e9bc471addda9d65f3ba7a49b0ed63cd328c33eced61e7c4"

  depends_on :emacs => "with-librsvg"

  def install
    mv "svg-clock-#{version}.el", "svg-clock.el"
    byte_compile "svg-clock.el"
    elisp.install "svg-clock.el", "svg-clock.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "svg-clock")
      (svg-clock)
      (svg-clock)
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

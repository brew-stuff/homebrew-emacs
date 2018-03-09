require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class TwitteringMode < EmacsFormula
  desc "Major mode for Twitter"
  homepage "https://twmode.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/twmode/twittering-mode-3.1.0/twittering-mode-3.1.0.tar.gz"
  sha256 "0b6ca146af6e5c06efa327ef2d4fbb9c56bbff7e28a802623c735fc7fa6249f3"
  head "https://github.com/hayamiz/twittering-mode.git"

  depends_on EmacsRequirement => "21.1"

  def install
    # currently fails https://github.com/hayamiz/twittering-mode/issues/119
    # make check
    byte_compile "twittering-mode.el"
    elisp.install "twittering-mode.el", "twittering-mode.elc"

    if Emacs.version < Version.create("22")
      byte_compile Dir["emacs21/*.el"], Dir["url-emacs21/*.el"]
      elisp.install Dir["emacs21/*.el"], Dir["emacs21/*.elc"],
                    Dir["url-emacs21/*.el"], Dir["url-emacs21/*.elc"]
    end
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "twittering-mode")
      (print (twittering-mode-version))
    EOS
    assert_equal "\"twittering-mode-v#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

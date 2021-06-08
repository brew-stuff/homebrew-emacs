require File.expand_path("../Homebrew/emacs_formula", __dir__)

class DockerfileMode < EmacsFormula
  desc "Emacs mode for handling Dockerfiles"
  homepage "https://github.com/spotify/dockerfile-mode"
  url "https://github.com/spotify/dockerfile-mode/archive/v1.2.tar.gz"
  sha256 "49618f06ed6d7a4d64251e00540df13870aeee9a8f55acd4def0482ada78156e"
  head "https://github.com/spotify/dockerfile-mode.git"

  depends_on EmacsRequirement => "24"

  def install
    byte_compile "dockerfile-mode.el"
    elisp.install "dockerfile-mode.el", "dockerfile-mode.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "dockerfile-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

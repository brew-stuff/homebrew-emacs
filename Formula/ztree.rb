require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Ztree < EmacsFormula
  desc "Emacs modes for directory tree comparison"
  homepage "https://github.com/fourier/ztree"
  url "https://elpa.gnu.org/packages/ztree-1.0.5.tar"
  sha256 "3d58d5a0a3220ed62f54014e51d12b1caed459650d2b8e2afabf85adbc5eeb92"
  head "https://github.com/fourier/ztree.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5253b970e776895b1da9ccd2d65151c31adfed162a16ffa03e6681e67bb499e" => :sierra
    sha256 "a1529c28939be1b7f0bf8723e08d1b79e1073f7a741f01152369bd5105573fca" => :el_capitan
    sha256 "a1529c28939be1b7f0bf8723e08d1b79e1073f7a741f01152369bd5105573fca" => :yosemite
  end

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "ztree")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

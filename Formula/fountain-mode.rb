require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FountainMode < EmacsFormula
  desc "Major mode for the Fountain screenwriting syntax"
  homepage "https://github.com/rnkn/fountain-mode"
  url "https://github.com/rnkn/fountain-mode/archive/v2.2.2.tar.gz"
  sha256 "7bd26a8c221df86e45aad18e9432766e3467cd5025cfe103476d508362dd80e7"
  head "https://github.com/rnkn/fountain-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "810ccf756bbb26c43618fca8b78ca56fb7220b189ce7338ed881599962ec7f9c" => :el_capitan
    sha256 "a47bfabe1dfc6d0ea49c70b81760d6ec5cbd5c051b61e893bc9afee816ec5e6d" => :yosemite
    sha256 "a47bfabe1dfc6d0ea49c70b81760d6ec5cbd5c051b61e893bc9afee816ec5e6d" => :mavericks
  end

  depends_on :emacs => "24.4"

  def install
    byte_compile "fountain-mode.el"
    elisp.install "fountain-mode.el", "fountain-mode.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "fountain-mode")
      (print fountain-version)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

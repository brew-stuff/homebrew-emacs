require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class FountainMode < EmacsFormula
  desc "Major mode for the Fountain screenwriting syntax"
  homepage "https://github.com/rnkn/fountain-mode"
  url "https://github.com/rnkn/fountain-mode/archive/v2.2.2.tar.gz"
  sha256 "7bd26a8c221df86e45aad18e9432766e3467cd5025cfe103476d508362dd80e7"
  head "https://github.com/rnkn/fountain-mode.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5c6033a6773495ac7b8f77179a2511da8ce87844b481855f892b7aa2a9e998ac" => :sierra
    sha256 "5c6033a6773495ac7b8f77179a2511da8ce87844b481855f892b7aa2a9e998ac" => :el_capitan
    sha256 "5c6033a6773495ac7b8f77179a2511da8ce87844b481855f892b7aa2a9e998ac" => :yosemite
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

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class PhpMode < EmacsFormula
  desc "Major mode for editing PHP files"
  homepage "https://github.com/ejmr/php-mode"
  head "https://github.com/ejmr/php-mode.git"

  stable do
    url "https://github.com/ejmr/php-mode/archive/v1.17.0.tar.gz"
    sha256 "4393e452e7ade8b7479a3b942b985a9495f6a961b443308718756038d21c231d"

    patch do
      url "https://github.com/ejmr/php-mode/commit/86eab8013c566eebcb77dadf5616b3e99e0eeb1d.diff"
      sha256 "a0199f08ecd1eea8aa8d1ff76c8088cd95ebc846443c41ade1f3cd2e7dbbfed0"
    end
  end

  depends_on :emacs => "24.1"

  def install
    ENV["TMPDIR"] = buildpath
    system "make", "test"
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (require 'php-mode)
      (print php-mode-version-number)
    EOS
    assert_equal "\"#{version}\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

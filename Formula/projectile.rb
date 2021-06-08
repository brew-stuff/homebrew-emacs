require File.expand_path("../Homebrew/emacs_formula", __dir__)

class Projectile < EmacsFormula
  desc "Project Interaction Library for Emacs"
  homepage "http://batsov.com/projectile/"
  url "https://github.com/bbatsov/projectile/archive/v0.14.0.tar.gz"
  sha256 "c7417e25f2fc113194ca68aaecb1a6fe55e44734d5ab0fd643ba7eb0511779d6"
  head "https://github.com/bbatsov/projectile.git"

  depends_on EmacsRequirement => "24.1"
  depends_on "dunn/emacs/dash-emacs"
  depends_on "dunn/emacs/epl"
  depends_on "dunn/emacs/pkg-info"

  def install
    byte_compile "projectile.el"
    elisp.install "projectile.el", "projectile.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{Formula["dunn/emacs/dash-emacs"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/epl"].opt_elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/pkg-info"].opt_elisp}")
      (add-to-list 'load-path "#{elisp}")
      (load "projectile")
      (print (projectile-version))
    EOS
    assert_equal %Q("#{version}"), shell_output("emacs --quick --batch --load #{testpath}/test.el").strip
  end
end

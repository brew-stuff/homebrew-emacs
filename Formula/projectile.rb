require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Projectile < EmacsFormula
  desc "Project Interaction Library for Emacs"
  homepage "http://batsov.com/projectile/"
  url "https://github.com/bbatsov/projectile/archive/v0.13.0.tar.gz"
  sha256 "1dbafcd6eafa718c83de0e1a48d6cf3f47d3bbb7bfb4e629522ce6b5e7e48208"
  head "https://github.com/bbatsov/projectile.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/dash-emacs"
  depends_on "homebrew/emacs/epl"
  depends_on "homebrew/emacs/pkg-info"

  def install
    byte_compile "projectile.el"
    (share/"emacs/site-lisp/projectile").install "projectile.el",
                                                 "projectile.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{Formula["homebrew/emacs/dash-emacs"].opt_share}/emacs/site-lisp/dash")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/epl"].opt_share}/emacs/site-lisp/epl")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/pkg-info"].opt_share}/emacs/site-lisp/pkg-info")
      (add-to-list 'load-path "#{share}/emacs/site-lisp/projectile")
      (load "projectile")
      (print (projectile-version))
    EOS
    assert_equal %("#{version}"), shell_output("emacs --quick --batch --load #{testpath}/test.el").strip
  end
end

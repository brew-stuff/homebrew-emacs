require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AnsibleDoc < EmacsFormula
  desc "Ansible documentation lookup for Emacs"
  homepage "https://github.com/lunaryorn/ansible-doc.el"
  url "https://github.com/lunaryorn/ansible-doc.el/archive/0.4.tar.gz"
  sha256 "77374246b73f1291513fd027c5ecd526ad95f6b507d2e457b40aa6d5638dcfaf"
  head "https://github.com/lunaryorn/ansible-doc.el.git"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/yaml-mode"

  def install
    system "make", "compile"
    system "make", "test" if build.head?
    elisp.install "ansible-doc.el", "ansible-doc.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "ansible-doc")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

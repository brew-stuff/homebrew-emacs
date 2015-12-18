require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AnsibleDoc < EmacsFormula
  desc "Ansible documentation lookup for Emacs"
  homepage "https://github.com/lunaryorn/ansible-doc.el"
  url "https://github.com/lunaryorn/ansible-doc.el/archive/0.3.tar.gz"
  sha256 "15214808b288dd9ff943b868dae5e7ac3f6e256bb4d1671ef69e50eab143a3e9"
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

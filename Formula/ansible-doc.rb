require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class AnsibleDoc < EmacsFormula
  desc "Ansible documentation lookup for Emacs"
  homepage "https://github.com/lunaryorn/ansible-doc.el"
  url "https://github.com/lunaryorn/ansible-doc.el/archive/0.4.tar.gz"
  sha256 "77374246b73f1291513fd027c5ecd526ad95f6b507d2e457b40aa6d5638dcfaf"
  head "https://github.com/lunaryorn/ansible-doc.el.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6aa199b9cd8c2a4b74d946a02b5efc837c13c2013ba2a39f8fb663f331442bdf" => :sierra
    sha256 "6aa199b9cd8c2a4b74d946a02b5efc837c13c2013ba2a39f8fb663f331442bdf" => :el_capitan
    sha256 "6aa199b9cd8c2a4b74d946a02b5efc837c13c2013ba2a39f8fb663f331442bdf" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/yaml-mode"

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

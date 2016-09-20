require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class HeapEmacs < EmacsFormula
  desc "Emacs implementation of the ternary heap data structure"
  homepage "http://www.dr-qubit.org/Emacs_data_structure_packages.html"
  url "http://www.dr-qubit.org/download.php?file=predictive/heap-0.4.el"
  sha256 "e6394912f111d9ee09b1005a69f08e37f18dae7e0b19d8728217f4bc37b06fef"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a59119151282c5c89bccf18ed0329d885dc84faeade695f924105f69e4e12e0" => :sierra
    sha256 "3a59119151282c5c89bccf18ed0329d885dc84faeade695f924105f69e4e12e0" => :el_capitan
    sha256 "3a59119151282c5c89bccf18ed0329d885dc84faeade695f924105f69e4e12e0" => :yosemite
  end

  depends_on :emacs

  def install
    mv "heap-#{version}.el", "heap.el"
    byte_compile "heap.el"
    elisp.install "heap.el", "heap.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "heap")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

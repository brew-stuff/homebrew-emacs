require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class IronyMode < EmacsFormula
  desc "C/C++ minor mode for Emacs powered by libclang"
  homepage "https://github.com/Sarcasm/irony-mode"
  url "https://github.com/Sarcasm/irony-mode/archive/v1.0.0.tar.gz"
  sha256 "7326bf7308d1308493a91efbb91aa25aecb1bc0c188888c7dc9ad5c9a1e6d0b9"
  head "https://github.com/Sarcasm/irony-mode.git"

  bottle do
    cellar :any
    sha256 "340776506d2ebac428dafb3e6f9d0b3bdb96b1abfd75b6da045933d6bcc725b8" => :sierra
    sha256 "9f4630d75228a66f22dc05475b155f5539043688337fef9d95105fbb631c3f17" => :el_capitan
    sha256 "0618e58e9410e1513199ba25ac9310a2341880ac0d383248bf6eaf1cdceb69ba" => :yosemite
  end

  depends_on :emacs => "24.1"
  depends_on "dunn/emacs/cl-lib" if Emacs.version < Version.create("24.3")
  depends_on "dunn/emacs/yasnippet" => :optional

  depends_on "llvm"
  depends_on "cmake" => :build

  def install
    ENV.append "LDFLAGS", "-lclang"
    mkdir "build" do
      args = std_cmake_args
      args << "-DLIBCLANG_LIBRARY=#{Formula["llvm"].opt_lib}"
      args << "-DLIBCLANG_INCLUDE_DIR=#{Formula["llvm"].opt_include}"
      system "cmake", "../server", *args
      system "make", "install"
    end
    elisp.install "server"
    byte_compile Dir["*.el"]
    elisp.install Dir["*.el"], Dir["*.elc"]
  end

  def caveats
    "Set the value of `irony-server-install-prefix' to #{opt_bin}"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (load "irony")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

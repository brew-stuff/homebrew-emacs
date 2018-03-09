require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class IronyMode < EmacsFormula
  desc "C/C++ minor mode for Emacs powered by libclang"
  homepage "https://github.com/Sarcasm/irony-mode"
  url "https://github.com/Sarcasm/irony-mode/archive/v1.2.0.tar.gz"
  sha256 "294dea9b524bad66a0005675fb436c102cc047cf0768633c55e24dfa40fcc8b8"
  head "https://github.com/Sarcasm/irony-mode.git"

  bottle :disable

  depends_on EmacsRequirement => "24.1"
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
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (load "irony")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

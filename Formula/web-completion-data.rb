require File.expand_path("../Homebrew/emacs_formula", __dir__)

class WebCompletionData < EmacsFormula
  desc "Completion data for ac-html and company-web"
  homepage "https://github.com/osv/web-completion-data"
  url "https://github.com/osv/web-completion-data/archive/v0.2.tar.gz"
  sha256 "14fef83de38bf98fcf1a4cfa2087f41ac877c61f90ab99a5e4981f0326d3c9fa"

  head do
    url "https://github.com/osv/web-completion-data.git"
    depends_on "node" => :build
  end

  def install
    if build.head?
      ENV.prepend_path "PATH", "#{Formula["node"].opt_libexec}/npm/bin"
      cd "convertor" do
        system "npm", "install"
      end
      system "make"
    end

    byte_compile "web-completion-data.el"
    elisp.install "html-stuff",
                  "web-completion-data.el", "web-completion-data.elc"
  end

  test do
    (testpath/"test.el").write <<~EOS
      (add-to-list 'load-path "#{elisp}")
      (load "web-completion-data")
      (print web-completion-data-html-source-dir)
    EOS
    assert_equal "\"#{elisp}/html-stuff\"", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

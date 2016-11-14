require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CompanyMode < EmacsFormula
  desc "Modular in-buffer completion framework for Emacs"
  homepage "https://company-mode.github.io"
  url "https://github.com/company-mode/company-mode/archive/0.9.2.tar.gz"
  sha256 "75c2e0325787c91228b5a9e4a0b702543e3ee3146194a849e429e20055915f08"
  head "https://github.com/company-mode/company-mode.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "8b411e04df35745ed0c99d876c2fb5ea5f873aacd9aa63041a82e6f72516ac90" => :sierra
    sha256 "8b411e04df35745ed0c99d876c2fb5ea5f873aacd9aa63041a82e6f72516ac90" => :el_capitan
    sha256 "8b411e04df35745ed0c99d876c2fb5ea5f873aacd9aa63041a82e6f72516ac90" => :yosemite
  end

  option "with-ansible", "Install Ansible backend"
  option "with-emoji", "Install emoji backend"
  option "with-php", "Install PHP backend"
  option "with-statistics", "Include statistical ranking minor mode"
  option "with-web", "Install web templating backend"

  depends_on :emacs => "24.1"
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  if build.with? "web"
    depends_on "homebrew/emacs/dash-emacs"
    depends_on "homebrew/emacs/web-completion-data"
  end

  if build.with? "php"
    depends_on "homebrew/emacs/f-emacs"
    depends_on "homebrew/emacs/popup"
    depends_on "homebrew/emacs/s-emacs"
    depends_on "homebrew/emacs/xcscope"
    depends_on "homebrew/emacs/yasnippet"
  end

  resource "ansible" do
    url "https://github.com/krzysztof-magosa/company-ansible/archive/0.3.0.tar.gz"
    sha256 "41a5fdf234484e4a67b4d3ae16e5917078a1ea3f2c01c08e26d95daade51d0ec"
  end

  resource "emoji" do
    url "https://github.com/dunn/company-emoji/archive/2.3.0.tar.gz"
    sha256 "51f5c3c43ab6fcb79ea88115b0e773269cc02d56a8dbaec1f83f7fbe3e5f34f8"
  end

  resource "php" do
    url "https://github.com/xcwen/ac-php/archive/1.7.5.tar.gz"
    sha256 "1730bfc2292c707c105f4c8abee5b6c76b178fa2e649bde5ad39f35bf194d538"
  end

  resource "statistics" do
    url "https://github.com/company-mode/company-statistics/archive/0.2.2.tar.gz"
    sha256 "31c7f68324f492cbe658f0733841e4de64149e86f821c878c390edb0e840e420"
  end

  resource "web" do
    url "https://github.com/osv/company-web/archive/v0.9.tar.gz"
    sha256 "c5e26ae5eb9f7c57684b24ad9a960fa86df5ab2e2dac14b7b1068f3853a98622"
  end

  def install
    if build.with? "ansible"
      resource("ansible").stage do
        byte_compile Dir["*.el"]
        (elisp/"ansible").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "emoji"
      resource("emoji").stage do
        byte_compile "company-emoji.el"
        (elisp/"emoji").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "php"
      resource("php").stage do
        byte_compile (Dir["*.el"] - ["ac-php.el"])
        (elisp/"php").install [(Dir["*.el"] - ["ac-php.el"]),
                               Dir["*.elc"], Dir["*.json"], "phpctags"].flatten
      end
    end

    if build.with? "statistics"
      resource("statistics").stage do
        byte_compile "company-statistics.el"
        (elisp/"statistics").install Dir["*.el"], Dir["*.elc"]
      end
    end

    if build.with? "web"
      resource("web").stage do
        byte_compile Dir["*.el"]
        (elisp/"web").install Dir["*.el"], Dir["*.elc"]
      end
    end

    system "make", "test-batch"
    system "make", "compile"
    elisp.install Dir["company*.el"], Dir["company*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["homebrew/emacs/cl-lib"].opt_elisp}")
      (load "company")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

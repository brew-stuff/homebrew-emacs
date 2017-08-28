require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class CompanyMode < EmacsFormula
  desc "Modular in-buffer completion framework for Emacs"
  homepage "https://company-mode.github.io"
  url "https://github.com/company-mode/company-mode/archive/0.9.4.tar.gz"
  sha256 "fd2662a452aa31644d0e7615e9aeff236f0c8e09b13b0371c400b1b0bc0d1e73"
  head "https://github.com/company-mode/company-mode.git"

  bottle :disable

  option "with-ansible", "Install Ansible backend"
  option "with-emoji", "Install emoji backend"
  option "with-php", "Install PHP backend"
  option "with-statistics", "Include statistical ranking minor mode"
  option "with-web", "Install web templating backend"

  depends_on :emacs => "24.3"
  depends_on "dunn/emacs/irony-mode" => :optional

  if build.with? "web"
    depends_on "dunn/emacs/dash-emacs"
    depends_on "dunn/emacs/web-completion-data"
  end

  if build.with? "php"
    depends_on "dunn/emacs/f-emacs"
    depends_on "dunn/emacs/popup"
    depends_on "dunn/emacs/s-emacs"
    depends_on "dunn/emacs/xcscope"
    depends_on "dunn/emacs/yasnippet"
  end

  resource "ansible" do
    url "https://github.com/krzysztof-magosa/company-ansible/archive/0.6.0.tar.gz"
    sha256 "5bf5cabd679f01c7bfb6d0bb469aa2773150e9452a514583fd741271a120d84a"
  end

  resource "emoji" do
    url "https://github.com/dunn/company-emoji/archive/2.5.0.tar.gz"
    sha256 "010fef421db8c73626ba7e1d844b650da8d77f46ea40ad9d9ca7f2f08e4d70f3"
  end

  # TODO: this should probably be an option --with-company in the
  # irony formula
  resource "irony" do
    url "https://github.com/Sarcasm/company-irony/archive/v1.0.0.tar.gz"
    sha256 "2e5610401d90c5bb2e7a2b81a1b177d273d05cade51c3600597e0a533191a7e0"
  end

  resource "php" do
    url "https://github.com/xcwen/ac-php/archive/1.8.tar.gz"
    sha256 "5a89026514c04458d7dacd461dcef05065495b0a631dc9a2cf1f366db185d83a"
  end

  resource "statistics" do
    url "https://elpa.gnu.org/packages/company-statistics-0.2.3.tar"
    sha256 "9c1358e9012bca320ef82a42fb50d49e06f92e76a42743b497691c97c0ed001d"
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

    if build.with? "irony-mode"
      resource("irony").stage do
        byte_compile "company-irony.el"
        (elisp/"irony").install Dir["*.el"], Dir["*.elc"]
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

    # https://github.com/company-mode/company-mode/issues/375
    inreplace "test/async-tests.el",
              "company-async-timeout 0.1",
              "company-async-timeout 2"

    system "make", "test-batch"
    system "make", "compile"
    elisp.install Dir["company*.el"], Dir["company*.elc"]
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (add-to-list 'load-path "#{Formula["dunn/emacs/cl-lib"].opt_elisp}")
      (load "company")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class RdfPrefix < EmacsFormula
  desc "Prefix lookup for RDF in Emacs"
  homepage "https://github.com/simenheg/rdf-prefix"
  url "https://github.com/simenheg/rdf-prefix/archive/1.8.tar.gz"
  sha256 "a82a18be9f0bffdc8856a845797df224470e7b5a049f763c48ea0d8aa9b68f4d"
  head "https://github.com/simenheg/rdf-prefix.git"

  depends_on EmacsRequirement

  def install
    byte_compile "rdf-prefix.el"
    elisp.install "rdf-prefix.el", "rdf-prefix.elc"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "rdf-prefix")
      (print (rdf-prefix-lookup "bf"))
    EOS
    assert_equal "\"http://bibframe.org/vocab/\"",
                 shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end

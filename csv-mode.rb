require 'formula'

class CsvMode < Formula
  homepage 'http://centaur.maths.qmul.ac.uk/Emacs/'
  url 'http://elpa.gnu.org/packages/csv-mode-1.2.el', :using => :curl
  sha1 'dae6f0d12788c1e67a23b080f8f516bc1ef9c6fb'

  def install
    (share+'emacs/site-lisp').install 'csv-mode-1.2.el' => 'csv-mode.el'
  end
end

require 'formula'

class YamlMode < Formula
  homepage 'https://github.com/yoshiki/yaml-mode'
  url 'https://github.com/yoshiki/yaml-mode/archive/release-0.0.10.tar.gz'
  sha1 '75c1318947d076ac6c1d5591e0a9ba944115c55a'
  head 'https://github.com/yoshiki/yaml-mode.git'

  def install
    system 'make', 'bytecompile'
    (share+'emacs/site-lisp').install ['yaml-mode.el', 'yaml-mode.elc']
  end
end

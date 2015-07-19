require 'formula'

class ColorThemeSolarized < Formula
  homepage 'https://github.com/sellout/emacs-color-theme-solarized'
  head 'https://github.com/sellout/emacs-color-theme-solarized.git'

  def install
    (share+'emacs/themes/solarized').install Dir['*.el']
  end
end

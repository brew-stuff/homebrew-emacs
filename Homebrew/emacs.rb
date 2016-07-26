module Emacs
  def self.version
    Version.create(
      Utils.popen_read("emacs", "-Q", "--batch", "--eval", "(princ emacs-version)")
    )
  end
end

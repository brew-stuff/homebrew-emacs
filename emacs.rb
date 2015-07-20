module Emacs
  def self.version
    Utils.popen_read("emacs", "--batch", "--eval", "(princ emacs-version)").to_f
  end
end

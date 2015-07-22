module Emacs
  def self.version
    Utils.popen_read("emacs", "--batch", "--eval", "(princ emacs-version)").to_f
  end

  def self.compile(*args)
    # TODO: load directories of dependencies
    args.each do |file|
      system "emacs", "--batch", "-Q", "-f", "batch-byte-compile", *file
    end
  end
end

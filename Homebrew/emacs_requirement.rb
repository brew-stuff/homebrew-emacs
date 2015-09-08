class EmacsRequirement < Requirement
  def initialize(tags)
    @version = tags.shift if /\d+\.*\d*/ === tags.first
    # patch EmacsRequirement to allow no version:
    # because we can't redefine the satisfaction block, just floor the
    # version if it's not given after `depends_on :emacs`
    @version ||= "0"
    super
  end
end

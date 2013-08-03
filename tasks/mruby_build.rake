module MRuby
  class CrossBuildiOS < CrossBuild
    def platform(platform = nil)
      @platform ||= platform
    end

    def sdk_path(sdk_path = nil)
      @sdk_path ||= sdk_path
    end

    def sdk_version(sdk_version = nil)
      @sdk_version ||= sdk_version
    end

    def sdk(sdk = nil)
      @sdk ||= sdk
    end

    def arch(arch = nil)
      @arch ||= arch
    end

  end
end
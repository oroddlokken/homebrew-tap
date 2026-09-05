class Cboard2 < Formula
  include Language::Python::Virtualenv

  desc "Terminal dashboard over every git repo on your disk"
  homepage "https://github.com/oroddlokken/cboard2"
  url "https://github.com/oroddlokken/cboard2/releases/download/v0.1.2/cboard2-0.1.2-py3-none-any.whl"
  sha256 "db0307a630ad5128cc26d17342678a2a3c0b6436fe7778568f22cec267146b41"
  license "MIT"

  depends_on "python@3.13"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    wheel = "cboard2-#{version}-py3-none-any.whl"
    libexec.install cached_download => wheel
    venv.pip_install libexec/wheel
    (bin/"cboard").write <<~BASH
      #!/bin/bash
      exec "#{libexec}/bin/cboard" "$@"
    BASH
  end

  # The dependencies land here rather than in install, after Homebrew has
  # relocated the keg. venv.pip_install passes --no-deps, so install leaves the
  # venv holding cboard2 alone and `cboard` dies on `import textual`. Every
  # dependency is a pure-Python wheel today, so relocation has nothing to do
  # for them; running after it also holds if one later ships an extension
  # module whose Mach-O header has no room for the longer dylib ID.
  post_install_steps do
    run "{{HOMEBREW_PREFIX}}/opt/python@3.13/bin/python3.13",
        args:           ["-m", "pip", "--python={{HOMEBREW_PREFIX}}/opt/cboard2/libexec/bin/python",
                         "install", "--no-cache-dir",
                         "{{HOMEBREW_PREFIX}}/opt/cboard2/libexec/cboard2-{{version}}-py3-none-any.whl"],
        network_access: true
  end

  test do
    system bin/"cboard", "--help"
  end
end

class Cboard2 < Formula
  include Language::Python::Virtualenv

  desc "A terminal dashboard over every git repo on your disk"
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

  test do
    system bin/"cboard", "--help"
  end
end

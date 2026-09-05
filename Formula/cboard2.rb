class Cboard2 < Formula
  include Language::Python::Virtualenv

  desc "A terminal dashboard over every git repo on your disk"
  homepage "https://github.com/oroddlokken/cboard2"
  url "https://github.com/oroddlokken/cboard2/releases/download/v0.1.1/cboard2-0.1.1-py3-none-any.whl"
  sha256 "8b717e6c8bbd57744f3da85b5e93c774d513d0f5b42f38660c3278207283f4e1"
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

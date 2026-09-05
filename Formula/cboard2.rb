class Cboard2 < Formula
  include Language::Python::Virtualenv

  desc "A terminal dashboard over every git repo on your disk"
  homepage "https://github.com/oroddlokken/cboard2"
  url "https://github.com/oroddlokken/cboard2/releases/download/v0.1.0/cboard2-0.1.0-py3-none-any.whl"
  sha256 "bbe99e36778e11e4a11797b36d126cb0e5d608a17b46db77efef3e3ff171c702"
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

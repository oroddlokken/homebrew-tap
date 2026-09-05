class Ccreport < Formula
  include Language::Python::Virtualenv

  desc "Token usage and cost reporting for Claude Code, plus a quota dashboard"
  homepage "https://github.com/oroddlokken/ccreport"
  # Both fields are rewritten by ccreport's update-homebrew job on every
  # release; the sha256 below is a placeholder until the first one lands.
  url "https://github.com/oroddlokken/ccreport/releases/download/v0.1.0/ccreport-0.1.0-py3-none-any.whl"
  sha256 "d80e5430745d816df6bc3f80d486109a39be5337f194fc285169961eff9feada"

  depends_on "python@3.13"

  def install
    virtualenv_create(libexec, "python3.13")
    wheel = "ccreport-#{version}-py3-none-any.whl"
    libexec.install cached_download => wheel
    # Not venv.pip_install: that passes --no-deps and leaves a venv holding
    # ccreport and none of what it imports. pip resolves the wheel's
    # dependencies from PyPI, binary wheels included, so nothing needs a Rust
    # toolchain here.
    python = formula_opt_bin("python@3.13")/"python3.13"
    system python, "-m", "pip", "--python=#{libexec}/bin/python", "install",
           "--no-cache-dir", libexec/wheel
    %w[ccreport ccu].each do |cmd|
      (bin/cmd).write <<~BASH
        #!/bin/bash
        exec "#{libexec}/bin/#{cmd}" "$@"
      BASH
    end
  end

  test do
    system bin/"ccreport", "--help"
  end
end

class Ccreport < Formula
  include Language::Python::Virtualenv

  desc "Token usage and cost reporting for Claude Code, plus a quota dashboard"
  homepage "https://github.com/oroddlokken/ccreport"
  # Both fields are rewritten by ccreport's update-homebrew job on every
  # release; the sha256 below is a placeholder until the first one lands.
  url "https://github.com/oroddlokken/ccreport/releases/download/v0.1.0/ccreport-0.1.0-py3-none-any.whl"
  sha256 "0000000000000000000000000000000000000000000000000000000000000000"

  depends_on "python@3.13"

  def install
    venv = virtualenv_create(libexec, "python3.13")
    wheel = "ccreport-#{version}-py3-none-any.whl"
    libexec.install cached_download => wheel
    venv.pip_install libexec/wheel
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

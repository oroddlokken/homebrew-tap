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

  # The dependencies land here rather than in install, after Homebrew has
  # relocated the keg. venv.pip_install passes --no-deps, and installing them
  # during install fails the relocation: orjson's extension module has no
  # header room for the longer dylib ID, and Homebrew stops the install on
  # that. Nothing here links against a Homebrew library, so relocation has
  # nothing to do for them.
  post_install_steps do
    run "{{HOMEBREW_PREFIX}}/opt/python@3.13/bin/python3.13",
        args:           ["-m", "pip", "--python={{HOMEBREW_PREFIX}}/opt/ccreport/libexec/bin/python",
                         "install", "--no-cache-dir",
                         "{{HOMEBREW_PREFIX}}/opt/ccreport/libexec/ccreport-{{version}}-py3-none-any.whl"],
        network_access: true
  end

  test do
    system bin/"ccreport", "--help"
  end
end

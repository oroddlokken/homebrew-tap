class Dogcat < Formula
  include Language::Python::Virtualenv

  desc "lightweight, file-based issue tracking and memory upgrade for AI agents (and humans!)"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.12.2/dogcat-0.12.2-py3-none-any.whl"
  sha256 "e859264a6adee4de4c0e75644ed84aa2173fd2a05cbedf0588b4338c2a0fc954"
  license "MIT"

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    libexec.install cached_download => "dogcat-#{version}-py3-none-any.whl"
    (bin/"dcat").write <<~BASH
      #!/bin/bash
      exec "#{libexec}/bin/dcat" "$@"
    BASH
    bin.install_symlink "dcat" => "dogcat"
  end

  def post_install
    python = Formula["python@3.14"].opt_bin/"python3.14"
    wheel = libexec/"dogcat-#{version}-py3-none-any.whl"
    system python, "-m", "pip", "--python", libexec/"bin/python", "install", "#{wheel}[web]"
  end

  test do
    system bin/"dcat", "--help"
  end
end

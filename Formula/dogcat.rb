class Dogcat < Formula
  include Language::Python::Virtualenv

  desc "lightweight, file-based issue tracking and memory upgrade for AI agents (and humans!)"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.11.2/dogcat-0.11.2-py3-none-any.whl"
  sha256 "110c0c71eb172fe2e2a8dbd2c518851c70a6654313292a48949a8edcfab794cc"
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

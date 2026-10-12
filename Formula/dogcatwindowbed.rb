class Dogcatwindowbed < Formula
  include Language::Python::Virtualenv

  desc "lightweight, file-based issue tracking and memory upgrade for AI agents (and humans!)"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.14.3-rc.2/dogcat-0.14.3rc2-py3-none-any.whl"
  sha256 "fe6b9d9c9bb4bd4702aac248999326804e9e838bf0c9ee56c467f89c0f38bfd8"
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
    generate_completions_from_executable(bin/"dcat", "--show-completion")
  end

  test do
    system bin/"dcat", "--help"
  end
end

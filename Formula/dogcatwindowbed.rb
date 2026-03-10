class Dogcatwindowbed < Formula
  include Language::Python::Virtualenv

  desc "lightweight, file-based issue tracking and memory upgrade for AI agents (and humans!)"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.11.6-rc.1/dogcat-0.11.6rc1-py3-none-any.whl"
  sha256 "3b0d7613ff31d8789214aa05928eb0eedf3501d4faf021b68bd09f5e07c49ade"
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

class Dogcatwindowbed < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.1.8/dogcat-0.1.8-py3-none-any.whl"
  sha256 "f0c0ea73032bc1c59680858f38bab58b1a597a09fa4723132c4420dda19cbe9c"
  license "MIT"

  depends_on "uv"

  def install
    libexec.install Dir["*"]
    (bin/"dcat").write <<~BASH
      #!/bin/bash
      exec "#{libexec}/.venv/bin/dcat" "$@"
    BASH
    bin.install_symlink "dcat" => "dogcat"
  end

  def post_install
    wheel = Dir[libexec/"dogcat-*.whl"].first
    system "uv", "venv", "--python", "3.13", libexec/".venv"
    system "uv", "pip", "install", "--python", libexec/".venv/bin/python", wheel
  end

  test do
    system bin/"dcat", "--help"
  end
end

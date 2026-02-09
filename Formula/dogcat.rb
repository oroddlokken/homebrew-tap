class Dogcat < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.5.5/dogcat-0.5.5-py3-none-any.whl"
  sha256 "74e0e808ff87432b454908d17a0fa73a3713c60de38b51efd3f7ec5c7bc9f3e8"
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
    ENV["UV_CACHE_DIR"] = HOMEBREW_CACHE/"uv"
    wheel = Dir[libexec/"dogcat-*.whl"].first
    system "uv", "venv", "--python", "3.13", libexec/".venv"
    system "uv", "pip", "install", "--python", libexec/".venv/bin/python", wheel
  end

  test do
    system bin/"dcat", "--help"
  end
end

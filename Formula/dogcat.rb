class Dogcat < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.5.3/dogcat-0.5.3-py3-none-any.whl"
  sha256 "7f5f0a6f989560f0cd0d5621dd418811d05ab39bcd6b26b87e82c59d2f487a22"
  license "MIT"

  depends_on "uv"

  conflicts_with "dogcat", because: "both install `dcat` and `dogcat` binaries"

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

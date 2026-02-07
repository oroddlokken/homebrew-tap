class Dogcat < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.1.9/dogcat-0.1.9-py3-none-any.whl"
  sha256 "29a96090426e39e4e00691b64f3ef54e25ad3cc641a5803bd253de1ee53edf16"
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

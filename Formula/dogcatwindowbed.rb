class Dogcatwindowbed < Formula
  desc "lightweight, file-based issue tracking and memory upgrade for AI agents (and humans!)"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.6.0/dogcat-0.6.0-py3-none-any.whl"
  sha256 "39f773e90e0e45c70bfafd16fc22226854ab2fded4f57cf04c03e6bd46463bbc"
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

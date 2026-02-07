class Dogcat < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/archive/refs/tags/v0.1.3.tar.gz"
  sha256 "a0bc88baf8892bf24698653102b41408d759ccf61ed9c3a48f7c09274e041be9"
  license "MIT"

  depends_on "uv"

  def install
    # Build wheel while source files (including README.md) are available
    system "uv", "build", "--wheel", "--out-dir", "dist", "--cache-dir", buildpath/"uv-cache"
    libexec.install Dir["*"]
    (bin/"dcat").write <<~BASH
      #!/bin/bash
      exec "#{libexec}/.venv/bin/dcat" "$@"
    BASH
    bin.install_symlink "dcat" => "dogcat"
  end

  def post_install
    # Install from pre-built wheel — no source build needed, no dylib relocation
    system "uv", "venv", "--python", "3.13", "--cache-dir", HOMEBREW_TEMP/"dogcat-uv-cache", libexec/".venv"
    wheel = Dir[libexec/"dist"/"dogcat-*.whl"].first
    system "uv", "pip", "install", "--python", libexec/".venv/bin/python",
           "--cache-dir", HOMEBREW_TEMP/"dogcat-uv-cache", wheel
  end

  test do
    system bin/"dcat", "--help"
  end
end

class Dogcat < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "27b9c65e5b648837e7cbfc880d70d8b87a17908327157cf123301b5b11ea8f24"
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
  end

  def post_install
    # Install from pre-built wheel — no source build needed, no dylib relocation
    system "uv", "venv", "--python", "python3", libexec/".venv"
    wheel = Dir[libexec/"dist"/"dogcat-*.whl"].first
    system "uv", "pip", "install", "--python", libexec/".venv/bin/python",
           "--cache-dir", HOMEBREW_TEMP/"dogcat-uv-cache", wheel
  end

  test do
    system bin/"dcat", "--help"
  end
end

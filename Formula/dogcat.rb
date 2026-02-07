class Dogcat < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "99e9067181ded6787c5efedbca86d19eff7025e9414e6bf5038c96054866c4c2"
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

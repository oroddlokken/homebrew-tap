class Dogcatwindowbed < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/archive/refs/tags/v0.1.6.tar.gz"
  sha256 "d877972a9d2aa3f0ca30ba90845b0222d21bdcd16997a608b45e4fa1d9d0de4c"
  license "MIT"

  depends_on "uv"

  def install
    # Build wheel while source files (including README.md) are available
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION"] = version.to_s
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

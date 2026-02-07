class Dogcat < Formula
  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "27b9c65e5b648837e7cbfc880d70d8b87a17908327157cf123301b5b11ea8f24"
  license "MIT"

  depends_on "uv"

  def install
    libexec.install Dir["*"]
    (bin/"dcat").write <<~BASH
      #!/bin/bash
      exec uv run --no-dev --project "#{libexec}" dcat "$@"
    BASH
  end

  test do
    system bin/"dcat", "--help"
  end
end

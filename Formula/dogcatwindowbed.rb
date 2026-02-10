class Dogcatwindowbed < Formula
  include Language::Python::Virtualenv

  desc "lightweight, file-based issue tracking and memory upgrade for AI agents (and humans!)"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.5.8/dogcat-0.5.8-py3-none-any.whl"
  sha256 "f0012e324d87213f68c55d4efabfe2171a604e0b19287f954832d5c07f2becd2"
  license "MIT"

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    wheel = buildpath/"dogcat-#{version}-py3-none-any.whl"
    cp cached_download, wheel
    venv.pip_install wheel
    bin.install_symlink libexec/"bin/dcat"
    bin.install_symlink "dcat" => "dogcat"
  end

  test do
    system bin/"dcat", "--help"
  end
end

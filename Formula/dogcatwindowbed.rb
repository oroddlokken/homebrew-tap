class Dogcatwindowbed < Formula
  include Language::Python::Virtualenv

  desc "lightweight, file-based issue tracking and memory upgrade for AI agents (and humans!)"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.6.0/dogcat-0.6.0-py3-none-any.whl"
  sha256 "39f773e90e0e45c70bfafd16fc22226854ab2fded4f57cf04c03e6bd46463bbc"
  license "MIT"

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    wheel = buildpath/"dogcat-#{version}-py3-none-any.whl"
    cp cached_download, wheel
    system libexec/"bin/pip", "install", wheel
    bin.install_symlink libexec/"bin/dcat"
    bin.install_symlink "dcat" => "dogcat"
  end

  test do
    system bin/"dcat", "--help"
  end
end

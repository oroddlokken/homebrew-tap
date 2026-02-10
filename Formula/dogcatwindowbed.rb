class Dogcatwindowbed < Formula
  include Language::Python::Virtualenv

  desc "Git-backed issue tracking for AI agents"
  homepage "https://github.com/oroddlokken/dogcat"
  url "https://github.com/oroddlokken/dogcat/releases/download/v0.5.4/dogcat-0.5.4-py3-none-any.whl"
  sha256 "a3608593839d4c4bb3f4b4959b475d64d27766393e8917b2327ab66aa25051bc"
  license "MIT"

  depends_on "python@3.14"

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install cached_download
    bin.install_symlink libexec/"bin/dcat"
    bin.install_symlink "dcat" => "dogcat"
  end

  test do
    system bin/"dcat", "--help"
  end
end

class Hscli < Formula
  desc "Command-line interface for Help Scout"
  homepage "https://github.com/wavyx/hscli"
  url "https://registry.npmjs.org/@wavyx/hscli/-/hscli-0.11.0.tgz"
  sha256 "8f96539391d0fe622e0c101a80fe3c6f5a7fbec56b69f619df539d7fe4e3828d"
  version "0.11.0"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "hscli", shell_output("#{bin}/hscli version")
  end
end

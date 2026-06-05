class Hscli < Formula
  desc "Command-line interface for Help Scout"
  homepage "https://github.com/wavyx/hscli"
  url "https://registry.npmjs.org/@wavyx/hscli/-/hscli-0.11.1.tgz"
  sha256 "81eb1bee56087b2299ef41b7c6e3bf4b7e22ef3f28bde3d151445505d9539745"
  license "MIT"

  depends_on "jq"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # hscli's --jq flag uses node-jq, which normally downloads its own jq binary
    # via a postinstall script. std_npm_args passes --ignore-scripts and the
    # Homebrew build sandbox blocks network, so point node-jq at the Homebrew jq
    # instead (node-jq honors $JQ_PATH at runtime).
    (bin/"hscli").write_env_script libexec/"bin/hscli",
                                   JQ_PATH: Formula["jq"].opt_bin/"jq"
  end

  test do
    assert_match "hscli", shell_output("#{bin}/hscli version")
    # Exercise --jq so the node-jq / Homebrew-jq wiring can't silently regress.
    system bin/"hscli", "config", "list", "--output", "json", "--jq", "."
  end
end

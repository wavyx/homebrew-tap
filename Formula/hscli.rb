class Hscli < Formula
  desc "Command-line interface for Help Scout"
  homepage "https://github.com/wavyx/hscli"
  url "https://registry.npmjs.org/@wavyx/hscli/-/hscli-0.11.2.tgz"
  sha256 "dee120dd00f7e9816cafead25baba802dc7c3df80de412cf86a27bbf67997746"
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

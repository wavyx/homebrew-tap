class Pdcli < Formula
  desc "Command-line interface for Pipedrive"
  homepage "https://github.com/wavyx/pdcli"
  url "https://registry.npmjs.org/@wavyx/pdcli/-/pdcli-0.22.0.tgz"
  sha256 "d07f5537053398c08b9bd12521f08a4e87b1cc47dfe6606481c111a29cebdc3d"
  license "MIT"

  depends_on "jq"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # pdcli's --jq flag uses node-jq, which normally downloads its own jq binary
    # via a postinstall script. std_npm_args passes --ignore-scripts and the
    # Homebrew build sandbox blocks network, so point node-jq at the Homebrew jq
    # instead (node-jq honors $JQ_PATH at runtime).
    (bin/"pdcli").write_env_script libexec/"bin/pdcli",
                                   JQ_PATH: Formula["jq"].opt_bin/"jq"
  end

  test do
    assert_match "pdcli", shell_output("#{bin}/pdcli version")
    # Exercise --jq so the node-jq / Homebrew-jq wiring can't silently regress.
    system bin/"pdcli", "config", "list", "--output", "json", "--jq", "."
  end
end

class Exactcli < Formula
  desc "Command-line interface for Exact Online"
  homepage "https://wavyx.github.io/exactcli/"
  url "https://registry.npmjs.org/@wavyx/exactcli/-/exactcli-0.14.4.tgz"
  sha256 "406ab63208654629c67c563bd1b7b63cf624e591e5813119c99f2e668b13730f"
  license "MIT"

  depends_on "jq"
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # --jq uses node-jq, which downloads its own jq in a postinstall script.
    # std_npm_args ignores scripts and the build sandbox has no network, so
    # point node-jq at the Homebrew jq (node-jq reads JQ_PATH at runtime).
    (bin/"exactcli").write_env_script libexec/"bin/exactcli",
                                      JQ_PATH: formula_opt_bin("jq")/"jq"
  end

  test do
    assert_match "exactcli", shell_output("#{bin}/exactcli version")
    # Run --jq too, so the Homebrew jq wiring cannot break unnoticed.
    system bin/"exactcli", "config", "list", "--output", "json", "--jq", "."
  end
end

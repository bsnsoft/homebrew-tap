# A draft of a Homebrew formula for the native executable, for a tap of this
# project. It is not submitted anywhere, and the two values a release fills in
# are marked: the owner of the repository the archives are attached to, and the
# checksum of each archive, which dist/package.sh writes beside it as a
# <archive>.sha256 file and a release attaches with the archives.
#
# Copyright 2026 BSNSoft Solutions GmbH. Author: Christian Bürckert. Licensed under the Apache License, Version 2.0.
class Esj < Formula
  desc "Read, check, convert and render EN 16931 invoices through the semantic model"
  homepage "https://github.com/bsnsoft/esj"
  version "0.9.7"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/bsnsoft/esj/releases/download/v#{version}/esj-#{version}-native-macos-arm64.zip"
      sha256 "87281b9c69840e9caf6ff8f53c43127d796d97789909c5882337ed2f6f1619ed"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/bsnsoft/esj/releases/download/v#{version}/esj-#{version}-native-linux-arm64.zip"
      sha256 "73dff52f13ab78de33a705a4fb91b33cba03f917614749fa0c35bcc3c49d8e25"
    end
    on_intel do
      url "https://github.com/bsnsoft/esj/releases/download/v#{version}/esj-#{version}-native-linux-x64.zip"
      sha256 "73c12054e361b9b42b5da790d38631306e02ce62385bdb80522c2e068a93a4aa"
    end
  end

  def install
    # The executable and, on the platforms that have them, the shared libraries
    # it loads for the fonts and images of a rendering.
    libexec.install Dir["*"]
    (bin/"esj").write_env_script libexec/"esj", {}
  end

  test do
    (testpath/"invoice.esj.json").write <<~JSON
      {"format":"EN16931-Semantic-JSON","version":"0.1",
       "semanticModel":"EN16931-1:2017+A1:2019/AC:2020","values":{"/BT-1":"RE-1"}}
    JSON
    assert_match "RE-1", shell_output("#{bin}/esj get invoice.esj.json /BT-1")
    assert_match version.to_s, shell_output("#{bin}/esj --version")
  end
end

import Foundation
import ArgumentParser

@main
struct Monch: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "レビュー依頼を楽にするコマンドライン・ツール",
        version: Version.value,
        subcommands: [Review.self],
        defaultSubcommand: Review.self
    )
    static let filePath = #file
}

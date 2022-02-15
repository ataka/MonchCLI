import Foundation
import ArgumentParser

protocol AsyncParsableCommand: ParsableCommand {
    mutating func runAsync() async throws
}
extension ParsableCommand {
    static func main(_ arguments: [String]? = nil) async {
        do {
            var command = try parseAsRoot(arguments)
            if case var asyncCommand as AsyncParsableCommand = command {
                try await asyncCommand.runAsync()
            } else {
                try command.run()
            }
        } catch {
            exit(withError: error)
        }
    }
}
extension AsyncParsableCommand {
    mutating func runAsync() async throws {
        throw CleanExit.helpRequest(self)
    }
}

@main
enum CLI {
    static func main() async {
        await Monch.main()
    }
}

struct Monch: ParsableCommand, AsyncParsableCommand {
    static var configuration = CommandConfiguration(
        abstract: "レビュー依頼を楽にするコマンドライン・ツール",
        version: Version.value,
        subcommands: [Review.self],
        defaultSubcommand: Review.self
    )
    static let filePath = #file
}

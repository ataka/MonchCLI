# MonchCLI

MonchCLI はレビュー依頼を簡便にするためのコマンドツールです。

## 名前について

Monch はメンヒと読みます。
アルプス山脈に属するスイスの山 [Mönch](https://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%B3%E3%83%92) から名前を取りました。

## インストール

Xcode 11.4+ を AppStore からインストールしておきます。

### Make

``` shellsession
$ git pull https://github.com/ataka/MonchCLI.git
$ cd MonchCLI
$ make install
```

## 設定

### 自分用の設定ファイル

HOME ディレクトリー直下にファイル `.monch.json` を作り、次の内容を書きます:

``` json
{
    "chatwork": {
        "token": "あなたの Chatwork API トークン"
    },
    "github": {
        "token": "あなたの GitHub Personal Access トークン"
    }
}
```

「あなたの Chatwork API トークン」は [Chatwork APIドキュメント](https://developer.chatwork.com/ja/) を参考にして取得します。取得したトークンを設定ファイルの「あなたの Chatwork API トークン」の部分に書きます。

「あなたの GitHub Personal Access トークン」は [コマンドライン用の個人アクセストークンを作成する \- GitHub ヘルプ](https://help.github.com/ja/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) を参考に取得します。トークンに付与するスコープは **repo** だけで十分です。取得したトークンを設定ファイルの「あなたの GitHub Personal Access トークン」の部分に書きます。

### プロジェクト用の設定ファイル

MonchCLI を使いたいプロジェクトのトップ・ディレクトリー直下に `.monch.json` を作り、次の内容を書きます。

``` json
{
    "chatwork": {
        "roomId": タスクを振る Chatwork のルームID
    },
    "github": {
        "repository": 対象の GitHub リポジトリー (`ataka/MonchCLI` の書式で...)
    },
    "reviewers": [
        { "name": "レビュワーの名前",  "chatworkId": Chatwork のアカウントID,  "githubLogin": "GitHub でのログイン名" }
    ]
}
```

## 利用方法

プロジェクトのトップ・ディレクトリー下で次のコマンドを打ちます:

``` shellsession
$ monch
```

詳細はヘルプを読んでください:

``` shellsession
$ monch --help
```

## Attributions

This tool is powered by:

- [apple/swift\-argument\-parser](https://github.com/apple/swift-argument-parser)

Inspiration for this tool came from an [@astronaughts](https://github.com/astronaughts)' private project *eiger-cli*!

## License

MonchCLI is licensed under the MIT license.  See [LICENSE](https://github.com/ataka/MonchCLI/blob/master/LICENSE) for more info.

# MonchCLI
<p>
    <a href="https://github.com/ataka/MonchCLI/blob/develop/LICENSE">
        <img alt="GitHub license" src="https://img.shields.io/github/license/ataka/MonchCLI"/>
    </a>
    <a href="https://docs.swift.org/swift-book/index.html">
        <img alt="Swift 5.4" src="https://img.shields.io/badge/Swift-5.4-orange.svg"/>
    </a>
    <a href="https://github.com/ataka/MonchCLI/releases">
        <img alt="GitHub release (latest by date)" src="https://img.shields.io/github/v/release/ataka/MonchCLI">
    </a>
</p>

MonchCLI はレビュー依頼を簡便にするためのコマンドツールです。

## 名前について

Monch はメンヒと読みます。
アルプス山脈に属するスイスの山 [Mönch](https://ja.wikipedia.org/wiki/%E3%83%A1%E3%83%B3%E3%83%92) から名前を取りました。

## インストール

Xcode 12.5+ を AppStore からインストールしておきます。

### Homebrew

``` shellsession
$ brew install ataka/formulae/MonchCLI
```

### Make

``` shellsession
$ git pull https://github.com/ataka/MonchCLI.git
$ cd MonchCLI
$ make install
```

## 設定

### 自分用の設定ファイル

HOME ディレクトリー直下にファイル `.monch.json` を作り、次の内容を書きます:

``` json5
{
    "chatwork": {
        "token": "01234abcdef" // あなたの Chatwork API トークン
    },
    "github": {
        "token": "ghp_56789uvwxyz" // あなたの GitHub Personal Access トークン
    }
}
```

「あなたの Chatwork API トークン」は [Chatwork APIドキュメント](https://developer.chatwork.com/ja/) を参考にして取得します。取得したトークンを設定ファイルの「あなたの Chatwork API トークン」の部分に書きます。

「あなたの GitHub Personal Access トークン」は [コマンドライン用の個人アクセストークンを作成する \- GitHub ヘルプ](https://help.github.com/ja/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line) を参考に取得します。トークンに付与するスコープは **repo** だけで十分です。取得したトークンを設定ファイルの「あなたの GitHub Personal Access トークン」の部分に書きます。

コメント部分は削除してください。

### プロジェクト用の設定ファイル

MonchCLI を使いたいプロジェクトのトップ・ディレクトリー直下に `.monch.json` を作り、次の内容を書きます。

``` json5
{
    "chatwork": {
        "roomId": 12345 // タスクを振る Chatwork のルームID
    },
    "github": {
        "repository": "ataka/MonchCLI" // 対象の GitHub リポジトリー (`` の書式で...)
    },
    "reviewers": [
        { 
            "name": "安宅正之",    // レビューワーの名前
            "chatworkId": 67890,   // ChatworkのアカウントID
            "githubLogin": "ataka" // GitHub でのログイン名
        }
    ]
}
```

コメント部分は削除してください。

#### カスタムクエリー (オプション設定)

Chatwork のタスクに独自の情報を追加することができます。
`.monch.json` に次のようなフォーマットで設定を追加してください。

``` json5
{
    // 省略
    "customQueries": [
        {
            "message": "仕様書の URL を入力してください", // プロンプトに表示するテキスト
            "format": "仕様書 URL: %@"                    // タスクに挿入されるテキスト
                                                          //     %@ が入力したテキストに置き換えられます
        }
    ]
}
```

`customQueries.format` には `%@` を 1 つだけ入れるようにしてください。

`customQueries` はオプション設定です。設定しなくても MonchCLI は動きます。

#### タスクを振るルームIDの上書き (オプション設定)

Chatwork のタスクを振るルームを特定のレビュワーだけ変更することができます。
`.monch.json` に次のようなフォーマットで設定を書いてください。

``` json5
{
    "chatwork": {
        "roomId": 12345 // タスクを振る Chatwork のルームID
    },
    // 省略
    "reviewers": [
        // 省略
        {
            "name": "別チームの開発者・デザイナー・テスター etc.",
            "chatworkId": 67891,
            "githubLogin": "someoneInOtherChat",
            "chatworkRoomId": 12346 // (Optional) chatwork.roomId で設定した「タスクを振る Chatwork のルームID」を上書きできます
        }
    ]
}
```

デフォールトでは、Chatwork のタスクは `chatwork.roomId` のチャットで作成されますが、
`reviewers[N].chatworkRoomId` を設定しているとこの設定を上書きして別のチャットでタスクを作成することが可能です。

`reviewers[N].chatworkRoomId` はオプション設定です。設定しなくても MonchCLI は動きます。

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

<!-- Local Variables: -->
<!-- mode: gfm -->
<!-- End: -->

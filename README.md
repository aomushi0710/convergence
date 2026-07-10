# convergence
インクリメンタル型2Dシミュレーションゲーム<br>
Godot Japan Game Jam 2026 参加作品
<img src="https://i.imgur.com/9zgHLBh.png" title="タイトル画面">


[Godot Japan Game Jam 2026 公式ページ](https://godot-japan.com/game-jam/)

### 公開URL
最新バージョンは[unityroom](https://unityroom.com/games/convergence)にてプレイ可能です<br>
Godot Japan Game Jam 2026に提出させていただいた初期バージョンは[godotplayer](https://godotplayer.com/games/convergence)にてプレイ可能です

### 工夫した点
- Polygon2Dノードを利用して、様々な多角形の図形を動的に表現
- 各種パラメータはカスタムリソースを作成し、構造化データとして扱うことで高い再利用性や拡張性などを実現
- 一部のパラメータは現在のレベルに応じて、インタラクティブに図形の変化を実装
- オートセーブ機能の実装

### 改善したい点
- 後半のレベルアップに必要な通貨量の増加に対し、距離の伸びを実感しにくくなってしまう現状のゲームバランスの是正
- モバイルでの操作時、パラメータ一覧のシークバーを用いなければ上下スクロールが行えない問題

### 開発環境
<table>
  <tr>
    <td>ゲームエンジン</td>
    <td>Godot Engine 4.6.2 stable</td>
  </tr>
  <tr>
    <td>統合開発環境</td>
    <td>Godot内蔵スクリプトエディタ</td>
  </tr>
</table>

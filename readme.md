
# ubuntu-openvpn

このリポジトリは、DockerのUbuntuイメージでOpenVPNを構築・運用するための設定・スクリプトをまとめたものです。


## 動かし方、動き方

- .enbを作成し、下記のように記載。
```
VPN_GLOBAL_IP=<DockerをホストしているPCのグローバルip>
VPN_PORT=<DockerをホストしているPCにおいて使うポート>
```
- `docker compose up -d`で起動。
- "volume: ubuntu-openvpn-data"が作成されてサーバーの鍵等はそこに入る。
- [preparation.sh](/sh/preparation.sh)がopenvpn起動前に走りvolumeにeasyrsaディレクトリが無ければ中身も一緒に作り始める。
- "ca.crt"が確認できると"status"が"healthy"になる(`docker ps`で見れる)
- `docker logs ubuntu-openvpn`で"Initialization Sequence Completed"と出ていればopenvpnが起動し待機している状態。
- `docker exec ubuntu-openvpn new-client <クライアントファイル名>`でクライアントファイル作成、ディレクトリcliantsに出力される。
- .ovpnファイルをクライアントにインポートして接続。


## 主な目的
- 学習


## 構成概要
- `docker-compose.yml` … サーバーコンテナの定義  
- `Dockerfile` … VPN サーバーイメージ定義＋起動スクリプトの登録  
- `sh/` ディレクトリ … 起動前準備 (`preparation.sh`)、クライアント生成 (`new_client.sh`) 等  
- `clients/` ディレクトリ … 生成されたクライアント用 `.ovpn` の出力先（ホスト側マウント）  
- `server.conf` … OpenVPN サーバー設定  


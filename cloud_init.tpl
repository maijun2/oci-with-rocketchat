#cloud-config
package_update: true
package_upgrade: true
packages:
  - snapd

runcmd:
  # snapd が利用可能になるまで少し待機
  - sleep 30
  #- snap wait system seed.loaded  
  # snap core のインストール/更新
  - snap install core
  - snap refresh core
  # RocketChat Server のインストール
  - snap install rocketchat-server --channel=4.x/stable
  # iptablesでの設定
  - iptables -I INPUT -p tcp --dport 3000 -j ACCEPT
  - DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent
  - netfilter-persistent save
  # RocketChatサービスの有効化と開始 (snapパッケージの場合、自動起動がデフォルトの場合もある)
  - systemctl enable snap.rocketchat-server.rocketchat-server.service
  - systemctl start snap.rocketchat-server.rocketchat-server.service

# 起動完了後に実行されるコマンド (オプション)
# final_message: "RocketChat installation script finished."

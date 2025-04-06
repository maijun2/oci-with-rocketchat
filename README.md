# OCI 上の Rocket.Chat を Terraform で構築

このプロジェクトは、Terraform を使用して Oracle Cloud Infrastructure（OCI）上に Rocket.Chat をデプロイします。

## 特徴

- HTTP アクセスのためのフレキシブル・ロードバランサー（FLB）
- Ubuntu コンピュートインスタンス
- SNAP 経由でインストールされた Rocket.Chat
- モジュール化された Terraform 構成

## セットアップ手順

### 事前準備
- テナンシーやコンパートメントの ocid の内容を確認
    - テナンシーの確認コマンド
        - oci iam tenancy get --tenancy-id $(oci iam compartment list --compartment-id-in-subtree true --all | jq -r '.data[0]."compartment-id"')
    - 自身のコンパートメントの確認
        - マネージメントコンソールから調べる方法が良いかも
- ssh-keygenで鍵の作成
- CloudShellの環境変数にて配置先のリージョンを上書き指定 ※CloudShellの動作リージョンとリソース設置先が異なる場合の対応
    - export TF_VAR_region=eu-frankfurt-1

### リソース作成
1. `terraform.tfvars.example` を `terraform.tfvars` にコピーし、自分の環境に適した値を入力します（テナンシーやコンパートメントのOCID）
2. `terraform.tfvars` に記述する必要情報を記載します
    - tenancy_ocid  
    - compartment_ocid 
    - ssh_public_key 
    
3. 以下を実行します：

```bash
export TF_VAR_region=eu-frankfurt-1 ※CloudShellのリージョンと配置先のリージョンが異なる場合に配置先リージョンを環境変数で指定
terraform init
terraform plan
terraform apply
```

4. 待ちます
- 特にインスタンス側でRocket.Chatのインストールに時間がかかるので5分ほど待ちます
- フレキシブルロードバランサーのヘルスチェックが正常になったらOK


5. 出力されるパブリック IP（http 経由）で Rocket.Chat にアクセスします。
- 注意点としてhttp://パブリックIPと入力すること。http:// をつけないとブラウザ側が勝手にhttpsと解釈するので！


## ディレクトリ構成

```
/
├── main.tf
├── variables.tf
├── terraform.tfvars.example
├── outputs.tf
├── cloud_init.tpl
├── README.md
├── modules/
│   ├── network/
│   ├── compute/
│   └── load_balancer/
```

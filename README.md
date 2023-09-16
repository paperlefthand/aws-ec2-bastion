# AWS EC2のPublic/Privateサブネット構成のサンプル

## 構成

1. 2つのAZ(ap-northeast-1a,1c)にまたがる1つのVPC. VPCにはInternet Gateway
2. それぞれのAZにPublic/Privateのサブネット
3. 2.のパブリックサブネットにはそれぞれNAT Gateway
4. ap-northeast-1aのpublic subnetには踏み台サーバ(EC2 t2.micro)
5. ap-northeast-1a,1cのprivate subnetにはそれぞれアプリサーバ(EC2 t2.micro)
6. 4.の踏み台サーバには, 公開鍵`ec2_key_pair/deployer_key.pub`を配置してSSH接続.

## TODO

- リソース名の付与
- サーバへのSSH確認
- FastAPI不要
- diagram

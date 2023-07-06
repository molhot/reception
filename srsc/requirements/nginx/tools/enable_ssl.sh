# 基本的にはこのサイトを見てやった
# https://qiita.com/tukiyo3/items/3d1634a1fa0477976f74

# SSL秘密鍵の作成
mkdir /etc/nginx/ssl
echo "Creating SSL Secret Key"
openssl genrsa -out /etc/nginx/ssl/server.key 3072

#Create the request (CSR)
echo "Creating CSR"
openssl req -new -key /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.csr -subj "/CN=example.com"

# CRT (SSLサーバー証明書)の作成
echo "Creating CRT"
openssl x509 -req -signkey /etc/nginx/ssl/server.key -in /etc/nginx/ssl/server.csr -out /etc/nginx/ssl/server.crt
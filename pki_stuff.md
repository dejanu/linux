
* Extensions:

- **CER (.cer)** or **CRT (.crt)**: certificate could be PEM or DER encoded, contains certificate owner information and public and private keys.
- **PEM (.pem)**: Base64 encoded form of DER certificate. Certificate and private key are stored in different files.
- **DER (.der)**: Binary form of PEM certificate used on Java platform. Certificate and private key are stored in different files.
- **PKCS7 (.p7b)**: ASCII code. Contains the certificate but not the private key.
- **PKCS12 (.pfx or .p12)**: Binary form used on Windows platforms. Contains certificate(s) private and public key. (it's password protected)

--------------------------------------------------------------------------------------------------
Flow: generate private key and certificate signing request (CSR) -> the CSR needs to be approved and signed by a signer, and the digital signature on the new certificate is provided by the Certificate Authority (CA) -> get the certificate CER and CRT extensions are nearly synonymous, certificates may be encoded as binary DER or as ASCII PEM.
--------------------------------------------------------------------------------------------------
* OpenSSL's s_client command can be used to analyze client-server communication,  including whether a port is open and if that port is capable of accepting an SSL/TLS connection. 

* Investigating SSL/TLS certificate-based connections and tests connectivity to an HTTPS service.
```bash
timeout 2 openssl s_client -connect HOST:PORT ; if [ $? -eq 24 ] ; then echo "Timeout" ; fi
timeout 2 openssl s_client -connect HOST:PORT ;  if [ $? -eq 24 ] ; then echo "Timeout" ; fi
```

* Verify/Debug SSL connection SSL connection and print the SSL certificate
```bash
openssl s_client -connect <URL or IP>:<port> -showcerts
openssl s_client -connect <URL or IP>:<port> -proxy <URL or IP>:<port>
openssl s_client -connect <URL or IP>:<port> -prexit

head -n1 < /dev/tcp/<IP>/<PORT> 2>/dev/null >/dev/null; if [ $? -eq 0 ] ; then echo works ; else echo nowork ; fi
```
* A TCP/IP network connection may be either blocked, dropped, open, or filtered leadin to Layer4 connection problem, info: "Connection refused" - timeout:

```bash
# Connection refused has 2 cases: 
    # no process is listening on IP:PORT 
    # the port is blocked by Firewall
```

* CLIENT SIDE:
 ```bash
# check TCP port connectivity: nc -z -v [hostname/IP address] [port number]
nc -z -v 192.168.10.12 22

# set timeout for CONNECTS
nc -zvw 2 192.168.10.12 <PORT>
```
* CLIENT SIDE: 
```bash
# check UDP port connectivity: nc -z -v -u [hostname/IP address] [port number]
nc -z -v -u 192.168.10.12 123
```
* CLIENT SIDE: check all open ports
```bash
nmap <IP>

# SERVER SIDE: -t TCP -u UDP sockets
netstat -tulpn | grep LISTEN
sudo lsof -i -P -n | grep LISTEN
sudo ss -tulpn | grep LISTEN
sudo lsof -i:22 ## see a specific port such as 22 ##
sudo nmap -sTU -O IP-address-Here
```
---

* Check which TLS version is supported by the server
```bash

# f you get the certificate chain and the handshake you know the system in question supports TLS
openssl s_client -connect google.com:443 -tls1_2
openssl s_client -connect google.com:443 -tls1_1
openssl s_client -connect google.com:443 -tls1

```

* Check TLS chiper strength

    - https://jumpnowtek.com/security/Using-nmap-to-check-certs-and-supported-algos.html

```bash
# The grade is based on the cryptographic strength A is good
nmap --script ssl-enum-ciphers -p 443 google.com
```

* Debug TLS stuff:
```bash
openssl s_client -msg -debug -state -connect google.com:443
```

* DNS stuff:
```bash
nslookup -type=any google.com
```
---

* Display content of certs:
```bash
openssl x509 -in fullchain.cer -noout -text
openssl x509 -in fullchain.cer -noout -dates

openssl x509 -in acs.cdroutertest.com.pem -text
openssl x509 -in MYCERT.der -inform der -text

openssl s_client -connect <hostname>:<PORT> -showcerts |  openssl x509 -noout  -dates
openssl s_client -showcerts -servername myserver.com -connect myserver.com:443 </dev/null
```

# Resolve-each-subdomain-to-its-IP
To extract **only IP addresses** from a **subdomains list**, use one of the methods below depending on your file format.

---

# ✅ **1. Resolve each subdomain to its IP (best method)**

If your file contains subdomains like:

```
api.example.com
test.example.com
dev.example.com
```

Use this:

### **Method A — Using `dig`**

```bash
while read -r domain; do
    ip=$(dig +short "$domain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}')
    if [ -n "$ip" ]; then
        echo "$ip"
    fi
done < all_sub.txt > ips.txt
```

---

### **Method B — Using `host`**

```bash
while read -r domain; do
    host "$domain" | grep "has address" | awk '{print $4}'
done < all_sub.txt > ips.txt
```

---

# ✅ **2. If your file contains URLs (remove protocol first)**

Example input:

```
https://api.example.com
http://test.example.com
https://dev.example.com/path
```

Clean them first:

```bash
sed 's#https\?://##' all_sub.txt | cut -d'/' -f1 > clean_subs.txt
```

Then resolve:

```bash
while read -r domain; do
    dig +short "$domain" | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}'
done < clean_subs.txt > ips.txt
```

---

# ✅ **3. One-line command (fast)**

```bash
for i in $(cat all_sub.txt); do dig +short $i; done | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}' > ips.txt
```

---

# ✅ **4. Remove duplicate IP addresses**

```bash
sort -u ips.txt > unique_ips.txt
```

---

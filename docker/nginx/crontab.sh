if ! crontab -l | grep -q "0 0 3 */3 * certbot renew -q"; then
    (crontab -l ; echo "0 0 3 */3 * certbot renew -q") | crontab -
fi

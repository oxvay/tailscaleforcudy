<img width="1056" height="294" alt="Pasted image 20261018170430" src="https://github.com/user-attachments/assets/c75f1997-2640-45b4-adc4-3f9ba3c193a4" />Скачать скрипт:
```Bash
wget -O /tmp/tailscale-install.sh \
  'https://raw.githubusercontent.com/oxvay/tailscaleforcudy/master/script.sh' \
  && sh /tmp/tailscale-install.sh
```
При появлении ссылки, нужно открыть ее в браузере и авторизоваться
После скачать Tailscale на другое устройство и авторизоваться в том же аккаунте
Проверить, что Podkop работает корректно

Скачать скрипт:
```
wget -O /tmp/subnetrouter.sh \
  'https://raw.githubusercontent.com/oxvay/tailscaleforcudy/master/subnetrouter.sh' \
  && sh /tmp/subnetrouter.sh
```
После завершения работы скрипта:

Перейти в панель Tailscale
https://login.tailscale.com/admin/machines
Найти раздел Subnets
Нажать на Review
<img width="1056" height="294" alt="Pasted image 20261018170430" src="https://github.com/user-attachments/assets/5b8af110-6486-429b-bf70-2dd0a5b601a9" />
Поставить галочку на IP и Save

<img width="708" height="581" alt="Pasted image 20261018170421" src="https://github.com/user-attachments/assets/8e938979-21a2-42c0-9ce6-52f1ae27801f" />
Проверить, что с другого устройства с включенным Tailscale открывается веб панель роутера


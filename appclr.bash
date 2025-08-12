#!/usr/bin/env bash
#-------------------------------------------------------
#  pkg-audit.sh – аудит пакета Debian/Ubuntu
#  Использование: sudo ./pkg-audit.sh <имя_пакета>
#-------------------------------------------------------

PKG="$1"
[ -z "$PKG" ] && {
  echo "Использование: $0 <package_name>"
  exit 1
}

echo "=== Проверка статуса пакета \"$PKG\" ==="

# проверяем, установлен ли пакет (статус ii)
dpkg -l | grep -E "^ii\s+$PKG"

# ищем удалённый пакет с оставшимися конфигами (статус rc)
dpkg -l | grep -E "^rc\s+$PKG"

# пакеты сироты которые можно убрать (dry‑run)
echo -e "\n=== Возможные сироты (sudo apt-get autoremove --dry-run) ==="
echo -e "\n Данные пакеты можно удалить:"
sudo apt-get autoremove --dry-run | grep -v '^ '


# 4. Путь к бинарнику / алиас / функции
echo -e "\n=== Наличие команды в PATH ==="
type -a "$PKG" || echo "Команда $PKG не найдена в PATH"

# 5. Поиск файлов с именем пакета (locate)
echo -e "\n=== Поиск файлов, содержащих \"$PKG\" (locate) ==="
sudo updatedb
locate -i "$PKG" | head -n 20

echo -e "\nПроверка завершена."

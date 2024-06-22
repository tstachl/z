{ writeShellApplication
}: writeShellApplication {
  name = "download";
  text = ''
    echo "Downloading ..."

    function urldecode() {
      echo -e "$(sed 's/+/ /g;s/%\(..\)/\\x\1/g;')"
    }
    filename=$(echo "$1" | rev | cut -d "/" -f 1 | rev | urldecode)

    curl "$1" \
      -H 'accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8' \
      -H 'accept-language: en-US,en;q=0.9,de;q=0.8,es;q=0.7' \
      -H 'cookie: donation-identifier=155a36141564aff8ff41417aeee3953c; abtest-identifier=5a24abce6734159b82597d1ef0ba7c43; PHPSESSID=o95p8rlhf44dvpjji9vihehqss' \
      -H 'dnt: 1' \
      -H 'priority: i' \
      -H 'referer: https://archive.org/details/chaos-charles-manson-the-cia-and-the-secret-history-of-the-sixties-audiobook_202212/04+-+Chapter+3+-+The+Golden+Penetrators.mp3' \
      -H 'sec-ch-ua: "Chromium";v="125", "Not.A/Brand";v="24"' \
      -H 'sec-ch-ua-mobile: ?0' \
      -H 'sec-ch-ua-platform: "macOS"' \
      -H 'sec-fetch-dest: image' \
      -H 'sec-fetch-mode: no-cors' \
      -H 'sec-fetch-site: same-origin' \
      -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
      --output "$HOME/Downloads/$filename"

    echo "Done!"
  '';
}

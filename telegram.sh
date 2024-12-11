






# env: TELEGRAM_API_KEY
#      TELEGRAM_CHAT_ID
#      send_timestamp
telegram_send_message() {
	text="$*"
	curl -X POST "https://api.telegram.org/bot$TELEGRAM_API_KEY/sendMessage" --data "chat_id=$TELEGRAM_CHAT_ID&text=${text:0:4096}" || true
}




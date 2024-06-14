#!/bin/bash

echo "=============================="
echo "       Apache2 Script"
echo "    By DiscordFreeVPS"
echo "=============================="

if [ -f token.txt ]; then
    NGROK_AUTH_TOKEN=$(<token.txt)
    echo "Using Ngrok authtoken from token.txt."
else
    echo "Before you start, you need an Ngrok authtoken to use this script."
    echo "Visit https://dashboard.ngrok.com/get-started/your-authtoken to sign up and get your authtoken."
    read -p "Please enter your Ngrok authtoken: " ngrok_token

    NGROK_AUTH_TOKEN="$ngrok_token"
    echo "$NGROK_AUTH_TOKEN" > token.txt
    echo "Ngrok authtoken saved to token.txt."
fi

show_menu() {
    clear
    echo "=============================="
    echo "       Apache2 Script"
    echo "    By DiscordFreeVPS"
    echo "=============================="
    echo "=============================="
    echo "1. Install Apache2"
    echo "2. Start Apache2 with ngrok"
    echo "3. Edit Apache2 index file"
    echo "4. Exit"
    echo "=============================="
    echo
}

while true; do
    show_menu
    read -p "Choose an option (1-4): " choice

    case $choice in
        1)
            echo "Installing Apache2..."
            sudo apt update
            sudo apt install nano
            sudo apt install apache2
            sudo /usr/sbin/apache2ctl start
            curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null && echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list && sudo apt update && sudo apt install ngrok
            ngrok authtoken "$NGROK_AUTH_TOKEN"
            clear
            echo "Apache2 installed."
            ;;
        2)
            echo "Starting Apache2..."
            ngrok http 80
            ;;
        3)
            echo "Editing Apache2 index file..."
            sudo nano /var/www/html/index.html
            ;;
        4)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please choose between 1 and 4."
            ;;
    esac
    echo
    read -p "Press Enter to continue..."
done

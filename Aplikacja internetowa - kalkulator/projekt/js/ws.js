class Chat {
    constructor(url) {
        this.sendButton = document.querySelector('#chat__send-button')
        this.messagesElement = document.querySelector('.chat__messages')
        this.userCountElement = document.querySelector('#chat__user-count')
        this.inputField = document.querySelector('#chat__input-field')

        this.ws = new WebSocket(url)

        this.initEvents()
    }

    buildChatInfo(message) {
        const el = document.createElement('p')

        el.classList.add('chat__info', 'font-size-s')
        el.innerText = message

        return el
    }

    buildChatMessage(user, message) {
        const el = document.createElement('p')

        const userPart = user 
            ? `<span style="color: ${user.color};">${user.name} (${user.email})</span>:` 
            : '<span style="color: blue;">:ja</span>'

        el.classList.add('chat__message', 'font-size-s')

        if(user) el.innerHTML = `<span class="chat__message--self">${userPart} ${message}</span>`
        else el.innerHTML = `<span class="chat__message--others">${message} ${userPart}</span>`
        
        return el
    }

    updateScroll() {
        this.messagesElement.scrollTop = this.messagesElement.scrollHeight
    }

    sendMessage() {
        if(this.ws.readyState == WebSocket.OPEN) {
            const message = this.inputField.value
            const messageLength = message.length

            this.inputField.classList.remove('input-field--error')

            if(messageLength <= 0 || messageLength > 255) {
                this.inputField.classList.add('input-field--error')
                return
            }

            this.ws.send(JSON.stringify({
                action: 'message',
                message: message
            }))

            this.messagesElement.appendChild(this.buildChatMessage(null, message))
            this.inputField.value = ''

            this.updateScroll()
        }
    }

    initEvents() {
        this.sendButton.addEventListener('click', () => {
            this.sendMessage()
        })

        this.inputField.addEventListener('keydown', e => {
            if(e.keyCode == 13) this.sendMessage()
        })

        this.inputField.addEventListener('focusout', () => {
            this.inputField.classList.remove('input-field--error')
        })

        this.ws.addEventListener('open', () => {
            this.messagesElement.appendChild(this.buildChatInfo(`Połączono`))
            this.updateScroll()
        })

        this.ws.addEventListener('message', ({data}) => {
            const {action, user, message, users_count} = JSON.parse(data)

            switch(action) {
                case 'client_join':
                    this.messagesElement.appendChild(this.buildChatInfo(`Użytkownik ${user.name} (${user.email}) dołączył do czatu`))
                    this.userCountElement.innerText = users_count
                    break

                case 'client_left':
                    this.messagesElement.appendChild(this.buildChatInfo(`Użytkownik ${user.name} (${user.email}) opuścił czat`))
                    this.userCountElement.innerText = users_count
                    break

                case 'message':
                    this.messagesElement.appendChild(this.buildChatMessage(user, message))
                    break
            }

            this.updateScroll()
        })

        this.ws.addEventListener('close', () => {
            this.messagesElement.appendChild(this.buildChatInfo(`Rozłączono z serwerem`))
            this.updateScroll()
        })

        this.ws.addEventListener('error', () => {
            this.messagesElement.appendChild(this.buildChatInfo(`Nie można nawiązać połączenia z serwerem`))
            this.updateScroll()
        })
    }
}

const chat = new Chat('ws://localhost:8080/chat')
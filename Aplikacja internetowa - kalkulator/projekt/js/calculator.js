class Calculator {
    constructor(prefix) {
        this.priceInput = document.querySelector(`#${prefix}-price-input`)
        this.usageInput = document.querySelector(`#${prefix}-usage-input`)
        this.button = document.querySelector(`#${prefix}-button`)
        this.result = document.querySelector(`#${prefix}-result`)

        this.initEvents()
    }

    initEvents() {
        this.button.addEventListener('click', () => {
            let price = parseFloat(this.priceInput.value)
            let usage = parseFloat(this.usageInput.value)

            this.priceInput.classList.remove('input-field--error')
            this.usageInput.classList.remove('input-field--error')

            if(isNaN(price)) {
                this.priceInput.classList.add('input-field--error')
                return
            }

            if(isNaN(usage)) {
                this.usageInput.classList.add('input-field--error')
                return
            }

            this.result.innerText = (price * usage).toFixed(2) + ' zł'
        })
    }
}

const electricityCalculator = new Calculator('e')
const gasCalculator = new Calculator('g')
const navButton = document.querySelector('.nav-toggle-button')
const navBar = document.querySelector('.nav-bar')

const navBarmediaQuery = window.matchMedia('(min-width: 1024px)')

navBarmediaQuery.addEventListener('change', e => {
    if(e.matches) navBar.style.left = '0px'
})

navButton.addEventListener('click', () => {
    if(navBar.style.left == '0px') navBar.style.left = '-270px'
    else navBar.style.left = '0px'
})
// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as bootstrap from "bootstrap"
import Lightbox from "bs5-lightbox"

document.addEventListener('turbo:load', function() {
    document.querySelectorAll('.photo-icon').forEach((el) => { el.addEventListener('click', Lightbox.initialize)
    })
})
